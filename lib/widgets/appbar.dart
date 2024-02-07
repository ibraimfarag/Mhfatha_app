import 'package:mhfatha/settings/imports.dart';

class CustomAppBar extends StatelessWidget {
  final String? title;
  final VoidCallback onBackTap;
  final Color? iconColor; // Add a parameter for icon color
final double? marginTop; 
  CustomAppBar({this.title, required this.onBackTap,this.iconColor,this.marginTop});

  @override
  Widget build(BuildContext context) {
    bool isEnglish = Provider.of<AppState>(context).isEnglish;

    return Container(
      margin: EdgeInsets.only(top: marginTop?? 10, bottom: 0),
      child: Row(
        mainAxisAlignment:
            isEnglish ? MainAxisAlignment.end : MainAxisAlignment.end,
        children: [
    // Render IconButton on the left if not English
            IconButton(
              icon: Icon(isEnglish? Icons.arrow_forward_ios : Icons.arrow_forward_ios),
              onPressed: onBackTap,
              color: iconColor ?? Color.fromARGB(255, 244, 244, 245), // Use the provided color or default to white
            ),
          if (title != null)
            Text(
              title!,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 7, 0, 34),
              ),
            ),
       
          // Add more widgets as needed
        ],
      ),
    );
  }
}
