import 'package:flutter/material.dart';
import 'package:revap/components/default_button.dart';
import 'package:revap/size_config.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:revap/screens/login_success/login_success_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../constants.dart';

class OtpForm extends StatefulWidget {
  final String email;
  const OtpForm({
    Key? key,
    required this.email,
  }) : super(key: key);

  @override
  _OtpFormState createState() => _OtpFormState();
}

class _OtpFormState extends State<OtpForm> {
  FocusNode? pin2FocusNode;
  FocusNode? pin3FocusNode;
  FocusNode? pin4FocusNode;
  FocusNode? pin5FocusNode;
  FocusNode? pin6FocusNode;

  String otp = "";
  String otp1 = "";
  String otp2 = "";
  String otp3 = "";
  String otp4 = "";
  String otp5 = "";
  String otp6 = "";

  @override
  void initState() {
    super.initState();
    pin2FocusNode = FocusNode();
    pin3FocusNode = FocusNode();
    pin4FocusNode = FocusNode();
    pin5FocusNode = FocusNode();
    pin6FocusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    pin2FocusNode!.dispose();
    pin3FocusNode!.dispose();
    pin4FocusNode!.dispose();
    pin5FocusNode!.dispose();
    pin6FocusNode!.dispose();
  }

  void nextField(String value, FocusNode? focusNode) {
    if (value.length == 1) {
      focusNode!.requestFocus();
    }
  }

  void verifyOtp() async {
    var headers = {'Content-Type': 'application/json'};
    var email = Uri.encodeComponent(widget.email); // Encode the email value
    var apiUrl =
        'https://revap-api-6f16447151c5.herokuapp.com/api/v1/auth/verifyemail/$email';

    otp = otp1 + otp2 + otp3 + otp4 + otp5 + otp6;

    var request = http.Request('POST', Uri.parse(apiUrl));
    request.body = json.encode({
      "code": otp,
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 202) {
      print(await response.stream.bytesToString());
      // TODO: Handle successful verification
      Navigator.pushReplacementNamed(context, LoginSuccessScreen.routeName);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      Map<String, dynamic> userJson =
          json.decode(await response.stream.bytesToString());
      prefs.setString('refreshToken', userJson['user']['refresh']);
      prefs.setString('accessToken', userJson['user']['access']);
      prefs.setString('userName', userJson['user']['name']);
      prefs.setString('userEmail', userJson['user']['email']);
      prefs.setBool('isUserVerified', userJson['user']['verified']);
    } else if (response.statusCode == 400 || response.statusCode == 404) {
      // Display error toast from the API response
      String errorMessage = await response.stream.bytesToString();
      try {
        Map<String, dynamic> errorJson = json.decode(errorMessage);
        String error = errorJson['error'];
        Fluttertoast.showToast(
          msg: error,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          backgroundColor: Color(0xFF083663),
          textColor: Colors.white,
        );
      } catch (e) {
        // If JSON decoding fails, display a generic error message
        Fluttertoast.showToast(
          msg: "An error occurred. Please try again.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          backgroundColor: Color(0xFF083663),
          textColor: Colors.white,
        );
      }
    } else {
      // Handle other status codes or errors
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          SizedBox(height: SizeConfig.screenHeight * 0.15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: getProportionateScreenWidth(40),
                child: TextFormField(
                  autofocus: true,
                  obscureText: false,
                  style: TextStyle(fontSize: 24),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: otpInputDecoration,
                  onChanged: (value) {
                    otp1 = value;
                    nextField(value, pin2FocusNode);
                    // Update the first digit of otp
                  },
                ),
              ),
              SizedBox(
                width: getProportionateScreenWidth(40),
                child: TextFormField(
                  focusNode: pin2FocusNode,
                  obscureText: false,
                  style: TextStyle(fontSize: 24),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: otpInputDecoration,
                  onChanged: (value) {
                    otp2 = value;
                    nextField(value, pin3FocusNode);
                  },
                ),
              ),
              SizedBox(
                width: getProportionateScreenWidth(40),
                child: TextFormField(
                  focusNode: pin3FocusNode,
                  obscureText: false,
                  style: TextStyle(fontSize: 24),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: otpInputDecoration,
                  onChanged: (value) {
                    otp3 = value;
                    nextField(value, pin4FocusNode);
                  },
                ),
              ),
              SizedBox(
                width: getProportionateScreenWidth(40),
                child: TextFormField(
                  focusNode: pin4FocusNode,
                  obscureText: false,
                  style: TextStyle(fontSize: 24),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: otpInputDecoration,
                  onChanged: (value) {
                    otp4 = value;
                    nextField(value, pin5FocusNode);
                  },
                ),
              ),
              SizedBox(
                width: getProportionateScreenWidth(40),
                child: TextFormField(
                  focusNode: pin5FocusNode,
                  obscureText: false,
                  style: TextStyle(fontSize: 24),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: otpInputDecoration,
                  onChanged: (value) {
                    otp5 = value;
                    nextField(value, pin6FocusNode);
                  },
                ),
              ),
              SizedBox(
                width: getProportionateScreenWidth(40),
                child: TextFormField(
                  focusNode: pin6FocusNode,
                  obscureText: false,
                  style: TextStyle(fontSize: 24),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: otpInputDecoration,
                  onChanged: (value) {
                    if (value.length == 1) {
                      otp6 = value;
                      pin6FocusNode!.unfocus();
                      // Then you need to check is the code is correct or not
                    }
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: SizeConfig.screenHeight * 0.15),
          DefaultButton(
            text: "Continue",
            press: verifyOtp,
          )
        ],
      ),
    );
  }
}
