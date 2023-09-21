import 'package:flutter/material.dart';
import 'package:revap/models/User.dart';
import 'package:revap/models/Company.dart';
import 'package:revap/components/loadingDialog.dart';
import 'package:revap/components/messageDialog.dart';
import 'package:revap/screens/details/details_screen.dart';
import 'package:revap/screens/sign_in/sign_in_screen.dart';

import '../../../size_config.dart';
import 'company_card.dart';
import '../../../size_config.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  List<Company> companyList = []; // Initialize the companyList here

  Future<void> fetchDataAndUpdateList() async {
    User user = User();
    String? accessToken = await user.getAccessToken();

    if (accessToken != null) {
      try {
        List<Company> fetchedCompanies =
            await Company.fetchCompanies(accessToken);

        setState(() {
          companyList = fetchedCompanies;
        });
      } catch (e) {
        if (e is UnauthorizedException) {
          User user = User();
          String? newAccessToken = await user.getRefreshToken();
          if (newAccessToken != null) {
            List<Company> fetchedCompanies =
                await Company.fetchCompanies(newAccessToken);

            setState(() {
              companyList = fetchedCompanies;
            });
          }
        } else {
          // Handle other exceptions here
          // ignore: use_build_context_synchronously
          showCustomDialog(context, "Error fetching companies: $e",
              const Color.fromARGB(206, 250, 1, 1));
        }
      }
    } else {
      print('Access token not found in SharedPreferences.');
      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(context, SignInScreen.routeName);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchDataAndUpdateList(); // Fetch data when the widget is initialized
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: companyList.length,
              itemBuilder: (context, index) => Padding(
                padding: EdgeInsets.symmetric(vertical: 0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, DetailsScreen.routeName);
                  },
                  child: CompanyCard(company: companyList[index]),
                ),
              ),
            ),
          ),
          // Divider(), // Add a line divider
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              'Total companies: ${companyList.length}',
              style: TextStyle(fontSize: 12), // Adjust the font size as needed
            ),
          ),
        ],
      ),
    );
  }
}
