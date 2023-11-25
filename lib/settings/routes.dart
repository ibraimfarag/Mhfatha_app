// lib\settings\routes.dart
import 'package:mhfatha/settings/imports.dart';

class Routes {
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      login: (context) => const LoginScreen(),
      register: (context) => const RegisterScreen(),
      home: (context) => const HomeScreen(),
    };
  }

  static MaterialPageRoute unknownRoute(RouteSettings settings) {
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
        title: const Text('Error'),
      ),
      body: Center(
        child: const Text('Page not found'),
      ),
    );
  }
}
