import 'package:flutter/material.dart';

import 'components/body.dart';

class OtpScreen extends StatelessWidget {
  static String routeName = "/otp";

  const OtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? otpData =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    return Scaffold(
      appBar: AppBar(
        title: const Text(""),
      ),
      body: Body(otpData: otpData),
    );
  }
}
