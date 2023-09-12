import 'package:flutter/material.dart';
import 'package:revap/helper/keyboard.dart';
import 'package:revap/components/custom_surfix_icon.dart';
import 'package:revap/components/default_button.dart';
import 'package:revap/components/form_error.dart';
import 'package:revap/screens/otp/otp_screen.dart';
import 'package:revap/components/loadingDialog.dart';
import 'package:revap/models/User.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  String? name;
  String? email;
  String? password;
  bool remember = false;
  final List<String?> errors = [];

  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your name';
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    // You can add additional email validation logic here if needed.
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    // You can add additional password validation logic here if needed.
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildNameFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildEmailFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildPasswordFormField(),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(40)),
          DefaultButton(
            text: "Continue",
            press: () async {
              if (_formKey.currentState!.validate()) {
                LoadingDialog.show(context);
                _formKey.currentState!.save();
                // hide keyboard
                KeyboardUtil.hideKeyboard(context);

                User user = User();
                final result = await user.signUp(name!, email!, password!);

                if (result['success']) {
                  // ignore: use_build_context_synchronously
                  LoadingDialog.hide(context);
                  // Success! Now navigate to the next screen
                  // ignore: use_build_context_synchronously
                  Navigator.pushReplacementNamed(context, OtpScreen.routeName,
                      arguments: {
                        'email': email, // Send email to OTP screen
                        'purpose': "Verify your email",
                        'expiration': 5,
                      });
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(); // Close the dialog
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
      onChanged: (value) {},
      validator: validatePassword,
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
      onChanged: (value) {},
      validator: validateEmail,
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

  TextFormField buildNameFormField() {
    return TextFormField(
      keyboardType: TextInputType.name,
      onSaved: (newValue) => name = newValue,
      onChanged: (value) {},
      validator: validateName,
      decoration: InputDecoration(
        labelText: "Name",
        hintText: "Enter your name",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User Icon.svg"),
      ),
    );
  }
}
