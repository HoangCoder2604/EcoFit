# Kiến trúc Flutter Eco Fit

## Mục tiêu

Giữ presentation độc lập với backend để có thể nối NestJS/PostgreSQL ở các giai đoạn sau mà không phải viết lại UI.

## Các lớp

- `app/`: khởi tạo ứng dụng và điều phối route.
- `core/`: theme, hằng số và tiện ích dùng toàn ứng dụng.
- `domain/`: model nghiệp vụ và phép tính thuần Dart.
- `data/`: dữ liệu mock hiện tại; sau này là repository/API/local database.
- `features/`: public API của từng nhóm chức năng.
- `shared/`: widget dùng chung giữa nhiều feature.

## Quy tắc phụ thuộc

```text
presentation/features -> domain <- data
app/router -> features
core/shared -> không phụ thuộc feature
```

Domain không import Flutter và có thể kiểm thử bằng unit test. Route được đặt tên tập trung trong `AppRoutes`; không thêm chuỗi route trực tiếp vào widget.

## Compatibility layer

`lib/data.dart`, `lib/theme.dart`, `lib/screens.dart` và `lib/widgets.dart` giữ tương thích cho presentation hiện tại. Code mới phải import từ thư mục phân lớp. Việc tách từng màn hình vật lý sẽ tiếp tục bên trong feature tương ứng khi feature được triển khai với API thật, tránh thay đổi lớn lặp lại trước giai đoạn backend.
