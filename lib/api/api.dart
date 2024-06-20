// lib\api\api.dart

import 'dart:io';

import 'package:mhfatha/settings/imports.dart';
import 'package:http_parser/http_parser.dart';

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

  Future<Map<String, String>> support(BuildContext context) async {
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    try {
      // Define headers
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${authProvider.token}',
      };

      // Make the HTTP GET request with headers
      final response = await http.get(
        Uri.parse('$baseUrl/contact-us'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        // Parse the response body as JSON
        Map<String, dynamic> responseData = json.decode(response.body);

        // Extract the 'contacts' object from the response data
        Map<String, dynamic> contactsData = responseData['contacts'];

        // Extract WhatsApp and email from contacts data
        String whatsapp = contactsData['whatsapp'];
        String email = contactsData['email'];

        // Return WhatsApp and email
        return {'whatsapp': whatsapp, 'email': email};
      } else {
        // If the response status code is not 200, return an empty map
        return {};
      }
    } catch (e) {
      // If an error occurs, return an empty map
      return {};
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
    String? gender, // Making gender optional
    String? birthday, // Making birthday optional
    required String region,
    required String mobile,
    required String email,
    required String password,
    required String confirmPassword,
    required int isVendor,
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
        'region': region,
        'mobile': mobile,
        'email': email,
        'password': password,
        'password_confirmation': confirmPassword,
        'is_vendor': isVendor.toString(),
        'otp': enteredOtp,
      };
      // Add gender to the data if provided
      if (gender != null) {
        data['gender'] = gender;
      }

      // Add birthday to the data if provided
      if (birthday != null) {
        data['birthday'] = birthday;
      }
      String jsonBody = jsonEncode(data);

      final response = await http.post(
        url,
        body: jsonBody,
        headers: {'Content-Type': 'application/json'},
      );

      Navigator.of(context, rootNavigator: true)
          .pop(); // Close the loading dialog
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        print(jsonResponse);
        if (jsonResponse['OTP'] == true) {
          QuickAlert.show(
              context: context,
              type: QuickAlertType.custom,
              showCancelBtn: true,
              barrierDismissible: false,
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
                    style: const TextStyle(fontSize: 17),
                    textFieldAlignment: MainAxisAlignment.spaceAround,
                    fieldStyle: FieldStyle.underline,
                    onCompleted: (pin) async {
                      data['otp'] = pin; // Update data map with entered OTP
                    },
                  ),
                ],
              ),
              onConfirmBtnTap: () async {
                jsonBody = jsonEncode(data); // Re-encode JSON body with OTP
                final otpResponse = await http.post(
                  url,
                  body: jsonBody,
                  headers: {'Content-Type': 'application/json'},
                );

                final otpJsonResponse = jsonDecode(otpResponse.body);

                if (otpResponse.statusCode == 200) {
                  QuickAlert.show(
                    context: context,
                    type: QuickAlertType.success,
                    text: otpJsonResponse['message'],
                    onConfirmBtnTap: () {
                      Navigator.pushNamed(context, '/login');
                    },
                  );
                  return otpJsonResponse[
                      'success']; // Return true, indicating success
                } else if (otpResponse.statusCode == 500) {
                  String errorMessage =
                      'A server error occurred. Please try again later.';
                  // Try to parse the JSON response to get more detailed error information if available
                  try {
                    if (otpJsonResponse.containsKey('error')) {
                      errorMessage = otpJsonResponse['error'];
                    } else if (otpJsonResponse.containsKey('message')) {
                      errorMessage = otpJsonResponse['message'];
                    } else {
                      // Fallback to using the entire response body as the error message
                      errorMessage = "Error ${otpResponse.statusCode}: ${otpResponse.body}";
                    }
                  } catch (e) {
                    // Log the error or handle parsing failure
                    print('Error parsing server error response: $e');
                    errorMessage = "Error parsing response: $e";
                  }

                  // Display the initial alert with an option to expand for more details
                  QuickAlert.show(
                    context: context,
                    type: QuickAlertType.error,
                    title: 'Server Error [${otpResponse.statusCode}]',
                    text: errorMessage,
                    widget: TextButton(
                      child: const Text('Show more',
                          style: TextStyle(color: Colors.blue)),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Full Error Report'),
                            content: SingleChildScrollView(
                                child: Text(errorMessage)),
                            actions: [
                              TextButton(
                                child: const Text('Close'),
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                  return otpJsonResponse['success'];
                } else {
                  QuickAlert.show(
                    context: context,
                    type: QuickAlertType.error,
                    title: 'Verification Failed',
                    text: otpJsonResponse['message'],
                  );
                  return otpJsonResponse[
                      'success']; // Return false, indicating failure
                }
              });
          return false; // Return false, OTP needs to be verified
        } else {
          return jsonResponse['success']; // Return success status from API
        }
      } else {
        final jsonResponse = jsonDecode(response.body);

        // Check if the 'messages' field is an array and join them into a single string
        String errorMessage = '';
        if (jsonResponse['messages'] is List) {
          errorMessage = (jsonResponse['messages'] as List).join('\n');
        } else {
          errorMessage = jsonResponse['messages'].toString();
        }

        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: isEnglish ? 'Registration Failed ' : 'خطأ اثناء التسجيل ',
          widget: Text(
            errorMessage,
            textAlign: TextAlign.start,
          ),
        );
        print(jsonResponse);
        return false;
      }
    } catch (e) {
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
                  style: const TextStyle(fontSize: 17),
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
                    confirmBtnColor: const Color(0xFF0D2750),
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
            confirmBtnColor: const Color(0xFF0D2750),
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
        return const Center(
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
          confirmBtnColor: const Color(0xFF0D2750),
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
      String? newPassword,
      String? newPasswordConfirmation]) async {
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
          'new_password': newPassword,
          'new_password_confirmation': newPasswordConfirmation
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
      rethrow;
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
      BuildContext context, String userType) async {
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
          'user_type': userType,
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

  Future<DateTime> fetchCurrentDateFromApi() async {
    final response = await client.get(Uri.parse('$baseUrl/time-and-date'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // Directly parse the ISO 8601 string from your API
      return DateTime.parse(data['time_and_date'].replaceFirst(' ', 'T'));
    } else {
      throw Exception('Failed to load date from API');
    }
  }

  Future<List<Map<String, dynamic>>> getSupportReasons(
      BuildContext context, String criteria) async {
    final url = Uri.parse('$baseUrl/supporting/get-resons');
    String lang = Provider.of<AppState>(context, listen: false).display;

    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);

    // Show loading dialog
    _showLoadingDialog(context);

    try {
      final http.Response response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${authProvider.token}',
        },
        body: jsonEncode(<String, String>{
          'criteria': criteria,
        }),
      );

      // Close loading dialog
      Navigator.of(context).pop();

      if (response.statusCode == 200) {
        // Parse the JSON response correctly
        final List<dynamic> data = jsonDecode(response.body);
        return data.cast<Map<String, dynamic>>();
      } else {
        // If the request was not successful, throw an error
        throw Exception('Failed to perform action: ${response.statusCode}');
      }
    } catch (e) {
      // Close loading dialog in case of an error
      Navigator.of(context).pop();
      // If an error occurs during the request, throw an error
      throw Exception('Failed to perform action: $e');
    }
  }

  Future<void> createSupportRequest(
    BuildContext context, {
    int? optionId,
    int? parentId,
    int? storeId,
    int? discountId,
    String message = '',
    List<String> attachments = const [],
    String additionalPhone = '',
  }) async {
    final url = Uri.parse('$baseUrl/supporting/create');
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    String lang = Provider.of<AppState>(context, listen: false).display;
    bool isEnglish = Provider.of<AppState>(context, listen: false).isEnglish;

    _showLoadingDialog(context);

    try {
      var request = http.MultipartRequest('POST', url);
      request.headers.addAll(<String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${authProvider.token}',
      });

      // Add optionId, parentId, storeId, and discountId as fields
      if (optionId != null) request.fields['option_id'] = optionId.toString();
      if (parentId != null) request.fields['parent_id'] = parentId.toString();
      if (storeId != null) request.fields['store_id'] = storeId.toString();
      if (discountId != null) {
        request.fields['discount_id'] = discountId.toString();
      }
      // Add message, additionalPhone, and lang as fields
      if (message.isNotEmpty) request.fields['description[message]'] = message;
      if (additionalPhone.isNotEmpty) {
        request.fields['additional_phone'] = additionalPhone;
      }
      if (lang.isNotEmpty) request.fields['lang'] = lang;

      // Concatenate file paths into a single string separated by a delimiter
      String attachedFiles = attachments.join(',');

      // Add the concatenated file paths to the description[attached] field
      request.fields['description[attached]'] = attachedFiles;

      // Upload files and add them to the request
      for (String filePath in attachments) {
        File file = File(filePath);
        String fileName = file.path.split('/').last;
        request.files.add(
          await http.MultipartFile.fromPath(
            'description[attached][]', // Adjust field name if needed
            filePath,
            filename: fileName,
            contentType: MediaType('application', 'octet-stream'),
          ),
        );
      }

      // Send the request
      var streamedResponse = await request.send();

      // Check the response
      if (streamedResponse.statusCode == 201) {
        // Get the response body
        var responseJson = await streamedResponse.stream.bytesToString();

        // Parse the response
        var responseData = json.decode(responseJson);

        // Display a quick alert with the message and ticket number

        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          customAsset: 'images/success.gif',
          widget: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Text(
                  responseData['message'], // Center the message
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 10), // Add some spacing
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      responseData['ticketNumber'], // Center the ticket number
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 10), // Add some spacing
                    IconButton(
                      icon: const Icon(Icons.copy),
                      onPressed: () {
                        // Copy ticket number to clipboard
                        Clipboard.setData(
                            ClipboardData(text: responseData['ticketNumber']));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content:
                                  Text('Ticket number copied to clipboard')),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          onConfirmBtnTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            Navigator.pushNamed(context, '/home'
                // Pass the store data to the route
                );
          },
          confirmBtnText: isEnglish ? 'ok' : 'حسنا',
          confirmBtnColor: const Color(0xFF0D2750),
        );
      } else {
        throw Exception(
            'Failed to create support request: ${streamedResponse.reasonPhrase}');
      }
    } catch (e) {
      Navigator.of(context).pop();
      throw Exception('Failed to create support request: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getSupportTickets(
      {String? criteria, String? postId, required BuildContext context}) async {
    final url = Uri.parse('$baseUrl/supporting/get');
    String lang = Provider.of<AppState>(context, listen: false).display;

    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);

    // Show loading dialog
    // _showLoadingDialog(context);

    try {
      final http.Response response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${authProvider.token}',
        },
        body: jsonEncode(<String, dynamic>{
          'lang': lang,
          'criteria': criteria,
          'postId': postId
        }),
      );

      // print(jsonDecode(response.body));

      if (response.statusCode == 200) {
        // Parse the JSON response correctly
        final List<dynamic> data = jsonDecode(response.body);
        List<Map<String, dynamic>> supportTickets =
            data.cast<Map<String, dynamic>>();

        supportTickets = supportTickets.map((ticket) {
          // Parse description if it's a string
          if (ticket['description'] is String) {
            try {
              ticket['description'] = jsonDecode(ticket['description']);
            } catch (e) {
              // print('Failed to parse description: $e');
              // Handle parsing error, perhaps by setting description to an empty map or null
              ticket['description'] = {}; // or null
            }
          }

          // print('ticketttt $ticket');
          return ticket;
        }).toList();

//  print('supportTickets $supportTickets');
        return supportTickets;
      } else {
        throw Exception('Failed to perform action: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
      throw Exception('Failed to perform action: $e');
    }
  }

  Future<Map<String, dynamic>> changeStatusSupportTickets({
    String? status,
    String? postId,
    required BuildContext context,
  }) async {
    final url = Uri.parse('$baseUrl/supporting/changeStatus');
    String lang = Provider.of<AppState>(context, listen: false).display;

    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);

    try {
      final http.Response response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${authProvider.token}',
        },
        body: jsonEncode(<String, dynamic>{
          'lang': lang,
          'status': status,
          'id': postId,
        }),
      );

      print(jsonDecode(response.body));

      if (response.statusCode == 200) {
        // Parse the JSON response correctly
        final Map<String, dynamic> data = jsonDecode(response.body);

        return {
          'statusCode': response.statusCode,
          'data': data,
        };
      } else {
        // Return status code and null data
        return {
          'statusCode': response.statusCode,
        };
      }
    } catch (e) {
      print('action: $e');
      throw Exception('Failed to perform action: $e');
    }
  }

  Future<Map<String, dynamic>> updateSupportRequest(
    BuildContext context, {
    String id = '',
    String criteria = '',
    String type = '',
    String message = '',
    List<String> attachments = const [],
  }) async {
    final url = Uri.parse('$baseUrl/supporting/update');
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    String lang = Provider.of<AppState>(context, listen: false).display;
    bool isEnglish = Provider.of<AppState>(context, listen: false).isEnglish;

    // _showLoadingDialog(context);

    try {
      var request = http.MultipartRequest('POST', url);
      request.headers.addAll(<String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${authProvider.token}',
      });

      // Add optionId, parentId, storeId, and discountId as fields
      request.fields['id'] = id.toString();
      request.fields['criteria'] = criteria.toString();
      request.fields['description[message_type]'] = type.toString();
      if (message.isNotEmpty) request.fields['description[message]'] = message;
      if (lang.isNotEmpty) request.fields['lang'] = lang;

      // Concatenate file paths into a single string separated by a delimiter
      String attachedFiles = attachments.join(',');

      // Add the concatenated file paths to the description[attached] field
      request.fields['description[attached]'] = attachedFiles;

      // Upload files and add them to the request
      for (String filePath in attachments) {
        File file = File(filePath);
        String fileName = file.path.split('/').last;
        request.files.add(
          await http.MultipartFile.fromPath(
            'description[attached][]', // Adjust field name if needed
            filePath,
            filename: fileName,
            contentType: MediaType('application', 'octet-stream'),
          ),
        );
      }

      // Send the request
      var streamedResponse = await request.send();
      var responseString = await streamedResponse.stream
          .bytesToString(); // Store the response in a variable

      // print(request.fields);
      // print(streamedResponse.statusCode);
      // print(responseString);
      // Check the response
      if (streamedResponse.statusCode == 200) {
        var responseData = json.decode(responseString);
        // print(responseData);
        return {
          'statusCode': streamedResponse.statusCode,
          'data': responseData
        };
      } else {
        throw Exception(
            'Failed to update support request: ${streamedResponse.reasonPhrase}');
      }
    } catch (e) {
      Navigator.of(context).pop();
      throw Exception('Failed to create support request: $e');
    }
  }
}

void _showLoadingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false, // Prevent dialog from closing on outside tap
    builder: (BuildContext context) {
      return const Dialog(
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
