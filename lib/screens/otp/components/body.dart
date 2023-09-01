import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:revap/constants.dart';
import 'package:revap/size_config.dart';

import 'otp_form.dart';

class Body extends StatefulWidget {
  final Map<String, dynamic>? otpData;
  const Body({Key? key, this.otpData}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  late String email;
  late String purpose;
  late int expiration;
  late int timerDuration;
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
    Timer.periodic(oneSec, (timer) {
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

  void resendOTP() async {
    // TODO: Implement logic to resend OTP through API
    var request = http.Request(
        'GET',
        Uri.parse(
            'https://revap-api-6f16447151c5.herokuapp.com/api/v1/auth/resendverify/$email'));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      // Handle successful resend
      String responseBody = await response.stream.bytesToString();
      Map<String, dynamic> responseJson = json.decode(responseBody);
      String message = responseJson['msg'];

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Success"),
            content: Text(message),
            actions: [
              TextButton(
                child: Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else if (response.statusCode == 400 ||
        response.statusCode == 404 ||
        response.statusCode == 409) {
      // Display error toast from the API response
      String errorMessage = await response.stream.bytesToString();
      try {
        Map<String, dynamic> errorJson = json.decode(errorMessage);
        String error = errorJson['error'];
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Error"),
              content: Text(error),
              actions: [
                TextButton(
                  child: Text("Close"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } catch (e) {
        // If JSON decoding fails, display a generic error message
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Error"),
              content: Text("An error occurred. Please try again."),
              actions: [
                TextButton(
                  child: Text("Close"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    } else {}
    setState(() {
      timerDuration = expiration * 60;
      isButtonEnabled = false;
      startTimer();
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
              Text("We sent your code to $email"),
              buildTimer(),
              ElevatedButton(
                onPressed: isButtonEnabled
                    ? () {
                        resendOTP();
                      }
                    : null,
                child: Text("Resend OTP Code"),
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
