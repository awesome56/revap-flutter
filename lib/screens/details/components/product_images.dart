import 'package:flutter/material.dart';
import 'package:revap/models/Company.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class CompanyImages extends StatefulWidget {
  const CompanyImages({
    Key? key,
    required this.company,
  }) : super(key: key);

  final Company company;

  @override
  _CompanyImagesState createState() => _CompanyImagesState();
}

class _CompanyImagesState extends State<CompanyImages> {
  int selectedImage = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: getProportionateScreenWidth(238),
          child: AspectRatio(
            aspectRatio: 1,
            child: Hero(
              tag: widget.company.id.toString(),
              child: Image.asset(widget.company.img[selectedImage]),
            ),
          ),
        ),
        // SizedBox(height: getProportionateScreenWidth(20)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ...List.generate(widget.company.img.length,
                (index) => buildSmallProductPreview(index)),
          ],
        )
      ],
    );
  }

  GestureDetector buildSmallProductPreview(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedImage = index;
        });
      },
      child: AnimatedContainer(
        duration: defaultDuration,
        margin: EdgeInsets.only(right: 15),
        padding: EdgeInsets.all(8),
        height: getProportionateScreenWidth(48),
        width: getProportionateScreenWidth(48),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: kPrimaryColor.withOpacity(selectedImage == index ? 1 : 0)),
        ),
        child: Image.asset(widget.company.img),
      ),
    );
  }
}
