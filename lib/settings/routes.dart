// lib\settings\routes.dart
import 'package:mhfatha/settings/imports.dart';

class Routes {
  static  String login = '/login';
  static  String register = '/register';
  static  String home = '/home';
  static  String settings = '/settings';
  static String storeInfo = '/store-info';
  static String qrscanner = '/qr-scanner';
  static String qrresponse = '/qr-response';
  static String getDiscount = '/get-discount';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      login: (context) =>  LoginScreen(),
      register: (context) =>  RegisterScreen(),
      home: (context) =>  HomeScreen(),
      settings: (context) =>  SettingsScreen(),
      storeInfo: (context) => StoreInfoScreen(),
      qrscanner: (context) => QrScanner(),
      qrresponse: (context) => QrResponse(responseData: '',),
      getDiscount: (context) => GetDiscount(),

      
    };
  }

  static MaterialPageRoute unknownRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (context) => LoginScreen(),
    );
  }
}

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text('Error'),
      ),
      body: Center(
        child:  Text('Page not found'),
      ),
    );
  }
}
