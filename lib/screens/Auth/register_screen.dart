// lib\screens\Auth\login_screen.dart

import 'dart:convert';
import 'dart:io';

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
  String selectedGender = ''; // Default gender selection
  String selectedVendor = ''; // Default gender selection

  DateTime? selectedDate;
// Declare variables to store selected region and city

  String selectedRegion = '';
  String? _selectedProfileImagePath;

  TextEditingController nameController = TextEditingController();
  TextEditingController familyNameController = TextEditingController();
  TextEditingController mailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    bool isEnglish = Provider.of<AppState>(context).isEnglish;
    Size size = MediaQuery.of(context).size;
    String lang = Provider.of<AppState>(context, listen: false).display;

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
                    SizedBox(height: 20),
                    Stack(
                      children: [
                        Positioned(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            padding: EdgeInsets.all(1),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // The "العودة" button
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/login');
                                  },
                                  child: Text(
                                    isEnglish ? 'Back' : 'العودة',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),

                                // The existing language selection PopupMenuButton on the right
                                PopupMenuButton<String>(
                                  icon: Icon(Icons.language,
                                      color:
                                          Color.fromARGB(146, 255, 255, 255)),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  onSelected: (String value) {
                                    if (value == 'en' || value == 'ar') {
                                      Provider.of<AppState>(context,
                                              listen: false)
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
                        BounceInDown(
                          child: Column(
                            // mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                height: 30,
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
                              // /* ------------------------------- first name ------------------------------- */
                              // /* -------------------------------------------------------------------------- */
                              CustomTextField(
                                label: isEnglish ? 'Name' : 'الاسم',
                                controller: nameController,
                              ),

                              // /* -------------------------------------------------------------------------- */
                              // /* ------------------------------- Family Name ------------------------------ */
                              // /* -------------------------------------------------------------------------- */

                              CustomTextField(
                                label:
                                    isEnglish ? 'Family Name' : 'اسم العائلة',
                                controller: familyNameController,
                              ),
                              // /* -------------------------------------------------------------------------- */
                              // /* ----------------------------- GenderSelection ---------------------------- */
                              // /* -------------------------------------------------------------------------- */
                              GenderSelection(
                                isEnglish: isEnglish,
                                selectedGender: selectedGender,
                                onGenderSelected: (value) {
                                  setState(() {
                                    selectedGender = value;
                                  });
                                },
                              ),

                              // /* -------------------------------------------------------------------------- */
                              // /* ---------------------------- Birthday selection ---------------------------- */
                              // /* -------------------------------------------------------------------------- */
                              DatePickerWidget(
                                isEnglish: isEnglish,
                                selectedDate: selectedDate,
                                onDateSelected: (date) {
                                  setState(() {
                                    selectedDate = date;
                                  });
                                },
                                label: isEnglish
                                    ? 'Birthday: '
                                    : 'تاريخ الميلاد: ',
                              ),

                              // /* -------------------------------------------------------------------------- */
                              // /* ------------------------------ profile image ----------------------------- */
                              // /* -------------------------------------------------------------------------- */
                              ProfilePhotoWidget(
                                isEnglish: isEnglish,
                                label: isEnglish
                                    ? 'Profile photo: '
                                    : 'الصورة الشخصية: ',
                                selectPhotoText:
                                    isEnglish ? 'Select Photo' : 'اختر صورة',
                                changePhotoText:
                                    isEnglish ? 'Change Photo' : 'تغير  الصورة',
                                removeText: isEnglish ? 'Remove' : 'إزالة',
                                onPhotoSelected: (path) {
                                  setState(() {
                                    _selectedProfileImagePath = path;
                                  });
                                },
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
                              CustomTextField(
                                label: isEnglish ? 'Mail' : 'البريد الالكتروني',
                                controller: mailController,
                              ),
                              // /* -------------------------------------------------------------------------- */
                              // /* ------------------------------ Mobile Number ----------------------------- */
                              // /* -------------------------------------------------------------------------- */
                              CustomTextField(
                                label:
                                    isEnglish ? 'Mobile Number' : 'رقم الجوال',
                                controller: mobileController,
                                isNumeric: true,
                                maxLength: 10,
                              ),
                              // /* -------------------------------------------------------------------------- */
                              // /* ------------------------------ Pssword ----------------------------- */
                              // /* -------------------------------------------------------------------------- */
                              CustomTextField(
                                label: isEnglish ? 'Password' : 'كلمة السر',
                                isPassword: true,
                                controller: passwordController,
                              ),

// /* -------------------------------------------------------------------------- */
// /* ------------------------------ co - Pssword ----------------------------- */
// /* -------------------------------------------------------------------------- */
                              CustomTextField(
                                label: isEnglish
                                    ? 'Confirm Password'
                                    : 'تأكيد كلمة السر',
                                isPassword: true,
                                controller: confirmPasswordController,
                              ),
                              // /* -------------------------------------------------------------------------- */
                              // /* ------------------------------- Vendor Join ------------------------------ */
                              // /* -------------------------------------------------------------------------- */
                              VendorJoinWidget(
                                isEnglish: isEnglish,
                                labelText: isEnglish
                                    ? 'Are you want to join as Vendor?'
                                    : 'هل تريد الانضمام كـ تاجر؟',
                                yesText: isEnglish ? 'yes' : 'نعم',
                                noText: isEnglish ? 'no' : 'لا',
                                onSelectionChanged: (isVendor) {
                                  // Handle the selection
                                  setState(() {
                                    selectedVendor = isVendor
                                        ? '1'
                                        : '0'; // Set '1' for yes, '0' for no
                                  });
                                },
                              ),
                              // /* -------------------------------------------------------------------------- */
                              // /* ------------------------------ submit button ----------------------------- */
//                             // /* -------------------------------------------------------------------------- */
//     TextButton(
//       onPressed: () {
// Navigator.pushNamed(context, '/login');      },
//       child: Text(
//         isEnglish?'Back':'',
//         style: TextStyle(
//           color: Colors.white,
//           fontSize: 16,
//         ),
//       ),
//     ),

                              Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .end, // Align items to the start (left)
                                children: [
                                  Container(
                                    height: 50,
                                    width: 150,
                                    margin: EdgeInsets.only(
                                        left: 40, right: 40, top: 50),
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        // Assuming you have controllers for the registration form fields
                                        bool success = await Api().registerUser(
                                          context: context,
                                          lang: lang,
                                          firstName: nameController.text,
                                          lastName: familyNameController.text,
                                          gender: selectedGender,
                                          birthday: selectedDate != null
                                              ? DateFormat('yyyy-MM-dd')
                                                  .format(selectedDate!)
                                              : '',
                                          region: selectedRegion,
                                          mobile: mobileController.text,
                                          email: mailController.text,
                                          password: passwordController.text,
                                          confirmPasswordController:
                                              confirmPasswordController.text,
                                          isVendor: selectedVendor == '1'
                                              ? 1
                                              : 0, // Convert '1' or '0' to int
                                          // imageFile: File(_selectedProfileImagePath ??''),
                                          imageFile: _selectedProfileImagePath !=
                                                  null
                                              ? File(
                                                  _selectedProfileImagePath ??
                                                      '')
                                              : null, // Pass null if no profile image
                                        );
                                      },
                                      child: Text(
                                        isEnglish ? "REGISTER" : "تسجيل",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        primary: backgroundColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
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
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
