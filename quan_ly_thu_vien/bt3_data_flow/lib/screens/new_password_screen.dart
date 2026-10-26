import 'package:flutter/material.dart';

import '../models/reset_data.dart';
import '../widgets/auth_widgets.dart';
import 'confirm_screen.dart';

class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({super.key, required this.email, required this.otp});
  final String email, otp;
  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  final _pass = TextEditingController();
  final _confirm = TextEditingController();

  @override
  void dispose() {
    _pass.dispose();
    _confirm.dispose();
    super.dispose();
  }

  void _next() {
    if (_pass.text.length < 6) {
      showMsg(context, 'Mật khẩu tối thiểu 6 ký tự');
      return;
    }
    if (_pass.text != _confirm.text) {
      showMsg(context, 'Mật khẩu xác nhận không khớp');
      return;
    }
    pushAndForward(
      context,
      ConfirmScreen(
        data: ResetData(
          email: widget.email,
          otp: widget.otp,
          password: _pass.text,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => AuthScaffold(
    title: 'Create new password',
    subtitle:
        'Your new password must be different form\npreviously used password',
    child: Column(
      children: [
        AuthField(
          icon: Icons.lock_outline,
          hint: 'Password',
          controller: _pass,
          obscure: true,
        ),
        AuthField(
          icon: Icons.lock_outline,
          hint: 'Confirm Password',
          controller: _confirm,
          obscure: true,
        ),
        const SizedBox(height: 6),
        PrimaryButton('Next', onPressed: _next),
      ],
    ),
  );
}
