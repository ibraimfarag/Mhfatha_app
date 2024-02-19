import 'dart:async';

import 'package:flutter/services.dart';
import 'package:mhfatha/settings/imports.dart';
import 'package:permission_handler/permission_handler.dart';

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

  // Call validateToken method from the api class every 10 seconds
  timer = Timer.periodic(Duration(seconds: 30), (timer) async {
    // Get the context
    BuildContext context = navigatorKey.currentContext!;
    // Call the validateToken method
    dynamic result = await Api().validateToken(context);
    bool isEnglish = Provider.of<AppState>(context, listen: false).isEnglish;
    bool isAuthenticated = Provider.of<AuthProvider>(context, listen: false).isAuthenticated;
        if (isAuthenticated) {
              if (result is Map<String, dynamic>) {
                bool success = result['success'];
                String? message = result['message']; // Make message nullable

                if (success) {
                  // print('Token is valid!');
                } else {
                  // print('Token is invalid!');
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(isEnglish ? 'Invalid' : 'خطأ'),
                        content: Text(message ??
                            'Unknown error'), // Provide a default message if message is null
                        actions: [
                          TextButton(
                            onPressed: () {
                              Provider.of<AuthProvider>(context, listen: false).logout();
                              Navigator.pop(context);
                            },
                            child: Text(isEnglish ? 'OK' : 'حسنا'),
                          ),
                        ],
                      );
                    },
                  );
                }
              } else {
                // print('Failed to validate token.');
              }
              }

    // print('helloooooooooooooooo');
  });
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
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color(
          0xFF080E27), // Set your desired status bar background color here
      statusBarBrightness:
          Brightness.light, // Set the status bar text color to dark
      statusBarIconBrightness:
          Brightness.light, // Set the status bar icon color to light
    ));
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
          return child!;
        },
        // navigatorKey: GlobalKey(),
      ); //matrial
    });
  }

  void _navigateTo(BuildContext context, String route) {
    Navigator.of(context).pushNamed(route);
  }
}
