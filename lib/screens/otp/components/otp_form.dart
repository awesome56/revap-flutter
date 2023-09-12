import 'package:flutter/material.dart';
import 'package:revap/components/default_button.dart';
import 'package:revap/screens/home/home_screen.dart';
import 'package:revap/size_config.dart';
import 'package:revap/models/User.dart';
import 'package:revap/components/loadingDialog.dart';

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

  bool isButtonEnabled = false;

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
    LoadingDialog.show(context);
    otp = otp1 + otp2 + otp3 + otp4 + otp5 + otp6;

    User user = User();
    final result = await user.verifyOtp(widget.email, otp);

    // ignore: use_build_context_synchronously
    LoadingDialog.hide(context);

    if (result['success']) {
      // ignore: use_build_context_synchronously
      LoadingDialog.hide(context);
      // Successful verification
      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(context, HomeScreen.routeName);
    } else {
      // ignore: use_build_context_synchronously
      LoadingDialog.hide(context);
      // Display error toast
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

                    // Check if all OTP fields are filled to enable the button
                    if (otp1.isNotEmpty &&
                        otp2.isNotEmpty &&
                        otp3.isNotEmpty &&
                        otp4.isNotEmpty &&
                        otp5.isNotEmpty &&
                        otp6.isNotEmpty) {
                      setState(() {
                        isButtonEnabled = true;
                      });
                    } else {
                      setState(() {
                        isButtonEnabled = false;
                      });
                    }
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: SizeConfig.screenHeight * 0.15),
          DefaultButton(
            text: "Continue",
            press: isButtonEnabled ? verifyOtp : null,
          )
        ],
      ),
    );
  }
}
