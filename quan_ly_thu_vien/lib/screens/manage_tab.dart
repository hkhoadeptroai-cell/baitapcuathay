import 'package:flutter/material.dart';

import '../data/library_manager.dart';
import '../models/book.dart';
import '../models/student.dart';

class ManageTab extends StatefulWidget {
  const ManageTab({super.key});
  @override
  State<ManageTab> createState() => _ManageTabState();
}

class _ManageTabState extends State<ManageTab> {
  final _lib = LibraryManager.instance;
  final _picked = <Book>{};

  Future<void> _changeStudent() async {
    final s = await showDialog<Student>(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text('Chọn sinh viên'),
        children: [
          for (final s in _lib.students)
            SimpleDialogOption(
              onPressed: () => Navigator.pop(ctx, s),
              child: Text('${s.id} - ${s.name}'),
            ),
        ],
      ),
    );
    if (s != null) _lib.select(s);
  }

  void _borrow() {
    final n = _picked.length;
    _lib.borrow(_lib.current, _picked);
    _picked.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${_lib.current.name} đã mượn $n sách')),
    );
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: _lib,
    builder: (_, __) {
      final books = _lib.available;
      final bold = Theme.of(context).textTheme.titleMedium
          ?.copyWith(fontWeight: FontWeight.bold);
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Hệ thống\nQuản lý Thư viện',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 32),
              Text('Sinh viên', style: bold),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      child: Text(_lib.current.name),
                    ),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: _changeStudent,
                    child: const Text('Thay đổi'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text('Danh sách sách', style: bold),
              const SizedBox(height: 8),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: books.isEmpty
                      ? const Center(child: Text('Không còn sách để mượn'))
                      : ListView.builder(
                          padding: const EdgeInsets.all(8),
                          itemCount: books.length,
                          itemBuilder: (_, i) {
                            final b = books[i];
                            return Card(
                              shape: const StadiumBorder(),
                              child: CheckboxListTile(
                                shape: const StadiumBorder(),
                                title: Text(b.title),
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                value: _picked.contains(b),
                                onChanged: (v) => setState(
                                  () => v! ? _picked.add(b) : _picked.remove(b),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: SizedBox(
                  width: 220,
                  height: 48,
                  child: FilledButton(
                    onPressed: _picked.isEmpty ? null : _borrow,
                    child: const Text('Thêm'),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
