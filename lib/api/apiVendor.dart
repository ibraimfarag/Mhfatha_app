import 'dart:io';

import 'package:flutter/services.dart';
import 'package:mhfatha/settings/imports.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

class VendorApi {
  static const String baseUrl = AppVariables.ApiUrl;
  final BuildContext context; // Add BuildContext as a parameter

  // Constructor to initialize context
 VendorApi(this.context) {
    initializeData();
  }

  bool isEnglish = false;
  String lang = '';
  String bearerToken = '';
  AuthProvider? authProvider;


  Future<void> initializeData() async {
    isEnglish = Provider.of<AppState>(context, listen: false).isEnglish;
    lang = Provider.of<AppState>(context, listen: false).display;
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    bearerToken = 'Bearer ${authProvider!.token}'; // Initialize Bearer token
  }


Future<Map<String, dynamic>> createVendorStores() async {
  final String url = '$baseUrl/vendor/stores';
  final Map<String, String> headers = {
    'Authorization': bearerToken,
  };

  try {
    final response = await http.post(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      // Parse the JSON response
      final Map<String, dynamic> responseData = jsonDecode(response.body);

      // Check if the response contains the required keys
      if (responseData.containsKey('userStores') &&
          responseData.containsKey('verifiedStoresCount') &&
          responseData.containsKey('pendingStoresCount') &&
          responseData.containsKey('sumCountTimes') &&
          responseData.containsKey('sumTotalPayments')) {
            // print(responseData);
        return responseData;
      } else {
        // Required keys are missing in the response, handle error
        print('One or more required keys are missing in the response.');
        return {}; // Return an empty map if required keys are missing
      }
    } else {
      // Request failed, handle error
      print('Failed to create vendor stores. Status code: ${response.statusCode}');
      return {}; // Return an empty map if request fails
    }
  } catch (e) {
    // Exception occurred, handle error
    print('Exception occurred while creating vendor stores: $e');
    return {}; // Return an empty map if exception occurs
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
