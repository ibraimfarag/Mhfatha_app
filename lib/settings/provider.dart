// lib\settings\provider.dart
// ignore: unused_import
import 'dart:convert';
import 'package:mhfatha/settings/imports.dart';
import 'package:shared_preferences/shared_preferences.dart';

// provider.dart
class AuthProvider extends ChangeNotifier {
  String? _token;
  bool _isAuthenticated = false;
  Map<String, dynamic>? _user;
final api = Api();
  // Getter for the token
  String? get token => _token;

  // Getter for authentication status
  bool get isAuthenticated => _isAuthenticated;

  // Getter for the user data
  Map<String, dynamic>? get user => _user;


  int? get userId => _user?['id'];

  // Load authentication data from SharedPreferences
  Future<void> loadAuthData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
    _user = prefs.getString('user') != null ? jsonDecode(prefs.getString('user')!) : null;
    _isAuthenticated = _token != null;

    notifyListeners();
  }

  // Save authentication data to SharedPreferences
  Future<void> saveAuthData(String token, Map<String, dynamic> userData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _token = token;
    _user = userData;
    _isAuthenticated = true;

    prefs.setString('token', token);
    prefs.setString('user', jsonEncode(userData));

    notifyListeners();
  }

  // Clear authentication data from SharedPreferences
  Future<void> clearAuthData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _token = null;
    _user = null;
    _isAuthenticated = false;

    prefs.remove('token');
    prefs.remove('user');

    notifyListeners();
  }
  void logout() {
    clearAuthData();

    // Additional logout logic (if needed)

    // Notify listeners to update UI
    notifyListeners();
  }

  Future<void> updateUserData(BuildContext context) async {
    try {
      // Fetch user details from the API
      Map<String, dynamic> newUserData = await api.getUserDetails(context);

      // Update the local user data in AuthProvider
      _user = newUserData;
        // print(_user);
      // Save the updated user data to SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('user', jsonEncode(newUserData));

      // Notify listeners to update UI
      notifyListeners();
    } catch (e) {
      print('Error updating user data: $e');
      // Handle errors or throw an exception if needed
    }
  }
}