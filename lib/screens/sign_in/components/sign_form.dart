import 'package:flutter/material.dart';
import 'package:revap/models/user.dart';
import 'package:revap/components/custom_surfix_icon.dart';
import 'package:revap/components/form_error.dart';
import 'package:revap/helper/keyboard.dart';
import 'package:revap/screens/forgot_password/forgot_password_screen.dart';
import 'package:revap/screens/home/home_screen.dart';
import 'package:revap/screens/otp/otp_screen.dart';
import 'package:revap/components/loadingDialog.dart';
import 'package:revap/components/messageDialog.dart';

import '../../../components/default_button.dart';
import '../../../constants.dart';
import '../../../size_config.dart';

class SignForm extends StatefulWidget {
  const SignForm({super.key});

  @override
  _SignFormState createState() => _SignFormState();
}

class _SignFormState extends State<SignForm> {
  final _formKey = GlobalKey<FormState>();
  String? email;
  String? password;
  bool? remember = false;
  bool obscureText = true;
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
              const Text("Remember me"),
              const Spacer(),
              GestureDetector(
                onTap: () => Navigator.pushNamed(
                    context, ForgotPasswordScreen.routeName),
                child: const Text(
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
                LoadingDialog.show(context);
                _formKey.currentState!.save();
                // hide keyboard
                KeyboardUtil.hideKeyboard(context);

                final user = User(
                  email: email!,
                  password: password!,
                );

                final result = await user.signIn(email!, password!);

                if (result['success']) {
                  if (result['verified']) {
                    // Successful sign-in, handle navigation and data storage
                    // Navigate to the home screen
                    // ignore: use_build_context_synchronously
                    LoadingDialog.hide(context);
                    // ignore: use_build_context_synchronously
                    Navigator.pushReplacementNamed(
                        context, HomeScreen.routeName);
                    errors.clear(); // Clear error messages
                  } else {
                    // Successful sign-in, user not verified
                    // Navigate to the verification page
                    // ignore: use_build_context_synchronously
                    LoadingDialog.hide(context);
                    // ignore: use_build_context_synchronously
                    Navigator.pushReplacementNamed(context, OtpScreen.routeName,
                        arguments: {
                          'email': email, // Send email to OTP screen
                          'purpose': "Verify your email",
                          'expiration': 5,
                        });
                  }
                } else {
                  // ignore: use_build_context_synchronously
                  LoadingDialog.hide(context);
                  // Display error toast
                  // ignore: use_build_context_synchronously
                  showCustomDialog(context, result["error"],
                      const Color.fromARGB(206, 250, 1, 1));
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
      obscureText: obscureText,
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
        suffixIcon: GestureDetector(
          onTap: () {
            setState(() {
              obscureText = !obscureText; // Toggle password visibility
            });
          },
          child: ColorFiltered(
            colorFilter: ColorFilter.mode(
              Color.fromARGB(255, 101, 100, 100),
              BlendMode.srcIn,
            ),
            child: CustomSurffixIcon(
              svgIcon: obscureText
                  ? "assets/icons/Eyes-close.svg"
                  : "assets/icons/Eyes-open.svg",
            ),
          ),
        ),
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
      decoration: const InputDecoration(
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
