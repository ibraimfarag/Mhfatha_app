import 'dart:convert';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart'
    as permission_handler;

import 'package:mhfatha/settings/imports.dart';

class AdminLayout extends StatefulWidget {
  @override
  _AdminLayoutState createState() => _AdminLayoutState();
}

class _AdminLayoutState extends State<AdminLayout> {
  

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isEnglish = Provider.of<AppState>(context, listen: false).isEnglish;
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    String authName = authProvider.user![
        'first_name']; // Replace with the actual property holding the user's name

    return DirectionalityWrapper(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
            color: Color(0xFF080E27), // Set background color to #080e27
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 5),
                  // height: 200,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 30,
                            ),
                            Text(
                              isEnglish ? '' : '',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            Text(
                              isEnglish ? ' ' : ' ',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              isEnglish
                                  ? ' Total Payments'
                                  : ' اجمالي المدفوعات  ',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            Text(
                              isEnglish ? '' : '',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              isEnglish
                                  ? ' Total Savings '
                                  : ' اجمالي التوفير ',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            Text(
                              isEnglish ? ' ' : '',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Image.asset(
                              'images/Wallet.gif', // Replace with the actual path to your GIF image
                              height: 100, // Adjust the height as needed
                            ),
                          ],
                        ),
                      ]),
                ),
                SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFF3F4F7),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  child: Column(children: []),
                ),
                // Display the user discounts information
              ],
            ),
          ),
        ),
        // bottomNavigationBar: BottomNavBar(initialIndex: 1),
        bottomNavigationBar: NewNav(),
      ),
    );
  }
}
