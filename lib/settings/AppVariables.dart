import 'package:mhfatha/settings/imports.dart';



class AppVariables {
  static final AppVariables _instance = AppVariables._internal();

  factory AppVariables() {
    return _instance;
  }

  AppVariables._internal();

  // Define your App variables here
  static const String appName = 'My App';
  static const String ApiUrl = 'https://mhfatha.net/api';

  // static Color primaryColor = Color(0xFF001844);
  MaterialColor primaryColor = Colors.primaries[0];
  String imageUrl = 'assets/your_image.png';
  static const Color themeColor = Color(0xFF001844);
  static const Color textcolor = Color(0xFFFFFFFF);
  static const double fontSizesmail = 16.0;

// theme color

  static MaterialColor customPrimaryColor = const MaterialColor(
    0xFF001844, // Replace with your desired primary color value
    <int, Color>{
      50: Color(0xFFE3EFFF),
      100: Color(0xFFB8CDFF),
      200: Color(0xFF8EA9FF),
      300: Color(0xFF6485FF),
      400: Color(0xFF416AFF),
      500: Color(0xFF003DFF),
      600: Color(0xFF0035E6),
      700: Color(0xFF002CBF),
      800: Color(0xFF002499),
      900: Color(0xFF001A66),
    },
  );

  // Add more variables as needed
  Color titleColor = textcolor;
  Color iconColor = textcolor;
  Color menuBackgroundColor = themeColor;
  double titleFontSize = 13;
  double iconSize = 34;
  String titleFontFamily = 'sidebar-menu';
  static const String  serviceFontFamily = 'sidebar-menu';

    String phoneNumber = '+201001802203'; 
    String whatsappMsg= 'مرحبًا، أنا أود القدوم ببعض الاقتراحات/الشكاوي'; 

}
