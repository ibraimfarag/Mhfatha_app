import 'package:mhfatha/settings/imports.dart';



class DarkModeProvider with ChangeNotifier {
  late SharedPreferences _prefs;
  bool _isDarkMode = false;

  DarkModeProvider() {
    _loadDarkMode();
  }

  bool get isDarkMode => _isDarkMode;

  Future<void> _loadDarkMode() async {
    _prefs = await SharedPreferences.getInstance();
    _isDarkMode = _prefs.getBool('isDarkMode') ?? false;
    notifyListeners();
  }

  Future<void> toggleDarkMode() async {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
    await _prefs.setBool('isDarkMode', _isDarkMode);
  }
}
