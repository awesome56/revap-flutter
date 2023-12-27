import 'package:flutter/material.dart';
import 'package:revap/models/Company.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:revap/components/loadingDialog.dart';
import 'package:revap/constants.dart';

import '../../../size_config.dart';
import 'company_card.dart';
import '../../../size_config.dart';

class CompanyListBody extends StatefulWidget {
  const CompanyListBody({super.key});

  @override
  _CompanyListBodyState createState() => _CompanyListBodyState();
}

class _CompanyListBodyState extends State<CompanyListBody> {
  final _storage = const FlutterSecureStorage();
  List<Company> companyList = []; // Initialize the companyList here

  Future<String?> getAccessToken() async {
    String? accessToken = await _storage.read(key: 'accessToken');
    return accessToken;
  }

  Future<String?> getRefreshToken() async {
    String? refreshToken = await _storage.read(key: 'refreshToken');
    return refreshToken;
  }

  Future<String?> refreshAccessToken() async {
    String? refreshToken = await getRefreshToken();

    if (refreshToken != null) {
      var headers = {
        'Authorization': 'Bearer $refreshToken',
      };

      var response = await http.get(
        Uri.parse('$kUrl/auth/token/refresh'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        // Parse the JSON response and extract the new access token
        Map<String, dynamic> jsonData = json.decode(response.body);
        String? newAccessToken = jsonData['access'];
        return newAccessToken;
      } else {
        // Handle the error when refreshing the token (e.g., show an error message)
        print('Failed to refresh access token: ${response.reasonPhrase}');
        return null;
      }
    } else {
      // Handle the case when the refresh token is not available
      print('Refresh token not found in SharedPreferences.');
      return null;
    }
  }

  Future<void> fetchDataAndUpdateList() async {
    String? accessToken = await getAccessToken();

    if (accessToken != null) {
      var headers = {
        'Authorization': 'Bearer $accessToken',
      };

      var response = await http.get(
        Uri.parse(
            'https://revap-api-6f16447151c5.herokuapp.com/api/v1/companies/?page=1'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        // Parse the JSON response and update the companyList
        Map<String, dynamic> jsonData = json.decode(response.body);
        List<Company> updatedCompanyList = [];
        // List<dynamic> data = json.decode(response.body);
        if (jsonData.containsKey("data")) {
          // Check if "data" key exists in the JSON response
          List<dynamic> data = jsonData["data"];

          for (var item in data) {
            updatedCompanyList.add(Company.fromJson(item));
          }
          // ignore: use_build_context_synchronously
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Center(
                  child: Text(
                    "Successful",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                content: const Text(
                  "Successful: Loading successful",
                  style: TextStyle(
                    color: Color.fromARGB(
                        255, 108, 54, 244), // Set the content text color to red
                  ),
                ),
                actions: [
                  TextButton(
                    child: Text("Close"),
                    onPressed: () {
                      LoadingDialog.hide(context);
                    },
                  ),
                ],
              );
            },
          );
        }

        setState(() {
          companyList = updatedCompanyList;
        });
      } else if (response.statusCode == 401) {
        // Handle the 401 error by refreshing the access token
        String? newAccessToken = await refreshAccessToken();

        if (newAccessToken != null) {
          // Update the headers with the new access token and retry the request
          headers['Authorization'] = 'Bearer $newAccessToken';
          response = await http.get(
            Uri.parse(
                'https://revap-api-6f16447151c5.herokuapp.com/api/v1/companies/?page=1'),
            headers: headers,
          );

          if (response.statusCode == 200) {
            // Parse the JSON response and update the companyList
            Map<String, dynamic> jsonData = json.decode(response.body);
            List<Company> updatedCompanyList = [];
            // List<dynamic> data = json.decode(response.body);
            if (jsonData.containsKey("data")) {
              // Check if "data" key exists in the JSON response
              List<dynamic> data = jsonData["data"];

              for (var item in data) {
                updatedCompanyList.add(Company.fromJson(item));
              }
              // ignore: use_build_context_synchronously
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Center(
                      child: Text(
                        "Successful",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    content: const Text(
                      "Successful: Loading successful",
                      style: TextStyle(
                        color: Color.fromARGB(255, 108, 54,
                            244), // Set the content text color to red
                      ),
                    ),
                    actions: [
                      TextButton(
                        child: Text("Close"),
                        onPressed: () {
                          LoadingDialog.hide(context);
                        },
                      ),
                    ],
                  );
                },
              );
            }

            setState(() {
              companyList = updatedCompanyList;
            });
          } else {
            print(
                'Failed to fetch data after token refresh: ${response.reasonPhrase}');
          }
        } else {
          print('Failed to refresh access token.');
        }
      } else {
        print('Failed to fetch data: ${response.reasonPhrase}');
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Center(
                child: Text(
                  "Network Error",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              content: Text(
                "Failed to fetch data: ${response.reasonPhrase}",
                style: const TextStyle(
                  color: Colors.red, // Set the content text color to red
                ),
              ),
              actions: [
                TextButton(
                  child: Text("Close"),
                  onPressed: () {
                    LoadingDialog.hide(context);
                  },
                ),
              ],
            );
          },
        );
      }
    } else {
      print('Access token not found in SharedPreferences.');
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Center(
              child: Text(
                "Network Error",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            content: const Text(
              "Access token not found in SharedPreferences.",
              style: TextStyle(
                color: Colors.red, // Set the content text color to red
              ),
            ),
            actions: [
              TextButton(
                child: Text("Close"),
                onPressed: () {
                  LoadingDialog.hide(context);
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchDataAndUpdateList(); // Fetch data when the widget is initialized
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: companyList.map((company) {
        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(20),
            vertical: 10,
          ),
          child: GestureDetector(
            onTap: () {
              // Handle the tap event for the CompanyCard here
              // You can navigate to a new screen or perform any desired action.
            },
            child: CompanyCard(company: company),
          ),
        );
      }).toList(),
    );
  }
}
