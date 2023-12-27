import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

import '../../../constants.dart';

class Branch {
  final int id, company_id;
  final String name,
      description,
      email,
      phone,
      website,
      img,
      manager,
      location,
      code,
      qrcode,
      created_at,
      updated_at;

  Branch({
    this.id = 0,
    this.company_id = 0,
    this.name = "",
    this.description = "",
    this.email = "",
    this.phone = "",
    this.website = "",
    this.img = "",
    this.manager = "",
    this.location = "",
    this.code = "",
    this.qrcode = "",
    this.created_at = "",
    this.updated_at = "",
  });

  Future<Map<String, dynamic>> addBranch(
    int company_id,
    String accessToken,
    name,
    description,
    email,
    phone,
    website,
    manager,
    location,
  ) async {
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };
    // var apiUrl = Uri.parse('$kUrl/branches/company/$company_id');

    var request =
        http.Request('POST', Uri.parse('$kUrl/branches/company/$company_id'));

    request.body = jsonEncode({
      "name": name,
      "description": description,
      "email": email,
      "phone": phone,
      "website": website,
      "manager": manager,
      "location": location,
    });

    request.headers.addAll(headers);

    try {
      // Simulate a successful sign-in
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 201) {
        // Successful login, navigate to the home screen
        Map<String, dynamic> branchJson =
            json.decode(await response.stream.bytesToString());

        return {
          'success': true,
          'data': {
            "id": branchJson['id'],
            "name": branchJson['name'],
            "description": branchJson['description'],
            "email": branchJson['email'],
            "phone": branchJson['phone'],
            "website": branchJson['website'],
            "img": branchJson['img'],
            "manager": branchJson['manager'],
            "location": branchJson['location'],
            "code": branchJson['code'],
            "qrcode": branchJson['qrcode'],
            "created_at": branchJson['created_at'],
            "updated_at": branchJson['updated_at'],
          },
        };
      } else if (response.statusCode == 401) {
        return {
          'success': 401,
        };
      } else if (response.statusCode == 400 ||
          response.statusCode == 409 ||
          response.statusCode == 404) {
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
  }
}
