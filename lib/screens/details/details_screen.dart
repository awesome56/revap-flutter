import 'package:flutter/material.dart';

import '../../models/Company.dart';
import 'components/body.dart';
import 'components/custom_app_bar.dart';

class DetailsScreen extends StatelessWidget {
  static String routeName = "/details";

  @override
  Widget build(BuildContext context) {
    final CompanyDetailsArguments agrs =
        ModalRoute.of(context)!.settings.arguments as CompanyDetailsArguments;
    return Scaffold(
      backgroundColor: Color(0xFFF5F6F9),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(AppBar().preferredSize.height),
        child: CustomAppBar(name: agrs.company.name),
      ),
      body: Body(company: agrs.company),
    );
  }
}

class CompanyDetailsArguments {
  final Company company;

  CompanyDetailsArguments({required this.company});
}
