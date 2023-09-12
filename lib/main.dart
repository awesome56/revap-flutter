import 'package:flutter/material.dart';
import 'package:revap/routes.dart';
import 'package:revap/screens/home/home_screen.dart';
import 'package:revap/screens/splash/splash_screen.dart';
import 'package:revap/theme.dart';
import 'package:revap/models/user.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final User _user = User();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Revap',
      theme: AppTheme.lightTheme(context),
      home: FutureBuilder<bool>(
        future: _user.checkIfUserDataExists(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While checking the user data existence, display a loading screen
            return SplashScreen();
          } else {
            // If user data exists, navigate to the home screen; otherwise, show the login screen
            return snapshot.data == true ? HomeScreen() : SplashScreen();
          }
        },
      ),
      routes: routes,
    );
  }
}
