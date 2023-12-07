import 'package:mhfatha/settings/imports.dart';
import 'package:permission_handler/permission_handler.dart';




// Function to request location permissions
Future<void> requestLocationPermission() async {
  var status = await Permission.location.request();
  if (status.isGranted) {
    // Location permission granted, you can proceed with location access
  } else {
    // Location permission denied
    // Handle the case where the user denies location permissions
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Future.wait([
    SharedPreferences.getInstance(),
  ]);
  

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AppState()),
        ChangeNotifierProvider(create: (context) => DarkModeProvider()), // Add DarkModeProvider
        ChangeNotifierProvider(create: (context) => AuthProvider()), // Add DarkModeProvider
      ],
      child: MhfathaApp(),
    ),
  );
}

class MhfathaApp extends StatefulWidget {
  const MhfathaApp({Key? key}) : super(key: key);

  @override
  State<MhfathaApp> createState() => _MhfathaAppState();
}

class _MhfathaAppState extends State<MhfathaApp> {
  // Assume you have a variable to track the selected language
  @override
  void initState() {
    super.initState();
    Provider.of<AuthProvider>(context, listen: false).loadAuthData();
  }
  @override
  Widget build(BuildContext context) {
    Provider.of<AppState>(context, listen: false).loadLanguage();
    bool isEnglish = Provider.of<AppState>(context, listen: false).isEnglish;

    return Consumer<AppState>(
      builder: (context, appState, child) {
        return MaterialApp(
      title: 'Mhfatha',
        theme: ThemeData.light().copyWith(
          
        primaryColor: Colors.red, // Change the primary color
        hintColor: const Color.fromARGB(255, 58, 52, 2), // Change the accent color
        scaffoldBackgroundColor: Colors.white, // Change the background color
        // Add more color customizations as needed

        
      ),

          darkTheme: ThemeData.dark(),
          themeMode: appState.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      debugShowCheckedModeBanner: false,
  home: Builder(
            builder: (BuildContext context) {
              // Check if the user is authenticated
              AuthProvider authProvider = Provider.of<AuthProvider>(context);
              bool isAuthenticated = authProvider.isAuthenticated;

              // Return the appropriate screen based on authentication status
              return isAuthenticated ? HomeScreen() : LoginScreen();
            },
          ),
      routes: Routes.getRoutes(),
      onGenerateRoute: (settings) {
        return Routes.unknownRoute(settings);
      },
      builder: (context, child) {
        // Wrap your app with Provider here
        // Example: return MyProvider(child: child);
        return child!;
      },
      navigatorKey: GlobalKey(),
    ); //matrial
  }
  );
}


void _navigateTo(BuildContext context, String route) {
  Navigator.of(context).pushNamed(route);
}
}