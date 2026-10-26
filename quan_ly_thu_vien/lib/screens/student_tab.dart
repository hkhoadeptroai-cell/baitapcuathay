import 'package:flutter/material.dart';

import '../core/dialogs.dart';
import '../data/library_manager.dart';

class StudentTab extends StatelessWidget {
  const StudentTab({super.key});

  @override
  Widget build(BuildContext context) {
    final lib = LibraryManager.instance;
    return Scaffold(
      appBar: AppBar(title: const Text('Danh sách sinh viên')),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final t = await askText(context, 'Tên sinh viên mới');
          if (t != null && t.isNotEmpty) lib.addStudent(t);
        },
        child: const Icon(Icons.person_add),
      ),
      body: ListenableBuilder(
        listenable: lib,
        builder: (_, __) => ListView(
          children: [
            for (final s in lib.students)
              ExpansionTile(
                leading: const Icon(Icons.person_outline),
                title: Text(s.name),
                subtitle: Text('${s.id} • Đang mượn ${s.borrowed.length} sách'),
                children: [
                  if (s.borrowed.isEmpty)
                    const ListTile(title: Text('Chưa mượn sách nào')),
                  for (final b in s.borrowed)
                    ListTile(
                      title: Text(b.title),
                      subtitle: Text('${b.author} • ${b.year}'),
                      trailing: TextButton(
                        onPressed: () => lib.giveBack(b),
                        child: const Text('Trả sách'),
                      ),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
