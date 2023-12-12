// lib\api\api.dart


import 'package:mhfatha/settings/imports.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;



class Api {
  static const String baseUrl = 'https://mhfatha.net/api';

  // /* -------------------------------------------------------------------------- */
  // /* -------------------------------- Login api ------------------------------- */
  // /* -------------------------------------------------------------------------- */

  Future<bool> loginUser(AuthProvider authProvider, String emailOrMobile, String password) async {
    final url = Uri.parse('$baseUrl/login-post');

    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, String>{
          'email_or_mobile': emailOrMobile,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        print('Response Data: $jsonResponse'); // Print the entire response for debugging
        String token = jsonResponse['token'];
        Map<String, dynamic> user = jsonResponse['user'];

        // Use the AuthProvider to store the token and user information
    authProvider.saveAuthData(token, user);

        return jsonResponse['success'];
      } else {
        throw Exception('Failed to login. Server responded with status code: ${response.statusCode} and error message: ${response.body}');
      }
      
    } catch (e) {
      print('Error during login: $e');
      return false;
    }
  }

  // /* -------------------------------------------------------------------------- */
  // /* ---------------------------- get nearBy stores --------------------------- */
  // /* -------------------------------------------------------------------------- */
  Future<String> sendLocation(AuthProvider authProvider, double userLatitude, double userLongitude, String language) async {
    final url = Uri.parse('$baseUrl/nearby');

    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${authProvider.token}',
        },
        body: jsonEncode(<String, dynamic>{
          'user_latitude': userLatitude,
          'user_longitude': userLongitude,
          'lang':language
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        print('Response Data: $jsonResponse');

        // Convert the response data to a JSON string
        String jsonString = jsonEncode(jsonResponse);

        return jsonString;
      } else {
        throw Exception('Failed to send location. Server responded with status code: ${response.statusCode} and error message: ${response.body}');
      }
    } catch (e) {
      print('Error during sending location: $e');
      return ''; // Return an empty string or handle the error as needed
    }
  }




  Future<String> getStoreDetails(AuthProvider authProvider, int storeId) async {
    final url = Uri.parse('$baseUrl/store');

    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${authProvider.token}',
        },
        body: jsonEncode(<String, dynamic>{
          'id': storeId,
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        // print('Store Details Response Data: $jsonResponse');

        // Convert the response data to a JSON string
        String jsonString = jsonEncode(jsonResponse);
        // print(jsonString);
        return jsonString;
      } else {
        throw Exception('Failed to get store details. Server responded with status code: ${response.statusCode} and error message: ${response.body}');
      }
    } catch (e) {
      print('Error getting store details: $e');
      return ''; // Return an empty string or handle the error as needed
    }
  }








}
