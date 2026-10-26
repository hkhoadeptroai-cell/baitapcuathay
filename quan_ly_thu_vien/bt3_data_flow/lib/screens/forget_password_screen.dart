import 'package:flutter/material.dart';

import '../models/reset_data.dart';
import '../widgets/auth_widgets.dart';
import 'verify_code_screen.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});
  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final _email = TextEditingController();
  ResetData? _result;

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  Future<void> _next() async {
    final email = _email.text.trim();
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
      showMsg(context, 'Email không hợp lệ');
      return;
    }
    final result = await Navigator.push<ResetData>(
      context,
      MaterialPageRoute(builder: (_) => VerifyCodeScreen(email: email)),
    );
    if (result != null) setState(() => _result = result);
  }

  @override
  Widget build(BuildContext context) {
    final r = _result;
    return AuthScaffold(
      showBack: false,
      title: 'Forget Password?',
      subtitle: 'Enter your Email, we will send you a verification code.',
      child: Column(
        children: [
          AuthField(
            icon: Icons.mail_outline,
            hint: 'Your Email',
            controller: _email,
            keyboard: TextInputType.emailAddress,
          ),
          const SizedBox(height: 6),
          PrimaryButton('Next', onPressed: _next),
          const SizedBox(height: 32),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFD9E7FA),
              borderRadius: BorderRadius.circular(28),
            ),
            child: r == null
                ? const Text(
                    'Dữ liệu từ màn hình 4 sẽ hiện ở đây',
                    textAlign: TextAlign.center,
                  )
                : Column(
                    children: [
                      _line('email', r.email),
                      _line('otp', r.otp),
                      _line('pass', r.password),
                      const Text(
                        '(từ màn hình 4)',
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _line(String k, String v) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 2),
    child: Text(
      '$k: $v',
      style: const TextStyle(
        color: Colors.red,
        fontSize: 18,
        fontWeight: FontWeight.w500,
      ),
    ),
  );
}
