// lib\screens\settings\settings.dart

import 'package:mhfatha/settings/imports.dart';
import 'package:url_launcher/url_launcher.dart';

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
    isAuthenticated = authProvider.isAuthenticated;
    fetchContactsData();
  }

  bool isAuthenticated = false;
  Map<String, String> _contactsData = {};

  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Future<void> fetchContactsData() async {
    // Call the support function and await its result
    Map<String, String> contactsData = await Api().support(context);

    // Update the state with the received contacts data
    setState(() {
      _contactsData = contactsData;
    });
  }

  @override
  Widget build(BuildContext context) {
    String whatsapp = _contactsData['whatsapp'] ?? '';
    String email = _contactsData['email'] ?? '';
    bool isEnglish = Provider.of<AppState>(context).isEnglish;
    bool isDarkMode = Provider.of<AppState>(context).isDarkMode;
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);

    Api api = Api();
    Color ui = Color.fromARGB(255, 250, 82, 82);

    return DirectionalityWrapper(
        child: Scaffold(
      backgroundColor: Color(0xFFF3F4F7),
      body: SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
            color: Color(0xFF080E27), // Set background color to #080e27
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(20, 60, 20, 5),
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
                                isEnglish ? ' Welcome ' : ' مرحبا بك',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              if (isAuthenticated)
                                Text(
                                  ' ${authProvider.user!['first_name']}',
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              SizedBox(height: 5),
                            ],
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          // Column(
                          //   crossAxisAlignment: CrossAxisAlignment.end,
                          //   children: [
                          //     SizedBox(
                          //       height: 20,
                          //     ),
                          //     CircleAvatar(
                          //       radius: 60,
                          //       // Add your profile image here
                          //       backgroundImage: NetworkImage(
                          //           'https://mhfatha.net/FrontEnd/assets/images/user_images/${authProvider.user!['photo']}'),
                          //     ),
                          //   ],
                          // ),
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
                                    if (newValue == 'English' && !isEnglish) {
                                      Provider.of<AppState>(context,
                                              listen: false)
                                          .toggleLanguage();
                                    } else if (newValue == 'العربية' &&
                                        isEnglish) {
                                      Provider.of<AppState>(context,
                                              listen: false)
                                          .toggleLanguage();
                                    }
                                  },
                                  items: <String>['English', 'العربية']
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
                        if (isAuthenticated)
                          buildSettingItem(context, Icons.settings,
                              'Account Settings', 'إعدادات الحساب', () async {
                            // Navigate to account settings screen
                            Navigator.pushNamed(context, '/account');
                            await authProvider.updateUserData(context);
                          }),
                        if (isAuthenticated)
                          buildSettingItem(context, Icons.password,
                              'Change Password', 'تغيير كلمة السر ', () {
                            Navigator.pushNamed(context, '/changePasswword');
                          }),
                        if (isAuthenticated)
                          buildSettingItem(context, Icons.privacy_tip,
                              'technical support', 'الدعم الفني', () {
                            Navigator.pushNamed(context, '/support');
                          }),

                        // buildSettingItem(
                        //     context, Icons.report, 'Report', 'الإبلاغ', () {
                        //   // Implement report logic
                        // }),
                        if (isAuthenticated)
                          if (!authProvider.isVendor)
                            buildSettingItem(
                                context,
                                Icons.policy,
                                'Vendor Policy and Terms',
                                'سياسة وشروط المستفيد', () {
                              Navigator.of(context).pushNamed('/user/trems');

                              // Implement report logic
                            }),
                        if (isAuthenticated)
                          if (!authProvider.isVendor)
                            buildSettingItem(
                                context,
                                Icons.shopping_basket,
                                'Get Vendor Account',
                                'تحويل الى حساب تاجر', () {
                              QuickAlert.show(
                                context: context,
                                type: QuickAlertType.confirm,
                                customAsset: 'images/confirm.gif',
                                text: isEnglish
                                    ? 'Are you sure you want to become a vendor account?'
                                    : 'هل أنت متأكد من تحويل الحساب إلى حساب تاجر؟',
                                widget: Column(
                                  children: [
                                    SizedBox(height: 10),
                                    GestureDetector(
                                      onTap: () {
                                        // Navigate to the terms and conditions screen
                                        Navigator.pushNamed(
                                            context, '/vendor/trems');
                                      },
                                      child: Text(
                                        isEnglish
                                            ? 'Terms And Conditions Policy click here to read'
                                            : 'انقر هنا لقراءة سياسة الشروط والأحكام',
                                        style: TextStyle(
                                          color: Colors.blue,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      isEnglish
                                          ? 'By choosing "Yes", you accept and agree to the Terms and Conditions.'
                                          : 'باختيارك "نعم"، فإنك توافق وتقبل الشروط والأحكام.',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                                cancelBtnText: isEnglish ? 'No' : 'لا',
                                confirmBtnText: isEnglish ? 'Yes' : 'نعم',
                                confirmBtnColor: Color(0xFF0D2750),
                                onConfirmBtnTap: () async {
                                  await Api().UserRequestActions(
                                      context, 'go to vendor');
                                },
                              );
                            }),
                        if (isAuthenticated)
                          if (authProvider.isVendor)
                            buildSettingItem(
                                context,
                                Icons.policy,
                                'Vendor Policy and Terms',
                                'سياسة وشروط التاجر', () {
                              Navigator.of(context).pushNamed('/vendor/trems');
                              // Implement report logic
                            }),
                        if (isAuthenticated)
                          if (authProvider.isVendor)
                            buildSettingItem(
                                context,
                                Icons.person_rounded,
                                'Back Beneficiary Account',
                                'تحويل الى حساب مستفيد', () async {
                              QuickAlert.show(
                                context: context,
                                type: QuickAlertType.confirm,
                                customAsset: 'images/confirm.gif',
                                text: isEnglish
                                    ? 'Are you sure be user account?'
                                    : 'هل أنت متاكد من تحويل الي حساب مستفيد ؟',
                                cancelBtnText: isEnglish ? 'No' : 'لا',
                                confirmBtnText: isEnglish ? 'Yes' : 'نعم',
                                confirmBtnColor: Color(0xFF0D2750),
                                onConfirmBtnTap: () async {
                                  await Api().UserRequestActions(
                                      context, 'go to user');

                                  Navigator.of(context)
                                      .pushReplacementNamed('/settings');
                                },
                              );
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
                        if (whatsapp != null || email != null)
                          Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 0),
                            padding: EdgeInsets.fromLTRB(20, 30, 20, 30),
                            decoration: BoxDecoration(
                              color: Color(0xFFFFFFFF),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Image.asset(
                                      'assets/icon/support.png', // Replace with your WhatsApp icon asset path
                                      width: 24, // Adjust width as needed
                                      height: 24, // Adjust height as needed
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      isEnglish
                                          ? 'Contact Support via'
                                          : 'الدعم الفني عبر',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    SizedBox(width: 30),
                                    if (whatsapp !=
                                        null) // Adjust as needed for spacing
                                      GestureDetector(
                                        onTap: () async {
                                          final String phoneNumber =
                                              whatsapp; // Replace with your WhatsApp phone number
                                          final String whatsappUrl =
                                              'https://wa.me/$phoneNumber';
                                          if (await canLaunch(whatsappUrl)) {
                                            await launch(whatsappUrl);
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                    'WhatsApp is not installed on your device.'),
                                              ),
                                            );
                                          }
                                        },
                                        child: Row(
                                          children: [
                                            Image.asset(
                                              'assets/icon/whatsaap.png', // Replace with your email icon asset path
                                              width:
                                                  24, // Adjust width as needed
                                              height:
                                                  24, // Adjust height as needed
                                            ),
                                            SizedBox(width: 5),
                                            Text(
                                              'WhatsApp',
                                              style: TextStyle(
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    SizedBox(width: 20),
                                    if (email != null)
                                      GestureDetector(
                                          onTap: () {
                                            // Handle email
                                            launchUrl(Uri.parse(
                                                'mailto:$email')); // Replace with your email address
                                          },
                                          child: Row(
                                            children: [
                                              Image.asset(
                                                'assets/icon/email.png', // Replace with your email icon asset path
                                                width:
                                                    24, // Adjust width as needed
                                                height:
                                                    24, // Adjust height as needed
                                              ),
                                              SizedBox(width: 5),
                                              Text(
                                                'Email',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          )),
                                  ],
                                ),
                              ],
                            ),
                          ),

                        SizedBox(
                          height: 10,
                        ),
                        if (isAuthenticated)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 60, // Set the height of the button
                                child: ElevatedButton(
                                  onPressed: () {
                                    QuickAlert.show(
                                        context: context,
                                        type: QuickAlertType.confirm,
                                        customAsset: 'images/confirm.gif',
                                        text: isEnglish
                                            ? 'are you sure you want delete your account?'
                                            : 'هل انت متأكد من حذف الحساب؟',
                                        confirmBtnText:
                                            isEnglish ? 'Yes' : 'نعم',
                                        cancelBtnText: isEnglish ? 'No' : 'لا',
                                        confirmBtnColor: Color(0xFF0D2750),
                                        onConfirmBtnTap: () async {
                                          await Api().UserRequestActions(
                                              context, 'go to delete');

                                          // Call the logout method from AuthProvider
                                          Provider.of<AuthProvider>(context,
                                                  listen: false)
                                              .logout();

                                          // Navigate to the login screen or perform any other necessary actions
                                          Navigator.pushNamedAndRemoveUntil(
                                              context,
                                              Routes.home,
                                              (route) => false);
                                        });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: ui, // Set the background color
                                    shape: isEnglish
                                        ? RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(30),
                                              bottomLeft: Radius.circular(30),
                                            ),
                                          )
                                        : RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(30),
                                              bottomRight: Radius.circular(30),
                                            ),
                                          ),
                                  ),
                                  child: Text(
                                    isEnglish ? 'Delete Account' : 'حذف الحساب',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 60, // Set the height of the button
                                child: ElevatedButton(
                                  onPressed: () {
                                    QuickAlert.show(
                                        context: context,
                                        type: QuickAlertType.confirm,
                                        customAsset: 'images/confirm.gif',
                                        text: isEnglish
                                            ? 'are you sure you want logout?'
                                            : 'هل انت متأكد من عملية تسجيل الخروج من الحساب؟',
                                        confirmBtnText:
                                            isEnglish ? 'Yes' : 'نعم',
                                        cancelBtnText: isEnglish ? 'No' : 'لا',
                                        confirmBtnColor: Color(0xFF0D2750),
                                        onConfirmBtnTap: () {
                                          // Call the logout method from AuthProvider
                                          Provider.of<AuthProvider>(context,
                                                  listen: false)
                                              .logout();

                                          // Navigate to the login screen or perform any other necessary actions
                                          Navigator.pushNamedAndRemoveUntil(
                                              context,
                                              Routes.home,
                                              (route) => false);
                                        });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: ui, // Set the background color
                                    shape: isEnglish
                                        ? RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(30),
                                              bottomRight: Radius.circular(30),
                                            ),
                                          )
                                        : RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(30),
                                              bottomLeft: Radius.circular(30),
                                            ),
                                          ),
                                  ),
                                  child: Text(
                                    isEnglish ? 'Logout' : 'تسجيل الخروج',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        // Logout Button
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
