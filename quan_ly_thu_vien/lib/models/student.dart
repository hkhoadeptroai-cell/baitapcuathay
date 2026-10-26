import 'book.dart';

class Student {
  Student(this.id, this.name);

  final String id;
  final String name;
  final List<Book> borrowed = [];
}
