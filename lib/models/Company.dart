import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

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

  // Function to add a new company
  Future<Map<String, dynamic>> addCompany(
    String accessToken,
    String name,
    String email,
    String category,
    String website,
    String ceo,
    String headOffice,
  ) async {
    // try {
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };

    var request = http.Request('POST', Uri.parse('$kUrl/companies/'));

    request.body = jsonEncode({
      "name": name,
      "email": email,
      "category": category,
      "website": website,
      "ceo": ceo,
      "head_office": headOffice,
    });

    request.headers.addAll(headers);

    // var response = await http.post(
    //   Uri.parse('$kUrl/companies/'),
    //   headers: headers,
    //   body: json.encode(body),
    // );

    try {
      // Simulate a successful sign-in
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 201) {
        // Successful login, navigate to the home screen
        Map<String, dynamic> companyJson =
            json.decode(await response.stream.bytesToString());

        return {
          'success': true,
          'data': {
            "id": companyJson['id'],
            "name": companyJson['name'],
            "email": companyJson['email'],
            "category": companyJson['category'],
            "ceo": companyJson['ceo'],
            "head_office": companyJson['head_office'],
            "img": companyJson['img'],
            "verified": companyJson['verified'],
            "website": companyJson['website'],
            "created_at": companyJson['created_at'],
            "updated_at": companyJson['updated_at'],
          },
        };
      } else if (response.statusCode == 401) {
        return {
          'success': 401,
        };
      } else if (response.statusCode == 400 || response.statusCode == 409) {
        // Display error toast from the API response
        String errorMessage = await response.stream.bytesToString();
        try {
          Map<String, dynamic> errorJson = json.decode(errorMessage);
          String error = errorJson['error'];

          return {
            'success': false,
            'error': error,
          };
        } catch (e) {
          // If JSON decoding fails, display a generic error message
          return {
            'success': false,
            'error': 'An error occurred. Please try again.',
          };
        }
      } else {
        // Handle other status codes or errors
        return {
          'success': false,
          'error': 'An error occurred. Please try again.',
        };
      }
    } catch (e) {
      if (e is SocketException) {
        // You can throw a custom network error here if needed.
        return {
          'success': false,
          'error': 'Network error: Failed to connect to the network.',
        };
      } else {
        // Handle other exceptions here
        return {
          'success': false,
          'error': 'An error occurred: $e',
        };
      }
    }
    //   if (response.statusCode == 200) {
    //     // Company added successfully
    //     return {
    //       "name": name,
    //       "email": email,
    //       "category": category,
    //       "website": website,
    //       "ceo": ceo,
    //       "head_office": headOffice,
    //     };
    //   } else if (response.statusCode == 401) {
    //     // Customize error handling for 401 here
    //     throw UnauthorizedException('Unauthorized: You are not logged in.');
    //   } else {
    //     throw Exception('Failed to fetch data: ${response.reasonPhrase}');
    //   }
    // } catch (e) {
    //   // Handle exceptions
    //   return {'error': "An error occurred: $e"};
    // }
  }

// Function to add a new company image
  Future<Map<String, dynamic>> addCompanyImage(
    String accessToken,
    int companyId,
    File imageFile,
  ) async {
    try {
      var headers = {
        'Authorization': 'Bearer $accessToken',
      };

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$kUrl/companies/dp/$companyId'),
      );

      // Add the image file to the request
      request.files.add(
        await http.MultipartFile.fromPath(
          'dp',
          imageFile.path,
        ),
      );

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      if (response.statusCode == 201) {
        // Image uploaded successfully
        Map<String, dynamic> imageJson =
            json.decode(await response.stream.bytesToString());

        return {
          'success': true,
          'data': {
            // Include any relevant data from the response
            "img": imageJson['img'],
            // Add more fields as needed
          },
        };
      } else if (response.statusCode == 401) {
        return {
          'success': 401,
        };
      } else {
        // Handle other status codes or errors
        return {
          'success': false,
          'error': 'An error occurred. Please try again.',
        };
      }
    } catch (e) {
      if (e is SocketException) {
        // Handle network error
        return {
          'success': false,
          'error': 'Network error: Failed to connect to the network.',
        };
      } else {
        // Handle other exceptions here
        return {
          'success': false,
          'error': 'An error occurred: $e',
        };
      }
    }
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
