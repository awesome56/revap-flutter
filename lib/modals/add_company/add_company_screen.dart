import 'package:flutter/material.dart';
import 'package:revap/constants.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:revap/models/Company.dart';
import 'package:revap/models/User.dart';
import 'package:revap/size_config.dart';
import 'package:revap/components/loadingDialog.dart';
import 'package:revap/components/messageDialog.dart';
import 'package:revap/modals/add_company_image/add_company_image_screen.dart';
import 'package:revap/screens/sign_in/sign_in_screen.dart';

class AddCompanyScreen extends StatefulWidget {
  static String routeName = "/complete_profile";

  const AddCompanyScreen({super.key});

  @override
  State<AddCompanyScreen> createState() => _AddCompanyScreenState();
}

class _AddCompanyScreenState extends State<AddCompanyScreen> {
  final _formKey = GlobalKey<FormState>();
  String? name;
  String? email;
  String? website;
  String? ceo;
  String? head_office;
  Company company = Company();
  User user = User();
  bool agreedToTerms = false;
  List<String> selectedCategories = [];
  final List<String> items = [
    "Technology",
    "Healthcare",
    "Finance",
    "Retail",
    "Entertainment",
    "Manufacturing",
    "Education",
    "Food & Beverage",
    "Transportation",
    "Real Estate",
    "Small Business",
    "Medium-sized Enterprise (SME)",
    "Large Corporation",
    "Local",
    "National",
    "International",
    "Startup",
    "Non-profit",
    "Government",
    "E-commerce",
    "Consulting",
    "Service",
    "Product",
    "Diversity & Inclusion",
    "Sustainability",
    "Innovation",
    "Social Responsibility",
    "Work-Life Balance",
    "Software",
    "Hardware",
    "Healthcare Providers",
    "Restaurants",
    "Retailers",
    "Entertainment Services",
    "Early-stage",
    "Growth-stage",
    "Established",
    "Specialized",
    "Top-rated companies",
    "User-reviewed companies",
    "Industry Awards",
    "Franchise",
    "Independent",
    "Publicly traded",
    "Privately owned",
    "Family-owned",
    "Accessible",
    "Online-only",
    "Physical locations",
    "Partnerships",
    "Supply Chain",
    "Financial Metrics",
    "Subscription Models",
    "Customer Demographics",
    "Product Pricing",
    "Tech Hubs",
    "Health and Safety Measures",
    "Innovation Labs",
    "Community Involvement",
    "Historical Significance",
    "Environmental Impact",
    "Global Brands",
    "Local Brands",
    "Art and Culture",
    "Legal and Compliance",
  ];

