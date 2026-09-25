import 'reflect-metadata';
import { Logger, ValidationPipe } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { NestFactory } from '@nestjs/core';
import { DocumentBuilder, SwaggerModule } from '@nestjs/swagger';
import helmet from 'helmet';
import { AppModule } from './app.module';
import { HttpExceptionFilter } from './common/filters/http-exception.filter';
import { ApiResponseInterceptor } from './common/interceptors/api-response.interceptor';
import { RequestContextMiddleware } from './common/middleware/request-context.middleware';
import { parseCorsOrigins } from './config/environment';

export async function createApp() {
  const app = await NestFactory.create(AppModule, { bufferLogs: true });
  const config = app.get(ConfigService);
  const origins = parseCorsOrigins(config.get<string>('CORS_ORIGINS'));
  const requestContext = new RequestContextMiddleware();

  app.useLogger(new Logger('EcoFitApi'));
  app.use(requestContext.use.bind(requestContext));
  app.use(helmet());
  app.enableCors({
    origin: origins.length > 0 ? origins : true,
    credentials: true,
    methods: ['GET', 'HEAD', 'POST', 'PUT', 'PATCH', 'DELETE', 'OPTIONS'],
  });
  app.setGlobalPrefix('api/v1');
  app.useGlobalPipes(
    new ValidationPipe({
      whitelist: true,
      forbidNonWhitelisted: true,
      transform: true,
      transformOptions: { enableImplicitConversion: true },
    }),
  );
  app.useGlobalInterceptors(new ApiResponseInterceptor());
  app.useGlobalFilters(new HttpExceptionFilter());
  app.enableShutdownHooks();

  if (config.get<boolean>('SWAGGER_ENABLED', true)) {
    const documentConfig = new DocumentBuilder()
      .setTitle('Eco Fit API')
      .setDescription('API cho ứng dụng sức khỏe đa nền tảng Eco Fit')
      .setVersion(config.get<string>('APP_VERSION', '0.1.0'))
      .addBearerAuth()
      .build();
    const document = SwaggerModule.createDocument(app, documentConfig);
    SwaggerModule.setup('docs', app, document, {
      swaggerOptions: { persistAuthorization: true },
    });
  }

  return app;
}

async function bootstrap(): Promise<void> {
  const app = await createApp();
  const config = app.get(ConfigService);
  const port = config.get<number>('PORT', 3000);
  await app.listen(port, '0.0.0.0');
  Logger.log(`Eco Fit API: http://localhost:${port}/api/v1`, 'Bootstrap');
  Logger.log(`Swagger: http://localhost:${port}/docs`, 'Bootstrap');
}

if (require.main === module) {
  void bootstrap();
}
