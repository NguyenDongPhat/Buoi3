# Weather App - Flutter Project

Ứng dụng dự báo thời tiết hoàn chỉnh được xây dựng bằng Flutter, tích hợp dữ liệu từ OpenWeatherMap API.


## Các tính năng chính

<ul>
  <li><b>Dữ liệu thời tiết thời gian thực:</b> Lấy dữ liệu thời tiết hiện tại và dự báo 5 ngày tới từ OpenWeatherMap API</li>
  <li><b>Tự động xác định vị trí:</b> Sử dụng GPS để tự động cập nhật thời tiết tại vị trí người dùng thông qua thư viện <code>geolocator</code>.</li>
  <li><b>Tìm kiếm linh hoạt:</b> Tìm kiếm thời tiết tại bất kỳ thành phố nào với thanh tìm kiếm tích hợp nút định vị nhanh và auto-focus.</li>
  <li><b>Lịch sử & Yêu thích:</b> Lưu trữ danh sách các thành phố đã tìm kiếm và các địa điểm yêu thích bằng <code>shared_preferences</code>.</li>
  <li><b>Thông báo cục bộ:</b> Gửi thông báo hiển thị thông tin thời tiết ngay khi dữ liệu được tải về thành công thông qua <code>NotificationService</code>.</li>
  <li><b>Chế độ ngoại tuyến (Offline):</b> Tự động lưu (cache) dữ liệu thời tiết gần nhất để người dùng có thể xem lại khi không có kết nối mạng.</li>
  <li><b>Giao diện động:</b> Màu sắc và hiệu ứng gradient tự động thay đổi theo điều kiện thời tiết thực tế và chu kỳ Ngày/Đêm.</li>
  <li><b>Tùy chỉnh đơn vị:</b> Hỗ trợ chuyển đổi giữa độ C/F, đơn vị tốc độ gió (m/s, km/h) và định dạng thời gian (12h/24h).</li>
</ul>


## Công nghệ sử dụng

*   **Framework:** Flutter & Dart
*   **State Management:** Provider
*   **API:** RESTful API với thư viện <code>http</code>
*   **Vị trí:** <code>geolocator</code> & <code>geocoding</code>
*   **Lưu trữ:** <code>shared_preferences</code>
*   **Thông báo:** <code>flutter_local_notifications</code>


## Cách chạy dự án

<ol>
  <li>Clone repository này.</li>
  <li>Tạo file <code>.env</code> tại thư mục gốc và thêm API Key: <code>OPENWEATHER_API_KEY=your_key_here</code>.</li>
  <li>Chạy lệnh <code>flutter pub get</code> để tải thư viện.</li>
  <li>Chạy ứng dụng bằng <code>flutter run</code>.</li>
</ol>
Link video demo: https://drive.google.com/file/d/14IbqR7k3RXrfApHKuM-N0_cz7GN5Krfp/view?usp=sharing
