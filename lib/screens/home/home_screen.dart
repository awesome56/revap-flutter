import 'package:flutter/material.dart';
import 'package:revap/components/coustom_bottom_nav_bar.dart';
import 'package:revap/enums.dart';
import 'package:revap/constants.dart';
import 'package:revap/modals/add_company/add_company_screen.dart';

import 'components/body.dart';

class HomeScreen extends StatelessWidget {
  static String routeName = "/home";

  // Callback function to open the AddCompanyScreen as a dialog
  void openAddCompanyDialog(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute<void>(
      builder: (BuildContext context) {
        return const AddCompanyScreen();
      },
      fullscreenDialog: true,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.home),
    );
  }
}
