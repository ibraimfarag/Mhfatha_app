// lib\screens\Auth\login_screen.dart

import 'package:intl/intl.dart';
import 'package:mhfatha/settings/imports.dart';
import 'package:flutter/cupertino.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  Color colors = Color.fromARGB(220, 255, 255, 255);
  Color backgroundColor = Color(0xFF05204a);
  String selectedGender = 'male'; // Default gender selection
  DateTime? selectedDate;
// Declare variables to store selected region and city

  String selectedRegion = 'riyadh';

  


  @override
  Widget build(BuildContext context) {
    bool isEnglish = Provider.of<AppState>(context).isEnglish;
    Size size = MediaQuery.of(context).size;
  
    return DirectionalityWrapper(
      child: Scaffold(

        body: Stack(
          children: [
          Positioned.fill(
            child: Image.asset(
              'assets/backgound.png', // Replace with your image path
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  // Background Image
                  SizedBox(
                    height: 20,
                  ),
                  Positioned(
                    top: 40,
                    right: 20,
                    child: Container(
                      decoration: BoxDecoration(
                        // color: backgroundColor,
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
                       
                        //             IconButton(
                        //   icon: Icon(Icons.arrow_back),
                        //   onPressed: () {
                        //     // Handle the back button press
                        //     Navigator.pop(context);
                        //   },
                        // ),
                        ],
                      ),
                    ),
                  ),

                  Column(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      Image.asset(
                        'images/logo.png', // Replace with the path to your image
                        height: 20, // Adjust the height as needed
                        // width: 100, // Adjust the width as needed
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        isEnglish
                            ? 'time to get discounts'
                            : 'وقت الحصول على الخصومات',
                        style: TextStyle(
                            color: Colors.grey.shade500, fontSize: 16),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      // /* -------------------------------------------------------------------------- */
                      // /* ------------------------------- field name ------------------------------- */
                      // /* -------------------------------------------------------------------------- */
                      Container(
                        margin: EdgeInsets.fromLTRB(
                            45, 0, 45, 0), // Adjust the padding as needed
                        alignment: isEnglish
                            ? Alignment.centerLeft
                            : Alignment.centerRight,
                        child: Text(
                          isEnglish ? 'Name' : 'الاسم',
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
                            fillColor: backgroundColor,
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
                      // /* -------------------------------------------------------------------------- */
                      // /* ------------------------------- family name ------------------------------- */
                      // /* -------------------------------------------------------------------------- */
                      Container(
                        margin: EdgeInsets.fromLTRB(
                            45, 0, 45, 0), // Adjust the padding as needed
                        alignment: isEnglish
                            ? Alignment.centerLeft
                            : Alignment.centerRight,
                        child: Text(
                          isEnglish ? 'Family ' : ' العائلة',
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
                            fillColor: backgroundColor,
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
                      // /* -------------------------------------------------------------------------- */
                      // /* ---------------------------- Gender selection ---------------------------- */
                      // /* -------------------------------------------------------------------------- */
                      Container(
                        margin: EdgeInsets.only(
                            left: 40,
                            right: 40,
                            top: 10), // Adjust the margin as needed
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              isEnglish ? 'Gender: ' : 'الجنس: ',
                              style: TextStyle(
                                color: colors,
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            Radio(
                              value: 'male',
                              groupValue: selectedGender,
                              onChanged: (value) {
                                setState(() {
                                  selectedGender = value.toString();
                                });
                              },
                            ),
                            Text(
                              isEnglish ? 'Male' : 'ذكر',
                              style: TextStyle(color: colors, fontSize: 16),
                            ),
                            Radio(
                              value: 'female',
                              groupValue: selectedGender,
                              onChanged: (value) {
                                setState(() {
                                  selectedGender = value.toString();
                                });
                              },
                            ),
                            Text(
                              isEnglish ? 'Female' : 'أنثى',
                              style: TextStyle(color: colors, fontSize: 16),
                            ),
                          ],
                        ),
                      ),

                      // /* -------------------------------------------------------------------------- */
                      // /* ---------------------------- Birthday selection ---------------------------- */
                      // /* -------------------------------------------------------------------------- */
                      Container(
                        margin: EdgeInsets.only(
                            left: 40,
                            right: 40,
                            top: 10), // Adjust the margin as needed
                        // padding: EdgeInsets.symmetric(horizontal: 16), // Adjust padding as needed
                        // decoration: BoxDecoration(
                        //   color: backgroundColor, // Set the background color for the entire container
                        //   borderRadius: BorderRadius.circular(10), // Make it circular
                        // ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isEnglish ? 'Birthday: ' : 'تاريخ الميلاد: ',
                              style: TextStyle(
                                color: colors,
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            SizedBox(height: 8), // Adjust the height as needed
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  width: 200,
                                  decoration: BoxDecoration(
                                    color:
                                        backgroundColor, // Set the background color for the button
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      DateTime? pickedDate =
                                          await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(1900),
                                        lastDate: DateTime.now(),
                                      );

                                      if (pickedDate != null &&
                                          pickedDate != selectedDate) {
                                        setState(() {
                                          selectedDate = pickedDate;
                                        });
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors
                                          .transparent, // Set the button color to transparent
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: Text(
                                      isEnglish ? 'Pick a Date' : 'اختر تاريخ',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8),
                                selectedDate != null
                                    ? Text(
                                        ' ${DateFormat('yyyy-MM-dd').format(selectedDate!)}',
                                        style: TextStyle(color: colors),
                                      )
                                    : Container(),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // /* -------------------------------------------------------------------------- */
                      // /* ----------------------------- city and region ---------------------------- */
                      // /* -------------------------------------------------------------------------- */

                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                                RegionSelection(
            onRegionSelected: (region) {
              setState(() {
                selectedRegion = region;
              });
            },
          ),
                            ],
                          ),
                        
                        ],
                      ),
                      SizedBox(
                        height: 24,
                      ),
// /* -------------------------------------------------------------------------- */
                      // /* ---------------------------------- email --------------------------------- */
// /* -------------------------------------------------------------------------- */
                      Container(
                        margin: EdgeInsets.fromLTRB(
                            45, 0, 45, 0), // Adjust the padding as needed

                        alignment: isEnglish
                            ? Alignment.centerLeft
                            : Alignment.centerRight,
                        child: Text(
                          isEnglish ? "Mail" : "البريد الالكتروني",
                          style: TextStyle(
                              color: colors,
                              fontSize: 16,
                              fontWeight: FontWeight.normal),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 40, right: 40),
                        child: TextField(
                          style: TextStyle(fontSize: 16, color: Colors.white),
                          decoration: InputDecoration(
                            hintStyle: TextStyle(color: Colors.grey.shade700),
                            filled: true,
                            fillColor: backgroundColor,
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

// /* -------------------------------------------------------------------------- */
// /* ------------------------------ Mobile Number ----------------------------- */
// /* -------------------------------------------------------------------------- */
                      Container(
                        margin: EdgeInsets.fromLTRB(
                            45, 0, 45, 0), // Adjust the padding as needed

                        alignment: isEnglish
                            ? Alignment.centerLeft
                            : Alignment.centerRight,
                        child: Text(
                          isEnglish ? "Mobile Number" : "رقم الجوال",
                          style: TextStyle(
                              color: colors,
                              fontSize: 16,
                              fontWeight: FontWeight.normal),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 40, right: 40),
                        child: TextField(
                          style: TextStyle(fontSize: 16, color: Colors.white),
                          decoration: InputDecoration(
                            hintStyle: TextStyle(color: Colors.grey.shade700),
                            filled: true,
                            fillColor: backgroundColor,
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

// /* -------------------------------------------------------------------------- */
// /* ------------------------------ Pssword ----------------------------- */
// /* -------------------------------------------------------------------------- */
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
                        height: 10,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 40, right: 40),
                        child: TextField(
                          style: TextStyle(fontSize: 16, color: Colors.white),
                          decoration: InputDecoration(
                            hintStyle: TextStyle(color: Colors.grey.shade700),
                            filled: true,
                            fillColor: backgroundColor,
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: backgroundColor)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: backgroundColor)),
                          ),
                        ),
                      ),

// /* -------------------------------------------------------------------------- */
// /* ------------------------------ co - Pssword ----------------------------- */
// /* -------------------------------------------------------------------------- */
                      Container(
                        margin: EdgeInsets.fromLTRB(
                            45, 0, 45, 0), // Adjust the padding as needed

                        alignment: isEnglish
                            ? Alignment.centerLeft
                            : Alignment.centerRight,
                        child: Text(
                          isEnglish ? "Confirm Password" : "تأكيد كلمة السر",
                          style: TextStyle(
                              color: colors,
                              fontSize: 16,
                              fontWeight: FontWeight.normal),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 40, right: 40),
                        child: TextField(
                          style: TextStyle(fontSize: 16, color: Colors.white),
                          decoration: InputDecoration(
                            hintStyle: TextStyle(color: Colors.grey.shade700),
                            filled: true,
                            fillColor: backgroundColor,
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

                      Row(
                        mainAxisAlignment: MainAxisAlignment
                            .end, // Align items to the start (left)
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
                                primary:
                                    backgroundColor, // Set the background color
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text(
                                isEnglish ? "SIGN UP" : "تسجيل",
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
                        height: 80,
                      ),

                    ],
                  ),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
