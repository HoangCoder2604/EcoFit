import type { INestApplication } from '@nestjs/common';
import request from 'supertest';
import { PrismaService } from '../src/database/prisma.service';
import { createApp } from '../src/main';

describe('Authentication (e2e)', () => {
  let app: INestApplication;
  let prisma: PrismaService;
  const email = `auth-e2e-${Date.now()}@example.com`;
  const password = 'EcoFit123';
  let verificationCode: string;

  beforeAll(async () => {
    process.env.NODE_ENV = 'test';
    process.env.SWAGGER_ENABLED = 'false';
    process.env.DATABASE_CONNECT_ON_START = 'true';
    app = await createApp();
    await app.init();
    prisma = app.get(PrismaService);
  });

  afterAll(async () => {
    await prisma.user.deleteMany({ where: { email } });
    await app.close();
  });

  it('đăng ký, chặn email trùng và không trả password hash', async () => {
    const registered = await request(app.getHttpServer())
      .post('/api/v1/auth/register')
      .send({ email: email.toUpperCase(), displayName: 'Auth E2E', password })
      .expect(201);

    expect(registered.body.data).toMatchObject({ verificationRequired: true, email });
    verificationCode = registered.body.data.developmentCode as string;
    expect(verificationCode).toMatch(/^\d{6}$/);
    expect(registered.body.data.accessToken).toBeUndefined();

    await request(app.getHttpServer())
      .post('/api/v1/auth/register')
      .send({ email, displayName: 'Trùng', password })
      .expect(409);

    await request(app.getHttpServer())
      .post('/api/v1/auth/login')
      .send({ email, password })
      .expect(403);
  });

  it('xác minh email, đăng nhập và truy cập endpoint được bảo vệ', async () => {
    const verified = await request(app.getHttpServer())
      .post('/api/v1/auth/email/verify')
      .send({ email, code: verificationCode })
      .expect(200);

    expect(verified.body.data).toMatchObject({
      tokenType: 'Bearer',
      accessTokenExpiresIn: 900,
      user: { email, displayName: 'Auth E2E', role: 'USER' },
    });
    expect(verified.body.data.user.passwordHash).toBeUndefined();

    await request(app.getHttpServer())
      .post('/api/v1/auth/login')
      .send({ email, password: 'SaiMatKhau1' })
      .expect(401);

    const login = await request(app.getHttpServer())
      .post('/api/v1/auth/login')
      .send({ email, password })
      .expect(200);

    await request(app.getHttpServer()).get('/api/v1/auth/me').expect(401);

    const me = await request(app.getHttpServer())
      .get('/api/v1/auth/me')
      .set('Authorization', `Bearer ${login.body.data.accessToken}`)
      .expect(200);

    expect(me.body.data).toMatchObject({ email, displayName: 'Auth E2E' });
  });

  it('không giả lập Google khi chưa có OAuth Client ID', async () => {
    await request(app.getHttpServer())
      .post('/api/v1/auth/google')
      .send({ idToken: 'not-a-real-google-id-token-value' })
      .expect(503);
  });

  it('xoay vòng refresh token và phát hiện token bị dùng lại', async () => {
    const login = await request(app.getHttpServer())
      .post('/api/v1/auth/login')
      .send({ email, password })
      .expect(200);

    const oldRefreshToken = login.body.data.refreshToken as string;
    const refreshed = await request(app.getHttpServer())
      .post('/api/v1/auth/refresh')
      .send({ refreshToken: oldRefreshToken })
      .expect(200);

    expect(refreshed.body.data.refreshToken).not.toBe(oldRefreshToken);

    await request(app.getHttpServer())
      .post('/api/v1/auth/refresh')
      .send({ refreshToken: oldRefreshToken })
      .expect(401);

    await request(app.getHttpServer())
      .post('/api/v1/auth/refresh')
      .send({ refreshToken: refreshed.body.data.refreshToken })
      .expect(401);
  });

  it('đăng xuất thu hồi refresh token nhưng giữ tính idempotent', async () => {
    const login = await request(app.getHttpServer())
      .post('/api/v1/auth/login')
      .send({ email, password })
      .expect(200);
    const refreshToken = login.body.data.refreshToken as string;

    await request(app.getHttpServer())
      .post('/api/v1/auth/logout')
      .send({ refreshToken })
      .expect(200)
      .expect(({ body }) => expect(body.data).toEqual({ loggedOut: true }));

    await request(app.getHttpServer())
      .post('/api/v1/auth/logout')
      .send({ refreshToken })
      .expect(200);

    await request(app.getHttpServer())
      .post('/api/v1/auth/refresh')
      .send({ refreshToken })
      .expect(401);
  });

  it('kiểm tra chính sách mật khẩu ở request boundary', async () => {
    const invalid = await request(app.getHttpServer())
      .post('/api/v1/auth/register')
      .send({ email: 'invalid@example.com', displayName: 'Invalid', password: '12345678' })
      .expect(400);

    expect(invalid.body.error.details).toEqual(
      expect.arrayContaining([expect.stringContaining('uppercase')]),
    );
  });
});
