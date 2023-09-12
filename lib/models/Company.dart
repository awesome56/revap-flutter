import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../constants.dart';

class Company {
  final int id, user_id, verified;
  final String name,
      email,
      category,
      website,
      img,
      ceo,
      head_office,
      created_at,
      updated_at;

  Company({
    this.id = 0,
    this.user_id = 0,
    this.name = "",
    this.category = "Uncategorized",
    this.email = "",
    this.website = "",
    this.img = "",
    this.ceo = "",
    this.head_office = "",
    this.verified = 0,
    this.created_at = "",
    this.updated_at = "",
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: json['id'] as int? ?? 0,
      user_id: json['user_id'] as int? ?? 0,
      name: json['name'] as String? ?? "",
      category: json['category'] as String? ?? "Uncategorized",
      email: json['email'] as String? ?? "",
      website: json['website'] as String? ?? "",

      img: json['img'] as String? ?? "assets/images/company-logo.png",
      ceo: json['ceo'] as String? ?? "",
      head_office: json['head_office'] as String? ?? "",
      verified: json['verified'] as int? ?? 0,
      created_at: json['created_at'] as String? ?? "",
      updated_at: json['updated_at'] as String? ?? "",
      // Map other JSON fields to corresponding class fields
    );
  }

  static Future<List<Company>> fetchCompanies(String accessToken) async {
    var headers = {
      'Authorization': 'Bearer $accessToken',
    };

    var response = await http.get(
      Uri.parse('$kUrl/companies/?page=1'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = json.decode(response.body);
      List<Company> companyList = [];

      if (jsonData.containsKey("data")) {
        List<dynamic> data = jsonData["data"];

        for (var item in data) {
          companyList.add(Company.fromJson(item));
        }
      }

      return companyList;
    } else if (response.statusCode == 401) {
      // Customize error handling for 401 here
      throw UnauthorizedException('Unauthorized: You are not logged in.');
    } else {
      throw Exception('Failed to fetch data: ${response.reasonPhrase}');
    }
  }
}

class UnauthorizedException implements Exception {
  final String message;

  UnauthorizedException(this.message);

  @override
  String toString() {
    return message;
  }
}
