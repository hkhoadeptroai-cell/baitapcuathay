import 'student.dart';

class Book {
  Book(this.id, this.title, this.author, this.year);

  final String id, title, author;
  final int year;
  Student? borrowedBy;

  bool get isAvailable => borrowedBy == null;
}
