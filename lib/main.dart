import 'package:mhfatha/settings/imports.dart';
import 'package:permission_handler/permission_handler.dart';




// Function to request location permissions

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
    double? latitude;
  double? longitude;
  @override
  void initState() {
    super.initState();
    Provider.of<AuthProvider>(context, listen: false).loadAuthData();
        _getLocation();

  }



  Future<void> _getLocation() async {
     bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the 
    // App to enable the location services.
    return Future.error('Location services are disabled.');
  }
    permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale 
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }
  
  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately. 
    return Future.error(
      'Location permissions are permanently denied, we cannot request permissions.');
  } 


  // Check if the widget is still mounted
  if (!mounted) {
    return;
  }

  // Check if locationWhenInUse permission is granted
  var status = await Permission.locationWhenInUse.status;

  if (status.isDenied) {
    // Request locationWhenInUse permission if not granted
    status = await Permission.locationWhenInUse.request();

    if (!mounted) {
      return;
    }

    if (status.isDenied) {
      // Handle case when locationWhenInUse permission is still not granted
      print('Location permission is denied.');
      return;
    }
  }

  // Check if locationAlways permission is granted

  try {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    // Check if the widget is still mounted before updating the state
    if (!mounted) {
      return;
    }

    setState(() {
      latitude = position.latitude;
      longitude = position.longitude;
    });

    // Call the method to send location when the coordinates are available
  
  } catch (e) {
    print("Error getting location: $e");
  }
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