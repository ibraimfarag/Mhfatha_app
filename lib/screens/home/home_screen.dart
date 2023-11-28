// lib\screens\Auth\home\home_screen.dart
import 'package:flutter/cupertino.dart';
import 'package:mhfatha/settings/imports.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  
  Widget build(BuildContext context) {
    bool isEnglish = Provider.of<AppState>(context).isEnglish;

    return DirectionalityWrapper(
      child:Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body:
                  Text(isEnglish ? 'English Text' : 'نص باللغة العربية'),


                     bottomNavigationBar:  BottomNav(initialIndex: 0),
    )
    );
  }
}
