import 'package:flutter/widgets.dart';
import 'package:revap/screens/company/company_screen.dart';
import 'package:revap/screens/reset_password/reset_password_screen.dart';
import 'package:revap/screens/details/details_screen.dart';
import 'package:revap/screens/forgot_password/forgot_password_screen.dart';
import 'package:revap/screens/home/home_screen.dart';
import 'package:revap/screens/login_success/login_success_screen.dart';
import 'package:revap/screens/otp/otp_screen.dart';
import 'package:revap/screens/profile/profile_screen.dart';
import 'package:revap/screens/sign_in/sign_in_screen.dart';
import 'package:revap/screens/splash/splash_screen.dart';
import 'package:revap/modals/add_company/add_company_screen.dart';

import 'screens/sign_up/sign_up_screen.dart';

// We use name route
// All our routes will be available here
final Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (context) => SplashScreen(),
  SignInScreen.routeName: (context) => SignInScreen(),
  ForgotPasswordScreen.routeName: (context) => ForgotPasswordScreen(),
  LoginSuccessScreen.routeName: (context) => LoginSuccessScreen(),
  SignUpScreen.routeName: (context) => SignUpScreen(),
  ResetPasswordScreen.routeName: (context) => ResetPasswordScreen(),
  OtpScreen.routeName: (context) => OtpScreen(),
  HomeScreen.routeName: (context) => HomeScreen(),
  DetailsScreen.routeName: (context) => DetailsScreen(),
  CompanyScreen.routeName: (context) => CompanyScreen(),
  ProfileScreen.routeName: (context) => ProfileScreen(),
};
