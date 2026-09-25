import { Controller, Get, ServiceUnavailableException } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import {
  ApiOkResponse,
  ApiOperation,
  ApiServiceUnavailableResponse,
  ApiTags,
} from '@nestjs/swagger';
import { PrismaService } from '../database/prisma.service';

@ApiTags('system')
@Controller('health')
export class HealthController {
  constructor(
    private readonly config: ConfigService,
    private readonly prisma: PrismaService,
  ) {}

  @Get()
  @ApiOperation({ summary: 'Kiểm tra trạng thái backend' })
  @ApiOkResponse({ description: 'Backend đang hoạt động bình thường.' })
  check() {
    return {
      status: 'ok',
      service: this.config.get<string>('APP_NAME', 'Eco Fit API'),
      version: this.config.get<string>('APP_VERSION', '0.1.0'),
      environment: this.config.get<string>('NODE_ENV', 'development'),
      uptimeSeconds: Math.floor(process.uptime()),
    };
  }

  @Get('ready')
  @ApiOperation({ summary: 'Kiểm tra backend và kết nối PostgreSQL' })
  @ApiOkResponse({ description: 'Backend sẵn sàng nhận traffic.' })
  @ApiServiceUnavailableResponse({ description: 'PostgreSQL chưa sẵn sàng.' })
  async ready() {
    try {
      const database = await this.prisma.isHealthy();
      if (!database) throw new Error('PostgreSQL không phản hồi đúng');
      return {
        status: 'ready',
        checks: { database: 'up' },
      };
    } catch {
      throw new ServiceUnavailableException('Không thể kết nối PostgreSQL');
    }
  }
}
