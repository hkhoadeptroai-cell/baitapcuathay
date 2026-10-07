import 'package:flutter/material.dart';

// 1. Class Student
class Student {
  String name;
  String? email;
  String? phone;

  Student(this.name, this.email, this.phone);
}

class StudentList extends StatelessWidget {
  const StudentList({super.key});

  @override
  Widget build(BuildContext context) {
    // 2. List 5 sinh viên, có người null email hoặc phone
    List<Student> students = [
      Student('Nguyễn Văn An', 'an@sv.edu.vn', '0901 234 567'),
      Student('Trần Thị Bình', null, '0912 888 999'),
      Student('Lê Minh Chi', 'chi@sv.edu.vn', null),
      Student('Phạm Quốc Dũng', null, null),
      Student('Võ Thanh Em', 'em@sv.edu.vn', '0933 111 222'),
    ];

    // 3. Dùng for để tạo các thẻ sinh viên
    List<Widget> cards = [];
    for (Student s in students) {
      // 4. Dùng ?? để thay null bằng "Chưa cập nhật"
      String email = s.email ?? 'Chưa cập nhật';
      String phone = s.phone ?? 'Chưa cập nhật';

      cards.add(
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                s.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Text('Email: '),
                  Text(
                    email,
                    style: TextStyle(
                      color: s.email == null ? Colors.red : Colors.black,
                      fontStyle: s.email == null
                          ? FontStyle.italic
                          : FontStyle.normal,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  const Text('SĐT: '),
                  Text(
                    phone,
                    style: TextStyle(
                      color: s.phone == null ? Colors.red : Colors.black,
                      fontStyle: s.phone == null
                          ? FontStyle.italic
                          : FontStyle.normal,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    // 5. Dùng for để đếm số sinh viên thiếu email
    int missingEmail = 0;
    for (Student s in students) {
      if (s.email == null) {
        missingEmail++;
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF1F3F8),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2C447C),
        foregroundColor: Colors.white,
        title: const Text('Danh sách sinh viên'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ...cards,
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFE3E9F5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Tổng: ${students.length} sinh viên'),
                  Text(
                    'Thiếu email: $missingEmail',
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
