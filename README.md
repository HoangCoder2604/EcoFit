# Eco Fit - 15 UI Frontend

Bản frontend được dựng theo 15 UI đã chốt.

## 15 màn hình
1. Splash
2. Onboarding Food
3. Onboarding Workout
4. Login / Sign up
5. Home Dashboard
6. Meal Plan
7. Meal Detail
8. Grocery & Budget
9. Workout Plan
10. Exercise Detail
11. Progress
12. Body Metrics
13. Daily Check-in
14. AI Coach
15. Profile & Settings

## Công nghệ
- Vite
- React
- React Router
- Lucide React
- CSS thuần
- Dữ liệu demo/local state

## Chạy dự án
```bash
npm install
npm run dev
```

Mở URL Vite hiện trong terminal, thường là:
```text
http://localhost:5173
```

## Build
```bash
npm run build
npm run preview
```

## Route nhanh
- `/` splash
- `/home`
- `/meals`
- `/workouts`
- `/progress`
- `/metrics`
- `/checkin`
- `/coach`
- `/profile`

## NestJS Backend

Backend nền tảng nằm trong thư mục `backend/`. Xem hướng dẫn chạy, health check,
Swagger và kiểm thử tại [`backend/README.md`](backend/README.md).

PostgreSQL và Prisma chưa được thêm ở phase này; chúng thuộc phase tiếp theo của
lộ trình Eco Fit.
