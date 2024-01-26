
// lib\layout\bottom_nav.dart
import 'package:mhfatha/settings/imports.dart';
class BottomNavBar extends StatefulWidget {
  final int initialIndex;

  BottomNavBar({required this.initialIndex});

  @override
  _BottomNavBarState createState() =>
      _BottomNavBarState(initialIndex);
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _currentIndex;

  _BottomNavBarState(this._currentIndex);

  @override
  Widget build(BuildContext context) {
        bool isEnglish = Provider.of<AppState>(context).isEnglish;

    return CustomNavigationBar(
      iconSize: 30.0,
      selectedColor: Color(0xff040307),
      strokeColor: Color(0x30040307),
      unSelectedColor: Color(0xffacacac),
      backgroundColor: Colors.white,
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
              Navigator.pushReplacementNamed(context, '/requests');
              break;
            case 2:
              Navigator.pushReplacementNamed(context, '/settings');
              break;
            case 3:
              Navigator.pushReplacementNamed(context, '/settings');
              break;
            
          }
        },
      items: [
        CustomNavigationBarItem(
          icon: Icon(Icons.home),
          title: Text(isEnglish?  'Home':'الرئيسية'),
        ),
        CustomNavigationBarItem(
          icon: Icon(Icons.wallet),
          title: Text(isEnglish? 'requets':'طلباتي'),
        ),
        CustomNavigationBarItem(
          icon: Icon(Icons.settings),
          title: Text(isEnglish?'settings':'الاعدادات'),
        ),
        CustomNavigationBarItem(
          icon: Icon(Icons.store),
          title: Text(isEnglish?'stores':'المتاجر'),
        ),
     
      ],
      currentIndex: _currentIndex,
      
    );

  }
}