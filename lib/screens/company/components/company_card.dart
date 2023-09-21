import 'package:flutter/material.dart';
import 'package:revap/models/Company.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class CompanyCard extends StatelessWidget {
  const CompanyCard({
    Key? key,
    required this.company,
  }) : super(key: key);

  final Company company;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(20),
            vertical: getProportionateScreenWidth(10),
          ),
          leading: SizedBox(
            width: 88,
            height: 88,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: company.img.isEmpty
                  ? Image.asset(
                      "assets/images/company-logo.png",
                      fit: BoxFit.cover,
                    )
                  : Image.network(
                      (kUrl + company.img).replaceFirst("/api/v1/app/src", ''),
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          title: Text(
            company.name,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 2,
          ),
          subtitle: Text(
            company.category,
            style: const TextStyle(
              color: kPrimaryColor,
              fontSize: 13,
            ),
          ),
        ),
        Divider(
          // You can adjust the thickness of the divider
          indent:
              getProportionateScreenWidth(20), // Adjust the left indentation
          endIndent:
              getProportionateScreenWidth(20), // Adjust the right indentation
        ),
      ],
    );
  }
}
