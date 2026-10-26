import 'package:flutter/material.dart';

import '../models/reset_data.dart';

const kBlue = Color(0xFF4795EB);

void showMsg(BuildContext c, String m) =>
    ScaffoldMessenger.of(c).showSnackBar(SnackBar(content: Text(m)));

/// Mở màn hình kế tiếp, nếu nhận được kết quả thì chuyển tiếp về màn trước đó.
Future<void> pushAndForward(BuildContext context, Widget page) async {
  final result = await Navigator.push<ResetData>(
    context,
    MaterialPageRoute(builder: (_) => page),
  );
  if (result != null && context.mounted) Navigator.pop(context, result);
}

class AuthScaffold extends StatelessWidget {
  const AuthScaffold({
    super.key,
    required this.title,
    required this.subtitle,
    required this.child,
    this.showBack = true,
  });
  final String title, subtitle;
  final Widget child;
  final bool showBack;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.white,
    body: SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: showBack
                  ? Material(
                      color: kBlue,
                      borderRadius: BorderRadius.circular(12),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () => Navigator.pop(context),
                        child: const SizedBox(
                          width: 40,
                          height: 40,
                          child: Icon(Icons.chevron_left, color: Colors.white),
                        ),
                      ),
                    )
                  : const SizedBox(height: 40),
            ),
            const SizedBox(height: 40),
            const Text(
              'UTH',
              style: TextStyle(
                fontSize: 44,
                fontWeight: FontWeight.w900,
                color: Color(0xFF2E8B8B),
                letterSpacing: 2,
              ),
            ),
            const Text(
              'UNIVERSITY OF TRANSPORT\nHOCHIMINH CITY',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.bold,
                color: Color(0xFFC0392B),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'SmartTasks',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: kBlue,
              ),
            ),
            const SizedBox(height: 36),
            Text(
              title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 28),
            child,
          ],
        ),
      ),
    ),
  );
}

class AuthField extends StatelessWidget {
  const AuthField({
    super.key,
    required this.icon,
    this.hint,
    this.controller,
    this.obscure = false,
    this.readOnly = false,
    this.keyboard,
  });
  final IconData icon;
  final String? hint;
  final TextEditingController? controller;
  final bool obscure, readOnly;
  final TextInputType? keyboard;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 14),
    child: TextField(
      controller: controller,
      obscureText: obscure,
      readOnly: readOnly,
      keyboardType: keyboard,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, size: 20),
        filled: true,
        fillColor: const Color(0xFFF7F8FA),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE3E6EA)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE3E6EA)),
        ),
      ),
    ),
  );
}

class PrimaryButton extends StatelessWidget {
  const PrimaryButton(this.label, {super.key, required this.onPressed});
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    height: 50,
    child: FilledButton(
      style: FilledButton.styleFrom(
        backgroundColor: kBlue,
        shape: const StadiumBorder(),
      ),
      onPressed: onPressed,
      child: Text(label),
    ),
  );
}
