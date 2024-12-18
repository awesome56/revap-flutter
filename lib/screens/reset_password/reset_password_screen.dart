import 'package:flutter/material.dart';

import 'components/body.dart';

class ResetPasswordScreen extends StatelessWidget {
  static String routeName = "/reset_password";

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? otpData =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: Body(otpData: otpData),
    );
  }
}
