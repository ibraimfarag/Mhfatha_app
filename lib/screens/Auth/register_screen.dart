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
  Color backgroundColor = Color.fromARGB(220, 255, 255, 255);
  Color ui = Color.fromARGB(220, 233, 233, 233);
  Color colors = Color(0xFF05204a);
  String selectedGender = ''; // Default gender selection
  String selectedVendor = ''; // Default gender selection

  DateTime? selectedDate;

  String? _selectedProfileImagePath;

  TextEditingController nameController = TextEditingController();
  TextEditingController familyNameController = TextEditingController();
  TextEditingController mailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  String selectedRegion = '1'; // Default region selection
  List<DropdownMenuItem<String>> regionDropdownItems = [];

  Api api = Api();
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Fetch data here
    fetchFilteredStores();
    

  }

  void fetchFilteredStores() async {
    bool isEnglish = Provider.of<AppState>(context).isEnglish;

    try {
      Map<String, dynamic>? result = await api.getRegionsAndCities(context);

      if (result != null) {
        setState(() {
          // Access the 'regions' data from the result
          List<dynamic> regions = result['regions'];

          // Clear existing items
          regionDropdownItems.clear();

          // Process each region and add a DropdownMenuItem for each
          regions.forEach((region) {
            int regionId = region['id'];
            String regionAr = region['region_ar'];
            String regionEn = region['region_en'];

            // Add a DropdownMenuItem for the current region
            regionDropdownItems.add(
              DropdownMenuItem(
                value: regionId.toString(),
                child: Text(isEnglish ? regionEn : regionAr),
              ),
            );
          });
        });
      } else {
        print('Error fetching filtered stores: Result is null');
      }
    } catch (e) {
      // Handle errors
      print('Error fetching filtered stores: $e');
    }
  }

// Variable to hold the selected region

  @override
  Widget build(BuildContext context) {
    bool isEnglish = Provider.of<AppState>(context).isEnglish;
    Size size = MediaQuery.of(context).size;
    String lang = Provider.of<AppState>(context, listen: false).display;
    bool isDark = Provider.of<AppState>(context).isDarkMode;
    

    return DirectionalityWrapper(
      child: Scaffold(
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                isDark
                    ? 'images/assse.png'
                    : 'images/abstract.jpg', // Replace with your image path
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
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/login');
                                  },
                                  child: Text(
                                    isEnglish ? 'Back' : 'العودة',
                                    style: TextStyle(
                                      color: colors,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),

                                // The existing language selection PopupMenuButton on the right
                                PopupMenuButton<String>(
                                  icon: Icon(Icons.language, color: colors),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  onSelected: (String value) {
                                    if ((value == 'en' &&
                                            !Provider.of<AppState>(context,
                                                    listen: false)
                                                .isEnglish) ||
                                        (value == 'ar' &&
                                            Provider.of<AppState>(context,
                                                    listen: false)
                                                .isEnglish)) {
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
                                'images/logoDark.png', // Replace with the path to your image
                                height: 50, // Adjust the height as needed
                                // width: 100, // Adjust the width as needed
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                isEnglish
                                    ? 'for discounts'
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
                                  color: ui,
                                  labelcolor: colors),

                              // /* -------------------------------------------------------------------------- */
                              // /* ------------------------------- Family Name ------------------------------ */
                              // /* -------------------------------------------------------------------------- */

                              CustomTextField(
                                  label:
                                      isEnglish ? 'Family Name' : 'اسم العائلة',
                                  controller: familyNameController,
                                  color: ui,
                                  labelcolor: colors),
                              // /* -------------------------------------------------------------------------- */
                              // /* ----------------------------- GenderSelection ---------------------------- */
                              // /* -------------------------------------------------------------------------- */
                              GenderSelection(
                                isEnglish: isEnglish,
                                selectedGender: selectedGender,
                                labelcolor: colors,
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
                                color: ui,
                                labelcolor: colors,
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
                                labelcolor: colors,
                                color: ui,
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
                              // /* --------------------------------- Region --------------------------------- */
                              // /* -------------------------------------------------------------------------- */
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 40, vertical: 20),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          isEnglish ? 'Region' : 'المدينة',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: colors,
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 1, horizontal: 20),
                                          decoration: BoxDecoration(
                                            color: Colors.grey[200],
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          child: DropdownButton<String>(
                                            value: selectedRegion,
                                            hint: Text(isEnglish
                                                ? 'Select Region'
                                                : 'اختر المنطقة'),
                                            onChanged: (String? newValue) {
                                              setState(() {
                                                selectedRegion = newValue!;
                                              });

                                              print(selectedRegion);
                                            },
                                            items: regionDropdownItems.map(
                                                (DropdownMenuItem<String>
                                                    item) {
                                              return item;
                                            }).toList(),
                                            underline: Container(),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                              // /* -------------------------------------------------------------------------- */
                              // /* ---------------------------------- email --------------------------------- */
                              // /* -------------------------------------------------------------------------- */
                              CustomTextField(
                                  label:
                                      isEnglish ? 'Mail' : 'البريد الالكتروني',
                                  controller: mailController,
                                  color: ui,
                                  labelcolor: colors),
                              // /* -------------------------------------------------------------------------- */
                              // /* ------------------------------ Mobile Number ----------------------------- */
                              // /* -------------------------------------------------------------------------- */
                              CustomTextField(
                                  label: isEnglish
                                      ? 'Mobile Number'
                                      : 'رقم الجوال',
                                  controller: mobileController,
                                  isNumeric: true,
                                  // maxLength: 10,
                                  color: ui,
                                  labelcolor: colors),
                              // /* -------------------------------------------------------------------------- */
                              // /* ------------------------------ Pssword ----------------------------- */
                              // /* -------------------------------------------------------------------------- */
                              CustomTextField(
                                  label: isEnglish ? 'Password' : 'كلمة السر',
                                  isPassword: true,
                                  controller: passwordController,
                                  color: ui,
                                  labelcolor: colors),

                              // /* -------------------------------------------------------------------------- */
                              // /* ------------------------------ co - Pssword ----------------------------- */
                              // /* -------------------------------------------------------------------------- */
                              CustomTextField(
                                  label: isEnglish
                                      ? 'Confirm Password'
                                      : 'تأكيد كلمة السر',
                                  isPassword: true,
                                  controller: confirmPasswordController,
                                  color: ui,
                                  labelcolor: colors),
                              // /* -------------------------------------------------------------------------- */
                              // /* ------------------------------- Vendor Join ------------------------------ */
                              // /* -------------------------------------------------------------------------- */
                              VendorJoinWidget(
                                labelcolor: colors,
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

                              Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .end, // Align items to the start (left)
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: isDark
                                          ? Color.fromARGB(251, 34, 34, 34)
                                          : Color(0xFFF0F0F0),
                                      borderRadius: BorderRadius.circular(30),
                                      boxShadow: [
                                        BoxShadow(
                                          color: isDark
                                              ? Color.fromARGB(250, 17, 17, 17)
                                              : Colors.grey.withOpacity(0.5),
                                          spreadRadius:
                                              5, // Negative spreadRadius makes the shadow inside
                                          blurRadius: 7,
                                          offset: Offset(0,
                                              3), // changes the position of the shadow
                                        ),
                                      ],
                                    ),
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
                                          color: colors,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        primary: ui,
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
