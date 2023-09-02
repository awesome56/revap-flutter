// import 'package:flutter/material.dart';
// import 'package:revap/routes.dart';
// import 'package:revap/screens/splash/splash_screen.dart';
// import 'package:revap/theme.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Revap',
//       theme: AppTheme.lightTheme(context),
//       initialRoute: SplashScreen.routeName,
//       routes: routes,
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:revap/routes.dart';
import 'package:revap/screens/home/home_screen.dart';
import 'package:revap/screens/splash/splash_screen.dart';
import 'package:revap/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Revap',
      theme: AppTheme.lightTheme(context),
      home: FutureBuilder<bool>(
        future: checkIfUserDataExists(),
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

  Future<bool> checkIfUserDataExists() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('userName') && prefs.containsKey('userEmail');
  }
}
