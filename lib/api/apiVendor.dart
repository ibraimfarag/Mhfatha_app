import 'dart:io';
import 'dart:typed_data';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:mhfatha/settings/imports.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart' as permission_handler;

class VendorApi {
  static const String baseUrl = AppVariables.ApiUrl;
  // final BuildContext context; // Add BuildContext as a parameter

  // Constructor to initialize context
  VendorApi(BuildContext context) {
    initializeData(context);
  }

  bool isEnglish = false;
  String lang = '';
  String bearerToken = '';
  AuthProvider? authProvider;

// Timer variable
  late Timer _timer;

// Function to start the timer
  void _startTimer(BuildContext context) {
    _timer = Timer(Duration(seconds: 3), () {
      Navigator.of(context).pop();
    });
  }

// Function to cancel the timer
  void _cancelTimer() {
    _timer.cancel();
  }

  Future<void> initializeData(BuildContext context) async {
    isEnglish = Provider.of<AppState>(context, listen: false).isEnglish;
    lang = Provider.of<AppState>(context, listen: false).display;
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    bearerToken = 'Bearer ${authProvider!.token}';
  }

  Future<bool> createstore({
    required String store_name,
    required String address,
    required String latitude,
    required String longitude,
    required String region,
    required String mobile,
    required String categoryId,
    required String tax_number,
    required Map<String, Map<String, String>> workingdays,
    File? imageFile,
    required BuildContext context,
  }) async {
    final url = Uri.parse('$baseUrl/vendor/store/create');

    try {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.loading,
        customAsset: 'images/loading.gif',
        title: isEnglish ? 'Loading' : 'انتظر قليلاً',
        text: isEnglish ? 'Fetching your data' : 'جاري تحميل البيانات',
      );

      final request = http.MultipartRequest('POST', url)
        // ..headers['Content-Type'] = 'application/json'
        ..headers['Authorization'] = bearerToken
        ..fields['lang'] = lang
        ..fields['name'] = store_name
        ..fields['location'] = address
        ..fields['phone'] = mobile
        ..fields['region'] = region
        ..fields['work_days'] = jsonEncode(workingdays)
        ..fields['latitude'] = latitude
        ..fields['status'] = '1'
        ..fields['longitude'] = longitude
        ..fields['category_id'] = categoryId
        ..fields['tax_number'] = tax_number;

      if (imageFile != null) {
        // Use the correct field name for the file, in this case, 'photo'
        request.files
            .add(await http.MultipartFile.fromPath('photo', imageFile.path));
      }

      final response = await request.send();
      // print(workingdays);
      // print(response);
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(await response.stream.bytesToString());
        final MessageC = jsonResponse['message'];
        await authProvider?.updateUserData(context);
        Navigator.pop(context);
        Navigator.pop(context);
        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          customAsset: 'images/success.gif',
          text: '$MessageC',
          onConfirmBtnTap: () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
        );

        print(MessageC);

