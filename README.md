# UTH SmartTasks (UTH Todo)

Ứng dụng quản lý công việc Flutter, môn Lập trình di động - UTH.
Sinh viên: [Họ tên] - MSSV: [MSSV]

## Tính năng

- Đăng nhập Firebase Authentication (Google, dùng thử không cần tài khoản)
- Trang chủ: tiến độ hôm nay, thống kê theo nhóm Học tập / Cuộc sống
- Danh sách: tìm kiếm, lọc nhóm, CẦN LÀM / ĐÃ XONG, nhãn Gấp
- Chi tiết: việc nhỏ (thêm, sửa, xóa, tick), đánh dấu hoàn thành, xóa công việc
- Thêm / sửa việc
- Thông báo, Cài đặt (giao diện sáng/tối, màu chủ đạo, cỡ chữ), Hồ sơ
- Firebase: Authentication, Realtime Database, Remote Config, Analytics, Cloud Messaging, Hosting

## API (mock server của giảng viên)

Base URL: `https://share.tryapps.store/mock/teach`
Header: `Authorization: Bearer TuanTruong-uth-student`

| Màn hình | Method | Endpoint |
|---|---|---|
| Trang chủ, Danh sách | GET | `/tasks` |
| Chi tiết | GET | `/tasks/{id}` |
| Sửa việc, tick, việc nhỏ | PATCH | `/tasks/{id}` |
| Xóa công việc | DELETE | `/tasks/{id}` |
| Thêm mới | POST | `/tasks` |

Mock server không lưu dữ liệu thật, nên app tự cập nhật danh sách trong máy sau khi gọi API thành công.
Mỗi lời gọi đều có trạng thái đang tải và báo lỗi (có nút Thử lại).

## Cấu trúc

```
lib/
├─ core/      routes.dart, utils.dart
├─ models/    task.dart
├─ data/      api_service.dart, task_repository.dart, auth_service.dart, ...
├─ widgets/   common.dart
└─ screens/   intro.dart, main_shell.dart, task_form.dart, task_detail.dart, profile.dart
```

## Chạy ứng dụng

```bash
flutter pub get
flutter run -d chrome
```

Demo: https://uth-todo-43070.web.app