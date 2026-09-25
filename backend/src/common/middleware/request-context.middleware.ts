import { randomUUID } from 'node:crypto';
import { Injectable, NestMiddleware } from '@nestjs/common';
import type { NextFunction, Request, Response } from 'express';

const safeRequestId = /^[A-Za-z0-9._-]{1,100}$/;

@Injectable()
export class RequestContextMiddleware implements NestMiddleware {
  use(request: Request, response: Response, next: NextFunction): void {
    const incoming = request.header('x-request-id');
    const requestId = incoming && safeRequestId.test(incoming) ? incoming : randomUUID();

    response.locals.requestId = requestId;
    response.setHeader('x-request-id', requestId);
    next();
  }
}
