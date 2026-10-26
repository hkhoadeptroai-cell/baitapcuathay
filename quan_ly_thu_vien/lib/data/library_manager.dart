import 'package:flutter/foundation.dart';

import '../models/book.dart';
import '../models/student.dart';

class LibraryManager extends ChangeNotifier {
  LibraryManager._();
  static final instance = LibraryManager._();

  final List<Book> books = [
    Book('B01', 'Sách 01', 'Nguyễn Văn A', 2020),
    Book('B02', 'Sách 02', 'Trần Thị B', 2021),
    Book('B03', 'Sách 03', 'Lê Văn C', 2019),
    Book('B04', 'Sách 04', 'Phạm Thị D', 2022),
  ];

  final List<Student> students = [
    Student('SV01', 'Nguyen Van A'),
    Student('SV02', 'Tran Thi B'),
    Student('SV03', 'Le Van C'),
  ];

  late Student current = students.first;

  List<Book> get available => books.where((b) => b.isAvailable).toList();

  void select(Student s) {
    current = s;
    notifyListeners();
  }

  void addBook(String title) {
    books.add(
      Book('B${books.length + 1}', title, 'Đang cập nhật', DateTime.now().year),
    );
    notifyListeners();
  }

  void addStudent(String name) {
    students.add(Student('SV${students.length + 1}', name));
    notifyListeners();
  }

  void borrow(Student s, Iterable<Book> list) {
    for (final b in list) {
      if (!b.isAvailable) continue;
      b.borrowedBy = s;
      s.borrowed.add(b);
    }
    notifyListeners();
  }

  void giveBack(Book b) {
    b.borrowedBy?.borrowed.remove(b);
    b.borrowedBy = null;
    notifyListeners();
  }
}
