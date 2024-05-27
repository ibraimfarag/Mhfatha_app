// lib\settings\routes.dart

import 'package:mhfatha/settings/imports.dart';

class Routes {
  // /* -------------------------------------------------------------------------- */
  // /*                                    Auth                                    */
  // /* -------------------------------------------------------------------------- */
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
  static String UserTremss ='/user/trems';

  /* ------------------------------- supporting ------------------------------- */
  static String MainSupport ='/support';
  static String MainSupportreport ='/support/report';
  static String SupportTicket ='/support/ticket';

// /* -------------------------------------------------------------------------- */
// /*                                   Vendor                                   */
// /* -------------------------------------------------------------------------- */
  static String vendorsMain ='/mainstores';
  static String vendorsStoreDetails ='/storedetails';
  static String createstore ='/createstore';
  static String editstore ='/editstore';
  static String storeDiscounts ='/storediscounts';
  static String VENDORTrems ='/vendor/trems';

// /* -------------------------------------------------------------------------- */
// /*                                  Dashboard                                 */
// /* -------------------------------------------------------------------------- */
  static String admin ='/admin';
  static String AdminViewUsers ='/admin/users';
  static String AdminEditUsers ='/admin/users/edit';
  static String AdminViewStoress ='/admin/stores';
  static String AdminViewRequestss ='/admin/requests';
  static String AdminViewAccountss ='/admin/accounts';
  static String AdminViewStoreAccountss ='/admin/accounts/store';
  static String AdminSendNotifis ='/admin/notification';
  static String AdminViewSettingss ='/admin/ViewSettings';
  static String AdminViewRegionss ='/admin/ViewSettings/Regions';
  static String AdminViewCategoriess ='/admin/ViewSettings/Categoriess';
  static String Viewtickets ='/admin/supporting/view';
  static String AdminTickets ='/admin/supporting/update';



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
      editstore : (context) => EditStore(),
      storeDiscounts : (context) => MainDiscounts(),
      admin : (context) => MainAdmin(),
      AdminViewUsers : (context) => AdminViewUser(),
      AdminEditUsers : (context) => AdminEditUser(),
      AdminViewStoress : (context) => AdminViewStores(),
      AdminViewRequestss : (context) => AdminViewRequests(),
      AdminViewAccountss : (context) => AdminViewAccounts(),
      AdminViewStoreAccountss : (context) => AdminViewStoreAccounts(),
      AdminSendNotifis : (context) => AdminSendNotifi(),
      AdminViewSettingss : (context) => AdminViewSettings(),
      AdminViewRegionss : (context) => AdminViewRegions(),
      AdminViewCategoriess : (context) => AdminViewCategories(),
      VENDORTrems : (context) => VendorTrems(),
      UserTremss : (context) => UserTrems(),
      vendorsStoreDetails : (context) => StoreDetails(),
      MainSupport : (context) => MainSupporting(),
      MainSupportreport : (context) => MainSupportingRepor(),
      SupportTicket : (context) => MHTicket(),
    Viewtickets : (context) => MainAdminSupporting(),
      AdminTickets : (context) => MHAdminTicket(),
      
      
    };
  }

static MaterialPageRoute unknownRoute(RouteSettings settings) {
  print('Unknown route: ${settings.name}');
  return MaterialPageRoute(
    builder: (context) => ErrorScreen(),
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
