// lib\screens\Auth\login_screen.dart

import 'package:mhfatha/settings/imports.dart';
import 'package:flutter/cupertino.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
Color colors = Color.fromARGB(220, 128, 202, 110);

List<String> imageList = [
  'images/login_in.png',
  'images/login_in2.png',

  // Add more image paths as needed
];


  @override
  Widget build(BuildContext context) {
    bool isEnglish = Provider.of<AppState>(context).isEnglish;
    Size size = MediaQuery.of(context).size;

    return DirectionalityWrapper(
      child: Scaffold(
      body: Stack(
        children: <Widget>[
       PageView.builder(
  itemCount: imageList.length, // Replace imageList with your list of image paths
  itemBuilder: (context, index) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(imageList[index]),
          fit: BoxFit.cover,
        ),
      ),
    );
  },
),

          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              Colors.transparent,
              Colors.transparent,
              Color(0xff161d27).withOpacity(0.9),
              Color(0xff161d27),
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          ),
Positioned(
  top: 20,
  right: 20,
  child: Container(
    decoration: BoxDecoration(
      color: Colors.black.withOpacity(0.6),
      borderRadius: BorderRadius.circular(15),
    ),
    padding: EdgeInsets.all(1),
    child: Row(
      children: [
        PopupMenuButton<String>(
          icon: Icon(Icons.language, color: Colors.white),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          onSelected: (String value) {
            if (value == 'en' || value == 'ar') {
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
        SizedBox(width: 10), // Add some spacing between language and dark mode icons
        IconButton(
          icon: Icon(
            Icons.nightlight_round, // You can replace this with your dark mode icon
            color: Colors.white,
          ),
          onPressed: () {
            // Implement logic to toggle dark mode
            Provider.of<AppState>(context, listen: false).toggleDarkMode();
          },
        ),
      ],
    ),
  ),
),

          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                    Image.asset(
                    'images/logo.png', // Replace with the path to your image
                    height: 40, // Adjust the height as needed
                    // width: 100, // Adjust the width as needed
                  ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  isEnglish ? 'time to get discounts, Sign in' : 'وقت للحصول على الخصومات, سجل دخولك الان',
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 16),
                ),
             
                SizedBox(
                  height: 20,
                ),
                Container(
                  height: 50,
                  margin: EdgeInsets.only(left: 40, right: 40),
                  child: TextField(
                    style: TextStyle(fontSize: 16, color: Colors.white),
                    decoration: InputDecoration(
                      hintText: isEnglish ?"Email or mobile number":"البريد الالكتروني او رقم الجوال",
                      hintStyle: TextStyle(color: Colors.grey.shade700),
                      filled: true,
                      fillColor: Color(0xff161d27).withOpacity(0.9),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: colors)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: colors)),
                    ),
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Container(
                  height: 50,
                  margin: EdgeInsets.only(left: 40, right: 40),
                  child: TextField(
                    obscureText: true,
                    style: TextStyle(fontSize: 16, color: Colors.white),
                    decoration: InputDecoration(
                      hintText: isEnglish ?"Password":"كلمة السر",
                      hintStyle: TextStyle(color: Colors.grey.shade700),
                      filled: true,
                      fillColor: Color(0xff161d27).withOpacity(0.9),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: colors)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: colors)),
                    ),
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Text(
                   isEnglish ?"Forgot Password?":"هل نسيت كلمة السر ؟",
                  style: TextStyle(
                      color: colors, fontSize: 14, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20,
                ),
Container(
  height: 50,
  width: double.infinity,
  margin: EdgeInsets.only(left: 40, right: 40),
  child: ElevatedButton(
    onPressed: () {
      // Implement your logic when the button is pressed
    },
    style: ElevatedButton.styleFrom(
      primary: colors, // Set the background color
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
    ),
    child: Text(
      isEnglish?"SIGN IN":"تسجيل الدخول",
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    ),
  ),
),
SizedBox(
  height: 16,
),                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                     isEnglish? "create new account":"انشاء حساب جديد",
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ],
      ),
    ),
    );
  }

  
}
