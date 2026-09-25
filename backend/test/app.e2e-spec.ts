import type { INestApplication } from '@nestjs/common';
import request from 'supertest';
import { PrismaService } from '../src/database/prisma.service';
import { createApp } from '../src/main';

describe('Eco Fit API (e2e)', () => {
  let app: INestApplication;

  beforeAll(async () => {
    process.env.NODE_ENV = 'test';
    process.env.SWAGGER_ENABLED = 'false';
    process.env.DATABASE_CONNECT_ON_START = 'false';
    app = await createApp();
    await app.init();
  });

  afterAll(async () => {
    await app.close();
  });

  it('GET /api/v1 trả về thông tin API theo response envelope', async () => {
    const response = await request(app.getHttpServer())
      .get('/api/v1')
      .set('x-request-id', 'eco-fit-e2e')
      .expect(200);

    expect(response.headers['x-request-id']).toBe('eco-fit-e2e');
    expect(response.headers['x-content-type-options']).toBe('nosniff');
    expect(response.body).toMatchObject({
      success: true,
      data: {
        name: 'Eco Fit API',
        version: '0.1.0',
        health: '/api/v1/health',
      },
      meta: {
        requestId: 'eco-fit-e2e',
        path: '/api/v1',
      },
    });
    expect(response.body.meta.timestamp).toBeTruthy();
  });

  it('GET /api/v1/health báo backend hoạt động', async () => {
    const response = await request(app.getHttpServer()).get('/api/v1/health').expect(200);

    expect(response.body.success).toBe(true);
    expect(response.body.data).toMatchObject({
      status: 'ok',
      service: 'Eco Fit API',
      environment: 'test',
    });
    expect(response.body.data.uptimeSeconds).toEqual(expect.any(Number));
  });

  it('GET /api/v1/health/ready kiểm tra được PostgreSQL', async () => {
    const prisma = app.get(PrismaService);
    jest.spyOn(prisma, 'isHealthy').mockResolvedValueOnce(true);

    const response = await request(app.getHttpServer()).get('/api/v1/health/ready').expect(200);

    expect(response.body).toMatchObject({
      success: true,
      data: {
        status: 'ready',
        checks: { database: 'up' },
      },
    });
  });

  it('trả lỗi 404 theo cùng một cấu trúc', async () => {
    const response = await request(app.getHttpServer()).get('/api/v1/not-found').expect(404);

    expect(response.body).toMatchObject({
      success: false,
      error: {
        code: 'NOT_FOUND',
      },
      meta: {
        path: '/api/v1/not-found',
      },
    });
    expect(response.body.meta.requestId).toBeTruthy();
  });

  it('chỉ cho phép origin đã cấu hình', async () => {
    const allowed = await request(app.getHttpServer())
      .options('/api/v1/health')
      .set('Origin', 'http://localhost:5173')
      .set('Access-Control-Request-Method', 'GET')
      .expect(204);

    expect(allowed.headers['access-control-allow-origin']).toBe('http://localhost:5173');
  });
});
