import 'package:flutter/material.dart';
import 'package:revap/components/custom_surfix_icon.dart';
import 'package:revap/components/default_button.dart';
import 'package:revap/components/form_error.dart';
import 'package:revap/components/no_account_text.dart';
import 'package:revap/screens/reset_password/reset_password_screen.dart';
import 'package:revap/components/loadingDialog.dart';
import 'package:revap/size_config.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io'; // Import the 'dart:io' library for SocketException

import '../../../constants.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: Column(
            children: [
              SizedBox(height: SizeConfig.screenHeight * 0.04),
              Text(
                "Forgot Password",
                style: TextStyle(
                  fontSize: getProportionateScreenWidth(28),
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Please enter your email and we will send \nyou a verification code",
                textAlign: TextAlign.center,
              ),
              SizedBox(height: SizeConfig.screenHeight * 0.1),
              ForgotPassForm(),
            ],
          ),
        ),
      ),
    );
  }
}

class ForgotPassForm extends StatefulWidget {
  const ForgotPassForm({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ForgotPassFormState createState() => _ForgotPassFormState();
}

class _ForgotPassFormState extends State<ForgotPassForm> {
  final _formKey = GlobalKey<FormState>();
  List<String> errors = [];
  TextEditingController emailController =
      TextEditingController(); // Add this controller

  @override
  void dispose() {
    emailController
        .dispose(); // Dispose of the controller to avoid memory leaks
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: emailController, // Use the controller here
            keyboardType: TextInputType.emailAddress,
            // onSaved: (newValue) => email = newValue,
            onChanged: (value) {
              if (value.isNotEmpty && errors.contains(kEmailNullError)) {
                setState(() {
                  errors.remove(kEmailNullError);
                });
              } else if (emailValidatorRegExp.hasMatch(value) &&
                  errors.contains(kInvalidEmailError)) {
                setState(() {
                  errors.remove(kInvalidEmailError);
                });
              }
              return null;
            },
            validator: (value) {
              if (value!.isEmpty && !errors.contains(kEmailNullError)) {
                setState(() {
                  errors.add(kEmailNullError);
                });
              } else if (!emailValidatorRegExp.hasMatch(value) &&
                  !errors.contains(kInvalidEmailError)) {
                setState(() {
                  errors.add(kInvalidEmailError);
                });
              }
              return null;
            },
            decoration: const InputDecoration(
              labelText: "Email",
              hintText: "Enter your email",
              // If  you are using latest version of flutter then lable text and hint text shown like this
              // if you r using flutter less then 1.20.* then maybe this is not working properly
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
            ),
          ),
          SizedBox(height: getProportionateScreenHeight(30)),
          FormError(errors: errors),
          SizedBox(height: SizeConfig.screenHeight * 0.1),
          DefaultButton(
              text: "Continue",
              press: () async {
                if (_formKey.currentState!.validate()) {
                  LoadingDialog.show(context);
                  try {
                    // Send forgot password request to API
                    String email = emailController.text;
                    var request = http.Request(
                        'GET', Uri.parse('$kUrl/auth/forgotpassword/$email'));

                    http.StreamedResponse response = await request.send();

                    if (response.statusCode == 201) {
                      print(await response.stream.bytesToString());
                      // TODO: Handle successful forgot password request
                      // ignore: use_build_context_synchronously
                      LoadingDialog.hide(context);
                      // ignore: use_build_context_synchronously
                      Navigator.pushReplacementNamed(
                          context, ResetPasswordScreen.routeName,
                          arguments: {
                            'email': emailController
                                .text, // Send email to OTP screen
                            'purpose': "Reset Passord",
                            'expiration': 5,
                          });
                    } else if (response.statusCode == 404) {
                      // Display error toast from the API response
                      String errorMessage =
                          await response.stream.bytesToString();
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
                                  child: const Text("Close"),
                                  onPressed: () {
                                    LoadingDialog.hide(context);
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
                              content: const Text(
                                  "An error occurred. Please try again."),
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
                    } else {
                      print(response.reasonPhrase);
                      // TODO: Handle errors
                    }
                  } catch (e) {
                    if (e is SocketException) {
                      // Handle network-related errors here
                      print("Network error: $e");
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
                    }
                  }
                }
              }),
          SizedBox(height: SizeConfig.screenHeight * 0.1),
          const NoAccountText(),
        ],
      ),
    );
  }
}
