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
    return Row(
      children: [
        SizedBox(
          width: 88,
          child: AspectRatio(
            aspectRatio: 0.88,
            child: Container(
              padding: EdgeInsets.all(getProportionateScreenWidth(10)),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F6F9),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Image.asset(
                company.img.isEmpty
                    ? "assets/images/company-logo.png"
                    : company.img,
                fit: BoxFit.cover, // Make the image fit inside the Container
              ),
            ),
          ),
        ),
        const SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              company.name,
              style: const TextStyle(color: Colors.black, fontSize: 16),
              maxLines: 2,
            ),
            const SizedBox(height: 10),
            Text.rich(
              TextSpan(
                text: company.category,
                style: const TextStyle(
                    fontWeight: FontWeight.w600, color: kPrimaryColor),
              ),
            )
          ],
        )
      ],
    );
  }
}
