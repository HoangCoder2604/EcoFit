# Eco Fit API

Backend Eco Fit xây dựng bằng NestJS 11, PostgreSQL và Prisma ORM 7. Prisma dùng PostgreSQL driver adapter thuần JavaScript để build gọn và triển khai linh hoạt. Authentication hỗ trợ access JWT ngắn hạn, refresh token xoay vòng lưu dạng SHA-256 trong database và rate limit cho các endpoint nhạy cảm.

## Yêu cầu

- Node.js 20 trở lên
- npm 10 trở lên
- Docker Desktop (khuyến nghị cho PostgreSQL local)

## Cài đặt và chạy

```bash
cd backend
copy .env.example .env
npm install
npm run db:up
npm run prisma:generate
npm run start:dev
```

PostgreSQL local của Eco Fit dùng cổng host `5433` để tránh xung đột với các dự án PostgreSQL khác; trong container và khi deploy vẫn dùng cổng chuẩn `5432`.

Các địa chỉ mặc định:

- API: `http://localhost:3000/api/v1`
- Health check: `http://localhost:3000/api/v1/health`
- Database readiness: `http://localhost:3000/api/v1/health/ready`
- Swagger UI: `http://localhost:3000/docs`

Android Emulator truy cập API trên máy Windows bằng `http://10.0.2.2:3000/api/v1`.

## Kiểm tra

```bash
npm run typecheck
npm test
npm run test:e2e
npm run build
```

## PostgreSQL và Prisma

- `DATABASE_URL` dùng cho truy vấn runtime; production nên dùng pooled URL.
- `DIRECT_URL` dùng cho Prisma CLI và migration; production nên dùng direct URL.
- `npm run db:dev` tạo migration trong môi trường phát triển.
- `npm run db:deploy` áp dụng migration đã có trong production.
- `npm run db:studio` mở Prisma Studio.

Schema hiện có `User`, `RefreshSession`, `EmailVerification` và `AuthIdentity` phục vụ Authentication. Các model hồ sơ, dinh dưỡng và tập luyện sẽ được bổ sung ở phase schema nghiệp vụ.

## Authentication

| Method | Endpoint | Mục đích |
| --- | --- | --- |
| `POST` | `/api/v1/auth/register` | Đăng ký và gửi mã xác minh email |
| `POST` | `/api/v1/auth/email/verify` | Xác minh mã 6 số rồi nhận cặp token |
| `POST` | `/api/v1/auth/email/resend` | Gửi lại mã xác minh email |
| `POST` | `/api/v1/auth/login` | Đăng nhập bằng email/mật khẩu |
| `POST` | `/api/v1/auth/google` | Kiểm chứng Google ID token rồi tạo phiên Eco Fit |
| `POST` | `/api/v1/auth/refresh` | Xoay vòng refresh token |
| `POST` | `/api/v1/auth/logout` | Thu hồi refresh token |
| `GET` | `/api/v1/auth/me` | Kiểm tra access token và lấy người dùng |

Ở production, phải đặt `JWT_ACCESS_SECRET` thành chuỗi ngẫu nhiên riêng dài ít nhất 32 ký tự. Ứng dụng Android nên giữ refresh token trong secure storage; web production nên dùng lớp BFF hoặc cookie `HttpOnly`, không lưu token dài hạn trong `localStorage`.

### Email thật và Google OAuth

- Local mặc định dùng `EMAIL_DELIVERY_MODE=console`: mã 6 số được ghi log và trả trong `developmentCode` để test, không giả vờ đã gửi email.
- Production dùng `EMAIL_DELIVERY_MODE=smtp` và bắt buộc cấu hình `EMAIL_FROM`, `SMTP_HOST`, `SMTP_PORT`, `SMTP_USER`, `SMTP_PASSWORD`. Response production không bao giờ trả mã xác minh.
- `GOOGLE_CLIENT_IDS` chứa một hoặc nhiều OAuth Client ID được Google Cloud cấp, phân cách bằng dấu phẩy. Backend dùng thư viện Google chính thức để kiểm tra chữ ký, audience, issuer, hạn token và `email_verified`.
- Flutter build với `--dart-define=GOOGLE_WEB_CLIENT_ID=<web-client-id>`. Android cần thêm OAuth Android client cho package `com.ecofit.eco_fit` và SHA-1 của khóa ký; Web client phải cho phép origin của website.

Ví dụ build:

```bash
flutter build web --dart-define=GOOGLE_WEB_CLIENT_ID=123.apps.googleusercontent.com
flutter build apk --debug --dart-define=GOOGLE_WEB_CLIENT_ID=123.apps.googleusercontent.com
```

Xem hướng dẫn production chi tiết tại [`DEPLOYMENT.md`](DEPLOYMENT.md).

## Quy ước API

Phản hồi thành công:

```json
{
  "success": true,
  "data": {},
  "meta": {
    "requestId": "uuid",
    "timestamp": "2026-09-25T00:00:00.000Z",
    "path": "/api/v1/health"
  }
}
```

Phản hồi lỗi:

```json
{
  "success": false,
  "error": {
    "code": "NOT_FOUND",
    "message": "Cannot GET /api/v1/example"
  },
  "meta": {
    "requestId": "uuid",
    "timestamp": "2026-09-25T00:00:00.000Z",
    "path": "/api/v1/example"
  }
}
```

## Cấu trúc

```text
src/
├── common/       # filter, interceptor, middleware dùng chung
├── config/       # kiểm tra biến môi trường
├── database/     # PrismaModule và PrismaService
├── generated/    # Prisma Client sinh tự động, không commit
├── health/       # health check
├── app.module.ts
└── main.ts
```
