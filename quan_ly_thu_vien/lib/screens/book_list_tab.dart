import 'package:flutter/material.dart';

import '../core/dialogs.dart';
import '../data/library_manager.dart';

class BookListTab extends StatelessWidget {
  const BookListTab({super.key});

  @override
  Widget build(BuildContext context) {
    final lib = LibraryManager.instance;
    return Scaffold(
      appBar: AppBar(title: const Text('Danh sách sách')),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final t = await askText(context, 'Tên sách mới');
          if (t != null && t.isNotEmpty) lib.addBook(t);
        },
        child: const Icon(Icons.add),
      ),
      body: ListenableBuilder(
        listenable: lib,
        builder: (_, __) => ListView.builder(
          itemCount: lib.books.length,
          itemBuilder: (_, i) {
            final b = lib.books[i];
            return ListTile(
              leading: const Icon(Icons.book_outlined),
              title: Text(b.title),
              subtitle: Text(
                'Mã: ${b.id} • Tác giả: ${b.author} • Năm: ${b.year}',
              ),
              trailing: Text(
                b.isAvailable ? 'Còn' : 'Đã mượn\n${b.borrowedBy!.name}',
                textAlign: TextAlign.end,
                style: TextStyle(
                  color: b.isAvailable ? Colors.green : Colors.red,
                  fontSize: 12,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
