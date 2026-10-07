import 'package:flutter/material.dart';

// 1. Khai báo biến điểm
double diem = 8.5;

// 2. Hàm nhận điểm, trả về xếp loại
String xepLoai(double d) {
  if (d < 0 || d > 10) {
    return 'Không hợp lệ';
  } else if (d >= 8.0) {
    return 'Giỏi';
  } else if (d >= 6.5) {
    return 'Khá';
  } else if (d >= 5.0) {
    return 'Trung bình';
  } else {
    return 'Yếu';
  }
}

// 3. Chọn màu chữ bằng if
Color mauChu(String loai) {
  if (loai == 'Giỏi') {
    return Colors.green.shade800;
  } else if (loai == 'Khá') {
    return Colors.blue.shade800;
  } else if (loai == 'Trung bình') {
    return Colors.orange.shade800;
  } else if (loai == 'Yếu') {
    return Colors.red.shade700;
  } else {
    return Colors.grey.shade700;
  }
}

// Màu nền nhạt tương ứng
Color mauNen(String loai) {
  if (loai == 'Giỏi') {
    return Colors.green.shade100;
  } else if (loai == 'Khá') {
    return Colors.blue.shade100;
  } else if (loai == 'Trung bình') {
    return Colors.orange.shade100;
  } else if (loai == 'Yếu') {
    return Colors.red.shade100;
  } else {
    return Colors.grey.shade300;
  }
}

// Hiển thị 9.0 thành "9", 5.5 giữ nguyên
String hienDiem(double d) {
  if (d == d.toInt()) {
    return d.toInt().toString();
  } else {
    return d.toString();
  }
}

class Bai2Screen extends StatelessWidget {
  const Bai2Screen({super.key});

  @override
  Widget build(BuildContext context) {
    String loai = xepLoai(diem);

    // 4. Phần "Kiểm tra thêm": gọi hàm với các điểm 9, 7, 5.5, 3, 11
    List<double> dsDiem = [9, 7, 5.5, 3, 11];
    List<Widget> dong = [];
    for (double d in dsDiem) {
      String l = xepLoai(d);
      dong.add(
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Điểm ${hienDiem(d)}'),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: mauNen(l),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  l,
                  style: TextStyle(
                    color: mauChu(l),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF1F3F8),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2C447C),
        foregroundColor: Colors.white,
        title: const Text('Xếp loại học lực'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thẻ điểm trung bình
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const Text(
                    'Điểm trung bình',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    hienDiem(diem),
                    style: const TextStyle(
                      fontSize: 56,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: mauNen(loai),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      loai,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: mauChu(loai),
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'KIỂM TRA THÊM',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            // Thẻ danh sách kiểm tra
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(children: dong),
            ),
          ],
        ),
      ),
    );
  }
}
