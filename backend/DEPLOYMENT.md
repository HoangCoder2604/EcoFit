# Deploy PostgreSQL + Prisma

## Hai URL kết nối

- `DATABASE_URL`: kết nối runtime của NestJS. Trên cloud nên dùng URL qua connection pooler.
- `DIRECT_URL`: kết nối trực tiếp dùng cho migration, introspection và Prisma Studio.

Với PostgreSQL tự quản lý, hai URL có thể giống nhau. Với Neon, Supabase hoặc Prisma Postgres, lấy riêng pooled URL và direct URL từ dashboard nhà cung cấp.

Ví dụ production:

```env
DATABASE_URL=postgresql://USER:PASSWORD@POOLER_HOST:6543/ecofit?sslmode=require
DIRECT_URL=postgresql://USER:PASSWORD@DIRECT_HOST:5432/ecofit?sslmode=require
DATABASE_CONNECT_ON_START=true
DB_POOL_MAX=10
DB_CONNECTION_TIMEOUT_MS=5000
DB_IDLE_TIMEOUT_MS=30000
```

Không commit `.env` hoặc thông tin đăng nhập thật.

## Quy trình CI/CD

Thực hiện theo thứ tự:

```bash
npm ci
npm run prisma:generate
npm run db:deploy
npm run build
npm run start:prod
```

`db:deploy` dùng `prisma migrate deploy`, chỉ áp dụng migration đã được review. Không dùng `prisma migrate dev` hoặc `prisma db push` trong production.

Nếu deploy nhiều replica, chỉ chạy migration một lần trong release job/pre-deploy job; không chạy đồng thời trong từng container ứng dụng.

## Docker image

Build backend:

```bash
docker build -t eco-fit-api .
```

Khi chạy, truyền secrets từ nền tảng deploy:

```bash
docker run --rm -p 3000:3000 \
  -e DATABASE_URL="$DATABASE_URL" \
  -e DIRECT_URL="$DIRECT_URL" \
  eco-fit-api
```

Endpoint kiểm tra:

- Liveness: `/api/v1/health`
- Readiness PostgreSQL: `/api/v1/health/ready`

Load balancer chỉ nên chuyển traffic khi readiness trả HTTP 200.

## Lưu ý connection pool

- Server chạy lâu dài: đặt `DB_POOL_MAX` theo giới hạn database và số replica.
- Serverless: dùng pooled URL và pool nhỏ; tổng số kết nối xấp xỉ `DB_POOL_MAX × số instance đang chạy`.
- Migration luôn dùng direct URL để tránh lỗi transaction pooler.
- Cloud PostgreSQL thường yêu cầu `sslmode=require`.
