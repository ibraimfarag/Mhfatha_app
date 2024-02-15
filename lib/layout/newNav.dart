import 'package:flutter/material.dart';
import 'package:mhfatha/settings/imports.dart';

class NewNav extends StatefulWidget {
  @override
  State<NewNav> createState() => _NewNavState();
}

class _NewNavState extends State<NewNav> {
  @override
  Widget build(BuildContext context) {
    bool isEnglish = Provider.of<AppState>(context).isEnglish;
    bool isDarkMode = Provider.of<AppState>(context).isDarkMode;
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);

    String lang = Provider.of<AppState>(context, listen: false).display;

    String currentRoute = ModalRoute.of(context)?.settings.name ?? '';

    return Container(
      padding: EdgeInsets.only(bottom: 15 , top: 5), // Adjust padding as needed
      color: Colors.white, // Customize background color
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceAround, // Adjust alignment as needed
        children: [
          _buildNavItem(
              Icons.home,
              isEnglish ? 'Home' : 'الرئيسية',
              '/home',
              currentRoute ==
                  '/home'), // Customize icon, label, and route for each item
          _buildNavItem(Icons.wallet, isEnglish ? 'My Wallet' : 'محفظتي',
              '/requests', currentRoute == '/requests'),
          if (authProvider.isVendor)
            _buildNavItem(Icons.store, isEnglish ? 'My Stores' : 'متاجري',
                '/mainstores', currentRoute == '/mainstores'),
          _buildNavItem(Icons.settings, isEnglish ? 'Settings' : 'الإعدادات',
              '/settings', currentRoute == '/settings'),
        ],
      ),
    );
  }

  Widget _buildNavItem(
      IconData icon, String label, String route, bool isSelected) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .pushReplacementNamed(route); // Navigate to the specified route
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon,
              size: 30,
              color: isSelected
                  ? Color(0xFF1D365C)
                  : Colors.grey), // Customize icon size and color
          SizedBox(height: 5), // Adjust spacing between icon and label
          Text(label,
              style: TextStyle(
                  fontSize: 14,
                  color: isSelected
                      ? Color(0xFF1D365C)
                      : Colors.grey)), // Customize label style and color
        ],
      ),
    );
  }
}
