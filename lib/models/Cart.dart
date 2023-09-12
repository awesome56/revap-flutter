import 'package:flutter/material.dart';

import 'Company.dart';

class Cart {
  final Company company;
  final int numOfItem;

  Cart({required this.company, required this.numOfItem});
}

// Demo data for our cart

// List<Cart> demoCarts = [
//   Cart(company: demoProducts[0], numOfItem: 2),
//   Cart(company: demoProducts[1], numOfItem: 1),
//   Cart(company: demoProducts[3], numOfItem: 1),
// ];
