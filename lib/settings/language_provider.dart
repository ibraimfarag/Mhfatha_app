// ignore_for_file: unused_import
// lib\settings\language_provider.dart
import 'package:flutter/services.dart';
import 'package:mhfatha/settings/imports.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'dart:async';






class AppState with ChangeNotifier {
  bool _isEnglish = true;

  bool get isEnglish => _isEnglish;

    bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

late Timer _internetCheckTimer;
bool _hasInternetConnection = true; // Default to true initially
bool _isNonetworkScreenOpen = false; // Flag to track if the nonetwork screen is open

AppState(BuildContext context) {
  _startInternetCheckTimer(context);
}

void _startInternetCheckTimer(BuildContext context) {
  _internetCheckTimer = Timer.periodic(Duration(seconds: 10), (timer) {
    _checkInternetConnection(context);
  });
}

Future<void> _checkInternetConnection(BuildContext context) async {
  bool result = await InternetConnectionChecker().hasConnection;
  if (result) {
    print('You are online');
    _setInternetConnectionState(true);
    _closeNointernetScreen(context); // Close the Nointernet screen if it was open
  } else {
    print('No internet :(');
    _setInternetConnectionState(false);
    _navigateToNointernet(context);
  }
}

void _setInternetConnectionState(bool hasConnection) {
  if (_hasInternetConnection != hasConnection) {
    _hasInternetConnection = hasConnection;
    notifyListeners(); // Notify listeners when the connection state changes
  }
}

bool _isNointernetScreenVisible(BuildContext context) {
  // Check if the Nointernet screen is currently on top of the stack
  return ModalRoute.of(context)?.settings.name == Routes.nonetwork;
}

void _navigateToNointernet(BuildContext context) {
  if (!_isNonetworkScreenOpen && !_isNointernetScreenVisible(context)) {
    navigatorKey.currentState?.pushNamed(Routes.nonetwork);
    _isNonetworkScreenOpen = true;
  }
}

void _closeNointernetScreen(BuildContext context) {
  if (_isNonetworkScreenOpen) {
    navigatorKey.currentState?.pop();
    _isNonetworkScreenOpen = false;
  }
}

 

  Future<void> toggleDarkMode() async {
    _isDarkMode = !_isDarkMode;
    notifyListeners();

    // Save the dark mode preference to SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', _isDarkMode);
  }

  Future<void> loadDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    notifyListeners();
  }

  Future<void> toggleLanguage() async {
    _isEnglish = !_isEnglish;
    notifyListeners();

    // Save the language choice to SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isEnglish', _isEnglish);
  }

  Future<void> loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    _isEnglish = prefs.getBool('isEnglish') ?? true;
    notifyListeners();
  }

    String get display {
    return _isEnglish ? 'en' : 'ar';
  }

}


