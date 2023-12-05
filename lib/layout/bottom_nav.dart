
// lib\layout\bottom_nav.dart
import 'package:mhfatha/settings/imports.dart';
class BottomNav extends StatefulWidget {
  final int initialIndex;

  BottomNav({required this.initialIndex});

  @override
  _BottomNavState createState() =>
      _BottomNavState(initialIndex);
}

class _BottomNavState extends State<BottomNav> {
  int _currentIndex;

  _BottomNavState(this._currentIndex);

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      // Set the default text style for the entire BottomNavigationBar
      style: TextStyle(
        // fontFamily: AppVariables.serviceFontFamily, // Use the font family you defined in pubspec.yaml
        fontSize: 20, // Adjust the font size as needed
      ),
      child: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          // Handle tab tap
          setState(() {
            _currentIndex = index;
          });

          // Navigate to the corresponding screen
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/home');
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/settings');
              break;
            
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'الرئيسية',
          ),
        
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'الاعدادات',
          ),
         
        ],
      ),
    );
  }
}