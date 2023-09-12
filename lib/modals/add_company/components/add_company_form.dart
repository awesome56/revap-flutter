import 'package:flutter/material.dart';
import 'package:revap/components/custom_surfix_icon.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:revap/components/form_error.dart';

class AddCompanyForm extends StatefulWidget {
  @override
  _AddCompanyFormState createState() => _AddCompanyFormState();
}

class _AddCompanyFormState extends State<AddCompanyForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String?> errors = [];
  String? email;
  String? ceo;
  String? head_office;

  final TextEditingController _controller = TextEditingController();
  final List<String> items = [
    "Afghanistan",
    "Albania",
    "Algeria",
    "American Samoa",
    "Andorra",
    "Angola",
    "Anguilla",
    "Antarctica",
    "Antigua and Barbuda",
    "Argentina",
    "Armenia",
    "Aruba",
    "Australia",
    "Austria",
    "Azerbaijan"
  ];

  List<String> selectedCategories = [];

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildNameFormField(),
          SizedBox(height: 30),
          buildEmailFormField(),
          SizedBox(height: 30),
          buildDropdownSearchFormField(items, selectedCategories),
          SizedBox(height: 30),
          buildWebsiteFormField(),
          SizedBox(height: 30),
          buildCeoFormField(),
          SizedBox(height: 30),
          buildAddressFormField(),
          FormError(errors: errors),
          SizedBox(height: 40),
          // Add your submit button here
        ],
      ),
    );
  }

  DropdownSearch<String> buildDropdownSearchFormField(
      List<String> items, List<String> selectedCategories) {
    return DropdownSearch<String>.multiSelection(
      items: items,
      popupProps: PopupPropsMultiSelection.menu(
        showSelectedItems: true,
        disabledItemFn: (String s) => s.startsWith('I'),
        showSearchBox: true,
      ),
      onChanged:
          print, // You might want to replace this with your logic for handling the selected items.
      dropdownDecoratorProps: const DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          labelText: "Categories",
          hintText: "Select one or more category",
          floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Shop Icon.svg"),
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
        suffixIcon:
            CustomSurffixIcon(svgIcon: "assets/icons/Location point.svg"),
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
        suffixIcon:
            CustomSurffixIcon(svgIcon: "assets/icons/Location point.svg"),
      ),
    );
  }

  TextFormField buildWebsiteFormField() {
    return TextFormField(
      onSaved: (newValue) => head_office = newValue,
      decoration: const InputDecoration(
        labelText: "Website",
        hintText: "Enter company website",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon:
            CustomSurffixIcon(svgIcon: "assets/icons/Location point.svg"),
      ),
    );
  }

  TextFormField buildEmailFormField() {
    return TextFormField(
      onSaved: (newValue) => email = newValue,
      decoration: InputDecoration(
        labelText: "Email",
        hintText: "Enter company email",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }

  TextFormField buildNameFormField() {
    return TextFormField(
      onSaved: (newValue) => email = newValue,
      validator: (value) {
        return null;
      },
      decoration: InputDecoration(
        labelText: "Name",
        hintText: "Enter company name",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }
}
