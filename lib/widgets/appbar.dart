import 'package:mhfatha/settings/imports.dart';



class CustomAppBar extends StatelessWidget  {
  final String? title;
  final VoidCallback onBackTap;

  CustomAppBar({this.title, required this.onBackTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 40,bottom: 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: onBackTap,
              color: Color.fromARGB(255, 244, 244, 245),
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
