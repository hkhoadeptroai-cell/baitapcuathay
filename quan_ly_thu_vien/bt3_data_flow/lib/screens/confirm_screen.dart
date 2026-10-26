import 'package:flutter/material.dart';

import '../models/reset_data.dart';
import '../widgets/auth_widgets.dart';

class ConfirmScreen extends StatelessWidget {
  const ConfirmScreen({super.key, required this.data});
  final ResetData data;

  @override
  Widget build(BuildContext context) => AuthScaffold(
    title: 'Confirm',
    subtitle: 'We are here to help you!',
    child: Column(
      children: [
        AuthField(
          icon: Icons.person_outline,
          controller: TextEditingController(text: data.email),
          readOnly: true,
        ),
        AuthField(
          icon: Icons.mail_outline,
          controller: TextEditingController(text: data.otp),
          readOnly: true,
        ),
        AuthField(
          icon: Icons.lock_outline,
          controller: TextEditingController(text: '*' * data.password.length),
          readOnly: true,
        ),
        const SizedBox(height: 6),
        PrimaryButton('Summit', onPressed: () => Navigator.pop(context, data)),
      ],
    ),
  );
}
