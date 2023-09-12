import 'package:flutter/material.dart';
import 'package:revap/constants.dart';
import 'package:revap/size_config.dart';

import 'add_company_form.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: SizeConfig.screenHeight * 0.03),
                AddCompanyForm(),
                SizedBox(height: getProportionateScreenHeight(30)),
                Text(
                  "By continuing you confirm that you agree \nwith our Terms and Conditions",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
