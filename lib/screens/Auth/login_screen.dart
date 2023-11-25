// lib\screens\Auth\login_screen.dart

import 'package:mhfatha/settings/imports.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Add your logo or image here
            // Image.asset('assets/your_logo.png', height: 100, width: 100),

            // Add some space
            SizedBox(height: 20),

            // Text field for username or email
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Username or Email',
              ),
            ),

            // Add some space
            SizedBox(height: 20),

            // Text field for password
            TextFormField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
            ),

            // Add some space
            SizedBox(height: 20),

            // Login button
            ElevatedButton(
              onPressed: () {
                // Implement your login logic here
              },
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
