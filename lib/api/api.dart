// lib\api\api.dart


import 'dart:io';

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


  // /* -------------------------------------------------------------------------- */
  // /* ---------------------------- Store QR Code API -------------------------- */
  // /* -------------------------------------------------------------------------- */

  Future<String> getStoreDetailsByQR(AuthProvider authProvider, String encryptedStoreID, String lang) async {
    final url = Uri.parse('$baseUrl/store-qr');

    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${authProvider.token}',
        },
        body: jsonEncode(<String, dynamic>{
          'encryptedStoreID': encryptedStoreID,
          'lang': lang,
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        // print('Store QR Response Data: $jsonResponse');

        // Convert the response data to a JSON string
        String jsonString = jsonEncode(jsonResponse);

        return jsonString;
      } else {
        throw Exception('Failed to get store details by QR. Server responded with status code: ${response.statusCode} and error message: ${response.body}');
      }
    } catch (e) {
      print('Error getting store details by QR: $e');
      return ''; // Return an empty string or handle the error as needed
    }
  }




Future scannedstore(AuthProvider authProvider, int userID, int storeID, int discountID, double totalPayment,String lang) async {
  final url = Uri.parse('$baseUrl/discounts-post');

  try {
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${authProvider.token}',
      },
      body: jsonEncode(<String, dynamic>{
        'user_id': userID,
        'store_id': storeID,
        'discount_id': discountID,
        'total_payment': totalPayment,
        'lang': lang,
      }),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      print('Discount Details Response Data: $jsonResponse');
      return response; // Include jsonResponse with success flag
    } else {
      print('Failed to post discount details. Server responded with status code: ${response.statusCode} and error message: ${response.body}');
      return  response; // Include error message with failure flag
    }
  } catch (e) {
    print('Error during posting discount details: $e');
      return  false; // Include error message with failure flag
  }
}

  // /* -------------------------------------------------------------------------- */
  // /* ------------------------------ User Registration ------------------------ */
  // /* -------------------------------------------------------------------------- */
Future<bool> registerUser({
  required BuildContext context,
  required String lang,
  required String firstName,
  required String lastName,
  required String gender,
  required String birthday,
  required String region,
  required String mobile,
  required String email,
  required String password,
  required String confirmPasswordController,
  required int isVendor,
  required File imageFile
}) async {
  final url = Uri.parse('$baseUrl/register-post');
bool isEnglish = Provider.of<AppState>(context, listen: false).isEnglish;

  try {
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        'lang': lang,
        'first_name': firstName,
        'last_name': lastName,
        'gender': gender,
        'birthday': birthday,
        'region': region,
        'mobile': mobile,
        'email': email,
        'password': password,
        'password_confirmation': password,
        'is_vendor': isVendor,
      }),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      print('Registration Response Data: $jsonResponse');

      if (jsonResponse['success'] == false) {
        // Extract and display individual error messages
        List<String> errorMessages = [];
        Map<String, dynamic> messages = jsonResponse['messages'];
        messages.forEach((field, errors) {
          errors.forEach((error) {
            errorMessages.add(error);
          });
        });

        // Show dialog for unsuccessful registration with individual error messages
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Registration Failed'),
              content: Column(
 crossAxisAlignment: isEnglish
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.end,                children: errorMessages.map((error) => Text(error)).toList(),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }

      return jsonResponse['success'];
    } else {
            final jsonResponse = jsonDecode(response.body);

  List<String> errorMessages = [];
        dynamic messages = jsonResponse['messages'];

 if (messages is Map<String, dynamic>) {
          // Handle the case where 'messages' is a map
          messages.forEach((field, errors) {
            if (errors is List) {
              errors.forEach((error) {
                errorMessages.add('$error');
              });
            }
          });
        } else if (messages is List<dynamic>) {
          // Handle the case where 'messages' is a list
          errorMessages.addAll(messages.map((error) => '$error'));
        }


        // Show dialog for unsuccessful registration
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(isEnglish
              ? 'Registration Failed':'خطأ اثناء التسجيل',textAlign: isEnglish?TextAlign.left:TextAlign.right),
              content: Column(
                crossAxisAlignment: isEnglish
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.end,   
                mainAxisSize: MainAxisSize.min,
                children: errorMessages.map((message) => Text(message)).toList(),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      
      throw Exception('Failed to register. Server responded with status code: ${response.statusCode} and error message: ${response.body}');
    }
  } catch (e) {
    print('Error during registration: $e');
    return false;
  }
}


}
