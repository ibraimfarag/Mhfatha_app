

import 'package:mhfatha/settings/imports.dart';





class DirectionalityWrapper extends StatelessWidget {
  final Widget child;

  DirectionalityWrapper({required this.child});

  @override
  Widget build(BuildContext context) {
    bool isEnglish = Provider.of<AppState>(context).isEnglish;
    bool isDarkMode = Provider.of<AppState>(context).isDarkMode;

    return Directionality(
      textDirection: isEnglish ? TextDirection.ltr : TextDirection.rtl,
      child: child,
    );
  }
}

