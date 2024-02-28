import 'dart:async';

import 'package:flutter/services.dart';
import 'package:mhfatha/settings/imports.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:yaml/yaml.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path/path.dart' as path;

import 'dart:io';

// Function to request location permissions
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Future.wait([
    SharedPreferences.getInstance(),
  ]);

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Request notification permissions
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  // Initialize flutter_local_notifications
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

// For iOS
  const DarwinInitializationSettings initializationSettingsIOS =
      DarwinInitializationSettings();

// Initialize FlutterLocalNotificationsPlugin with both Android and iOS settings
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );

// Initialize the plugin
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // Configure Firebase message handler
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    // Handle the received message
    _handleFirebaseMessage(message, flutterLocalNotificationsPlugin);
  });

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AppState(context)),
        ChangeNotifierProvider(create: (context) => DarkModeProvider()),
        ChangeNotifierProvider(create: (context) => AuthProvider()),
      ],
      child: MhfathaApp(),
    ),
  );
  late Timer timer;

  timer = Timer.periodic(Duration(seconds: 10), (timer) async {
    // Get the context outside the async function
    BuildContext? context = navigatorKey.currentContext;

    // Check if context is null to avoid errors
    if (context != null) {
      // Call the validateToken method
      dynamic result = await Api().validateToken(context);
      bool isEnglish = Provider.of<AppState>(context, listen: false).isEnglish;
      bool isAuthenticated =
          Provider.of<AuthProvider>(context, listen: false).isAuthenticated;

      if (isAuthenticated) {
        if (result is Map<String, dynamic>) {
          bool success = result['success'];
          String? message = result['message'];

          if (success) {
            // Token is valid
          } else {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(isEnglish ? 'Invalid' : 'خطأ'),
                  content: Text(message ?? 'Unknown error'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Provider.of<AuthProvider>(context, listen: false)
                            .logout();
                        Navigator.pop(context);

                        // Delay navigation to ensure the dialog is closed

                        Navigator.pushNamed(context, '/login');
                      },
                      child: Text(isEnglish ? 'OK' : 'حسنا'),
                    ),
                  ],
                );
              },
            );
          }
        }
      }
    }
  });


checkAndUpdateVersion();

}
Future<void> checkAndUpdateVersion() async {
  // Read YAML version
  final yamlString = await rootBundle.loadString('pubspec.yaml');
  final parsedYaml = loadYaml(yamlString);
  String currentVersion = parsedYaml['version'];
  print('Current YAML Version: $currentVersion');

  // Determine platform
  String platform = Platform.isAndroid ? 'Android' : 'iOS';
  print('Platform: $platform');

  // Check API version
  final Map<String, dynamic> versionData = await Api().checkVersion(platform);

  // Extract API version and required fields
  String apiVersion = versionData['version'];
  bool required = versionData['required'];
  print('API Version: $apiVersion');
  print('Required: $required');

  // Determine if English language is used
  bool isEnglish = Provider.of<AppState>(navigatorKey.currentContext!, listen: false).isEnglish;

  // Perform actions based on the version information
  if (apiVersion.compareTo(currentVersion) > 0 ) {
    // If API version is greater than current version and update is not required
    // Display a popup with the API version
showDialog(
  context: navigatorKey.currentContext!,
  barrierDismissible: !required, // Prevent dismissing the dialog if update is required
  builder: (BuildContext context) {
    return Directionality(
      textDirection: isEnglish ? TextDirection.ltr : TextDirection.rtl,
      child: AlertDialog(
        title: Text(
          isEnglish ? 'New Version Available' : 'إصدار جديد متاح',
          textDirection: isEnglish ? TextDirection.ltr : TextDirection.rtl,
        ),
        content: Text(
          isEnglish ? 'A new version ($apiVersion) is available.' : 'الإصدار الجديد ($apiVersion) متاح.',
          textDirection: isEnglish ? TextDirection.ltr : TextDirection.rtl,
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(isEnglish ? 'Update' : 'تحديث'),
          ),
        ],
      ),
    );
  },
);

    // Show a local notification with the API version
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'new_version_notification_channel',
      'New Version Notification',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      isEnglish ? 'New Version Available' : 'إصدار جديد متاح',
      isEnglish ? 'A new version ($apiVersion) is available.' : 'الإصدار الجديد ($apiVersion) متاح.',
      platformChannelSpecifics,
    );
  } else {
    // If update is not required or the API version is not greater than current version
    // Continue with app initialization
  }
}




Future<void> _handleFirebaseMessage(RemoteMessage message,
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
  // Extract notification details from the message
  final String? title = message.notification?.title;
  final String? body = message.notification?.body;

  if (title != null && body != null) {
    // Show the notification using flutter_local_notifications
    await _showNotification(flutterLocalNotificationsPlugin, title, body);
  }
}

Future<void> _showNotification(
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
    String title,
    String body) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'firebase_notification_channel_id',
    'Firebase Notifications',
    importance: Importance.max,
    priority: Priority.high,
// sound: RawResourceAndroidNotificationSound('wrong.mp3'),
    icon: '@mipmap/launcher_icon', // Specify custom icon here
    ticker: 'ticker',
  );

  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.show(
    0,
    title,
    body,
    platformChannelSpecifics,
    payload: 'Firebase Notification',
  );
}

class MhfathaApp extends StatefulWidget {
  const MhfathaApp({Key? key}) : super(key: key);

  @override
  State<MhfathaApp> createState() => _MhfathaAppState();
}

class _MhfathaAppState extends State<MhfathaApp> {
  final PushNotificationService _notificationService =
      PushNotificationService();

  @override
  void initState() {
    super.initState();
    Provider.of<AuthProvider>(context, listen: false).loadAuthData();
  }

  @override
  Widget build(BuildContext context) {
    _notificationService.initialize();

    Provider.of<AppState>(context, listen: false).loadLanguage();
    bool isEnglish = Provider.of<AppState>(context, listen: false).isEnglish;

    return Consumer<AppState>(builder: (context, appState, child) {
      return MaterialApp(
        navigatorKey: navigatorKey,
        title: 'Mhfatha',
        theme: ThemeData.light().copyWith(
          primaryColor: Colors.red, // Change the primary color
          hintColor:
              const Color.fromARGB(255, 58, 52, 2), // Change the accent color
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
          return Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(0),
              child: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Color(0xFF080E27),
                elevation: 0,
                //   systemOverlayStyle: SystemUiOverlayStyle(
                //     statusBarColor: Color(0xFF080E27),
                //     statusBarIconBrightness: Brightness.light,
                //   ),
              ),
            ),
            body: child,
          );
        },
        // navigatorKey: GlobalKey(),
      ); //matrial
    });
  }

  void _navigateTo(BuildContext context, String route) {
    Navigator.of(context).pushNamed(route);
  }
}
