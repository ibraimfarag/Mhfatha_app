// lib\screens\settings\settings.dart

import 'dart:io';

import 'package:intl/intl.dart';
import 'package:mhfatha/settings/imports.dart';

class ChangePassword extends StatefulWidget {
  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  late AuthProvider authProvider; // Declare authProvider variable

  Color backgroundColor = Color.fromARGB(220, 255, 255, 255);
  Color ui = Color.fromARGB(220, 233, 233, 233);
  Color ui2 = Color.fromARGB(255, 113, 194, 110);
  Color colors = Color(0xFF05204a);
  TextEditingController currentPassword = TextEditingController();
  TextEditingController newpassword = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();

  Api api = Api();
  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthProvider>(context, listen: false);
  }

  void didChangeDependencies() {
    super.didChangeDependencies();
    
  }

  @override
  Widget build(BuildContext context) {
    bool isEnglish = Provider.of<AppState>(context).isEnglish;
    bool isDarkMode = Provider.of<AppState>(context).isDarkMode;
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);

    String lang = Provider.of<AppState>(context, listen: false).display;
    return DirectionalityWrapper(
        child: Scaffold(
      body: SingleChildScrollView(
        child: Container(
            color: Color(0xFF080E27), // Set background color to #080e27
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomAppBar(
                    onBackTap: () {
                      Navigator.pop(context);
                    },
                    marginTop: 30,
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 5),
                    // height: 200,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                isEnglish ? ' Welcome ' : ' مرحبا بك',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                ' ${authProvider.user!['first_name']}',
                                style: TextStyle(
                                    fontSize: 24,
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
                              CircleAvatar(
                                radius: 60,
                                // Add your profile image here
                                backgroundImage: NetworkImage(
                                    'https://mhfatha.net/FrontEnd/assets/images/user_images/${authProvider.user!['photo']}'),
                              ),
                            ],
                          ),
                        ]),
                  ),
                  SizedBox(height: 16),
                  Container(
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    decoration: BoxDecoration(
                      color: Color(0xFFF3F4F7),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20),
                        buildSettingItem(
                            context, 'Current Password', 'كلمة السر الحالية',
                            () {
                          // Implement report logic
                        }, currentPassword, ' '),
                        buildSettingItem(
                            context, 'New Password', 'كلمة السر الجديدة', () {
                          // Implement report logic
                        }, newpassword, ' '),
                        buildSettingItem(context, 'Confirm New Password',
                            'تأكيد كلمة السر الجديدة', () {
                          // Implement report logic
                        }, confirmPassword, ' '),
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
                                  // customAsset: 'images/no-internet.jpg',
                                  type: QuickAlertType.confirm,
                                  text: isEnglish
                                      ? 'Do you want to update profile'
                                      : 'هل انت متاكد من تحديث البيانات الشخصية',
                                  confirmBtnText: isEnglish ? 'Yes' : 'نعم',
                                  cancelBtnText: isEnglish ? 'No' : 'لا',
                                  confirmBtnColor: Colors.green,
                                  onConfirmBtnTap: () async {
                                    Navigator.pop(context);
                                    String oldPassword = currentPassword
                                        .text; // Assuming you have a TextEditingController for the email field
                                    String newPassword = newpassword
                                        .text; // Assuming you have a TextEditingController for the email field
                                    String confirmationNewPassword =
                                        confirmPassword.text;
                                    try {
                                      String message = await api.changePassword(
                                        context,
                                        oldPassword,
                                        newPassword,
                                        confirmationNewPassword,
                                      );
                                      // Show success message or handle accordingly
                                    } catch (e) {
                                      // Handle error, show error message, etc.
                                    }
                                  },
                                );
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
                  )
                ])),
      ),
      // bottomNavigationBar: BottomNavBar(initialIndex: 2),
      bottomNavigationBar: NewNav(),
    ));
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
