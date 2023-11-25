// lib\screens\Auth\register_screen.dart

import 'package:mhfatha/settings/imports.dart';


class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Center(
        child: const Text('Register Screen'),
      ),
    );
  }
}
