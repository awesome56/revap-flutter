import 'package:flutter/material.dart';
import 'package:revap/components/default_button.dart';
import 'package:revap/models/Company.dart';
import 'package:revap/size_config.dart';

import 'color_dots.dart';
import 'product_description.dart';
import 'top_rounded_container.dart';
import 'product_images.dart';

class Body extends StatelessWidget {
  final Company company;

  const Body({Key? key, required this.company}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        CompanyImages(company: company),
        TopRoundedContainer(
          color: Colors.white,
          child: Column(
            children: [
              CompanyCategory(
                company: company,
                pressOnSeeMore: () {},
              ),
              // TopRoundedContainer(
              //   color: Color(0xFFF6F7F9),
              //   child: Column(
              //     children: [
              //       ColorDots(product: product),
              //       TopRoundedContainer(
              //         color: Colors.white,
              //         child: Padding(
              //           padding: EdgeInsets.only(
              //             left: SizeConfig.screenWidth * 0.15,
              //             right: SizeConfig.screenWidth * 0.15,
              //             bottom: getProportionateScreenWidth(40),
              //             top: getProportionateScreenWidth(15),
              //           ),
              //           child: DefaultButton(
              //             text: "Add To Cart",
              //             press: () {},
              //           ),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      ],
    );
  }
}
