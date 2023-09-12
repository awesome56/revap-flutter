import 'package:flutter/material.dart';
import 'package:revap/components/coustom_bottom_nav_bar.dart';
import 'package:revap/constants.dart';
import 'package:revap/modals/add_company/add_company_screen.dart';
import 'package:revap/enums.dart';

import 'components/body.dart';

class CompanyScreen extends StatelessWidget {
  static String routeName = "/cart";

  void openAddCompanyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddCompanyScreen(); // Use your AddCompanyScreen here
      },
    );
  }

  const CompanyScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: Body(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your FAB's action here
          openAddCompanyDialog(context);
          // For example, you can navigate to another screen or perform some action1
        },
        child: Icon(Icons.add), // Customize the FAB icon as needed
        backgroundColor: kPrimaryColor,
      ),
      bottomNavigationBar:
          const CustomBottomNavBar(selectedMenu: MenuState.company),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: const Column(
        children: [
          Text(
            "My companies",
            style: TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }
}
