String two(int n) => n.toString().padLeft(2, '0');
String fmtTime(DateTime d) => '${two(d.hour)}:${two(d.minute)}';
String fmtDate(DateTime d) => '${two(d.day)}/${two(d.month)}';

bool isSameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

String relDay(DateTime d) {
  final now = DateTime.now();
  if (isSameDay(d, now)) return 'Hôm nay';
  if (isSameDay(d, now.add(const Duration(days: 1)))) return 'Ngày mai';
  return fmtDate(d);
}

String fmtLong(DateTime d) {
  const names = ['Hai', 'Ba', 'Tư', 'Năm', 'Sáu', 'Bảy'];
  final w = d.weekday == 7 ? 'Chủ nhật' : 'Thứ ${names[d.weekday - 1]}';
  return '$w, ${d.day} tháng ${d.month}';
}
