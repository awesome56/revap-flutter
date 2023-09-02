import 'dart:io';

import 'package:flutter/material.dart';
import 'package:revap/components/custom_surfix_icon.dart';
import 'package:revap/components/default_button.dart';
import 'package:revap/components/form_error.dart';
import 'package:revap/components/loadingDialog.dart';
import 'package:revap/screens/login_success/login_success_screen.dart';

import 'package:revap/screens/sign_in/sign_in_screen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../constants.dart';
import '../../../size_config.dart';

class ResetPasswordForm extends StatefulWidget {
  final String email;
  const ResetPasswordForm({
    Key? key,
    required this.email,
  }) : super(key: key);

  @override
  _ResetPasswordFormState createState() => _ResetPasswordFormState();
}

class _ResetPasswordFormState extends State<ResetPasswordForm> {
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

  final _formKey = GlobalKey<FormState>();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final List<String?> errors = [];
  String? password;
  String? comfirmPassword;

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
          const Text(
            "OTP",
            style: TextStyle(
              fontSize: 18, // Adjust the font size as needed
              fontWeight: FontWeight.bold, // You can change the style as needed
            ),
          ),
          SizedBox(height: getProportionateScreenHeight(10)),
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
          SizedBox(height: getProportionateScreenHeight(30)),
          buildPasswordFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildComfirmPasswordFormField(),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(40)),
          DefaultButton(
            text: "continue",
            press: () async {
              final email = widget.email;
              final code =
                  otp1 + otp2 + otp3 + otp4 + otp5 + otp6; // Combine OTP digits
              password = passwordController.text;
              comfirmPassword = confirmPasswordController.text;

              // Validate the form before making the API request
              if (_formKey.currentState!.validate()) {
                LoadingDialog.show(context);
                // Assuming the email and OTP have been filled correctly in your form

                // API request
                var headers = {
                  'Content-Type': 'application/json',
                };
                var request = http.Request(
                    'POST', Uri.parse('$kUrl/auth/resetpassword/$email'));
                request.body = json.encode({
                  "code": code,
                  "password": password, // Get the password from your form
                  "comfirm_password":
                      comfirmPassword, // Get the confirmed password from your form
                });

                request.headers.addAll(headers);

                try {
                  final response = await request.send();

                  if (response.statusCode == 200) {
                    // ignore: use_build_context_synchronously
                    LoadingDialog.hide(context);

                    // ignore: use_build_context_synchronously
                    Navigator.pushReplacementNamed(
                        context, LoginSuccessScreen.routeName,
                        arguments: {
                          'head': "Password successfully changed",
                          'button': "Back to login",
                        });
                  } else if (response.statusCode == 400 ||
                      response.statusCode == 404) {
                    // Display error toast from the API response
                    String errorMessage = await response.stream.bytesToString();
                    try {
                      Map<String, dynamic> errorJson =
                          json.decode(errorMessage);
                      String error = errorJson['error'];
                      // ignore: use_build_context_synchronously
                      LoadingDialog.hide(context);
                      // ignore: use_build_context_synchronously
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
                      // ignore: use_build_context_synchronously
                      LoadingDialog.hide(context);
                      // ignore: use_build_context_synchronously
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Error"),
                            content:
                                Text("An error occurred. Please try again."),
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
                  } else {
                    // ignore: use_build_context_synchronously
                    LoadingDialog.hide(context);
                    // ignore: use_build_context_synchronously
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Center(
                            child: Text(
                              "Error",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          content: Text(
                            "An error occured. We are working on it",
                            style: TextStyle(
                              color: Colors
                                  .red, // Set the content text color to red
                            ),
                          ),
                          actions: [
                            TextButton(
                              child: Text("Close"),
                              onPressed: () {
                                LoadingDialog.hide(context);
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }
                } catch (e) {
                  if (e is SocketException) {
                    // You can throw a custom network error here if needed.
                    // ignore: use_build_context_synchronously
                    LoadingDialog.hide(context);
                    // ignore: use_build_context_synchronously
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Center(
                            child: Text(
                              "Network Error",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          content: const Text(
                            "Network error: Failed to connect to network",
                            style: TextStyle(
                              color: Colors
                                  .red, // Set the content text color to red
                            ),
                          ),
                          actions: [
                            TextButton(
                              child: Text("Close"),
                              onPressed: () {
                                LoadingDialog.hide(context);
                              },
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    // Handle other exceptions here
                    // ignore: use_build_context_synchronously
                    LoadingDialog.hide(context);
                    print("Other error: $e");
                    // ignore: use_build_context_synchronously
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Center(
                            child: Text(
                              "Error",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          content: Text(
                            "An error occured: $e",
                            style: const TextStyle(
                              color: Colors
                                  .red, // Set the content text color to red
                            ),
                          ),
                          actions: [
                            TextButton(
                              child: Text("Close"),
                              onPressed: () {
                                LoadingDialog.hide(context);
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }
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
      controller: passwordController,
      decoration: const InputDecoration(
        labelText: "Password",
        hintText: "Enter your password",
        // If you are using the latest version of Flutter, then label text and hint text are shown like this.
        // If you're using Flutter less than 1.20.*, this may not work properly.
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          addError(error: kPassNullError);
          return "";
        } else if (value.length < 6) {
          addError(error: kShortPassError);
          return "";
        }
        return null;
      },
    );
  }

  TextFormField buildComfirmPasswordFormField() {
    return TextFormField(
      controller: confirmPasswordController,
      obscureText: true,
      decoration: const InputDecoration(
        labelText: "Confirm Password",
        hintText: "Re-enter Password",
        // If you are using the latest version of Flutter, then label text and hint text are shown like this.
        // If you're using Flutter less than 1.20.*, this may not work properly.
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          addError(error: kComfirmNullError);
          return "";
        } else if (value != password) {
          addError(error: kMatchPassError);
          return "";
        }
        return null;
      },
    );
  }
}
