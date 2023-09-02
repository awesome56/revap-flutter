import 'package:flutter/material.dart';

import 'components/body.dart';

class LoginSuccessScreen extends StatelessWidget {
  static String routeName = "/login_success";

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? otpData =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    return Scaffold(
      appBar: AppBar(
        leading: SizedBox(),
        title: Text(""),
      ),
      body: Body(otpData: otpData),
    );
  }
}
