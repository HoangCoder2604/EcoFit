import { environmentSchema, isCorsOriginAllowed, parseCorsOrigins } from './environment';

describe('parseCorsOrigins', () => {
  it('chuẩn hóa danh sách origin', () => {
    expect(parseCorsOrigins(' http://localhost:5173, ,http://127.0.0.1:8088 ')).toEqual([
      'http://localhost:5173',
      'http://127.0.0.1:8088',
    ]);
  });

  it('trả về danh sách rỗng khi chưa cấu hình', () => {
    expect(parseCorsOrigins(undefined)).toEqual([]);
  });
});

describe('isCorsOriginAllowed', () => {
  const configuredOrigins = ['https://app.ecofit.example'];

  it('cho phép localhost và loopback với mọi cổng trong development', () => {
    expect(isCorsOriginAllowed('http://localhost:8088', configuredOrigins, true)).toBe(true);
    expect(isCorsOriginAllowed('http://127.0.0.1:50594', configuredOrigins, true)).toBe(true);
    expect(isCorsOriginAllowed('http://[::1]:8088', configuredOrigins, true)).toBe(true);
  });

  it('không nhầm domain giả mạo localhost là loopback', () => {
    expect(isCorsOriginAllowed('http://localhost.example.com:8088', configuredOrigins, true)).toBe(
      false,
    );
  });

  it('chỉ cho danh sách cấu hình trong production', () => {
    expect(isCorsOriginAllowed('https://app.ecofit.example', configuredOrigins, false)).toBe(true);
    expect(isCorsOriginAllowed('http://localhost:8088', configuredOrigins, false)).toBe(false);
  });

  it('cho phép request không có Origin như mobile app và server-to-server', () => {
    expect(isCorsOriginAllowed(undefined, configuredOrigins, false)).toBe(true);
  });
});

describe('environmentSchema', () => {
  it('không cho production dùng JWT secret mặc định', () => {
    const result = environmentSchema.validate({
      NODE_ENV: 'production',
      JWT_ACCESS_SECRET: 'eco-fit-local-access-secret-change-before-production',
    });

    expect(result.error).toBeDefined();
  });

  it('chấp nhận JWT secret production đủ mạnh', () => {
    const result = environmentSchema.validate({
      NODE_ENV: 'production',
      JWT_ACCESS_SECRET: 'a-production-only-secret-with-at-least-48-random-characters-123',
      EMAIL_DELIVERY_MODE: 'smtp',
      EMAIL_FROM: 'no-reply@ecofit.app',
      SMTP_HOST: 'smtp.example.com',
      SMTP_PORT: 587,
      SMTP_USER: 'eco-fit',
      SMTP_PASSWORD: 'secret',
      GOOGLE_CLIENT_IDS: '123456789.apps.googleusercontent.com',
    });

    expect(result.error).toBeUndefined();
  });
});
