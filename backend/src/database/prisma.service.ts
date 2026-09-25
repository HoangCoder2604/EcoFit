import { Injectable, Logger, OnApplicationShutdown, OnModuleInit } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { PrismaPg } from '@prisma/adapter-pg';
import { PrismaClient } from '../generated/prisma/client';

@Injectable()
export class PrismaService extends PrismaClient implements OnModuleInit, OnApplicationShutdown {
  private readonly logger = new Logger(PrismaService.name);
  private readonly connectOnStart: boolean;

  constructor(config: ConfigService) {
    const connectionString = config.getOrThrow<string>('DATABASE_URL');
    const adapter = new PrismaPg({
      connectionString,
      max: config.get<number>('DB_POOL_MAX', 10),
      connectionTimeoutMillis: config.get<number>('DB_CONNECTION_TIMEOUT_MS', 5000),
      idleTimeoutMillis: config.get<number>('DB_IDLE_TIMEOUT_MS', 30000),
    });

    super({
      adapter,
      log: ['warn', 'error'],
    });
    this.connectOnStart = config.get<boolean>('DATABASE_CONNECT_ON_START', true);
  }

  async onModuleInit(): Promise<void> {
    if (!this.connectOnStart) return;
    await this.$connect();
    this.logger.log('Đã kết nối PostgreSQL qua Prisma');
  }

  async onApplicationShutdown(): Promise<void> {
    await this.$disconnect();
  }

  async isHealthy(): Promise<boolean> {
    const rows = await this.$queryRaw<Array<{ ok: number }>>`SELECT 1 AS ok`;
    return rows[0]?.ok === 1;
  }
}
