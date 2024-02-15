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
  final InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);
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
}

Future<void> _handleFirebaseMessage(
    RemoteMessage message, FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
  // Extract notification details from the message
  final String? title = message.notification?.title;
  final String? body = message.notification?.body;

  if (title != null && body != null) {
    // Show the notification using flutter_local_notifications
    await _showNotification(flutterLocalNotificationsPlugin, title, body);
  }
}

Future<void> _showNotification(
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin, String title, String body) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'firebase_notification_channel_id',
    'Firebase Notifications',
    importance: Importance.max,
    priority: Priority.high,
    // sound: RawResourceAndroidNotificationSound('your_custom_sound'), // Specify custom sound here
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
  final PushNotificationService _notificationService = PushNotificationService();


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

    return Consumer<AppState>(
      builder: (context, appState, child) {
        return MaterialApp(
                    navigatorKey: navigatorKey,

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
      // navigatorKey: GlobalKey(),
    ); //matrial
  }
  );
}


void _navigateTo(BuildContext context, String route) {
  Navigator.of(context).pushNamed(route);
}
}