// lib\screens\settings\settings.dart

import 'package:mhfatha/settings/imports.dart';

class SettingsScreen extends StatefulWidget {

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
@override


  void initState() {
    super.initState();

   AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    authProvider.updateUserData(context);

  }


  @override
  Widget build(BuildContext context) {
    bool isEnglish = Provider.of<AppState>(context).isEnglish;
    bool isDarkMode = Provider.of<AppState>(context).isDarkMode;
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    Api api = Api();
    Color ui = Color.fromARGB(255, 250, 82, 82);

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
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                isEnglish ? ' welcome ' : ' مرحبا بك',
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

                        // Language Section
// Language Section
                        Container(
                          padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
                          decoration: BoxDecoration(
                            color: Color(0xFFFFFFFF),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.language),
                              SizedBox(width: 10),
                              Text(isEnglish ? 'Language' : 'اللغة'),
                              SizedBox(width: 10),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: Colors.white,
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: DropdownButton<String>(
                                  value: isEnglish ? 'English' : 'العربية',
                                  onChanged: (String? newValue) {
                                    if (newValue == 'English') {
                                      Provider.of<AppState>(context,
                                              listen: false)
                                          .toggleLanguage();
                                    } else {
                                      Provider.of<AppState>(context,
                                              listen: false)
                                          .toggleLanguage();
                                    }
                                  },
                                  items: <String>['English', 
                                  
                                  'العربية']
                                      .map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Other Settings...
                        buildSettingItem(context, Icons.settings,
                            'Account Settings', 'إعدادات الحساب', () async {
                          // Navigate to account settings screen
                          Navigator.pushNamed(context, '/account');
                          await authProvider.updateUserData(context);
                        }),

                        buildSettingItem(
                            context, Icons.password, 'change password', 'تغير كلة السر ',
                            () {
                            Navigator.pushNamed(context, '/changePasswword');
                        }),
                        buildSettingItem(
                            context, Icons.privacy_tip, 'Privacy', 'الخصوصية',
                            () {
                          Navigator.pushNamed(context, '/NotificationReceiver');
                        }),

                        buildSettingItem(
                            context, Icons.report, 'Report', 'الإبلاغ', () {
                          // Implement report logic
                        }),

                        // buildSettingItem(
                        //     context, Icons.message, 'Messages', 'الرسائل', () {
                        //   // Implement messages logic
                        // }),

                        // ListTile(
                        //   title: Text('Dark Mode'),
                        //   trailing: Switch(
                        //     value: isDarkMode,
                        //     onChanged: (value) {
                        //       Provider.of<AppState>(context, listen: false)
                        //           .toggleDarkMode();
                        //     },
                        //   ),
                        // ),

                        // Logout Button
                        ElevatedButton(
                          onPressed: () {
                            QuickAlert.show(
                                context: context,
                                type: QuickAlertType.confirm,
                                text: isEnglish
                                    ? 'are you sure you want logout?'
                                    : 'هل انت متأكد من عملية تسجيل الخروج من الحساب؟',
                                confirmBtnText: isEnglish ? 'Yes' : 'نعم',
                                cancelBtnText: isEnglish ? 'No' : 'لا',
                                confirmBtnColor: Colors.green,
                                onConfirmBtnTap: () {
                                  // Call the logout method from AuthProvider
                                  Provider.of<AuthProvider>(context,
                                          listen: false)
                                      .logout();

                                  // Navigate to the login screen or perform any other necessary actions
                                  Navigator.pushNamedAndRemoveUntil(
                                      context, Routes.login, (route) => false);
                                });
                          },
                          style: ElevatedButton.styleFrom(
                            primary: ui, // Set the background color
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text(isEnglish ? 'Logout' : 'تسجيل الخروج', style: TextStyle(color:Colors.white),),
                        ),
                      ],
                    ),
                  )
                ])),
      ),
      // bottomNavigationBar: BottomNav(initialIndex: 2),
      bottomNavigationBar: NewNav(),
    ));
  }

  Widget buildSettingItem(
    BuildContext context,
    IconData icon,
    String englishTitle,
    String arabicTitle,
    VoidCallback onTap,
  ) {
    bool isEnglish = Provider.of<AppState>(context).isEnglish;

    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
        padding: EdgeInsets.fromLTRB(20, 30, 20, 30),
        decoration: BoxDecoration(
          color: Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            Icon(icon),
            SizedBox(width: 10),
            Text(isEnglish ? englishTitle : arabicTitle),
          ],
        ),
      ),
    );
  }
}
