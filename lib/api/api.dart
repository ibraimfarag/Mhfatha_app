// lib\api\api.dart

import 'dart:io';

import 'package:flutter/services.dart';
import 'package:mhfatha/settings/imports.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

class Api {
  static const String baseUrl = AppVariables.ApiUrl;
  final client = http.Client();

  Future<String> checkInternetConnection(BuildContext context) async {
    try {
      final response = await client.get(Uri.parse('$baseUrl/check-network'));

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);

        // You can add your logic here when the internet is connected
        return 'Online';
      } else {
        return 'Offline';
      }
    } catch (e) {
      return 'Offline';
    }
  }

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
      final response = await client.post(
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
        // Print the entire response for debugging
        String token = jsonResponse['token'];
        Map<String, dynamic> user = jsonResponse['user'];

        // Use the AuthProvider to store the token and user information
        authProvider.saveAuthData(token, user);
        Navigator.of(context, rootNavigator: true).pop();

        return jsonResponse['success'];
      } else {
        Navigator.of(context, rootNavigator: true).pop();

        final jsonResponse = jsonDecode(response.body);

        String errorMessage = jsonResponse['error'] ?? 'Unknown error';

        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: isEnglish ? 'Error' : 'خطأ',
          text: errorMessage,
        );

        throw Exception(
            'Failed to login. Server responded with status code: ${response.statusCode} and error message: ${response.body}');
      }
    } catch (e) {
      return false;
    }
  }

  Future<String> sendLocation(AuthProvider authProvider, double userLatitude,
      double userLongitude, String language) async {
    final url = Uri.parse('$baseUrl/nearby');

    try {
      final response = await client.post(
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

        // Convert the response data to a JSON string
        String jsonString = jsonEncode(jsonResponse);

        return jsonString;
      } else {
        throw Exception(
            'Failed to send location. Server responded with status code: ${response.statusCode} and error message: ${response.body}');
      }
    } catch (e) {
      return ''; // Return an empty string or handle the error as needed
    }
  }

  Future<String> getStoreDetails(
      BuildContext context,
      AuthProvider authProvider,
      int storeId,
      double latitude,
      double longitude) async {
    final url = Uri.parse('$baseUrl/store');
    bool isEnglish = Provider.of<AppState>(context, listen: false).isEnglish;
    String lang = Provider.of<AppState>(context, listen: false).display;
    try {
      final response = await client.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${authProvider.token}',
        },
        body: jsonEncode(<String, dynamic>{
          'id': storeId,
          'user_latitude': latitude,
          'user_longitude': longitude,
          'lang': lang
        }),
      );
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);

        // Convert the response data to a JSON string
        String jsonString = jsonEncode(jsonResponse);

        return jsonString;
      } else {
        throw Exception(
            'Failed to get store details. Server responded with status code: ${response.statusCode} and error message: ${response.body}');
      }
    } catch (e) {
      return ''; // Return an empty string or handle the error as needed
    }
  }

  Future<String> getStoreDetailsByQR(
      AuthProvider authProvider, String encryptedStoreID, String lang) async {
    final url = Uri.parse('$baseUrl/store-qr');

    try {
      final response = await client.post(
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

        // Convert the response data to a JSON string
        String jsonString = jsonEncode(jsonResponse);
        return jsonString;
      } else if (response.statusCode == 404) {
        final jsonResponse = jsonDecode(response.body);

        // Convert the response data to a JSON string
        String jsonString = jsonEncode(jsonResponse);

        // print('responseeeeeee : $jsonString');
        return jsonString;
      } else {
        throw Exception(
            'Failed to get store details by QR. Server responded with status code: ${response.statusCode} and error message: ${response.body}');
      }
    } catch (e) {
      return ''; // Return an empty string or handle the error as needed
    }
  }

  Future scannedstore(AuthProvider authProvider, int userID, int storeID,
      int discountID, double totalPayment, String lang) async {
    final url = Uri.parse('$baseUrl/discounts-post');

    try {
      final response = await client.post(
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
        return response; // Include jsonResponse with success flag
      } else {
        return response; // Include error message with failure flag
      }
    } catch (e) {
      return false; // Include error message with failure flag
    }
  }

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
    required String confirmPassword,
    required int isVendor,
    // File? imageFile,
    String? otp,
  }) async {
    final url = Uri.parse('$baseUrl/register-post');
    bool isEnglish = Provider.of<AppState>(context, listen: false).isEnglish;
    _showLoadingDialog(context);
    OtpFieldController otpController = OtpFieldController();
    String enteredOtp = otp ?? '';

    try {
      Map<String, dynamic> data = {
        'lang': lang,
        'first_name': firstName,
        'last_name': lastName,
        'gender': gender,
        'birthday': birthday,
        'region': region,
        'mobile': mobile,
        'email': email,
        'password': password,
        'password_confirmation': confirmPassword,
        'is_vendor': isVendor.toString(),
        'otp': enteredOtp,
      };

      // Convert map to JSON string
      String jsonBody = jsonEncode(data);

      // Setup headers for JSON content type
      Map<String, String> headers = {'Content-Type': 'application/json'};

      final response = await client.post(url, headers: headers, body: jsonBody);

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        print(jsonResponse);
        if (jsonResponse['OTP'] == true) {
          // Display OTP dialog
          // Ensure correct usage of the OTP dialog here
          return _handleOTPVerification(
              context, data, url, jsonResponse, isEnglish, otpController);
        }
        return jsonResponse['success'] as bool;
      } else {
        // Handle errors
        _handleRegistrationError(context, response, isEnglish);
        return false;
      }
    } catch (e) {
      // Navigator.of(context, rootNavigator: true)
      //     .pop(); // Ensure dialogs are closed in case of an error
      _showError(context, isEnglish, e.toString()); // Display error
      return false;
    }
  }

  void _showError(BuildContext context, bool isEnglish, String errorMessage) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.error,
      title: isEnglish ? 'Error' : 'خطأ',
      text: errorMessage,
    );
  }

  void _handleRegistrationError(
      BuildContext context, http.Response response, bool isEnglish) {
    final jsonResponse = jsonDecode(response.body);
    List<String> errorMessages = _extractErrorMessages(jsonResponse);
    Navigator.of(context, rootNavigator: true).pop();

    QuickAlert.show(
      context: context,
      type: QuickAlertType.error,
      title: isEnglish ? 'Registration Failed' : 'خطأ اثناء التسجيل',
      widget: Column(
        crossAxisAlignment:
            isEnglish ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: errorMessages.map((message) => Text(message)).toList(),
      ),
    );
  }

  List<String> _extractErrorMessages(Map<String, dynamic> jsonResponse) {
    List<String> errorMessages = [];
    dynamic messages = jsonResponse['messages'];

    if (messages is Map<String, dynamic>) {
      messages.forEach((field, errors) {
        if (errors is List) {
          errors.forEach((error) {
            errorMessages.add('$error');
          });
        }
      });
    } else if (messages is List<dynamic>) {
      errorMessages.addAll(messages.map((error) => '$error'));
    }
    return errorMessages;
  }

  Future<bool> _handleOTPVerification(
      BuildContext context,
      Map<String, dynamic> data,
      Uri url,
      Map<String, dynamic> jsonResponse,
      bool isEnglish,
      OtpFieldController otpController) async {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.custom,
      showCancelBtn: true,
      barrierDismissible: true,
      confirmBtnText: isEnglish ? 'Verify' : 'تفعيل',
      cancelBtnText: isEnglish ? 'Cancel' : 'الغاء',
      customAsset: 'images/MeG.gif',
      widget: Column(
        children: [
          Text(jsonResponse['message']),
          OTPTextField(
            controller: otpController,
            length: 5,
            width: MediaQuery.of(context).size.width,
            fieldWidth: 20,
            style: TextStyle(fontSize: 17),
            textFieldAlignment: MainAxisAlignment.spaceAround,
            fieldStyle: FieldStyle.underline,
            onCompleted: (pin) {
              print("OTP Entered: $pin"); // Debug to check the entered OTP
              data['otp'] = pin; // Update OTP in data
            },
          ),
        ],
      ),
      onConfirmBtnTap: () async {
        // Properly handle async operation
        bool result = await _verifyOTP(context, data, url, isEnglish);
        if (result) {
          print("OTP Verification Success");
          QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            title: 'Success',
            text: 'OTP verification successful.',
          );
        } else {
          print("OTP Verification Failed");
          QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            title: 'Error',
            text: 'OTP verification failed. Please try again.',
          );
        }
      },
    );
    return false;
  }

  Future<bool> _verifyOTP(BuildContext context, Map<String, dynamic> data,
      Uri url, bool isEnglish) async {
    try {
      String jsonBody = jsonEncode(data);
      Map<String, String> headers = {'Content-Type': 'application/json'};
      final response = await client.post(url, headers: headers, body: jsonBody);
      return _processOTPResponse(context, response, isEnglish);
    } catch (e) {
      print("Error during OTP verification: $e");
      return false;
    }
  }

  Future<bool> _processOTPResponse(
      BuildContext context, http.Response response, bool isEnglish) async {
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      Navigator.of(context, rootNavigator: true).pop(); // Close the OTP dialog
      QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        customAsset: 'images/success.gif',
        text: jsonResponse['message'] ?? '',
        onConfirmBtnTap: () {
          Navigator.pushNamed(context, '/login');
        },
        confirmBtnColor: Color(0xFF0D2750),
      );
      return true;
    } else {
      final jsonResponse = jsonDecode(response.body);
      final MeC = jsonResponse['error'];
      Navigator.pop(context); // Close the OTP dialog

      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Oops...',
        text: '$MeC',
      );
      return false;
    }
  }

  Future<String> searchStores(
      AuthProvider authProvider, String query, String lang) async {
    final url = Uri.parse('$baseUrl/stores/search-by-name');

    try {
      final response = await client.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${authProvider.token}',
        },
        body: jsonEncode(<String, dynamic>{
          'search_term': query,
          'lang': lang,
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);

        // Convert the response data to a JSON string
        String jsonString = jsonEncode(jsonResponse);

        return jsonString;
      } else {
        throw Exception(
            'Failed to search stores. Server responded with status code: ${response.statusCode} and error message: ${response.body}');
      }
    } catch (e) {
      return ''; // Return an empty string or handle the error as needed
    }
  }

  Future<String> getUserDiscounts(
    BuildContext context,
  ) async {
    final url = Uri.parse('$baseUrl/user-discounts');
    bool isEnglish = Provider.of<AppState>(context, listen: false).isEnglish;
    String lang = Provider.of<AppState>(context, listen: false).display;
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    try {
      final response = await client.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${authProvider.token}',
        },
        body: jsonEncode(<String, dynamic>{
          'lang': lang,
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        // Convert the response data to a JSON string
        String jsonString = jsonEncode(jsonResponse);

        return jsonString;
      } else {
        throw Exception(
            'Failed to get user discounts. Server responded with status code: ${response.statusCode} and error message: ${response.body}');
      }
    } catch (e) {
      return ''; // Return an empty string or handle the error as needed
    }
  }

  Future<String> fetchVendorStores(BuildContext context) async {
    final url = Uri.parse('$baseUrl/vendor/stores');
    bool isEnglish = Provider.of<AppState>(context, listen: false).isEnglish;
    String lang = Provider.of<AppState>(context, listen: false).display;
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);

    // Show loading indicator asynchronously after the current build
    await Future.delayed(Duration.zero);
    _showLoadingDialog(context);

    try {
      final response = await client.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${authProvider.token}',
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        // Convert the response data to a JSON string
        String jsonString = jsonEncode(jsonResponse);

        // Hide loading indicator
        Navigator.of(context).pop();

        return jsonString;
      } else {
        // Hide loading indicator
        Navigator.of(context).pop();
        throw Exception(
            'Failed to get user discounts. Server responded with status code: ${response.statusCode} and error message: ${response.body}');
      }
    } catch (e) {
      // Hide loading indicator
      Navigator.of(context).pop();
      return ''; // Return an empty string or handle the error as needed
    }
  }

  Future<Map<String, dynamic>> getRegionsAndCities(BuildContext context) async {
    final url = Uri.parse('$baseUrl/regions');

    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);

    try {
      final response = await client.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        // Check if 'regions' key exists in the JSON response
        if (jsonResponse.containsKey('regions')) {
          return jsonResponse;
        } else {
          throw Exception('Invalid response format. Missing "regions" key.');
        }
      } else {
        throw Exception(
            'Failed to fetch regions and cities. Server responded with status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception(
          'Failed to fetch regions and cities. Check your internet connection.');
    }
  }

  Future<Map<String, dynamic>> getcategories(BuildContext context) async {
    final url = Uri.parse('$baseUrl/categories');

    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);

    try {
      final response = await client.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        // Check if 'regions' key exists in the JSON response
        if (jsonResponse.containsKey('Category')) {
          return jsonResponse;
        } else {
          throw Exception('Invalid response format. Missing "categories" key.');
        }
      } else {
        throw Exception(
            'Failed to fetch regions and cities. Server responded with status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception(
          'Failed to fetch regions and cities. Check your internet connection.');
    }
  }

  Future<Map<String, dynamic>> getRegionsWithCities(
      BuildContext context) async {
    final url = Uri.parse('$baseUrl/registerregions');

    try {
      final response = await client.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        // Check if 'regions' key exists in the JSON response
        if (jsonResponse.containsKey('regions')) {
          return jsonResponse;
        } else {
          throw Exception('Invalid response format. Missing "regions" key.');
        }
      } else {
        throw Exception(
            'Failed to fetch regions and cities. Server responded with status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception(
          'Failed to fetch regions and cities. Check your internet connection.');
    }
  }

  Future<Map<String, dynamic>> getUserDetails(BuildContext context) async {
    final url = Uri.parse('$baseUrl/user');
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);

    try {
      final response = await client.get(
        url,
        headers: <String, String>{
          'Authorization': 'Bearer ${authProvider.token}',
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);

        if (jsonResponse['user'] is Map<String, dynamic>) {
          // Check if 'user' is a Map<String, dynamic>
          Map<String, dynamic> userData = jsonResponse['user'];
          return userData;
        } else {
          throw Exception('Invalid user data format received from the server.');
        }
      } else {
        throw Exception(
            'Failed to get user details. Server responded with status code: ${response.statusCode} and error message: ${response.body}');
      }
    } catch (e) {
      throw Exception(
          'Failed to get user details. Check your internet connection.');
    }
  }

  Future<bool> updateUserProfile({
    required String firstName,
    required String lastName,
    required String birthday,
    required String region,
    required String mobile,
    required String email,
    String? otp,
    // File? imageFile,
    required BuildContext context,
  }) async {
    final url = Uri.parse('$baseUrl/auth/update');
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    String lang = Provider.of<AppState>(context, listen: false).display;
    bool isEnglish = Provider.of<AppState>(context, listen: false).isEnglish;
    OtpFieldController otpController = OtpFieldController();
    String enteredOtp = '';
    try {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.loading,
        customAsset: 'images/loading.gif',
        title: isEnglish ? 'Loading' : 'انتظر قليلاً',
        text: isEnglish ? 'Fetching your data' : 'جاري تحميل البيانات',
      );

      final request = http.MultipartRequest('POST', url)
        ..headers['Content-Type'] = 'application/json'
        ..headers['Authorization'] = 'Bearer ${authProvider.token}'
        ..fields['lang'] = lang
        ..fields['first_name'] = firstName
        ..fields['last_name'] = lastName
        ..fields['birthday'] = birthday
        ..fields['region'] = region
        ..fields['mobile'] = mobile
        ..fields['otp'] = enteredOtp
        ..fields['email'] = email;

      // if (imageFile != null) {
      //   // Use the correct field name for the file, in this case, 'photo'
      //   request.files
      //       .add(await http.MultipartFile.fromPath('photo', imageFile.path));
      // }

      final response = await client.send(request);

      if (response.statusCode == 200) {
        Navigator.pop(context);
        final jsonResponse = jsonDecode(await response.stream.bytesToString());
        final MessageC = jsonResponse['message'];
        await authProvider.updateUserData(context);

        if (jsonResponse['OTP'] == true) {
          // Display dialog if 'OTP' is true
          QuickAlert.show(
            context: context,
            type: QuickAlertType.custom,
            showCancelBtn: true,
            barrierDismissible: true,
            confirmBtnText: isEnglish ? 'verify' : 'تفعيل',
            cancelBtnText: isEnglish ? 'cancel' : 'الغاء',
            customAsset: 'images/MeG.gif',
            widget: Column(
              children: [
                Text(jsonResponse['error']),
                OTPTextField(
                  controller: otpController,
                  length: 5,
                  width: MediaQuery.of(context).size.width,
                  fieldWidth: 20,
                  style: TextStyle(fontSize: 17),
                  textFieldAlignment: MainAxisAlignment.spaceAround,
                  fieldStyle: FieldStyle.underline,
                  onCompleted: (pin) {
                    enteredOtp = pin;
                  },
                ),
              ],
            ),
            onConfirmBtnTap: () async {
              try {
                QuickAlert.show(
                  context: context,
                  type: QuickAlertType.loading,
                  customAsset: 'images/loading.gif',
                  title: isEnglish ? 'Loading' : 'انتظر قليلاً',
                  text:
                      isEnglish ? 'Fetching your data' : 'جاري تحميل البيانات',
                );
                final request = http.MultipartRequest('POST', url)
                  ..headers['Content-Type'] = 'application/json'
                  ..headers['Authorization'] = 'Bearer ${authProvider.token}'
                  ..fields['lang'] = lang
                  ..fields['first_name'] = firstName
                  ..fields['last_name'] = lastName
                  ..fields['birthday'] = birthday
                  ..fields['region'] = region
                  ..fields['mobile'] = mobile
                  ..fields['otp'] = enteredOtp
                  ..fields['email'] = email;

                // if (imageFile != null) {
                //   // Use the correct field name for the file, in this case, 'photo'
                //   request.files.add(await http.MultipartFile.fromPath(
                //       'photo', imageFile.path));
                // }

                final response = await request.send();

                if (response.statusCode == 200) {
                  final jsonResponse =
                      jsonDecode(await response.stream.bytesToString());
                  final MeC = jsonResponse['message'];
                  Navigator.pop(context);
                  Navigator.pop(context);
                  QuickAlert.show(
                    context: context,
                    type: QuickAlertType.success,
                    customAsset: 'images/success.gif',
                    confirmBtnColor: Color(0xFF0D2750),
                    text: '$MeC',
                  );
                  await authProvider.updateUserData(context);
                } else {
                  final jsonResponse =
                      jsonDecode(await response.stream.bytesToString());
                  final MeC = jsonResponse['error'];
                  Navigator.pop(context);

                  QuickAlert.show(
                    context: context,
                    type: QuickAlertType.error,
                    title: 'Oops...',
                    text: '$MeC',
                  );
                }
              } catch (e) {}
            },
          );
        } else {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            customAsset: 'images/success.gif',
            text: '$MessageC',
            confirmBtnColor: Color(0xFF0D2750),
          );
        }

        return jsonResponse['success'];
      } else {
        final jsonResponse = jsonDecode(await response.stream.bytesToString());
        throw Exception(
            'Failed to update user profile. Server responded with status code: ${response.statusCode} and error message: $jsonResponse');
      }
    } catch (e) {
      return false;
    }
  }

  Future<Map<String, dynamic>> filterStores(
    BuildContext context,
    String region,
    String category,
    String userLatitude,
    String userLongitude,
  ) async {
    final url = Uri.parse('$baseUrl/filter-stores');
    String lang = Provider.of<AppState>(context, listen: false).display;
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    bool isEnglish = Provider.of<AppState>(context, listen: false).isEnglish;

    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      final response = await client.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${authProvider.token}',
        },
        body: jsonEncode(<String, dynamic>{
          'lang': lang,
          'region': region,
          'category': category,
          'user_latitude': userLatitude,
          'user_longitude': userLongitude,
        }),
      );

      // Close loading indicator
      Navigator.of(context).pop();

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return jsonResponse;
      } else {
        throw Exception(
            'Failed to filter stores. Server responded with status code: ${response.statusCode}');
      }
    } catch (e) {
      // Close loading indicator
      Navigator.of(context).pop();

      throw Exception(
          'Failed to filter stores. Check your internet connection.');
    }
  }

  Future<String> changePassword(BuildContext context, String oldPassword,
      String newPassword, String confirmationNewPassword) async {
    final url = Uri.parse('$baseUrl/auth/changepassword');
    String lang = Provider.of<AppState>(context, listen: false).display;
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);

    try {
      final response = await client.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${authProvider.token}',
        },
        body: jsonEncode(<String, dynamic>{
          'lang': lang,
          'old_password': oldPassword,
          'new_password': newPassword,
          'new_password_confirmation': confirmationNewPassword,
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);

        String message = jsonResponse['message'];
        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          customAsset: 'images/success.gif',
          text: message,
          confirmBtnColor: Color(0xFF0D2750),
        );
        return message;
      } else {
        final jsonResponse = jsonDecode(response.body);

        String message = jsonResponse['error'];
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          text: message,
        );
        return message;
      }
    } catch (e) {
      throw Exception(
          'Failed to change password. Check your internet connection.');
    }
  }

  Future<Map<String, dynamic>> restPassword(
      BuildContext context, String emailOrMobile,
      [String? otp,
      String? new_password,
      String? new_password_confirmation]) async {
    final url = Uri.parse('$baseUrl/auth/resetPassword');
    String lang = Provider.of<AppState>(context, listen: false).display;
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);

    try {
      final response = await client.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${authProvider.token}',
        },
        body: jsonEncode(<String, dynamic>{
          'lang': lang,
          'email_or_mobile': emailOrMobile,
          'otp': otp,
          'new_password': new_password,
          'new_password_confirmation': new_password_confirmation
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return jsonResponse;
      } else {
        final jsonResponse = jsonDecode(response.body);
        String message = jsonResponse['error'];
        QuickAlert.show(
          context: context,
          title: '',
          type: QuickAlertType.error,
          text: message,
        );
        // Returning the message in case of error
        return {'error': message};
      }
    } catch (e) {
      throw Exception(
          'Failed to change password. Check your internet connection.');
    }
  }

  Future<void> updateDeviceInfo(
    BuildContext context,
    String deviceToken,
    String platform,
    String platformVersion,
    String platformDevice,
  ) async {
    final url = Uri.parse('$baseUrl/update-device-info');
    String lang = Provider.of<AppState>(context, listen: false).display;
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);

    try {
      final response = await client.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${authProvider.token}',
        },
        body: jsonEncode(<String, dynamic>{
          'device_token': deviceToken,
          'platform': platform,
          'platform_version': platformVersion,
          'platform_device': platformDevice,
          'lang': lang
        }),
      );

      if (response.statusCode == 200) {
        // print('Device info updated successfully.');
      } else {
        // print(
        //     'Failed to update device info. Server responded with status code: ${response.statusCode}');
      }
    } catch (e) {
      // print('Failed to update device info. Error: $e');
    }
  }

  Future<Map<String, dynamic>> validateToken(BuildContext context) async {
    final url = Uri.parse('$baseUrl/validateToken');
    String lang = Provider.of<AppState>(context, listen: false).display;
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);

    try {
      final response = await client.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${authProvider.token}',
        },
        body: jsonEncode(<String, dynamic>{
          'lang': lang,
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        // print(jsonResponse);
        return jsonResponse; // Return the entire response
      } else {
        // print(
        //     'Failed to update device info. Server responded with status code: ${response.statusCode}');
        // Throw an exception if the response status code is not 200
        throw Exception(
            'Failed to update device info. Server responded with status code: ${response.statusCode}');
      }
    } catch (e) {
      // Print and re-throw any caught exceptions
      // print('Failed to update device info. Error: $e');
      throw e;
    }
  }

  Future<Map<String, dynamic>> checkVersion(String platform) async {
    final url = Uri.parse('$baseUrl/checkversion');

    try {
      final http.Response response = await client.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, String>{
          'platform': platform,
        }),
      );

      if (response.statusCode == 200) {
        // Parse the JSON response
        final Map<String, dynamic> data = jsonDecode(response.body);
        // Extract version and required fields
        String version = data['version'];
        bool required = data['required'] == 1 ? true : false;
        return {
          'version': version,
          'required': required,
        };
      } else {
        // If the request was not successful, throw an error
        throw Exception('Failed to check version: ${response.statusCode}');
      }
    } catch (e) {
      // If an error occurs during the request, throw an error
      throw Exception('Failed to check version: $e');
    }
  }

  Future<Map<String, dynamic>> UserRequestActions(
      BuildContext context, String action) async {
    final url = Uri.parse('$baseUrl/auth/updateAuthUserStatus');
    String lang = Provider.of<AppState>(context, listen: false).display;
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);

    // Show loading dialog
    _showLoadingDialog(context);

    try {
      final http.Response response = await client.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${authProvider.token}',
        },
        body: jsonEncode(<String, String>{
          'lang': lang,
          'action': action,
        }),
      );

      // Close loading dialog

      if (response.statusCode == 200) {
        // Parse the JSON response
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        final Map<String, dynamic> data = jsonDecode(response.body);
        // print(data);
        return data;
      } else {
        // If the request was not successful, throw an error
        throw Exception('Failed to perform action: ${response.statusCode}');
      }
    } catch (e) {
      // If an error occurs during the request, throw an error
      throw Exception('Failed to perform action: $e');
    }
  }

  Future<Map<String, dynamic>> tremsRequestActions(
      BuildContext context, String user_type) async {
    final url = Uri.parse('$baseUrl/TermsAndConditions');
    String lang = Provider.of<AppState>(context, listen: false).display;
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);

    // Show loading dialog
    _showLoadingDialog(context);

    try {
      final http.Response response = await client.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, String>{
          // 'lang': lang,
          'lang': lang,
          'user_type': user_type,
        }),
      );

      // Close loading dialog

      if (response.statusCode == 200) {
        Navigator.of(context).pop();
        // Parse the JSON response correctly
        final Map<String, dynamic> data = jsonDecode(response.body);
        return data;
      } else {
        // If the request was not successful, throw an error
        throw Exception('Failed to perform action: ${response.statusCode}');
      }
    } catch (e) {
      // If an error occurs during the request, throw an error
      throw Exception('Failed to perform action: $e');
    }
  }
}

void _showLoadingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false, // Prevent dialog from closing on outside tap
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Center(
          child:
              CircularProgressIndicator(), // Replace QuickAlert with CircularProgressIndicator
        ),
      );
    },
  );
}


// void _showLoadingDialog(BuildContext context) {
//   bool isEnglish = Provider.of<AppState>(context, listen: false).isEnglish;

//   QuickAlert.show(
//     context: context,
//     type: QuickAlertType.loading,
                                  //  customAsset: 'images/loading.gif',
//     // customAsset:,
//     title: isEnglish ? 'please wait' : 'يرجى الانتظار...',
//     text: isEnglish ? 'loading your data' : 'جاري تحميل البيانات',
//   );
// }
