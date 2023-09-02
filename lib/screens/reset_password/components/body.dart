import 'dart:async';
import 'package:flutter/material.dart';
import 'package:revap/constants.dart';
import 'package:revap/size_config.dart';

import 'reset_password_form.dart';

class Body extends StatefulWidget {
  final Map<String, dynamic>? otpData;
  const Body({Key? key, this.otpData}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  late String email;
  late String purpose;
  late int expiration;
  late int timerDuration;

  @override
  void initState() {
    super.initState();
    if (widget.otpData != null) {
      email = widget.otpData!['email'];
      purpose = widget.otpData!['purpose'];
      expiration = widget.otpData!['expiration'];
      timerDuration = expiration * 60;
      startTimer();
    }
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    Timer.periodic(oneSec, (timer) {
      setState(() {
        if (timerDuration <= 0) {
          timer.cancel();
        } else {
          timerDuration--;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.otpData == null) {
      // Handle the case where otpData is not available
      return Scaffold(
          //...
          );
    }
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: SizeConfig.screenHeight * 0.03),
                Text(purpose, style: headingStyle),
                Text(
                  "A verification code has been sent to $email  \nenter the code with your new password",
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.06),
                ResetPasswordForm(
                  email: email,
                ),
                SizedBox(height: getProportionateScreenHeight(30)),
                buildTimer(),
                // Text(
                //   "By continuing your confirm that you agree \nwith our Term and Condition",
                //   textAlign: TextAlign.center,
                //   style: Theme.of(context).textTheme.caption,
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row buildTimer() {
    int minutes = timerDuration ~/ 60;
    int seconds = timerDuration % 60;
    String formattedTime =
        "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("The verification code will expire in $formattedTime"),
      ],
    );
  }
}
