// lib\screens\Auth\login_screen.dart

import 'package:mhfatha/settings/imports.dart';
import 'package:flutter/cupertino.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Color backgroundColor  = Color.fromARGB(220, 255, 255, 255);
  Color ui  = Color.fromARGB(220, 233, 233, 233);
  Color colors = Color(0xFF05204a);
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  void didChangeDependencies() {
    super.didChangeDependencies();
    
  }
  @override
  Widget build(BuildContext context) {
    bool isEnglish = Provider.of<AppState>(context).isEnglish;
    Size size = MediaQuery.of(context).size;
    bool isDark = Provider.of<AppState>(context).isDarkMode;

    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);

    return DirectionalityWrapper(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage( isDark?'images/assse.png':'images/abstract.jpg'),
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
      color: isDark ? Color.fromARGB(251, 34, 34, 34) : Color(0xFFF0F0F0),
      borderRadius: BorderRadius.circular(15),
      boxShadow: [
        BoxShadow(
          color: isDark
              ? Color.fromARGB(250, 17, 17, 17)
              : Colors.grey.withOpacity(0.5),
          spreadRadius: 5,
          blurRadius: 7,
          offset: Offset(0, 3),
        ),
      ],
    ),
    padding: EdgeInsets.all(1),
    child: Row(
      children: [
        PopupMenuButton<String>(
          icon: Icon(Icons.language, color: colors),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          onSelected: (String value) {
            if ((value == 'en' && !isEnglish) || (value == 'ar' && isEnglish)) {
              Provider.of<AppState>(context, listen: false).toggleLanguage();
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
                      'images/logoDark.png', // Replace with the path to your image
                      height: 50, // Adjust the height as needed
                      // width: 100, // Adjust the width as needed
                    )),
                    SizedBox(
                      height: 10,
                    ),
                    FadeOut(
                      child: Text(
                        isEnglish
                            ? 'for discounts'
                            : 'وقت الحصول على الخصومات',
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
                                  : '  البريد الالكتروني او رقم الجوال',
                              style: TextStyle(
                                  color: colors,
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal),
                            ),
                          ),
                          SizedBox(height: 8), // Adjust the height as needed
                          Container(   decoration: BoxDecoration(
                                color: isDark? Color.fromARGB(251, 34, 34, 34):Color(0xFFF0F0F0),
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: [
                                  BoxShadow(
                                    color:isDark? Color.fromARGB(250, 17, 17, 17): Colors.grey.withOpacity(0.5),
                                    spreadRadius:
                                        5, // Negative spreadRadius makes the shadow inside
                                    blurRadius: 7,
                                    offset: Offset(0,
                                        3), // changes the position of the shadow
                                  ),
                                ],
                              ),
                            margin: EdgeInsets.only(left: 40, right: 40),
                            child: TextField(
                              controller: _emailController,
                              style:
                                  TextStyle(fontSize: 16, color: colors),
                              decoration: InputDecoration(
                                hintStyle:
                                    TextStyle(color: Colors.grey.shade700),
                                filled: true,
                                fillColor: ui,
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide:
                                        BorderSide(color: backgroundColor)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
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
                              isEnglish ? "Password" : "كلمة المرور",
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
                               decoration: BoxDecoration(
                                color: isDark? Color.fromARGB(251, 34, 34, 34):Color(0xFFF0F0F0),
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: [
                                  BoxShadow(
                                    color:isDark? Color.fromARGB(250, 17, 17, 17): Colors.grey.withOpacity(0.5),
                                    spreadRadius:
                                        5, // Negative spreadRadius makes the shadow inside
                                    blurRadius: 7,
                                    offset: Offset(0,
                                        3), // changes the position of the shadow
                                  ),
                                ],
                              ),
                            child: TextField(
                              obscureText: true,
                              controller: _passwordController,
                              style:
                                  TextStyle(fontSize: 16, color: colors),
                              decoration: InputDecoration(
                                hintStyle:
                                    TextStyle(color: Colors.grey.shade700),
                                filled: true,
                                fillColor: ui,
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide:
                                        BorderSide(color: backgroundColor)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
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
                      child:GestureDetector(
                            onTap: () {
                              // Navigate to the register screen when the text is tapped
                              Navigator.pushNamed(context, '/restpassword');
                            },
                            child:  Text(
                        isEnglish ? "Forgot Password?" : "هل نسيت كلمة المرور ؟",
                        style: TextStyle(
                            color: colors,
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      ),
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
                               decoration: BoxDecoration(
                                color: isDark? Color.fromARGB(251, 34, 34, 34):Color(0xFFF0F0F0),
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: [
                                  BoxShadow(
                                    color:isDark? Color.fromARGB(250, 17, 17, 17): Colors.grey.withOpacity(0.5),
                                    spreadRadius:
                                        5, // Negative spreadRadius makes the shadow inside
                                    blurRadius: 7,
                                    offset: Offset(0,
                                        3), // changes the position of the shadow
                                  ),
                                ],
                              ),
                            height: 50,
                            // width: 100,
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
                                    ui, // Set the background color
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: Text(
                                isEnglish ? "SIGN IN" : "دخول",
                                style: TextStyle(
                                  color: colors,
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
                                color: colors,
                                // decoration: TextDecoration
                                //     .underline,
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
