import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[900],
      body: Column(
        children: [
          Text(
            'Hello, welcome back!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Text(
            'Login to continue',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          TextField(
            decoration: InputDecoration(hintText: 'Username'),
          ),
          TextField(
            decoration: InputDecoration(hintText: 'Password'),
          ),
          TextButton(onPressed: () {}, child: Text('Forgot password')),
          ElevatedButton(onPressed: () {}, child: Text('Login')),
          Text('Or sign in with'),
          ElevatedButton(
            onPressed: () {},
            child: Row(
              children: [
                Image.asset(
                  'assets/img/google-logo.png',
                  width: 22,
                  height: 22,
                ),
                Text('Login with Google')
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            child: Row(
              children: [
                Image.asset(
                  'assets/img/facebook-logo.png',
                  width: 22,
                  height: 22,
                ),
                Text('Login with Facebook')
              ],
            ),
          ),
          Row(
            children: [
              Text("Don't have account? "),
              TextButton(onPressed: () {}, child: Text('Sign up')),
            ],
          )
        ],
      ),
    );
  }
}
