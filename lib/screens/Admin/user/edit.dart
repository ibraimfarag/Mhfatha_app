import 'dart:convert';

import 'dart:io';

import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';

import 'package:mhfatha/settings/imports.dart';
import 'package:permission_handler/permission_handler.dart'
    as permission_handler;

class AdminEditUser extends StatefulWidget {
  AdminEditUser({Key? key}) : super(key: key);

  @override
  _AdminEditUserState createState() => _AdminEditUserState();
}

class _AdminEditUserState extends State<AdminEditUser> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late AuthProvider authProvider; // Declare authProvider variable
  late Map<String, dynamic> usert;

  Color backgroundColor = Color.fromARGB(220, 255, 255, 255);
  Color ui = Color.fromARGB(220, 233, 233, 233);
  Color ui2 = Color.fromARGB(255, 113, 194, 110);
  Color colors = Color(0xFF05204a);
  TextEditingController first_name = TextEditingController();
  TextEditingController last_name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController mobile = TextEditingController();
  TextEditingController birthdayController = TextEditingController();
  late String selectedRegion; // Declare selectedRegion variable
  String? _selectedProfileImagePath;

  @override
  void initState() {
    super.initState();
    fetchDataFromApi(context);
  }

  void didChangeDependencies() {
    super.didChangeDependencies();
    // Receive the user data passed from the previous screen
    usert = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    selectedRegion = '${usert['region']}';
  }

  Future<void> fetchDataFromApi(BuildContext context) async {
    try {
      setState(() {});
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime currentDate = DateTime.now();
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime(1900),
      lastDate: currentDate,
    );

    if (picked != null && picked != currentDate) {
      setState(() {
        birthdayController.text = picked.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isEnglish = Provider.of<AppState>(context, listen: false).isEnglish;
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);

    return MainAdminContainer(
      showCustomAppBar: true,
      additionalWidgets: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              isEnglish ? 'edit user' : 'تعديل حساب',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${usert['first_name']} ${usert['last_name']}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.03,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              ProfilePhotoWidget(
                isEnglish: isEnglish,
                labelcolor: colors,
                color: ui,
                label: isEnglish ? 'Profile Photo: ' : 'صورة الحساب: ',
                selectPhotoText: isEnglish ? 'Select Photo' : 'اختر صورة',
                changePhotoText: isEnglish ? 'Change Photo' : 'تغير  الصورة',
                removeText: isEnglish ? 'Remove' : 'إزالة',
                endurl: 'user_images/${usert['photo']}',
                onPhotoSelected: (path) {
                  setState(() {
                    _selectedProfileImagePath = path;
                  });
                  print('path : $path');
                },
              ),
              SizedBox(height: 20),
              buildSettingItem(context, 'First Name', 'الاسم', () {
                // Navigate to account settings screen
                // Navigator.pushNamed(context, Routes.accountSettings);
              }, first_name, ' ${usert['first_name']}'),
              buildSettingItem(context, 'Last Name', 'اسم العائلة', () {
                // Implement privacy logic
              }, last_name, ' ${usert['last_name']}'),
              buildSettingItem(
                context,
                'Birthday',
                'تاريخ الميلاد',
                () {
                  // Show date picker and update the selected date
                  _selectDate(context);
                },
                birthdayController, // Assume you have a TextEditingController for the birthday
                ' ${usert['birthday']}',
              ),
              buildSettingItem(context, 'Mobile Number', 'رقم الجوال', () {
                // Implement report logic
              }, mobile, ' ${usert['mobile']}'),
              buildSettingItem(context, 'Email', 'البريد الالكتروني', () {
                // Implement report logic
              }, email, ' ${usert['email']}'),
              Container(
                margin: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                padding: EdgeInsets.fromLTRB(20, 30, 20, 30),
                decoration: BoxDecoration(
                  color: Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        RegionSelection(
                          color: ui,
                          labelcolor: colors,
                          onRegionSelected: (value) {
                            print('onRegionSelected: $value');

                            setState(() {
                              print(
                                  'selectedRegion in AccountScreen: $selectedRegion');
                              selectedRegion = value;
                              // Update City with the value of selectedRegion
                            });

                            print(
                                'selectedRegion in AccountScreen: $selectedRegion');
                          },
                          selectedRegion: selectedRegion,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 24,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      QuickAlert.show(
                          context: context,
                          type: QuickAlertType.confirm,
                          customAsset: 'images/confirm.gif',
                          text: isEnglish
                              ? 'Do you want to update profile'
                              : 'هل انت متاكد من تحديث البيانات الشخصية',
                          confirmBtnText: isEnglish ? 'Yes' : 'نعم',
                          cancelBtnText: isEnglish ? 'No' : 'لا',
                          confirmBtnColor: Color(0xFF0D2750),
                          onConfirmBtnTap: () async {
                            Navigator.pop(context);

                            print(
                                'selectedRegion in AccountScreen: $selectedRegion');

                            bool success = await AdminApi(context).UpdateUser(
                                context: context,
                                user_id: '${usert['id']}',
                                first_name: first_name.text,
                                last_name: last_name.text,
                                birthday: birthdayController.text,
                                region: selectedRegion,
                                mobile: mobile.text,
                                email: email.text,
                                imageFile: _selectedProfileImagePath != null
                                    ? File(_selectedProfileImagePath ?? '')
                                    : null
                                // otp: /* Pass the OTP if needed */,

                                );
                            print(_selectedProfileImagePath);
                          });
                    },
                    style: ElevatedButton.styleFrom(
                      primary: ui, // Set the background color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Text(
                      isEnglish ? 'Update' : 'تحديث',
                      style: TextStyle(color: colors),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildSettingItem(
    BuildContext context,
    // IconData icon,
    String englishTitle,
    String arabicTitle,
    VoidCallback onTap,
    TextEditingController controller,
    String preFilledText,
  ) {
    bool isEnglish = Provider.of<AppState>(context).isEnglish;
    controller.text = preFilledText;

    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
        padding: EdgeInsets.fromLTRB(20, 30, 20, 30),
        decoration: BoxDecoration(
          color: Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Column(
          children: [
            Row(
              children: [
                // Icon(icon),
                SizedBox(width: 10),
                Text(isEnglish ? englishTitle : arabicTitle),
              ],
            ),
            SizedBox(height: 10),
            // Add TextField here
            if (englishTitle.toLowerCase() ==
                'birthday') // Check if it's the birthday field
              InkWell(
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );

                  if (pickedDate != null && pickedDate != DateTime.now()) {
                    controller.text =
                        DateFormat('yyyy-MM-dd').format(pickedDate);
                  }
                },
                child: AbsorbPointer(
                  child: TextField(
                    controller: controller,
                    style: TextStyle(fontSize: 16, color: colors),
                    decoration: InputDecoration(
                      hintStyle: TextStyle(color: Colors.grey.shade700),
                      filled: true,
                      fillColor: ui,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(color: backgroundColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(color: backgroundColor),
                      ),
                    ),
                  ),
                ),
              )
            else
              TextField(
                obscureText: false,
                controller: controller,
                style: TextStyle(fontSize: 16, color: colors),
                decoration: InputDecoration(
                  hintStyle: TextStyle(color: Colors.grey.shade700),
                  filled: true,
                  fillColor: ui,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: backgroundColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: backgroundColor),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
