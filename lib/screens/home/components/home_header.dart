import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../size_config.dart';
import 'icon_btn_with_counter.dart';
import 'search_field.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              // Handle onPressed event here
            },
            icon: InkWell(
              child: SvgPicture.asset(
                "assets/icons/Hamburger-menu.svg",
                color: Colors.black54, // Set the color here
                width: 24, // Set the width here
                height: 24, // Set the height here
              ),
              onTap: () {
                // Handle onTap event here
              },
            ),
          ),
          SearchField(),
          IconBtnWithCounter(
            svgSrc: "assets/icons/Camera Icon2.svg",
            press: () {},
          ),
        ],
      ),
    );
  }
}
