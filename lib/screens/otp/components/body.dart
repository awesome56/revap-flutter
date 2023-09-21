import 'dart:async';
import 'package:flutter/material.dart';
import 'package:revap/constants.dart';
import 'package:revap/size_config.dart';
import 'package:revap/models/User.dart';
import 'package:revap/components/loadingDialog.dart';

import 'otp_form.dart';

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
  late Timer _timer;
  bool isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    if (widget.otpData != null) {
      email = widget.otpData!['email'];
      purpose = widget.otpData!['purpose'];
      expiration = widget.otpData!['expiration'];
      timerDuration = expiration * 60;
      isButtonEnabled = false;
      startTimer();
    }
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (timer) {
      setState(() {
        if (timerDuration <= 0) {
          timer.cancel();
          isButtonEnabled = true;
        } else {
          timerDuration--;
        }
      });
    });
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed
    _timer.cancel();
    super.dispose();
  }

  void resendOTP() async {
    LoadingDialog.show(context);

    User user = User();
    final result = await user.resendOtp(email);

    if (result['success']) {
      setState(() {
        timerDuration = expiration * 60;
        isButtonEnabled = false;
        startTimer();
      });
      // Successful resend
      // ignore: use_build_context_synchronously
      LoadingDialog.hide(context);
      // Show a success dialog or toast message here
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      "OTP has been resent to your email",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                          color: kPrimaryColor),
                    ),
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                        },
                        child: const Text(
                          "Close",
                          style: TextStyle(color: kPrimaryColor),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    } else {
      // Resend failed
      // ignore: use_build_context_synchronously
      LoadingDialog.hide(context);
      // Show an error dialog or toast message here
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      result['error'],
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                          color: Color.fromARGB(206, 250, 1, 1)),
                    ),
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                        },
                        child: const Text(
                          "Close",
                          style: TextStyle(color: kPrimaryColor),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.otpData == null) {
      // Handle the case where otpData is not available
      return const Scaffold(
          //...
          );
    }

    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: SizeConfig.screenHeight * 0.05),
              Text(
                purpose,
                style: headingStyle,
              ),
              Text("A verification code has been sent to $email"),
              buildTimer(),
              ElevatedButton(
                onPressed: isButtonEnabled
                    ? () {
                        resendOTP();
                      }
                    : null,
                child: const Text("Resend OTP Code"),
              ),
              OtpForm(
                email: email,
              ),
              SizedBox(height: SizeConfig.screenHeight * 0.1),
            ],
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
        Text("This code will expire in $formattedTime"),
      ],
    );
  }
}
