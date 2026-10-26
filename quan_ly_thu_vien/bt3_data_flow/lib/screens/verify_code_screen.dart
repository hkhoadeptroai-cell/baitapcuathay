import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../widgets/auth_widgets.dart';
import 'new_password_screen.dart';

class VerifyCodeScreen extends StatefulWidget {
  const VerifyCodeScreen({super.key, required this.email});
  final String email;
  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  static const _len = 5;
  final _ctrls = List.generate(_len, (_) => TextEditingController());
  final _nodes = List.generate(_len, (_) => FocusNode());

  @override
  void dispose() {
    for (final c in _ctrls) {
      c.dispose();
    }
    for (final n in _nodes) {
      n.dispose();
    }
    super.dispose();
  }

  void _next() {
    final otp = _ctrls.map((c) => c.text).join();
    if (otp.length < _len) {
      showMsg(context, 'Vui lòng nhập đủ $_len số');
      return;
    }
    pushAndForward(context, NewPasswordScreen(email: widget.email, otp: otp));
  }

  @override
  Widget build(BuildContext context) => AuthScaffold(
    title: 'Verify Code',
    subtitle: 'Enter the the code\nwe just sent you on your registered Email',
    child: Column(
      children: [
        Row(
          children: [
            for (var i = 0; i < _len; i++)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: TextField(
                    controller: _ctrls[i],
                    focusNode: _nodes[i],
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    maxLength: 1,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: InputDecoration(
                      counterText: '',
                      filled: true,
                      fillColor: const Color(0xFFF1F2F5),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (v) {
                      if (v.isNotEmpty && i < _len - 1)
                        _nodes[i + 1].requestFocus();
                      if (v.isEmpty && i > 0) _nodes[i - 1].requestFocus();
                    },
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 24),
        PrimaryButton('Next', onPressed: _next),
      ],
    ),
  );
}
