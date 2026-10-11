# Google Sign-In cho Eco Fit

Eco Fit dùng Google Identity Services trên web và Google Credential Manager trên Android. Backend chỉ nhận Google ID token, kiểm tra token bằng thư viện Google chính thức rồi mới tạo phiên Eco Fit.

## Thông tin Android hiện tại

- Package name: `com.ecofit.eco_fit`
- Debug SHA-1: `65:43:0F:51:4D:01:6A:4E:82:75:2F:07:A6:59:1D:3C:DF:74:4B:F4`
- Debug SHA-256: `5B:45:F2:EF:B9:6E:0A:0D:B5:BA:4D:32:B7:B0:FF:D3:37:48:36:8F:7B:6A:F8:32:4C:31:5C:4B:AF:B3:42:04`

Release phải dùng SHA của khóa release thật, không dùng SHA debug ở trên.

## Tạo OAuth credentials

Trong cùng một Google Cloud project:

1. Cấu hình OAuth consent screen.
2. Tạo OAuth Client ID loại **Web application**.
3. Thêm Authorized JavaScript origins:
   - `http://localhost:8088`
   - domain HTTPS production sau này, ví dụ `https://app.ecofit.example`
4. Tạo OAuth Client ID loại **Android**:
   - Package: `com.ecofit.eco_fit`
   - SHA-1: dùng debug SHA-1 ở trên khi test emulator.
5. Sao chép **Web Client ID**. Eco Fit dùng chính ID này làm audience phía backend và `serverClientId` trên Android.

Không cần lưu OAuth Client Secret trong Flutter. Client ID không phải bí mật.

## Cấu hình local

Sao chép file mẫu:

```powershell
Copy-Item config/google_oauth.example.json config/google_oauth.local.json
```

Điền Web Client ID:

```json
{
  "GOOGLE_WEB_CLIENT_ID": "123456789-example.apps.googleusercontent.com"
}
```

Trong `backend/.env`, đặt cùng Web Client ID:

```dotenv
GOOGLE_CLIENT_IDS=123456789-example.apps.googleusercontent.com
```

Nếu production có nhiều audience hợp lệ, phân cách các Client ID bằng dấu phẩy.

## Chạy và build

Web development phải dùng port cố định đã đăng ký:

```powershell
flutter run -d chrome --web-hostname localhost --web-port 8088 --dart-define-from-file=config/google_oauth.local.json
```

Android emulator:

```powershell
flutter run -d emulator-5554 --dart-define-from-file=config/google_oauth.local.json
```

Build:

```powershell
flutter build web --dart-define-from-file=config/google_oauth.local.json
flutter build apk --debug --dart-define-from-file=config/google_oauth.local.json
```

Khởi động lại backend sau khi thay `GOOGLE_CLIENT_IDS`.

## Kết quả đúng

- Web hiển thị nút Google do Google Identity Services render.
- Android mở trình chọn tài khoản Google.
- Backend chỉ chấp nhận ID token có audience nằm trong `GOOGLE_CLIENT_IDS` và email đã được Google xác minh.
- Lần đăng nhập đầu tạo `users` và `auth_identities`; các lần sau dùng lại cùng user.
- Refresh trang vẫn giữ phiên Eco Fit bằng refresh token của Eco Fit, không phụ thuộc phiên Google trên trình duyệt.
