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

  Future<bool> loginUser(
    BuildContext context,
    AuthProvider authProvider,
    String emailOrMobile,
    String password,
  ) async {
    final url = Uri.parse('$baseUrl/login-post');
    _showLoadingDialog(context);
    bool isEnglish = Provider.of<AppState>(context, listen: false).isEnglish;
    String lang = Provider.of<AppState>(context, listen: false).display;
    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, String>{
          'email_or_mobile': emailOrMobile,
          'password': password,
          "lang": lang,
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        print(
            'Response Data: $jsonResponse'); // Print the entire response for debugging
        String token = jsonResponse['token'];
        Map<String, dynamic> user = jsonResponse['user'];

        // Use the AuthProvider to store the token and user information
        authProvider.saveAuthData(token, user);
        Navigator.of(context, rootNavigator: true).pop();

        return jsonResponse['success'];
      } else {
        Navigator.of(context, rootNavigator: true).pop();

        final jsonResponse = jsonDecode(response.body);

        print('Error during login: ${response.body}');
        String errorMessage = jsonResponse['error'] ?? 'Unknown error';

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(isEnglish ? 'Error' : 'خطأ',
                  textAlign: isEnglish ? TextAlign.left : TextAlign.right),
              content: Text(errorMessage,
                  textAlign: isEnglish ? TextAlign.left : TextAlign.right),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK',
                      textAlign: isEnglish ? TextAlign.left : TextAlign.right),
                ),
              ],
            );
          },
        );

        print('Error during login: ${response.body}');
        throw Exception(
            'Failed to login. Server responded with status code: ${response.statusCode} and error message: ${response.body}');
      }
    } catch (e) {
      print('Error during login: $e');
      return false;
    }
  }

  // /* -------------------------------------------------------------------------- */
  // /* ---------------------------- get nearBy stores --------------------------- */
  // /* -------------------------------------------------------------------------- */
  Future<String> sendLocation(AuthProvider authProvider, double userLatitude,
      double userLongitude, String language) async {
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
          'lang': language
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        print('Response Data: $jsonResponse');

        // Convert the response data to a JSON string
        String jsonString = jsonEncode(jsonResponse);

        return jsonString;
      } else {
        throw Exception(
            'Failed to send location. Server responded with status code: ${response.statusCode} and error message: ${response.body}');
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
        throw Exception(
            'Failed to get store details. Server responded with status code: ${response.statusCode} and error message: ${response.body}');
      }
    } catch (e) {
      print('Error getting store details: $e');
      return ''; // Return an empty string or handle the error as needed
    }
  }

  // /* -------------------------------------------------------------------------- */
  // /* ---------------------------- Store QR Code API -------------------------- */
  // /* -------------------------------------------------------------------------- */

  Future<String> getStoreDetailsByQR(
      AuthProvider authProvider, String encryptedStoreID, String lang) async {
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
        throw Exception(
            'Failed to get store details by QR. Server responded with status code: ${response.statusCode} and error message: ${response.body}');
      }
    } catch (e) {
      print('Error getting store details by QR: $e');
      return ''; // Return an empty string or handle the error as needed
    }
  }

  Future scannedstore(AuthProvider authProvider, int userID, int storeID,
      int discountID, double totalPayment, String lang) async {
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
        print(
            'Failed to post discount details. Server responded with status code: ${response.statusCode} and error message: ${response.body}');
        return response; // Include error message with failure flag
      }
    } catch (e) {
      print('Error during posting discount details: $e');
      return false; // Include error message with failure flag
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
    File? imageFile,
  }) async {
    final url = Uri.parse('$baseUrl/register-post');
    bool isEnglish = Provider.of<AppState>(context, listen: false).isEnglish;
    _showLoadingDialog(context);

    try {
      final request = http.MultipartRequest('POST', url)
        ..fields['lang'] = lang
        ..fields['first_name'] = firstName
        ..fields['last_name'] = lastName
        ..fields['gender'] = gender
        ..fields['birthday'] = birthday
        ..fields['region'] = region
        ..fields['mobile'] = mobile
        ..fields['email'] = email
        ..fields['password'] = password
        ..fields['password_confirmation'] = confirmPasswordController
        ..fields['is_vendor'] = isVendor.toString();
      // Use the correct field name for the file, in this case, 'photo'
      // ..files.add(await http.MultipartFile.fromPath('photo', imageFile.path));
      if (imageFile != null) {
        // Use the correct field name for the file, in this case, 'photo'
        request.files
            .add(await http.MultipartFile.fromPath('photo', imageFile.path));
      }
      final response = await request.send();

if (response.statusCode == 200) {
  final jsonResponse = jsonDecode(await response.stream.bytesToString());
  print('Registration Response Data: $jsonResponse');

 
    // Display a success dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            isEnglish ? 'Registration Successful' : 'تم التسجيل بنجاح',
            textAlign: isEnglish ? TextAlign.left : TextAlign.right,
          ),
          content: Text(
            jsonResponse['message'] ?? '', // Display the message from jsonResponse
            textAlign: isEnglish ? TextAlign.left : TextAlign.right,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                 Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    LoginScreen()));
              },
              child: Text(
                'OK',
                textAlign: isEnglish ? TextAlign.left : TextAlign.right,
              ),
            ),
          ],
        );
      },
    );
  

  return jsonResponse['success'];
}
 else {
        final jsonResponse = jsonDecode(await response.stream.bytesToString());

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
        Navigator.of(context, rootNavigator: true).pop();

        // Show dialog for unsuccessful registration
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                  isEnglish ? 'Registration Failed' : 'خطأ اثناء التسجيل',
                  textAlign: isEnglish ? TextAlign.left : TextAlign.right),
              content: Column(
                crossAxisAlignment: isEnglish
                    ? CrossAxisAlignment.start
                    : CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children:
                    errorMessages.map((message) => Text(message)).toList(),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK',
                      textAlign: isEnglish ? TextAlign.left : TextAlign.right),
                ),
              ],
            );
          },
        );

        throw Exception(
            'Failed to register. Server responded with status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during registration: $e');
      return false;
    }
  }
}

void _showLoadingDialog(BuildContext context) {
  bool isEnglish = Provider.of<AppState>(context, listen: false).isEnglish;

  showDialog(
    context: context,
    barrierDismissible:
        false, // Prevent dismissing the dialog by tapping outside
    builder: (BuildContext context) {
      return AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(), // Show the loading indicator
            SizedBox(height: 16),
            Text(isEnglish
                ? "please wait"
                : "يرجى الانتظار..."), // Add a message to inform the user
          ],
        ),
      );
    },
  );
}
