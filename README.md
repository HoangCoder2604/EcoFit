# Eco Fit Flutter

Bản Flutter native được chuyển từ prototype React/Vite ở thư mục cha, giữ nguyên 15 màn hình, nội dung tiếng Việt và các tương tác demo/local state.

## Chạy dự án

```bash
flutter pub get
flutter run
```

Chọn thiết bị Android, iOS, Windows hoặc trình duyệt từ danh sách thiết bị của Flutter.

## Cấu trúc chính

- `lib/app`: app root và router tập trung
- `lib/core`: theme và nền tảng dùng chung
- `lib/domain`: model và nghiệp vụ thuần Dart
- `lib/data`: mock data, sau này thay bằng repository/API
- `lib/features`: public API theo từng feature
- `lib/shared`: widget dùng chung
- `docs/architecture.md`: quy tắc kiến trúc và phụ thuộc

## Màn hình

Splash, Onboarding Food, Onboarding Workout, Login, Home, Meal Plan, Meal Detail, Grocery, Workout Plan, Exercise Detail, Progress, Body Metrics, Daily Check-in, AI Coach và Profile.
