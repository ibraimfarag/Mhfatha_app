// lib\api\api.dart


import 'package:mhfatha/settings/imports.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;



class Api {
  static const String baseUrl = 'https://mhfatha.net/api';


// /* -------------------------------------------------------------------------- */
// /* -------------------------------- Login api ------------------------------- */
// /* -------------------------------------------------------------------------- */

Future<bool> loginUser(String emailOrMobile, String password) async {
 final url = Uri.parse('$baseUrl/login-post'); // Replace with your login API endpoint

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

    // Check if the response status code is successful
    if (response.statusCode == 200) {
      // If the response is successful, parse the JSON and return true
      final jsonResponse = jsonDecode(response.body);
          AuthProvider().setUserData(jsonResponse);

        return jsonResponse['success'];
    } else {
      // If the response is not successful, throw an exception with the status code and the error message
      throw Exception('Failed to login. Server responded with status code: ${response.statusCode} and error message: ${response.body}');
    }
 } catch (e) {
    // Print the exception message and return false
    print(e);
    return false;
 }
}
}
