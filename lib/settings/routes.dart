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
  static String nearby = '/nearby';
  static String report = '/report';
  static String request= '/requests';
  static String nonetwork= '/nonet';
  static String account= '/account';
  static String filteredStores ='/filteredStores';
  static String changePasswword ='/changePasswword';
  static String restPassword ='/restpassword';
  static String vendorsMain ='/mainstores';
  static String createstore ='/createstore';

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
      nearby: (context) => NearBy(),
      report: (context) => ReportScreen(),
      request: (context) => RequestsScreen(),
      nonetwork: (context) => Nointernet(),
      account: (context) => AccountScreen(),
      filteredStores : (context) => FiteredStroes(),
      changePasswword : (context) => ChangePassword(),
      restPassword : (context) => RestPassword(),
      vendorsMain : (context) => MainStores(),
      createstore : (context) => CreateStore(),
  
      
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
