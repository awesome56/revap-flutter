import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:revap/components/custom_surfix_icon.dart';
import 'package:revap/components/form_error.dart';
import 'package:revap/helper/keyboard.dart';
import 'package:revap/screens/forgot_password/forgot_password_screen.dart';
import 'package:revap/screens/login_success/login_success_screen.dart';
import 'package:revap/screens/otp/otp_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../components/default_button.dart';
import '../../../constants.dart';
import '../../../size_config.dart';

class SignForm extends StatefulWidget {
  @override
  _SignFormState createState() => _SignFormState();
}

class _SignFormState extends State<SignForm> {
  final _formKey = GlobalKey<FormState>();
  String? email;
  String? password;
  bool? remember = false;
  final List<String?> errors = [];

  void addError({String? error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  void removeError({String? error}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildEmailFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildPasswordFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          Row(
            children: [
              Checkbox(
                value: remember,
                activeColor: kPrimaryColor,
                onChanged: (value) {
                  setState(() {
                    remember = value;
                  });
                },
              ),
              Text("Remember me"),
              Spacer(),
              GestureDetector(
                onTap: () => Navigator.pushNamed(
                    context, ForgotPasswordScreen.routeName),
                child: Text(
                  "Forgot Password",
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              )
            ],
          ),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(20)),
          DefaultButton(
            text: "Continue",
            press: () async {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                // if all are valid then go to success screen
                KeyboardUtil.hideKeyboard(context);
                // Navigator.pushNamed(context, LoginSuccessScreen.routeName);

                var headers = {'Content-Type': 'application/json'};
                var request = http.Request(
                    'POST',
                    Uri.parse(
                        'https://revap-api-6f16447151c5.herokuapp.com/api/v1/auth/login'));
                request.body = json.encode({
                  "email": email,
                  "password": password,
                });
                request.headers.addAll(headers);

                http.StreamedResponse response = await request.send();

                if (response.statusCode == 200) {
                  // Credentials are correct but user is not verified
                  // Navigator.pushReplacementNamed(context, OtpScreen.routeName);
                  Navigator.pushReplacementNamed(context, OtpScreen.routeName,
                      arguments: {
                        'email': email, // Send email to OTP screen
                        'purpose': "Verify your email",
                        'expiration': 5,
                      });
                } else if (response.statusCode == 202) {
                  // Successful login, navigate to the home screen
                  Navigator.pushReplacementNamed(
                      context, LoginSuccessScreen.routeName);
                  errors.clear(); // Clear error messages

                  // Save data to shared preferences
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  Map<String, dynamic> userJson =
                      json.decode(await response.stream.bytesToString());
                  prefs.setString('refreshToken', userJson['user']['refresh']);
                  prefs.setString('accessToken', userJson['user']['access']);
                  prefs.setString('userName', userJson['user']['name']);
                  prefs.setString('userEmail', userJson['user']['email']);
                  prefs.setBool('isUserVerified', userJson['user']['verified']);
                } else if (response.statusCode == 400 ||
                    response.statusCode == 401) {
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
            },
          ),
        ],
      ),
    );
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      obscureText: true,
      onSaved: (newValue) => password = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        } else if (value.length >= 8) {
          removeError(error: kShortPassError);
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kPassNullError);
          return "";
        } else if (value.length < 8) {
          addError(error: kShortPassError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Password",
        hintText: "Enter your password",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
      ),
    );
  }

  TextFormField buildEmailFormField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      onSaved: (newValue) => email = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kEmailNullError);
        } else if (emailValidatorRegExp.hasMatch(value)) {
          removeError(error: kInvalidEmailError);
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kEmailNullError);
          return "";
        } else if (!emailValidatorRegExp.hasMatch(value)) {
          addError(error: kInvalidEmailError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Email",
        hintText: "Enter your email",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
      ),
    );
  }
}
