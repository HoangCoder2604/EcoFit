import {
  ArgumentsHost,
  Catch,
  ExceptionFilter,
  HttpException,
  HttpStatus,
  Logger,
} from '@nestjs/common';
import type { Request, Response } from 'express';

type ExceptionBody = {
  error?: string;
  message?: string | string[];
};

@Catch()
export class HttpExceptionFilter implements ExceptionFilter {
  private readonly logger = new Logger(HttpExceptionFilter.name);

  catch(exception: unknown, host: ArgumentsHost): void {
    const context = host.switchToHttp();
    const request = context.getRequest<Request>();
    const response = context.getResponse<Response>();
    const isHttpException = exception instanceof HttpException;
    const status = isHttpException ? exception.getStatus() : HttpStatus.INTERNAL_SERVER_ERROR;
    const raw = isHttpException ? exception.getResponse() : undefined;
    const body: ExceptionBody = typeof raw === 'object' && raw !== null ? raw : {};
    const rawMessage = typeof raw === 'string' ? raw : body.message;
    const details = Array.isArray(rawMessage) ? rawMessage : undefined;
    const message = details
      ? 'Dữ liệu gửi lên không hợp lệ'
      : (rawMessage ?? 'Đã xảy ra lỗi nội bộ');
    const code = (body.error ?? HttpStatus[status] ?? 'ERROR').toUpperCase().replaceAll(' ', '_');

    if (!isHttpException) {
      this.logger.error(
        `${request.method} ${request.originalUrl}`,
        exception instanceof Error ? exception.stack : String(exception),
      );
    }

    response.status(status).json({
      success: false,
      error: {
        code,
        message,
        ...(details ? { details } : {}),
      },
      meta: {
        requestId: String(response.locals.requestId ?? ''),
        timestamp: new Date().toISOString(),
        path: request.originalUrl,
      },
    });
  }
}
