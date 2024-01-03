import 'package:mhfatha/settings/imports.dart';
import 'package:permission_handler/permission_handler.dart';




// Function to request location permissions
Future<void> requestLocationPermission() async {
     var status = await Permission.locationWhenInUse.status;
if(!status.isGranted){
  var status = await Permission.locationWhenInUse.request();
  if(status.isGranted){
    var status = await Permission.locationAlways.request();
    if(status.isGranted){
      //Do some stuff
    }else{
      //Do another stuff
    }
  }else{
    //The user deny the permission
  }
  if(status.isPermanentlyDenied){
    //When the user previously rejected the permission and select never ask again
    //Open the screen of settings
    bool res = await openAppSettings();
  }
}else{
  //In use is available, check the always in use
  var status = await Permission.locationAlways.status;
  if(!status.isGranted){
    var status = await Permission.locationAlways.request();
    if(status.isGranted){
      //Do some stuff
    }else{
      //Do another stuff
    }
  }else{
    //previously available, do some stuff or nothing
  }
}

}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
requestLocationPermission();
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
var statues = await Permission.locationAlways.status;

if (statues.isDenied) {
  // Request locationAlways permission
  status = await Permission.locationAlways.request();

  if (statues.isDenied) {
    // Handle case when locationAlways permission is still not granted
    print('Location permission for background use is denied.');
    return;
  }
}

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