        return jsonResponse['success'];
      } else {
        final jsonResponse = jsonDecode(await response.stream.bytesToString());
        // Navigator.pop(context);
        // Navigator.pop(context);

        // Extracting error messages from the jsonResponse
        final errors = jsonResponse['errors'];
        final errorMessages = errors.values.toList().join('\n');

        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: isEnglish ? 'Error' : 'خطأ',
          text: errorMessages.isNotEmpty
              ? errorMessages
              : 'Sorry, something went wrong',
          confirmBtnText: isEnglish ? 'ok' : 'حسنا',
          confirmBtnColor: Colors.red,
          onConfirmBtnTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            // Navigator.of(context).pop();
          },
        );

        print(jsonResponse);
        throw Exception(
            'Failed to update user profile. Server responded with status code: ${response.statusCode} and error message: $jsonResponse');
        // print(jsonResponse);
      }
    } catch (e) {
      // print(e);
      return false;
    }
  }

  Future<bool> updatestore({
    required String store_id,
    required String store_name,
    required String address,
    required String latitude,
    required String longitude,
    required String region,
    required String mobile,
    required String categoryId,
    required String tax_number,
    required Map<String, Map<String, String>> workingdays,
    File? imageFile,
    required BuildContext context,
  }) async {
    final url = Uri.parse('$baseUrl/vendor/store/edit');

    try {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.loading,
        customAsset: 'images/loading.gif',
        title: isEnglish ? 'Loading' : 'انتظر قليلاً',
        text: isEnglish ? 'Fetching your data' : 'جاري تحميل البيانات',
      );

      final request = http.MultipartRequest('POST', url)
        // ..headers['Content-Type'] = 'application/json'
        ..headers['Authorization'] = bearerToken
        ..fields['lang'] = lang
        ..fields['store_id'] = store_id
        ..fields['name'] = store_name
        ..fields['location'] = address
        ..fields['phone'] = mobile
        ..fields['region'] = region
        ..fields['work_days'] = jsonEncode(workingdays)
        ..fields['latitude'] = latitude
        ..fields['status'] = '1'
        ..fields['longitude'] = longitude
        ..fields['category_id'] = categoryId
        ..fields['tax_number'] = tax_number;

      if (imageFile != null) {
        // Use the correct field name for the file, in this case, 'photo'
        request.files
            .add(await http.MultipartFile.fromPath('photo', imageFile.path));
      }

      final response = await request.send();
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(await response.stream.bytesToString());
        final MessageC = jsonResponse['message'];
        await authProvider?.updateUserData(context);
        Navigator.pop(context);
        Navigator.pop(context);
        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          customAsset: 'images/success.gif',
          text: '$MessageC',
          onConfirmBtnTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
        );

        // print(MessageC);

        return jsonResponse['success'];
      } else {
        final jsonResponse = jsonDecode(await response.stream.bytesToString());
        Navigator.pop(context);
        Navigator.pop(context);

        // Extracting error messages from the jsonResponse
        final errors = jsonResponse['errors'];
        final errorMessages = errors.values.toList().join('\n');

        QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            title: isEnglish ? 'Error' : 'خطأ',
            text: errorMessages.isNotEmpty
                ? errorMessages
                : 'Sorry, something went wrong',
            confirmBtnText: isEnglish ? 'ok' : 'حسنا',
            confirmBtnColor: Colors.red);
        // print(jsonResponse);
        throw Exception(
            'Failed to update user profile. Server responded with status code: ${response.statusCode} and error message: $jsonResponse');
        // print(jsonResponse);
      }
    } catch (e) {
      // print(e);
      return false;
    }
  }

  Future<void> getStoreQRImage(String storeId, BuildContext context) async {
    final url = Uri.parse('$baseUrl/vendor/store/qr');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': bearerToken,
    };
    final body = '{"storeId": "$storeId"}';

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final imageUrl = jsonResponse['url'];
        // print(imageUrl);
        // Download the image
        await downloadAndSaveImage(imageUrl, 'store_qr_image.png', context);
      } else {
        throw Exception('Failed to get store QR image');
      }
    } catch (e) {
      // print('Error getting store QR image: $e');
    }
  }

