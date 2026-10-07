import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

const blue = Color(0xFF2196F3);
const red = Color(0xFFEF3E3E);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(debugShowCheckedModeBanner: false, home: Home());
  }
}

// Thanh dưới cùng để chuyển nhanh giữa các màn hình khi demo
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int index = 0;
  final screens = const [
    HelloScreen(),
    NumberScreen(),
    EmailScreen(),
    CalcScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(child: screens[index]),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: index,
        onTap: (i) => setState(() => index = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Hello'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Number'),
          BottomNavigationBarItem(icon: Icon(Icons.email), label: 'Email'),
          BottomNavigationBarItem(icon: Icon(Icons.calculate), label: 'Calc'),
        ],
      ),
    );
  }
}

// ---------- 1. Hello World ----------
class HelloScreen extends StatelessWidget {
  const HelloScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            // Muốn dùng ảnh thật: CircleAvatar(radius: 50, backgroundImage: AssetImage('assets/avatar.png'))
            CircleAvatar(
              radius: 50,
              backgroundColor: red,
              child: Icon(Icons.person, size: 60, color: Colors.white),
            ),
            SizedBox(height: 16),
            Text(
              'Nguyen Hoang Huy Khoa - 058206001568',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            SizedBox(height: 8),
            Text(
              'Mong muốn và định hướng của bạn là gì sau khi học xong môn học là gì?',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------- 2. Thực hành 02: nhập số -> tạo danh sách nút ----------
class NumberScreen extends StatefulWidget {
  const NumberScreen({super.key});

  @override
  State<NumberScreen> createState() => _NumberScreenState();
}

class _NumberScreenState extends State<NumberScreen> {
  final controller = TextEditingController();
  String error = '';
  int count = 0;

  void create() {
    final n = int.tryParse(controller.text.trim());
    setState(() {
      if (n == null || n <= 0) {
        error = 'Dữ liệu bạn nhập không hợp lệ';
        count = 0;
      } else {
        error = '';
        count = n;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 0),
      child: Column(
        children: [
          const Text(
            'Thực hành 02',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: 'Nhập vào số lượng',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: create,
                style: ElevatedButton.styleFrom(
                  backgroundColor: blue,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Tạo'),
              ),
            ],
          ),
          if (error.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                error,
                style: const TextStyle(color: Colors.red, fontSize: 11),
              ),
            ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.separated(
              itemCount: count,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (_, i) => SizedBox(
                height: 40,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: red,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text('${i + 1}'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------- 3. Email ----------
class EmailScreen extends StatefulWidget {
  const EmailScreen({super.key});

  @override
  State<EmailScreen> createState() => _EmailScreenState();
}

class _EmailScreenState extends State<EmailScreen> {
  final controller = TextEditingController();
  String message = '';
  bool ok = false;

  void check() {
    final e = controller.text.trim();
    final valid = RegExp(r'^[\w.+-]+@[\w-]+(\.[\w-]+)+$').hasMatch(e);
    setState(() {
      if (e.isEmpty) {
        ok = false;
        message = 'Email không được để trống';
      } else if (!valid) {
        ok = false;
        message = 'Email không đúng định dạng';
      } else {
        ok = true;
        message = 'Email hợp lệ';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 60, 24, 0),
      child: Column(
        children: [
          const Text(
            'Thực hành 03',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: controller,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              hintText: 'Email',
              border: OutlineInputBorder(),
              isDense: true,
            ),
          ),
          if (message.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                message,
                style: TextStyle(
                  color: ok ? Colors.green[800] : Colors.red,
                  fontSize: 11,
                ),
              ),
            ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: check,
              style: ElevatedButton.styleFrom(
                backgroundColor: blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text('Kiểm tra'),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------- 4. Máy tính ----------
class CalcScreen extends StatefulWidget {
  const CalcScreen({super.key});

  @override
  State<CalcScreen> createState() => _CalcScreenState();
}

class _CalcScreenState extends State<CalcScreen> {
  final a = TextEditingController();
  final b = TextEditingController();
  String result = '';

  void calc(String op) {
    final x = double.tryParse(a.text.trim());
    final y = double.tryParse(b.text.trim());
    String r;
    if (x == null || y == null) {
      r = 'Dữ liệu không hợp lệ';
    } else if (op == '/' && y == 0) {
      r = 'Không thể chia cho 0';
    } else {
      final v = op == '+'
          ? x + y
          : op == '-'
          ? x - y
          : op == '*'
          ? x * y
          : x / y;
      r = v == v.truncateToDouble() ? v.toInt().toString() : v.toString();
    }
    setState(() => result = r);
  }

  @override
  Widget build(BuildContext context) {
    final ops = {
      '+': red,
      '-': const Color(0xFFE8A93A),
      '*': const Color(0xFF6C3CE9),
      '/': const Color(0xFF1E1E1E),
    };

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 0),
      child: Column(
        children: [
          const Text(
            'Thực hành 03',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: a,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: 'Số thứ nhất',
              border: OutlineInputBorder(),
              isDense: true,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: ops.entries
                .map(
                  (e) => ElevatedButton(
                    onPressed: () => calc(e.key),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: e.value,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(44, 44),
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: Text(e.key),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: b,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: 'Số thứ hai',
              border: OutlineInputBorder(),
              isDense: true,
            ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Kết quả: $result',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
