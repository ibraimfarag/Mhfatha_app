import 'package:mhfatha/settings/imports.dart';
void main() {
  runApp(const MhfathaApp());
}

class MhfathaApp extends StatelessWidget {
  const MhfathaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,

      ),
       debugShowCheckedModeBanner: false,

      home: const LoginScreen(),
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
    );
  }
}

void _navigateTo(BuildContext context, String route) {
  Navigator.of(context).pushNamed(route);
}
