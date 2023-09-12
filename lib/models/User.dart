import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import '../../../constants.dart';

class User {
  final int id, verified;
  final String name, email, password, created_at, updated_at;

  User({
    this.id = 0,
    this.verified = 0,
    this.name = "",
    this.email = "",
    this.password = "",
    this.created_at = "",
    this.updated_at = "",
  });

  final _storage = FlutterSecureStorage();

  Future<String?> getAccessToken() async {
    String? accessToken = await _storage.read(key: 'accessToken');
    return accessToken;
  }

  Future<String?> getRefreshToken() async {
    String? refreshToken = await _storage.read(key: 'refreshToken');
    if (refreshToken != null) {
      var headers = {
        'Authorization': 'Bearer $refreshToken',
      };

      var response = await http.get(
        Uri.parse('$kUrl/auth/token/refresh'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        // Parse the JSON response and extract the new access token
        Map<String, dynamic> jsonData = json.decode(response.body);
        String? newAccessToken = jsonData['access'];
        return newAccessToken;
      } else {
        // Handle the error when refreshing the token (e.g., show an error message)
        print('Failed to refresh access token: ${response.reasonPhrase}');
        return null;
      }
    } else {
      // Handle the case when the refresh token is not available
      print('Refresh token not found in SharedPreferences.');
      return null;
    }
  }

  Future<Map<String, dynamic>> signIn(String email, String password) async {
    // Perform your sign-in logic here
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request('POST', Uri.parse('$kUrl/auth/login'));
    request.body = json.encode({
      "email": email,
      "password": password,
    });
    request.headers.addAll(headers);
    try {
      // Simulate a successful sign-in
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        // Credentials are correct but user is not verified
        return {
          'success': true,
          'verified': false,
        };
      } else if (response.statusCode == 202) {
        // Successful login, navigate to the home screen
        Map<String, dynamic> userJson =
            json.decode(await response.stream.bytesToString());

        // Store tokens securely
        await _storage.write(
            key: 'refreshToken', value: userJson['user']['refresh']);
        await _storage.write(
            key: 'accessToken', value: userJson['user']['access']);
        await _storage.write(key: 'userName', value: userJson['user']['name']);
        await _storage.write(
            key: 'userEmail', value: userJson['user']['email']);

        return {
          'success': true,
          'verified': true,
        };
      } else if (response.statusCode == 400 || response.statusCode == 401) {
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

  Future<Map<String, dynamic>> signUp(
      String? name, String? email, String? password) async {
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request(
      'POST',
      Uri.parse('$kUrl/auth/register'),
    );
    request.body = json.encode({
      "name": name,
      "email": email,
      "password": password,
    });
    request.headers.addAll(headers);

    try {
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 201) {
        // Success! User registered
        return {'success': true};
      } else {
        // Handle errors
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
      }
    } catch (e) {
      if (e is SocketException) {
        // Handle network error
        return {
          'success': false,
          'error': 'Network error: Failed to connect to the network.',
        };
      } else {
        // Handle other exceptions
        return {
          'success': false,
          'error': 'An error occurred: $e',
        };
      }
    }
  }

  Future<Map<String, dynamic>> verifyOtp(String email, String otp) async {
    var headers = {'Content-Type': 'application/json'};
    var encodedEmail = Uri.encodeComponent(email);
    var apiUrl = '$kUrl/auth/verifyemail/$encodedEmail';

    var request = http.Request('POST', Uri.parse(apiUrl));
    request.body = json.encode({"code": otp});
    request.headers.addAll(headers);

    try {
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 202) {
        Map<String, dynamic> userJson =
            json.decode(await response.stream.bytesToString());
        // Successful verification
        // Handle saving tokens and user data here
        // Store tokens securely
        await _storage.write(
            key: 'refreshToken', value: userJson['user']['refresh']);
        await _storage.write(
            key: 'accessToken', value: userJson['user']['access']);
        await _storage.write(key: 'userName', value: userJson['user']['name']);
        await _storage.write(
            key: 'userEmail', value: userJson['user']['email']);
        return {'success': true};
      } else if (response.statusCode == 400 || response.statusCode == 404) {
        // Verification failed
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
          'error': 'An error occurred. Please try again.'
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

  Future<Map<String, dynamic>> resendOtp(String email) async {
    var headers = {'Content-Type': 'application/json'};
    var apiUrl = '$kUrl/auth/resendverify/$email';

    var request = http.Request('GET', Uri.parse(apiUrl));
    request.headers.addAll(headers);

    try {
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        // Successful resend
        String responseBody = await response.stream.bytesToString();
        Map<String, dynamic> responseJson = json.decode(responseBody);
        String message = responseJson['msg'];
        return {'success': true, 'message': message};
      } else {
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

  Future<void> clearUserData() async {
    await _storage.delete(key: 'refreshToken');
    await _storage.delete(key: 'accessToken');
    await _storage.delete(key: 'userName');
    await _storage.delete(key: 'userEmail');
  }

  Future<bool> checkIfUserDataExists() async {
    final refreshToken = await _storage.read(key: 'refreshToken');
    final accessToken = await _storage.read(key: 'accessToken');
    final userName = await _storage.read(key: 'userName');
    final userEmail = await _storage.read(key: 'userEmail');

    // Check if all required keys exist
    return refreshToken != null &&
        accessToken != null &&
        userName != null &&
        userEmail != null;
  }
}