  // Function to handle the "Next" button click
  Future<void> _handleNextButtonClick() async {
    if (_formKey.currentState!.validate() && agreedToTerms) {
      LoadingDialog.show(context);
      try {
        _formKey.currentState!.save();
        String? accessToken = await user.getAccessToken();

        if (accessToken != null) {
          final result = await company.addCompany(accessToken, name!, email!,
              selectedCategories.toString(), website!, ceo!, head_office!);
          if (result['success'] == true) {
            // ignore: use_build_context_synchronously
            LoadingDialog.hide(context);
            // ignore: use_build_context_synchronously
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddCompanyImageScreen(formData: {
                        "id": result["data"]['name'],
                        "name": result["data"]['name'],
                        "email": result["data"]['name'],
                        "category": result["data"]['name'],
                        "ceo": result["data"]['name'],
                        "head_office": result["data"]['name'],
                        "img": result["data"]['name'],
                        "verified": result["data"]['name'],
                        "website": result["data"]['name'],
                        "created_at": result["data"]['name'],
                        "updated_at": result["data"]['name'],
                      })),
            );
          } else if (result['success'] == 401) {
            String? newAccessToken = await user.getRefreshToken();
            if (newAccessToken != null) {
              final result = await company.addCompany(
                  newAccessToken,
                  name!,
                  email!,
                  selectedCategories.toString(),
                  website!,
                  ceo!,
                  head_office!);

              if (result['success'] == true) {
                // ignore: use_build_context_synchronously
                LoadingDialog.hide(context);
                // ignore: use_build_context_synchronously
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddCompanyImageScreen(formData: {
                            "id": result["data"]['id'],
                            "name": result["data"]['name'],
                            "email": result["data"]['email'],
                            "category": result["data"]['category'],
                            "ceo": result["data"]['ceo'],
                            "head_office": result["data"]['head_office'],
                            "img": result["data"]['img'],
                            "verified": result["data"]['verified'],
                            "website": result["data"]['website'],
                            "created_at": result["data"]['created_at'],
                            "updated_at": result["data"]['updated_at'],
                          })),
                );
              } else {
                // ignore: use_build_context_synchronously
                LoadingDialog.hide(context);
                // ignore: use_build_context_synchronously
                showCustomDialog(context, result["error"],
                    const Color.fromARGB(206, 250, 1, 1));
              }
            } else {
              // ignore: use_build_context_synchronously
              showCustomDialog(context, 'An error occurred. Please try again.',
                  const Color.fromARGB(206, 250, 1, 1));
              // Handle the error here, e.g., show an error message
            }
          } else {
            // ignore: use_build_context_synchronously
            LoadingDialog.hide(context);
            // ignore: use_build_context_synchronously
            showCustomDialog(
                context, result["error"], const Color.fromARGB(206, 250, 1, 1));
          }
        } else {
          // ignore: use_build_context_synchronously
          LoadingDialog.hide(context);
          // ignore: use_build_context_synchronously
          Navigator.pushReplacementNamed(context, SignInScreen.routeName);
        }
      } catch (e) {
        // ignore: use_build_context_synchronously
        LoadingDialog.hide(context);
        // ignore: use_build_context_synchronously
        showCustomDialog(context, "$e", const Color.fromARGB(206, 223, 0, 0));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              icon: const Icon(Icons.close),
            ),
            const Text(
              'New company',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: _handleNextButtonClick,
              child: const Text(
                'Next',
                style: TextStyle(color: kPrimaryColor),
              ),
            ),
          ],
        ),
      ),
      body: ListView(
        children: <Widget>[
          SafeArea(
            child: SizedBox(
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(20)),
                // SingleChildScrollView
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(height: SizeConfig.screenHeight * 0.03),
                      buildNameFormField(),
                      const SizedBox(height: 30),
                      buildEmailFormField(),
                      const SizedBox(height: 30),
                      buildDropdownSearchFormField(items),
                      const SizedBox(height: 30),
                      buildWebsiteFormField(),
                      const SizedBox(height: 30),
                      buildCeoFormField(),
                      const SizedBox(height: 30),
                      buildAddressFormField(),
                      const SizedBox(height: 40),
                      SizedBox(
                          height: getProportionateScreenHeight(
                              10)), // Adjust the spacing
                      Row(
                        children: [
                          Checkbox(
                            value: agreedToTerms,
                            onChanged: (newValue) {
                              setState(() {
                                agreedToTerms = newValue!;
                              });
                            },
                          ),
                          Flexible(
                            child: Text(
                              "By continuing you confirm that you agree with our Terms and Conditions",
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                          height: getProportionateScreenHeight(
                              20)), // Adjust the spacing
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  DropdownSearch<String> buildDropdownSearchFormField(List<String> items) {
    return DropdownSearch<String>.multiSelection(
      items: items,
      popupProps: const PopupPropsMultiSelection.menu(
        showSelectedItems: true,
        // disabledItemFn: (String s) => s.startsWith('I'),
        showSearchBox: true,
      ),
      onSaved: (selectedItems) => selectedCategories = selectedItems!,
      validator: (selectedItems) {
        if (selectedItems!.isEmpty) {
          return 'Please select at least one category.';
        }
        return null;
      },
      dropdownDecoratorProps: const DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          labelText: "Categories",
          hintText: "Select one or more category",
          floatingLabelBehavior: FloatingLabelBehavior.always,
        ),
      ),
      selectedItems: selectedCategories,
    );
  }

  TextFormField buildAddressFormField() {
    return TextFormField(
      onSaved: (newValue) => head_office = newValue,
      decoration: const InputDecoration(
        labelText: "Head office",
        hintText: "Enter Head office address",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildCeoFormField() {
    return TextFormField(
      onSaved: (newValue) => ceo = newValue,
      decoration: const InputDecoration(
        labelText: "CEO/ Manager",
        hintText: "Enter CEO name",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildWebsiteFormField() {
    return TextFormField(
      onSaved: (newValue) => website = newValue,
      decoration: const InputDecoration(
        labelText: "Website",
        hintText: "Enter company website",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildEmailFormField() {
    return TextFormField(
      onSaved: (newValue) => email = newValue,
      decoration: const InputDecoration(
        labelText: "Email",
        hintText: "Enter company email",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildNameFormField() {
    return TextFormField(
      onSaved: (newValue) => name = newValue,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter a company name.';
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "Name",
        hintText: "Enter company name",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }
}
