# Eco Fit API

Backend Eco Fit xây dựng bằng NestJS 11, PostgreSQL và Prisma ORM 7. Prisma dùng PostgreSQL driver adapter thuần JavaScript để build gọn và triển khai linh hoạt.

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

Schema hiện chỉ khai báo PostgreSQL và Prisma Client. Các model nghiệp vụ sẽ được thêm ở phase **Database Schema** tiếp theo.

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
