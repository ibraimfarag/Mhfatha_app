// lib\settings\routes.dart

import 'package:mhfatha/settings/imports.dart';
class Routes {
  // Route definitions
  static String login = '/login';
  static String register = '/register';
  static String home = '/home';
  static String settings = '/settings';
  static String storeInfo = '/store-info';
  static String qrscanner = '/qr-scanner';
  static String qrresponse = '/qr-response';
  static String getDiscount = '/get-discount';
  static String nearby = '/nearby';
  static String report = '/report';
  static String request = '/requests';
  static String nonetwork = '/nonet';
  static String account = '/account';
  static String filteredStores = '/filteredStores';
  static String changePasswword = '/changePasswword';
  static String restPassword = '/restpassword';
  static String UserTremss = '/user/trems';
  static String MainSupport = '/support';
  static String MainSupportreport = '/support/report';
  static String SupportTicket = '/support/ticket';
  static String vendorsMain = '/mainstores';
  static String vendorsStoreDetails = '/storedetails';
  static String createstore = '/createstore';
  static String editstore = '/editstore';
  static String storeDiscounts = '/storediscounts';
  static String VENDORTrems = '/vendor/trems';
  static String admin = '/admin';
  static String AdminViewUsers = '/admin/users';
  static String AdminEditUsers = '/admin/users/edit';
  static String AdminViewStoress = '/admin/stores';
  static String AdminViewRequestss = '/admin/requests';
  static String AdminViewAccountss = '/admin/accounts';
  static String AdminViewStoreAccountss = '/admin/accounts/store';
  static String AdminSendNotifis = '/admin/notification';
  static String AdminViewSettingss = '/admin/ViewSettings';
  static String AdminViewRegionss = '/admin/ViewSettings/Regions';
  static String AdminViewCategoriess = '/admin/ViewSettings/Categoriess';
  static String Viewtickets = '/admin/supporting/view';
  static String AdminTickets = '/admin/supporting/update';

  static Map<String, WidgetBuilder> getRoutes(BuildContext context) {
    return {
      // Routes that do not require authentication
      login: (context) => LoginScreen(),
      register: (context) => RegisterScreen(),
      home: (context) => HomeScreen(),
      storeInfo: (context) => StoreInfoScreen(),
      nearby: (context) => NearBy(),
      nonetwork: (context) => Nointernet(),
      filteredStores: (context) => FiteredStroes(),
      settings: (context) => SettingsScreen(),

      // Routes that require authentication
      qrscanner: (context) => RouteGuard(screen: QrScanner()),
      qrresponse: (context) => RouteGuard(screen: QrResponse(responseData: '')),
      getDiscount: (context) => RouteGuard(screen: GetDiscount()),
      report: (context) => RouteGuard(screen: ReportScreen()),
      request: (context) => RouteGuard(screen: RequestsScreen()),
      account: (context) => RouteGuard(screen: AccountScreen()),
      changePasswword: (context) => RouteGuard(screen: ChangePassword()),
      restPassword: (context) => RouteGuard(screen: RestPassword()),
      vendorsMain: (context) => RouteGuard(screen: MainStores()),
      createstore: (context) => RouteGuard(screen: CreateStore()),
      editstore: (context) => RouteGuard(screen: EditStore()),
      storeDiscounts: (context) => RouteGuard(screen: MainDiscounts()),
      admin: (context) => RouteGuard(screen: MainAdmin()),
      AdminViewUsers: (context) => RouteGuard(screen: AdminViewUser()),
      AdminEditUsers: (context) => RouteGuard(screen: AdminEditUser()),
      AdminViewStoress: (context) => RouteGuard(screen: AdminViewStores()),
      AdminViewRequestss: (context) => RouteGuard(screen: AdminViewRequests()),
      AdminViewAccountss: (context) => RouteGuard(screen: AdminViewAccounts()),
      AdminViewStoreAccountss: (context) => RouteGuard(screen: AdminViewStoreAccounts()),
      AdminSendNotifis: (context) => RouteGuard(screen: AdminSendNotifi()),
      AdminViewSettingss: (context) => RouteGuard(screen: AdminViewSettings()),
      AdminViewRegionss: (context) => RouteGuard(screen: AdminViewRegions()),
      AdminViewCategoriess: (context) => RouteGuard(screen: AdminViewCategories()),
      VENDORTrems: (context) => RouteGuard(screen: VendorTrems()),
      UserTremss: (context) => RouteGuard(screen: UserTrems()),
      vendorsStoreDetails: (context) => RouteGuard(screen: StoreDetails()),
      MainSupport: (context) => RouteGuard(screen: MainSupporting()),
      MainSupportreport: (context) => RouteGuard(screen: MainSupportingRepor()),
      SupportTicket: (context) => RouteGuard(screen: MHTicket()),
      Viewtickets: (context) => RouteGuard(screen: MainAdminSupporting()),
      AdminTickets: (context) => RouteGuard(screen: MHAdminTicket()),
    };
  }

  static MaterialPageRoute unknownRoute(RouteSettings settings) {
    print('Unknown route: ${settings.name}');
    return MaterialPageRoute(
      builder: (context) => HomeScreen(),
    );
  }
}

class RouteGuard extends StatelessWidget {
  final Widget screen;

  RouteGuard({required this.screen});

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);
    bool isAuthenticated = authProvider.isAuthenticated;

    if (isAuthenticated) {
      return screen;
    } else {
      return LoginScreen();
    }
  }
}

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Error'),
      ),
      body: Center(
        child: Text('Page not found'),
      ),
    );
  }
}
