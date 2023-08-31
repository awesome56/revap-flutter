import 'package:flutter/material.dart';
import 'package:revap/size_config.dart';

import 'components/body.dart';

class OtpScreen extends StatelessWidget {
  static String routeName = "/otp";

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
