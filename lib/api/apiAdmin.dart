import 'dart:io';
import 'dart:typed_data';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:mhfatha/settings/imports.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class AdminApi {
  static const String baseUrl = AppVariables.ApiUrl;
  // final BuildContext context; // Add BuildContext as a parameter

  // Constructor to initialize context
  AdminApi(BuildContext context) {
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

        print(MessageC);

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
        print(jsonResponse);
        throw Exception(
            'Failed to update user profile. Server responded with status code: ${response.statusCode} and error message: $jsonResponse');
        print(jsonResponse);
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<Map<String, dynamic>> fetchStatistics(BuildContext context) async {
    final url = Uri.parse('$baseUrl/admin/statistics');

    await Future.delayed(Duration.zero);
    _showLoadingDialog(context);
    try {
      final http.Response response = await http.get(
        url,

        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': bearerToken,
        },
        // body: jsonEncode(<String, String>{
        //   'type': 'general',
        //   'message': 'Hello, this is a private notification.',
        // }
        // ),
      );

      if (response.statusCode == 200) {
        Navigator.of(context).pop();

        // Parse the JSON response
        final Map<String, dynamic> data = jsonDecode(response.body);
        return data;
      } else {
        // If the request was not successful, throw an error
        throw Exception('Failed to load statistics: ${response.statusCode}');
      }
    } catch (e) {
      // If an error occurs during the request, throw an error
      throw Exception('Failed to load statistics: $e');
    }
  }

  Future<Map<String, dynamic>> actions(
      BuildContext context, String userId, String query) async {
    final url = Uri.parse('$baseUrl/admin/actions');

    // Show loading dialog
    _showLoadingDialog(context);

    try {
      final http.Response response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': bearerToken,
        },
        body: jsonEncode(<String, String>{
          'user_id': userId,
          'query': query,
        }),
      );

      // Close loading dialog

      if (response.statusCode == 200) {
        // Parse the JSON response
        Navigator.of(context).pop();
        Navigator.of(context).pop();
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

  Future<Map<String, dynamic>> Storeactions(
      BuildContext context, String storeID, String query) async {
    final url = Uri.parse('$baseUrl/admin/store/actions');

    // Show loading dialog
    _showLoadingDialog(context);

    try {
      final http.Response response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': bearerToken,
        },
        body: jsonEncode(<String, String>{
          'store_id': storeID,
          'query': query,
        }),
      );

      // Close loading dialog

      if (response.statusCode == 200) {
        // Parse the JSON response
        Navigator.of(context).pop();
        Navigator.of(context).pop();
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

  Future<bool> UpdateUser({
    required String user_id,
    required String first_name,
    required String last_name,
    required String birthday,
    required String email,
    required String region,
    required String mobile,
    File? imageFile,
    required BuildContext context,
  }) async {
    final url = Uri.parse('$baseUrl/admin/user/update');

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
        ..fields['user_id'] = user_id
        ..fields['first_name'] = first_name
        ..fields['last_name'] = last_name
        ..fields['birthday'] = birthday
        ..fields['region'] = region
        ..fields['mobile'] = mobile
        ..fields['email'] = email;

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
        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          customAsset: 'images/success.gif',
          text: '$MessageC',
          onConfirmBtnTap: () async {
            Navigator.of(context).pop();

            // await fetchStatistics(context);
            Navigator.pushNamed(context, '/admin/users'
                // Pass the user data to the destination screen
                );
          },
        );

        print(MessageC);

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
        print(jsonResponse);
        throw Exception(
            'Failed to update user profile. Server responded with status code: ${response.statusCode} and error message: $jsonResponse');
        print(jsonResponse);
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  
  Future<Map<String, dynamic>> RequestActions(
      BuildContext context, String requestID, String action) async {
    final url = Uri.parse('$baseUrl/admin/requests');

    // Show loading dialog
    _showLoadingDialog(context);

    try {
      final http.Response response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': bearerToken,
        },
        body: jsonEncode(<String, String>{
          'id': requestID,
          'action': action,
        }),
      );

      // Close loading dialog

      if (response.statusCode == 200) {
        // Parse the JSON response
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        final Map<String, dynamic> data = jsonDecode(response.body);
print(data);
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
