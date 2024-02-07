import 'dart:io';

import 'package:flutter/services.dart';
import 'package:mhfatha/settings/imports.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

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

  Future<void> initializeData(BuildContext context) async {
    isEnglish = Provider.of<AppState>(context, listen: false).isEnglish;
    lang = Provider.of<AppState>(context, listen: false).display;
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    bearerToken = 'Bearer ${authProvider!.token}'; // Initialize Bearer token
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
      print(workingdays);
      print(response);
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(await response.stream.bytesToString());
        final MessageC = jsonResponse['message'];
        await authProvider?.updateUserData(context);
        Navigator.pop(context);
        Navigator.pop(context);
        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          text: '$MessageC',
           onConfirmBtnTap: () {
                  Navigator.of(context).pop();
                    },
        );

        print(MessageC);

        return jsonResponse['success'];
      } else {
        final jsonResponse = jsonDecode(await response.stream.bytesToString());
        throw Exception(
            'Failed to update user profile. Server responded with status code: ${response.statusCode} and error message: $jsonResponse');
        print(jsonResponse);
      }
    } catch (e) {
      print(e);
      return false;
    }
  }
}

void _showLoadingDialog(BuildContext context) {
  bool isEnglish = Provider.of<AppState>(context, listen: false).isEnglish;

  QuickAlert.show(
    context: context,
    type: QuickAlertType.loading,
    title: isEnglish ? 'please wait' : 'يرجى الانتظار...',
    text: isEnglish ? 'loading your data' : 'جاري تحميل البيانات',
  );
}
