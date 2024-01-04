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


  AppState(BuildContext context) {

      network(context);

  }
 


  Future<void> network(BuildContext context) async {
    bool result = await InternetConnectionChecker().hasConnection;
    if (result == true) {
      print('YAY! Free cute dog pics!');
    } else {
      print('No internet :( ');
      // You can safely use the context here to navigate
      Navigator.pushNamed(context, '/nointernet');
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


