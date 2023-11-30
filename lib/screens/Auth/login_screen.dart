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

  @override
  Widget build(BuildContext context) {
    bool isEnglish = Provider.of<AppState>(context).isEnglish;
    Size size = MediaQuery.of(context).size;

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
                    Image.asset(
                      'images/logo.png', // Replace with the path to your image
                      height: 50, // Adjust the height as needed
                      // width: 100, // Adjust the width as needed
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      isEnglish
                          ? 'time to get discounts'
                          : 'وقت للحصول على الخصومات',
                      style:
                          TextStyle(color: Colors.grey.shade500, fontSize: 16),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Container(
                      margin:  EdgeInsets.fromLTRB ( 45, 0, 45, 0), // Adjust the padding as needed

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
                        style: TextStyle(fontSize: 16, color: Colors.white),
                        decoration: InputDecoration(
                          hintStyle: TextStyle(color: Colors.grey.shade700),
                          filled: true,
                          fillColor:  backgroundColor,
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: backgroundColor)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: backgroundColor)),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                      Container(
                      margin:  EdgeInsets.fromLTRB ( 45, 0, 45, 0), // Adjust the padding as needed

                      alignment: isEnglish
                          ? Alignment.centerLeft
                          : Alignment.centerRight,
                      child: Text(
                        isEnglish
                            ?  "Password" : "كلمة السر",
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

                        style: TextStyle(fontSize: 16, color: Colors.white),
                        decoration: InputDecoration(
                          hintStyle: TextStyle(color: Colors.grey.shade700),
                          filled: true,
                          fillColor:backgroundColor,
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: backgroundColor)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: backgroundColor)),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                      Container(
                      margin:  EdgeInsets.fromLTRB ( 45, 0, 45, 0), // Adjust the padding as needed

                      alignment: isEnglish
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Text(
                        isEnglish
                            ? "Forgot Password?" : "هل نسيت كلمة السر ؟",
                        style: TextStyle(
                            color: colors,
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
Row(
  mainAxisAlignment: MainAxisAlignment.end, // Align items to the start (left)
  children: [
    Container(
      height: 50,
      width: 100,
      margin: EdgeInsets.only(left: 40, right: 40),
      child: ElevatedButton(
        onPressed: () {
          // Implement your logic when the button is pressed
        },
        style: ElevatedButton.styleFrom(
          primary: backgroundColor, // Set the background color
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
                    SizedBox(
                      height: 66,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[

                        Text(
                          isEnglish ? "create new account" : "انشاء حساب جديد",
                          style: TextStyle(color: Colors.white),
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
