import 'package:flutter/material.dart';

// Điểm bắt đầu: chạy app, màn hình đầu tiên là Welcome
void main() => runApp(
  MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
    home: const Welcome(),
  ),
);

// Hàm chuyển màn hình: mở trang mới có thanh tiêu đề và nút quay lại
// Chuyển màn: hiện skeleton 1.2 giây rồi mới hiện nội dung thật
void go(BuildContext c, String title, Widget body) => Navigator.push(
  c,
  MaterialPageRoute(
    builder: (_) => Scaffold(
      appBar: AppBar(title: Text(title), centerTitle: true),
      body: FutureBuilder(
        future: Future.delayed(const Duration(milliseconds: 1200)),
        builder: (_, s) => AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: s.connectionState == ConnectionState.done
              ? body
              : const Skeleton(),
        ),
      ),
    ),
  ),
);

// Skeleton: các khối xám nhấp nháy (mờ sáng liên tục) làm hiệu ứng chờ tải
class Skeleton extends StatefulWidget {
  const Skeleton({super.key});
  @override
  State<Skeleton> createState() => _SkeletonState();
}

class _SkeletonState extends State<Skeleton>
    with SingleTickerProviderStateMixin {
  late final ctrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 800),
  )..repeat(reverse: true);

  @override
  void dispose() {
    ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FadeTransition(
    opacity: Tween(begin: 0.4, end: 1.0).animate(ctrl),
    child: ListView(
      padding: const EdgeInsets.all(16),
      children: [
        for (var i = 0; i < 6; i++)
          Container(
            height: i == 0 ? 160 : 60,
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
      ],
    ),
  );
}

// Ô màu bo góc dùng cho demo Row/Column
Widget box([Color? c]) => Container(
  width: 80,
  height: 50,
  margin: const EdgeInsets.all(6),
  decoration: BoxDecoration(
    color: c ?? Colors.blue.shade200,
    borderRadius: BorderRadius.circular(10),
  ),
);

// Thêm khoảng cách xung quanh widget
Widget pad(Widget w) => Padding(padding: const EdgeInsets.all(20), child: w);

// Màn hình chào, nút "I'm ready" chuyển sang danh sách
class Welcome extends StatelessWidget {
  const Welcome({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Spacer(),
            const Icon(Icons.hexagon, size: 130, color: Colors.green),
            const SizedBox(height: 24),
            const Text(
              'Jetpack Compose',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              'Jetpack Compose is a modern UI toolkit for building native Android applications using a declarative programming approach.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13),
            ),
            const Spacer(),
            // Spacer đẩy nút xuống đáy, SizedBox(width: infinity) làm nút full chiều ngang
            SizedBox(
              width: double.infinity,
              height: 50,
              child: FilledButton(
                onPressed: () =>
                    go(context, 'UI Components List', const Home()),
                child: const Text("I'm ready"),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

// Màn danh sách: dữ liệu gồm nhóm -> tên -> [mô tả, màn chi tiết]
class Home extends StatelessWidget {
  const Home({super.key});
  @override
  Widget build(BuildContext context) {
    final data = {
      'Display': {
        'Text': ['Displays text', textDemo()],
        'Image': ['Displays an image', imageDemo()],
      },
      'Input': {
        'TextField': ['Input field for text', textFieldDemo()],
        'PasswordField': ['Input field for passwords', passwordDemo()],
      },
      'Layout': {
        'Column': [
          'Arranges elements vertically',
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [box(), box(Colors.blue), box()],
            ),
          ),
        ],
        'Row': [
          'Arranges elements horizontally',
          Column(
            children: [
              for (var i = 0; i < 4; i++)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [box(), box(Colors.blue), box()],
                ),
            ],
          ),
        ],
      },
      'Tự tìm hiểu': {
        'Selection': ['Button, Checkbox, Radio, Picker', selectionDemo()],
        'Input nâng cao': ['Toggle, Slider, DatePicker', inputDemo()],
        'Navigation': ['TabBar, Menu', navDemo()],
        'Content': ['List, Card, Divider', contentDemo()],
      },
    };
    // Duyệt dữ liệu để tự sinh tiêu đề nhóm và các thẻ bấm được
    return ListView(
      children: [
        for (final g in data.entries) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
            child: Text(
              g.key,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          for (final e in g.value.entries)
            Card(
              color: g.key == 'Tự tìm hiểu'
                  ? Colors.red.shade100
                  : Colors.blue.shade100,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: ListTile(
                title: Text(e.key),
                subtitle: Text(e.value[0] as String),
                onTap: () => go(context, e.key, e.value[1] as Widget),
              ),
            ),
        ],
      ],
    );
  }
}

// Text: Text.rich + TextSpan để mỗi từ một kiểu (gạch ngang, màu, nghiêng, đậm...)
Widget textDemo() => pad(
  Text.rich(
    TextSpan(
      style: const TextStyle(fontSize: 28, color: Colors.black),
      children: [
        const TextSpan(text: 'The '),
        const TextSpan(
          text: 'quick ',
          style: TextStyle(decoration: TextDecoration.lineThrough),
        ),
        TextSpan(
          text: 'Brown ',
          style: TextStyle(color: Colors.orange.shade800, fontSize: 34),
        ),
        const TextSpan(text: 'fox '),
        const TextSpan(text: 'jumps ', style: TextStyle(letterSpacing: 6)),
        const TextSpan(
          text: 'over ',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
          ),
        ),
        const TextSpan(
          text: 'the ',
          style: TextStyle(decoration: TextDecoration.underline),
        ),
        const TextSpan(
          text: 'lazy ',
          style: TextStyle(
            fontStyle: FontStyle.italic,
            fontFamily: 'monospace',
          ),
        ),
        const TextSpan(text: 'dog.'),
      ],
    ),
  ),
);

// Image: Image.network tải ảnh từ link
Widget imageDemo() {
  const u1 =
      'https://giaothongvantaitphcm.edu.vn/wp-content/uploads/2025/01/Logo-GTVT.png';
  const u2 = 'https://picsum.photos/600/300';
  return ListView(
    padding: const EdgeInsets.all(16),
    children: [
      Image.network(u1),
      const Text(
        u1,
        style: TextStyle(fontSize: 11, decoration: TextDecoration.underline),
      ),
      const SizedBox(height: 16),
      Image.network(u2),
      const Center(child: Text('In app')),
    ],
  );
}

// TextField: onChanged cập nhật biến t, setState (set) vẽ lại chữ đỏ ngay khi gõ
Widget textFieldDemo() {
  var t = '';
  return StatefulBuilder(
    builder: (c, set) => pad(
      Column(
        children: [
          TextField(
            decoration: const InputDecoration(
              hintText: 'Thông tin nhập',
              border: OutlineInputBorder(),
            ),
            onChanged: (v) => set(() => t = v),
          ),
          const SizedBox(height: 16),
          Text(
            t.isEmpty ? 'Tự động cập nhật dữ liệu theo textfield' : t,
            style: const TextStyle(color: Colors.red),
          ),
        ],
      ),
    ),
  );
}

// PasswordField: obscureText ẩn ký tự, nút con mắt đảo biến hide để hiện/ẩn
Widget passwordDemo() {
  var hide = true;
  return StatefulBuilder(
    builder: (c, set) => pad(
      TextField(
        obscureText: hide,
        decoration: InputDecoration(
          hintText: 'Mật khẩu',
          border: const OutlineInputBorder(),
          suffixIcon: IconButton(
            icon: Icon(hide ? Icons.visibility_off : Icons.visibility),
            onPressed: () => set(() => hide = !hide),
          ),
        ),
      ),
    ),
  );
}

// Selection: Button (hiện SnackBar), Checkbox, Radio (chọn 1), Picker (Dropdown)
Widget selectionDemo() {
  var check = false, radio = 1, pick = 'Hà Nội';
  return StatefulBuilder(
    builder: (c, set) => ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ElevatedButton(
          onPressed: () =>
              ScaffoldMessenger.of(c)
                  .showSnackBar(const SnackBar(content: Text('Đã bấm Button'))),
          child: const Text('Button'),
        ),
        CheckboxListTile(
          title: const Text('Checkbox'),
          value: check,
          onChanged: (v) => set(() => check = v!),
        ),
        // Các Radio dùng chung groupValue nên chỉ chọn được 1
        for (final i in [1, 2])
          RadioListTile<int>(
            title: Text('RadioButton $i'),
            value: i,
            groupValue: radio,
            onChanged: (v) => set(() => radio = v!),
          ),
        DropdownButton<String>(
          value: pick,
          isExpanded: true,
          items: [
            'Hà Nội',
            'TP.HCM',
            'Đà Nẵng',
          ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: (v) => set(() => pick = v!),
        ),
      ],
    ),
  );
}

// Toggle (Switch), Slider chọn giá trị 0-100, DatePicker mở hộp chọn ngày
Widget inputDemo() {
  var on = false, val = 50.0;
  DateTime? date;
  return StatefulBuilder(
    builder: (c, set) => ListView(
      padding: const EdgeInsets.all(16),
      children: [
        SwitchListTile(
          title: const Text('Toggle'),
          value: on,
          onChanged: (v) => set(() => on = v),
        ),
        Slider(
          value: val,
          max: 100,
          label: '${val.round()}',
          onChanged: (v) => set(() => val = v),
        ),
        ListTile(
          title: Text(
            date == null
                ? 'Chọn ngày'
                : '${date!.day}/${date!.month}/${date!.year}',
          ),
          trailing: const Icon(Icons.calendar_month),
          onTap: () async {
            // await: chờ người dùng chọn xong ngày mới chạy tiếp
            final d = await showDatePicker(
              context: c,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            );
            if (d != null) set(() => date = d);
          },
        ),
      ],
    ),
  );
}

// Navigation: TabBar chuyển 3 tab (TabBarView là nội dung), PopupMenuButton là Menu
Widget navDemo() => DefaultTabController(
  length: 3,
  child: Column(
    children: [
      const TabBar(
        tabs: [
          Tab(text: 'Tab 1'),
          Tab(text: 'Tab 2'),
          Tab(text: 'Tab 3'),
        ],
      ),
      const Expanded(
        child: TabBarView(
          children: [
            Center(child: Text('Nội dung 1')),
            Center(child: Text('Nội dung 2')),
            Center(child: Text('Nội dung 3')),
          ],
        ),
      ),
      Builder(
        builder: (c) => PopupMenuButton<String>(
          onSelected: (v) =>
              ScaffoldMessenger.of(c)
                  .showSnackBar(SnackBar(content: Text('Chọn: $v'))),
          itemBuilder: (_) => [
            'Sửa',
            'Xoá',
            'Chia sẻ',
          ].map((e) => PopupMenuItem(value: e, child: Text(e))).toList(),
          child: const Padding(
            padding: EdgeInsets.all(20),
            child: Text('Menu ⋮'),
          ),
        ),
      ),
    ],
  ),
);

// Content: List (ListView) chứa Card, Divider ngăn cách giữa các mục
Widget contentDemo() => ListView(
  children: [
    for (var i = 1; i <= 5; i++) ...[
      Card(
        margin: const EdgeInsets.all(8),
        child: ListTile(
          leading: const Icon(Icons.star),
          title: Text('Item $i'),
        ),
      ),
      const Divider(),
    ],
  ],
);
