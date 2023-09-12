import 'package:flutter/material.dart';
import 'components/body.dart';

class AddCompanyScreen extends StatelessWidget {
  static String routeName = "/complete_profile";

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          AppBar(
            automaticallyImplyLeading: false, // Remove the default back button
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: Text(
                    'Close',
                    style: TextStyle(
                      color: Colors.red, // Customize the button color
                    ),
                  ),
                ),
                Text(
                  'New Company',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Handle the "Next" button action
                  },
                  child: Text('Next'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: <Widget>[
                // Add your scrollable content here
                Body(), // Replace with your Body widget
              ],
            ),
          ),
        ],
      ),
    );
  }
}
