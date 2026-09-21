# Eco Fit Flutter

Bản Flutter native được chuyển từ prototype React/Vite ở thư mục cha, giữ nguyên 15 màn hình, nội dung tiếng Việt và các tương tác demo/local state.

## Chạy dự án

```bash
flutter pub get
flutter run
```

Chọn thiết bị Android, iOS, Windows hoặc trình duyệt từ danh sách thiết bị của Flutter.

## Cấu trúc chính

- `lib/main.dart`: khởi tạo app và routes
- `lib/screens.dart`: 15 màn hình và state tương tác
- `lib/widgets.dart`: các widget dùng chung
- `lib/data.dart`: dữ liệu mẫu và phép tính BMI/BMR/TDEE
- `lib/theme.dart`: màu sắc, typography và Material 3 theme

## Màn hình

Splash, Onboarding Food, Onboarding Workout, Login, Home, Meal Plan, Meal Detail, Grocery, Workout Plan, Exercise Detail, Progress, Body Metrics, Daily Check-in, AI Coach và Profile.
