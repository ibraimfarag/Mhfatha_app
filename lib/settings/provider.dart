// lib\settings\provider.dart
// ignore: unused_import
import 'package:mhfatha/settings/imports.dart';

// provider.dart
class AuthProvider extends ChangeNotifier {
  String? token;
  bool isLoggedIn = false;
  Map<String, dynamic>? userData;

  // Function to set user data after successful login
  void setUserData(Map<String, dynamic> data) {
    token = data['token'];
    userData = data['user'];
    isLoggedIn = true;

    // Notify listeners that the authentication state has changed
    notifyListeners();
  }

  // Function to clear user data after logout
  void clearUserData() {
    token = null;
    userData = null;
    isLoggedIn = false;

    // Notify listeners that the authentication state has changed
    notifyListeners();
  }

  // Function to check if the user is logged in
  bool isUserLoggedIn() {
    return isLoggedIn;
  }
}
