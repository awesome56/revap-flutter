import 'package:flutter/material.dart';
import 'package:revap/constants.dart';
import 'package:revap/models/Branch.dart';
import 'package:revap/models/User.dart';
import 'package:revap/size_config.dart';
import 'package:revap/components/loadingDialog.dart';
import 'package:revap/components/messageDialog.dart';
import 'package:revap/modals/add_company_image/add_company_image_screen.dart';
import 'package:revap/screens/sign_in/sign_in_screen.dart';

class AddBranchScreen extends StatefulWidget {
  static String routeName = "/complete_profile";
  final int company_id;

  const AddBranchScreen({required this.company_id, Key? key}) : super(key: key);

  @override
  State<AddBranchScreen> createState() => _AddBranchScreenState();
}

class _AddBranchScreenState extends State<AddBranchScreen> {
  final _formKey = GlobalKey<FormState>();
  int? company_id;
  String? name, description, phone, email, website, manager, location;
  Branch branch = Branch();
  User user = User();

  @override
  void initState() {
    super.initState();
    company_id = widget.company_id;
  }

  // Function to handle the "Next" button click
  Future<void> _handleNextButtonClick() async {
    if (_formKey.currentState!.validate()) {
      LoadingDialog.show(context);
      try {
        _formKey.currentState!.save();
        String? accessToken = await user.getAccessToken();

        if (accessToken != null) {
          final result = await branch.addBranch(company_id!, accessToken, name!,
              description!, phone!, email!, website!, manager!, location!);
          if (result['success'] == true) {
            // ignore: use_build_context_synchronously
            LoadingDialog.hide(context);
            // ignore: use_build_context_synchronously
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddCompanyImageScreen(formData: {
                        "id": result["data"]['id'],
                        "company_id": result["data"]['company_id'],
                        "name": result["data"]['name'],
                        "email": result["data"]['email'],
                        "phone": result["data"]['phone'],
                        "manager": result["data"]['manager'],
                        "location": result["data"]['location'],
                        "img": result["data"]['name'],
                        "code": result["data"]['code'],
                        "qrcode": result["data"]['qrcode'],
                        "website": result["data"]['website'],
                        "created_at": result["data"]['created_at'],
                        "updated_at": result["data"]['updated_at'],
                      })),
            );
          } else if (result['success'] == 401) {
            String? newAccessToken = await user.getRefreshToken();
            if (newAccessToken != null) {
              final result = await branch.addBranch(
                  company_id!,
                  newAccessToken,
                  name!,
                  description!,
                  phone!,
                  email!,
                  website!,
                  manager!,
                  location!);

              if (result['success'] == true) {
                // ignore: use_build_context_synchronously
                LoadingDialog.hide(context);
                // ignore: use_build_context_synchronously
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddCompanyImageScreen(formData: {
                            "id": result["data"]['id'],
                            "company_id": result["data"]['company_id'],
                            "name": result["data"]['name'],
                            "description": result["data"]['description'],
                            "email": result["data"]['email'],
                            "phone": result["data"]['phone'],
                            "manager": result["data"]['manager'],
                            "location": result["data"]['location'],
                            "img": result["data"]['name'],
                            "code": result["data"]['code'],
                            "qrcode": result["data"]['qrcode'],
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
                      buildDescriptionFormField(),
                      const SizedBox(height: 30),
                      buildPhoneFormField(),
                      const SizedBox(height: 30),
                      buildEmailFormField(),
                      const SizedBox(height: 30),
                      buildWebsiteFormField(),
                      const SizedBox(height: 30),
                      buildManagerFormField(),
                      const SizedBox(height: 30),
                      buildLocationFormField(),
                      const SizedBox(height: 40),
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

  TextFormField buildLocationFormField() {
    return TextFormField(
      onSaved: (newValue) => location = newValue,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter branch location.';
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "Location",
        hintText: "Enter location of branch",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildManagerFormField() {
    return TextFormField(
      onSaved: (newValue) => manager = newValue,
      decoration: const InputDecoration(
        labelText: "Manager",
        hintText: "Enter manager name",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildWebsiteFormField() {
    return TextFormField(
      onSaved: (newValue) => website = newValue,
      decoration: const InputDecoration(
        labelText: "Website",
        hintText: "Enter branch website",
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

  TextFormField buildPhoneFormField() {
    return TextFormField(
      onSaved: (newValue) => phone = newValue,
      decoration: const InputDecoration(
        labelText: "Phone",
        hintText: "Enter branch phone",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildDescriptionFormField() {
    return TextFormField(
      maxLines: 3, // Allow up to 3 lines of text
      onSaved: (newValue) => description = newValue,
      decoration: const InputDecoration(
        labelText: "Description",
        hintText: "Enter branch description",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      textInputAction:
          TextInputAction.newline, // Display a newline button on the keyboard
    );
  }

  TextFormField buildNameFormField() {
    return TextFormField(
      onSaved: (newValue) => name = newValue,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter a branch name.';
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
