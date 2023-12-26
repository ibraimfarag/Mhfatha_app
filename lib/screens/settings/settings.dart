// lib\screens\settings\settings.dart

import 'package:mhfatha/settings/imports.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool isEnglish = Provider.of<AppState>(context).isEnglish;
    bool isDarkMode = Provider.of<AppState>(context).isDarkMode;
    AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);

    
    return DirectionalityWrapper(
      child: Scaffold(
      appBar: AppBar(
        title: Text(isEnglish ? 'Settings' : 'الاعدادات'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Section
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  // Add your profile image here
                  backgroundImage: NetworkImage('https://mhfatha.net/FrontEnd/assets/images/user_images/${authProvider.user!['photo']}'),
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(' ${authProvider.user!['first_name']}'),
                    // Other profile details...
                  ],
                ),
              ],
            ),

            SizedBox(height: 20),

            // Language Section
              Row(
              children: [
                Icon(Icons.language),
                SizedBox(width: 10),
                Text(isEnglish ? 'Language' : 'اللغة'),
                SizedBox(width: 10),
                DropdownButton<String>(
                  value: isEnglish ? 'English' : 'Arabic',
                  onChanged: (String? newValue) {
                    if (newValue == 'English') {
                      Provider.of<AppState>(context, listen: false).toggleLanguage();
                    } else {
                      Provider.of<AppState>(context, listen: false).toggleLanguage();
                    }
                  },
                  items: <String>['English', 'Arabic'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),

            // Other Settings...
            buildSettingItem(context, Icons.settings, 'Account Settings', 'إعدادات الحساب', () {
              // Navigate to account settings screen
              // Navigator.pushNamed(context, Routes.accountSettings);
            }),

            buildSettingItem(context, Icons.privacy_tip, 'Privacy', 'الخصوصية', () {
              // Implement privacy logic
            }),

            buildSettingItem(context, Icons.report, 'Report', 'الإبلاغ', () {
              // Implement report logic
            }),

            buildSettingItem(context, Icons.message, 'Messages', 'الرسائل', () {
              // Implement messages logic
            }),

          ListTile(
            title: Text('Dark Mode'),
            trailing: Switch(
              value: isDarkMode,
              onChanged: (value) {
            Provider.of<AppState>(context, listen: false).toggleDarkMode();


              },
            ),
          ),
            // Logout Button
         ElevatedButton(
  onPressed: () {
    // Call the logout method from AuthProvider
    Provider.of<AuthProvider>(context, listen: false).logout();

    // Navigate to the login screen or perform any other necessary actions
    Navigator.pushNamedAndRemoveUntil(context, Routes.login, (route) => false);
  },

  child: Text(isEnglish ? 'Logout' : 'تسجيل الخروج'),
),

          ],
        ),
      ),
      bottomNavigationBar: BottomNav(initialIndex: 1),
    )
    );
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
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
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
