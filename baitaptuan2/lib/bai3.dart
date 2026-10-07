import 'package:flutter/material.dart';

import 'bai2.dart'; // dùng lại hàm xepLoai, mauChu của Bài 2

// 1. Class Student gồm name và double? score
class Student {
  String name;
  double? score;

  Student(this.name, this.score);
}

class Bai3Screen extends StatelessWidget {
  const Bai3Screen({super.key});

  @override
  Widget build(BuildContext context) {
    List<Student> students = [
      Student('Nguyễn Văn An', 9.0),
      Student('Trần Thị Bình', 7.2),
      Student('Lê Minh Chi', null),
      Student('Phạm Quốc Dũng', 4.5),
      Student('Võ Thanh Em', 5.8),
    ];

    // 3. Dùng for + if để tính các số liệu
    double tong = 0;
    int daCoDiem = 0;
    int soGioi = 0;
    int chuaCoDiem = 0;
    double caoNhat = 0;

    for (Student s in students) {
      if (s.score == null) {
        chuaCoDiem++;
      } else {
        tong += s.score!;
        daCoDiem++;
        if (xepLoai(s.score!) == 'Giỏi') {
          soGioi++;
        }
        if (s.score! > caoNhat) {
          caoNhat = s.score!;
        }
      }
    }

    double trungBinh = 0;
    if (daCoDiem > 0) {
      trungBinh = tong / daCoDiem;
    }

    // 2. Dùng for để tạo từng dòng sinh viên
    List<Widget> dong = [];
    for (Student s in students) {
      String loai;
      String diemText;
      Color mau;

      if (s.score == null) {
        loai = 'Chưa có điểm';
        diemText = '—';
        mau = Colors.grey;
      } else {
        loai = xepLoai(s.score!);
        diemText = s.score!.toStringAsFixed(1);
        mau = mauChu(loai);
      }

      dong.add(
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    s.name,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    loai,
                    style: TextStyle(
                      color: mau,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Text(
                diemText,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
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
        title: const Text('Bảng điểm lớp'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thẻ xanh tổng kết
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF2C447C),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Điểm trung bình lớp',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  Text(
                    trungBinh.toStringAsFixed(2),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      thongKe('Giỏi', '$soGioi'),
                      thongKe('Chưa có điểm', '$chuaCoDiem'),
                      thongKe('Cao nhất', caoNhat.toStringAsFixed(1)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'DANH SÁCH · ${students.length} SINH VIÊN',
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...dong,
          ],
        ),
      ),
    );
  }

  // Một ô thống kê nhỏ trong thẻ xanh
  Widget thongKe(String nhan, String giaTri) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(nhan, style: const TextStyle(color: Colors.white70, fontSize: 11)),
        const SizedBox(height: 2),
        Text(
          giaTri,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