Future<void> downloadAndSaveImage(
    String imageUrl, String fileName, BuildContext context) async {
  // Check if permission is granted
  permission_handler.PermissionStatus status = await permission_handler.Permission.storage.status;
  if (!status.isGranted) {
    // If permission is not granted, request it
    status = await permission_handler.Permission.storage.request();
    if (!status.isGranted) {
      // Permission still not granted, handle accordingly (e.g., show a message)
      return;
    }
  }

  final response = await http.get(Uri.parse(imageUrl));
  final bytes = response.bodyBytes;

  // Get the directory for storing images
  final directory = await getApplicationDocumentsDirectory();
  final imagePath = '${directory.path}/$fileName';

  // Save the image file
  await File(imagePath).writeAsBytes(bytes);

  // Add image to the phone's image directory
  final result = await ImageGallerySaver.saveFile(imagePath);
  // print('Image saved to gallery: $result');

  // Show success message
  QuickAlert.show(
    context: context,
    type: QuickAlertType.success,
    customAsset: 'images/success.gif',
    text: isEnglish ? 'Image saved to gallery' : 'تم حفظ الصورة بنجاح',
    onConfirmBtnTap: () {
      // Cancel the timer when 'onConfirmBtnTap' is called
      _cancelTimer();
      // Optionally, you can perform other actions here
      Navigator.pop(context);
    },
    confirmBtnText: isEnglish ? 'ok' : 'حسنا',
    confirmBtnColor: Color(0xFF0D2750),
  );

  // Pop context after 3 seconds
  _startTimer(context);
}


  Future<void> deleteStore(String storeId, BuildContext context) async {
    final url = Uri.parse('$baseUrl/vendor/store/delete');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': bearerToken,
    };
    final body = jsonEncode({'storeId': storeId, 'lang': lang});

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final message = jsonResponse['message'];

        // Show success message
        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          customAsset: 'images/success.gif',
          text: message,
          onConfirmBtnTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            Navigator.of(context).pushReplacementNamed('/mainstores');
          },
          confirmBtnText: isEnglish ? 'ok' : 'حسنا',
          confirmBtnColor: Color(0xFF0D2750),
        );
      } else {
        final jsonResponse = jsonDecode(response.body);
        final message = jsonResponse['message'];
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          text: message,
          onConfirmBtnTap: () {
            Navigator.of(context).pop();
          },
          confirmBtnText: isEnglish ? 'ok' : 'حسنا',
          confirmBtnColor: Colors.redAccent,
        );
      }
    } catch (e) {
      // print('Error deleting store: $e');
      // Show error message
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        text: 'Error deleting store',
        onConfirmBtnTap: () {
          Navigator.of(context).pop();
        },
      );
    }
  }

  Future<dynamic> fetchDiscounts(String storeId, BuildContext context) async {
    final String apiUrl = '$baseUrl/vendor/store/discounts';

    final Map<String, dynamic> requestData = {
      "store_id": storeId,
      "lang": lang
    };

    final http.Response response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': bearerToken,
      },
      body: jsonEncode(requestData),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);

      // Check if the response contains the "message" key
      if (responseBody.containsKey('message')) {
        return responseBody['message'];
      }

      // Check if the response contains the "discounts" key
      if (responseBody.containsKey('discounts')) {
        List<dynamic> discounts = responseBody['discounts'];
        List<Map<String, dynamic>> formattedDiscounts =
            discounts.map<Map<String, dynamic>>((discount) {
          return Map<String, dynamic>.from(discount);
        }).toList();
        return formattedDiscounts;
      }
    } else {
      // Handle the error
      // print('Error: ${response.statusCode}');
      // print('Response body: ${response.body}');
      // Return an appropriate error message or throw an exception based on your error handling strategy
      return 'Error: Failed to fetch discounts';
    }
  }

  Future<bool> createDiscount(
    String storeid,
    String percent,
    String category,
    String startDate,
    String endDate,
    Map<String, dynamic> store,
    BuildContext context,
  ) async {
    final url = Uri.parse('$baseUrl/vendor/store/discounts/create');

    try {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.loading,
        customAsset: 'images/loading.gif',
        title: isEnglish ? 'Loading' : 'انتظر قليلاً',
        text: isEnglish ? 'Creating discount' : 'جاري إنشاء الخصم',
      );

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': bearerToken,
        },
        body: jsonEncode({
          'store_id': storeid,
          'percent': percent,
          'category': category,
          'start_date': startDate,
          'end_date': endDate,
          'lang': lang,
        }),
      );

      if (response.statusCode == 201) {
        final jsonResponse = jsonDecode(response.body);
        final message = jsonResponse['message'];
        Navigator.of(context).pop();

        // Show success message
        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          customAsset: 'images/success.gif',
          text: message,
          onConfirmBtnTap: () {
            // Navigator.of(context).pop();
            Navigator.of(context).pop();
            Navigator.pushReplacementNamed(
              context,
              '/storediscounts',
              arguments: store, // Pass the store data to the route
            );
          },
          confirmBtnText: isEnglish ? 'ok' : 'حسنا',
          confirmBtnColor: Color(0xFF0D2750),
        );

        return true;
      } else {
        final jsonResponse = jsonDecode(response.body);
        final message = jsonResponse['message'];
        Navigator.of(context).pop();

        // Show error message
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          text: message,
          onConfirmBtnTap: () {
            Navigator.of(context).pop();
          },
          confirmBtnText: isEnglish ? 'ok' : 'حسنا',
          confirmBtnColor: Colors.redAccent,
        );

        return false;
      }
    } catch (e) {
      // print('Error creating discount: $e');
      Navigator.of(context).pop();

      // Show error message
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        text: isEnglish ? 'Error creating discount' : 'خطأ في إنشاء الخصم',
        onConfirmBtnTap: () {
          Navigator.of(context).pop();
        },
      );

      return false;
    }
  }

  Future<bool> deleteDiscount(String discountId, BuildContext context) async {
    final url = Uri.parse('$baseUrl/vendor/store/discounts/delete');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': bearerToken,
    };
    final body = jsonEncode({'discount_id': discountId, 'lang': lang});

    try {
      _showLoadingDialog(context);

      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final message = jsonResponse['message'];
        Navigator.of(context).pop();
        Navigator.of(context).pop();

        // Show success message
        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          customAsset: 'images/success.gif',
          text: message,
          onConfirmBtnTap: () {
            Navigator.of(context).pop();
            // You may add additional navigation logic here if needed
          },
          confirmBtnText: isEnglish ? 'ok' : 'حسنا',
          confirmBtnColor: Color(0xFF0D2750),
        );
        return true;
      } else {
        final jsonResponse = jsonDecode(response.body);
        final message = jsonResponse['message'];
        Navigator.of(context).pop();
        Navigator.of(context).pop();

        // Show error message
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          text: message,
          onConfirmBtnTap: () {
            Navigator.of(context).pop();
          },
          confirmBtnText: isEnglish ? 'ok' : 'حسنا',
          confirmBtnColor: Colors.redAccent,
        );
        return false;
      }
    } catch (e) {
      // print('Error deleting discount: $e');

      // Show error message
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        text: isEnglish ? 'Error deleting discount' : 'خطأ في حذف الخصم',
        onConfirmBtnTap: () {
          Navigator.of(context).pop();
        },
      );
      return false;
    }
  }
}

void _showLoadingDialog(BuildContext context) {
  bool isEnglish = Provider.of<AppState>(context, listen: false).isEnglish;

  QuickAlert.show(
    context: context,
    type: QuickAlertType.loading,
    customAsset: 'images/loading.gif',
    title: isEnglish ? 'please wait' : 'يرجى الانتظار...',
    text: isEnglish ? 'loading your data' : 'جاري تحميل البيانات',
  );
}
