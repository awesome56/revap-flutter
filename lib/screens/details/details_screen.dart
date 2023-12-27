import 'package:flutter/material.dart';

import '../../models/Company.dart';
import 'components/body.dart';
import 'components/custom_app_bar.dart';
import 'package:revap/modals/add_branch/add_branch_screen.dart';

class DetailsScreen extends StatelessWidget {
  static String routeName = "/details";

  @override
  Widget build(BuildContext context) {
    final CompanyDetailsArguments agrs =
        ModalRoute.of(context)!.settings.arguments as CompanyDetailsArguments;

    String? name = agrs.company.name;
    return Scaffold(
      backgroundColor: Color(0xFFF5F6F9),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.arrow_back),
            ),
            Expanded(
              child: Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  overflow: TextOverflow.ellipsis, // Handle text overflow
                ),
              ),
            ),
            PopupMenuButton(
              onSelected: (value) {
                // Handle the selected item here
                if (value == "Add branch") {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AddBranchScreen(company_id: agrs.company.id);
                    },
                  );
                } else if (value == "Edit company") {
                  // Perform the action for "Edit company"
                } else if (value == "Delete company") {
                  // Perform the action for "Delete company"
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: "Add branch",
                  child: Text("Add branch"),
                ),
                const PopupMenuItem(
                  value: "Edit company",
                  child: Text("Edit company"),
                ),
                const PopupMenuItem(
                  value: "Delete company",
                  child: Text("Delete company"),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Body(company: agrs.company),
    );
  }
}

class CompanyDetailsArguments {
  final Company company;

  CompanyDetailsArguments({required this.company});
}
