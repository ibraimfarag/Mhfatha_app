// lib\screens\Auth\login_screen.dart

import 'package:mhfatha/settings/imports.dart';
import 'package:flutter/cupertino.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Color colors = Color.fromARGB(220, 255, 255, 255);
  Color backgroundColor = Color(0xFF05204a);
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    bool isEnglish = Provider.of<AppState>(context).isEnglish;
    Size size = MediaQuery.of(context).size;

    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);

    return DirectionalityWrapper(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/backgound.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: <Widget>[
                // Background Image

                Positioned(
                  top: 60,
                  right: 20,
                  child: Container(
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: EdgeInsets.all(1),
                    child: Row(
                      children: [
                        PopupMenuButton<String>(
                          icon: Icon(Icons.language,
                              color: Color.fromARGB(146, 255, 255, 255)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          onSelected: (String value) {
                            if (value == 'en' || value == 'ar') {
                              Provider.of<AppState>(context, listen: false)
                                  .toggleLanguage();
                            }
                          },
                          itemBuilder: (BuildContext context) {
                            return <PopupMenuEntry<String>>[
                              PopupMenuItem<String>(
                                value: 'en',
                                child: Text('English'),
                              ),
                              PopupMenuItem<String>(
                                value: 'ar',
                                child: Text('العربية'),
                              ),
                              // Add more languages as needed
                            ];
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                Column(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 150,
                    ),
                    BounceInDown(
                        child: Image.asset(
                      'images/logo.png', // Replace with the path to your image
                      height: 50, // Adjust the height as needed
                      // width: 100, // Adjust the width as needed
                    )),
                    SizedBox(
                      height: 10,
                    ),
                    FadeOut(
                      child: Text(
                        isEnglish
                            ? 'time to get discounts'
                            : 'وقت للحصول على الخصومات',
                        style: TextStyle(
                            color: Colors.grey.shade500, fontSize: 16),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    FadeInLeft(
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.fromLTRB(
                                45, 0, 45, 0), // Adjust the padding as needed

                            alignment: isEnglish
                                ? Alignment.centerLeft
                                : Alignment.centerRight,
                            child: Text(
                              isEnglish
                                  ? 'Email or mobile number'
                                  : 'البريد الالكتروني',
                              style: TextStyle(
                                  color: colors,
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal),
                            ),
                          ),
                          SizedBox(height: 8), // Adjust the height as needed
                          Container(
                            margin: EdgeInsets.only(left: 40, right: 40),
                            child: TextField(
                              controller: _emailController,
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                              decoration: InputDecoration(
                                hintStyle:
                                    TextStyle(color: Colors.grey.shade700),
                                filled: true,
                                fillColor: backgroundColor,
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide:
                                        BorderSide(color: backgroundColor)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide:
                                        BorderSide(color: backgroundColor)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    FadeInRight(
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.fromLTRB(
                                45, 0, 45, 0), // Adjust the padding as needed

                            alignment: isEnglish
                                ? Alignment.centerLeft
                                : Alignment.centerRight,
                            child: Text(
                              isEnglish ? "Password" : "كلمة السر",
                              style: TextStyle(
                                  color: colors,
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal),
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 40, right: 40),
                            child: TextField(
                              obscureText: true,
                              controller: _passwordController,
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                              decoration: InputDecoration(
                                hintStyle:
                                    TextStyle(color: Colors.grey.shade700),
                                filled: true,
                                fillColor: backgroundColor,
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide:
                                        BorderSide(color: backgroundColor)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide:
                                        BorderSide(color: backgroundColor)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(
                          45, 0, 45, 0), // Adjust the padding as needed

                      alignment: isEnglish
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Text(
                        isEnglish ? "Forgot Password?" : "هل نسيت كلمة السر ؟",
                        style: TextStyle(
                            color: colors,
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    BounceInUp(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment
                            .end, // Align items to the start (left)
                        children: [
                          Container(
                            height: 50,
                            width: 100,
                            margin: EdgeInsets.only(left: 40, right: 40),
                            child: ElevatedButton(
                              onPressed: () async {
                                // Get the values entered by the user in the email and password fields
                                String emailOrMobile = _emailController
                                    .text; // Assuming you have a TextEditingController for the email field
                                String password = _passwordController
                                    .text; // Assuming you have a TextEditingController for the password field

                                // Now you can use these values in your API call
                                Api api = Api();
                                AuthProvider authProvider =
                                    Provider.of<AuthProvider>(context,
                                        listen: false);

                                bool loginSuccess = await api.loginUser(context,
                                    authProvider, emailOrMobile, password);

                                if (loginSuccess) {
                                  // Navigate to the next screen or perform other actions
                                  print('Login successful');
                                  Navigator.pushReplacementNamed(
                                      context, '/home');
                                } else {
                                  // Handle login failure
                                  print('Login failed');
                                }

                                if (authProvider.isAuthenticated &&
                                    authProvider.user != null) {
                                  // print('User Name: ${authProvider.user!['first_name']}');
                                  // print('Token: ${authProvider.token}');
                                  print(' ${authProvider.isAuthenticated}');
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                primary:
                                    backgroundColor, // Set the background color
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text(
                                isEnglish ? "SIGN IN" : "دخول",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 45,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        FadeInUp(
                          child: GestureDetector(
                            onTap: () {
                              // Navigate to the register screen when the text is tapped
                              Navigator.pushNamed(context, '/register');
                            },
                            child: Text(
                              isEnglish
                                  ? "create new account"
                                  : "انشاء حساب جديد",
                              style: TextStyle(
                                color: Colors.white,
                                decoration: TextDecoration
                                    .underline, // Add underline to indicate it's clickable
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 0,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
