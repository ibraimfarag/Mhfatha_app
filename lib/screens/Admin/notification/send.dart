import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import 'package:mhfatha/settings/imports.dart';
import 'package:permission_handler/permission_handler.dart'
    as permission_handler;

class AdminSendNotifi extends StatefulWidget {
  const AdminSendNotifi({Key? key}) : super(key: key);

  @override
  _AdminSendNotifiState createState() => _AdminSendNotifiState();
}

class _AdminSendNotifiState extends State<AdminSendNotifi> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController bodyController = TextEditingController();
  final TextEditingController titleArabicController = TextEditingController();
  final TextEditingController bodyArabicController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController birthdayController = TextEditingController();
  final TextEditingController regionController = TextEditingController();
  final TextEditingController isVendorController = TextEditingController();
  final TextEditingController isAdminController = TextEditingController();
  final TextEditingController isIOSController = TextEditingController();
  final TextEditingController isAndroidController = TextEditingController();
  final TextEditingController platformController = TextEditingController();
  final TextEditingController recipientIdentifierController =
      TextEditingController();
  Color backgroundColor = Color.fromARGB(220, 255, 255, 255);
  Color ui = Color.fromARGB(220, 233, 233, 233);
  Color ui2 = Color.fromARGB(255, 113, 194, 110);
  Color colors = Color(0xFF05204a);
  String selectedAction = 'sendByFilters'; // Default action selection
  late String selectedRegion; // Declare selectedRegion variable

  @override
  void initState() {
    super.initState();

    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    authProvider.updateUserData(context);
    selectedRegion = '${authProvider.user!['region']}';
  }

  @override
  Widget build(BuildContext context) {
    final isEnglish = Provider.of<AppState>(context, listen: false).isEnglish;
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return MainAdminContainer(
      additionalWidgets: [
        Column(
          children: [
            Text(
              isEnglish ? 'Send Notifications' : 'إرسال اشعارات',
              style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            SizedBox(height: 10),
          ],
        ),
      ],
      child: Column(
        children: [
          Row(
            children: [
              Row(
                children: [
                  Radio<String>(
                    value: 'sendByFilters',
                    groupValue: selectedAction,
                    onChanged: (String? value) {
                      setState(() {
                        selectedAction = value!;
                      });
                    },
                  ),
                  Text(
                    isEnglish ? 'Send By Filters' : 'إرسال حسب الفلاتر',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Radio<String>(
                    value: 'sendToUser',
                    groupValue: selectedAction,
                    onChanged: (String? value) {
                      setState(() {
                        selectedAction = value!;
                      });
                    },
                  ),
                  Text(
                    isEnglish ? 'Send To User' : 'إرسال للمستخدم',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          buildTextField(context, 'Title (English)', 'العنوان (الانجليزيه)',
              titleController),
          buildTextField(context, 'Body (English)', 'المحتوى (الانجليزيه)',
              bodyController),
          buildTextField(context, 'Title (Arabic)', 'العنوان (بالعربية)',
              titleArabicController),
          buildTextField(context, 'Body (Arabic)', 'المحتوى (بالعربية)',
              bodyArabicController),
          Visibility(
            visible: selectedAction ==
                'sendByFilters', // Show filters only when 'Send By Filters' is selected
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
              padding: EdgeInsets.fromLTRB(20, 30, 20, 30),
              decoration: BoxDecoration(
                color: Color(0xFFFFFFFF),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  buildTextField(
                      context, 'Birthday', 'تاريخ الميلاد', birthdayController),
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

                      print('selectedRegion in AccountScreen: $selectedRegion');
                    },
                    selectedRegion: selectedRegion,
                  ),
                  Row(
                    children: [
                      Row(
                        children: [
                          Radio<String>(
                            value: 'Male',
                            groupValue: genderController.text,
                            onChanged: (String? value) {
                              setState(() {
                                genderController.text = value!;
                              });
                            },
                          ),
                          Text(
                            isEnglish ? 'Male' : 'ذكر',
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Radio<String>(
                            value: 'Female',
                            groupValue: genderController.text,
                            onChanged: (String? value) {
                              setState(() {
                                genderController.text = value!;
                              });
                            },
                          ),
                          Text(
                            isEnglish ? 'Female' : 'أنثى',
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Radio<String>(
                        value: "1",
                        groupValue: isVendorController.text,
                        onChanged: (String? value) {
                          setState(() {
                            isVendorController.text = value!;
                          });
                        },
                      ),
                      Text(isEnglish ? 'Is Vendor' : 'البائع'),
                      Radio<String>(
                        value: "0",
                        groupValue: isVendorController.text,
                        onChanged: (String? value) {
                          setState(() {
                            isVendorController.text = value!;
                          });
                        },
                      ),
                      Text(isEnglish ? 'Not Vendor' : 'ليس بائعًا'),
                    ],
                  ),
                  Row(
                    children: [
                      Radio<String>(
                        value: "1",
                        groupValue: isAdminController.text,
                        onChanged: (String? value) {
                          setState(() {
                            isAdminController.text = value!;
                          });
                        },
                      ),
                      Text(isEnglish ? 'Is Admin' : 'المشرف'),
                      Radio<String>(
                        value: "0",
                        groupValue: isAdminController.text,
                        onChanged: (String? value) {
                          setState(() {
                            isAdminController.text = value!;
                          });
                        },
                      ),
                      Text(isEnglish ? 'Not Admin' : 'ليس مشرفًا'),
                    ],
                  ),
                  Row(
                    children: [
                      Radio<String>(
                        value: "iOS",
                        groupValue: isIOSController.text,
                        onChanged: (String? value) {
                          setState(() {
                            isIOSController.text = value!;
                          });
                        },
                      ),
                      Text('iOS'),
                      Radio<String>(
                        value: "Android",
                        groupValue: isAndroidController.text,
                        onChanged: (String? value) {
                          setState(() {
                            isAndroidController.text = value!;
                          });
                        },
                      ),
                      Text('Android'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Visibility(
            visible: selectedAction == 'sendToUser',
            child: buildTextField(
                context,
                'Recipient Identifier (ID, Mobile, Email)',
                'معرف المستلم (الهوية، الجوال، البريد الإلكتروني)',
                recipientIdentifierController),
          ),
          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              if (selectedAction == 'sendToUser') {
                AdminApi(context).sendNotification(
                    context: context,
                    action: selectedAction,
                    body: bodyController.text,
                    title: titleController.text,
                    bodyArabic: bodyArabicController.text,
                    titleArabic: titleArabicController.text,
                    recipient_identifier: recipientIdentifierController.text);
              } else {
                // Call your sendNotification function with the provided parameters
                AdminApi(context).sendNotification(
                  context: context,
                  action: selectedAction,
                  body: bodyController.text,
                  title: titleController.text,
                  bodyArabic: bodyArabicController.text,
                  titleArabic: titleArabicController.text,
                  gender: genderController.text,
                  birthday: birthdayController.text,
                  region: selectedRegion,
                  isVendor: isVendorController.text,
                  isAdmin: isAdminController.text,
                  platform: isIOSController.text,
                );
              }
            },
            child: Text(
              isEnglish ? 'Send Notification' : 'إرسال الإشعار',
              style: TextStyle(fontSize: 16.0, color: Color(0xFF05204a)),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTextField(
    BuildContext context,
    String englishLabel,
    String arabicLabel,
    TextEditingController controller,
  ) {
    bool isEnglish = Provider.of<AppState>(context).isEnglish;

    return InkWell(
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
                SizedBox(width: 10),
                Text(isEnglish ? englishLabel : arabicLabel),
              ],
            ),
            SizedBox(height: 10),
            if (englishLabel.toLowerCase() ==
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
