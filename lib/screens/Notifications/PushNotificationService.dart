import 'package:mhfatha/settings/imports.dart';

Future<void> backgroundHandler(RemoteMessage message) async {
  print('Handling a background message ${message.messageId}');
}

class PushNotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  Future<void> initialize() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });

    FirebaseMessaging.onBackgroundMessage(backgroundHandler);

    // Get the token
    await getToken();
  }

  Future<String?> getToken() async {
    String? token = await _fcm.getToken();
    // print('Token: $token');
    return token;
  }
}
