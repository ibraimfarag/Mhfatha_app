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
      login: (context) => const LoginScreen(),
      register: (context) => const RegisterScreen(),
      home: (context) => const HomeScreen(),
      storeInfo: (context) => const StoreInfoScreen(),
      nearby: (context) => const NearBy(),
      nonetwork: (context) => const Nointernet(),
      filteredStores: (context) => const FiteredStroes(),
      settings: (context) => const SettingsScreen(),
      restPassword: (context) => const RestPassword(),
      qrscanner: (context) =>  const QrScanner(),
      qrresponse: (context) =>  const QrResponse(responseData: ''),

      // Routes that require authentication
      getDiscount: (context) => const RouteGuard(screen: GetDiscount()),
      report: (context) => const RouteGuard(screen: ReportScreen()),
      request: (context) => const RouteGuard(screen: RequestsScreen()),
      account: (context) => const RouteGuard(screen: AccountScreen()),
      changePasswword: (context) => const RouteGuard(screen: ChangePassword()),
      vendorsMain: (context) => const RouteGuard(screen: MainStores()),
      createstore: (context) => const RouteGuard(screen: CreateStore()),
      editstore: (context) => const RouteGuard(screen: EditStore()),
      storeDiscounts: (context) => const RouteGuard(screen: MainDiscounts()),
      admin: (context) => const RouteGuard(screen: MainAdmin()),
      AdminViewUsers: (context) => const RouteGuard(screen: AdminViewUser()),
      AdminEditUsers: (context) => const RouteGuard(screen: AdminEditUser()),
      AdminViewStoress: (context) => const RouteGuard(screen: AdminViewStores()),
      AdminViewRequestss: (context) => const RouteGuard(screen: AdminViewRequests()),
      AdminViewAccountss: (context) => const RouteGuard(screen: AdminViewAccounts()),
      AdminViewStoreAccountss: (context) => const RouteGuard(screen: AdminViewStoreAccounts()),
      AdminSendNotifis: (context) => const RouteGuard(screen: AdminSendNotifi()),
      AdminViewSettingss: (context) => const RouteGuard(screen: AdminViewSettings()),
      AdminViewRegionss: (context) => const RouteGuard(screen: AdminViewRegions()),
      AdminViewCategoriess: (context) => const RouteGuard(screen: AdminViewCategories()),
      VENDORTrems: (context) => const RouteGuard(screen: VendorTrems()),
      UserTremss: (context) => const RouteGuard(screen: UserTrems()),
      vendorsStoreDetails: (context) => const RouteGuard(screen: StoreDetails()),
      MainSupport: (context) => const RouteGuard(screen: MainSupporting()),
      MainSupportreport: (context) => const RouteGuard(screen: MainSupportingRepor()),
      SupportTicket: (context) => const RouteGuard(screen: MHTicket()),
      Viewtickets: (context) => const RouteGuard(screen: MainAdminSupporting()),
      AdminTickets: (context) => const RouteGuard(screen: MHAdminTicket()),
    };
  }

  static MaterialPageRoute unknownRoute(RouteSettings settings) {
    print('Unknown route: ${settings.name}');
    return MaterialPageRoute(
      builder: (context) => const HomeScreen(),
    );
  }
}
class RouteGuard extends StatelessWidget {
  final Widget screen;

  const RouteGuard({super.key, required this.screen});

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);
    bool isAuthenticated = authProvider.isAuthenticated;

    bool isEnglish = Provider.of<AppState>(context, listen: false).isEnglish;

    if (isAuthenticated) {
      return screen;
    } else {
      // Show a dialog with login and sign-up options
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              titlePadding: EdgeInsets.zero,
              contentPadding: const EdgeInsets.only(top: 16, bottom: 16),
              title: Stack(
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Text(
                        isEnglish ? 'Authentication Required' : 'يجب تسجيل الدخول',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      isEnglish
                          ? 'You need to be logged in to access this feature.'
                          : 'تحتاج إلى تسجيل الدخول للوصول إلى هذه الميزة.',
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pushNamed(Routes.login);
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blue,
                          onPrimary: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          isEnglish ? 'Login' : 'تسجيل الدخول',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pushNamed(Routes.register);
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.green,
                          onPrimary: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          isEnglish ? 'Sign Up' : 'تسجيل',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      });

      // Return an empty container while the dialog is being shown
      return Container();
    }
  }
}

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Error'),
      ),
      body: const Center(
        child: Text('Page not found'),
      ),
    );
  }
}
