import 'package:flutter/material.dart';
import 'package:revap/components/default_button.dart';
import 'package:revap/screens/sign_in/sign_in_screen.dart';
import 'package:revap/size_config.dart';

class Body extends StatefulWidget {
  final Map<String, dynamic>? otpData;
  const Body({Key? key, this.otpData}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  late String head;
  late String button;

  @override
  void initState() {
    super.initState();
    if (widget.otpData != null) {
      head = widget.otpData!['head'];
      button = widget.otpData!['button'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: SizeConfig.screenHeight * 0.04),
        Image.asset(
          "assets/images/success.png",
          height: SizeConfig.screenHeight * 0.4, //40%
        ),
        SizedBox(height: SizeConfig.screenHeight * 0.08),
        Text(
          head,
          style: TextStyle(
            fontSize: getProportionateScreenWidth(30),
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        Spacer(),
        SizedBox(
          width: SizeConfig.screenWidth * 0.6,
          child: DefaultButton(
            text: button,
            press: () {
              Navigator.pushReplacementNamed(context, SignInScreen.routeName);
            },
          ),
        ),
        Spacer(),
      ],
    );
  }
}
