import 'package:mhfatha/settings/imports.dart';

class Nointernet extends StatefulWidget {
  @override
  _NointernetState createState() => _NointernetState();
}

class _NointernetState extends State<Nointernet> {
  @override
  Widget build(BuildContext context) {

    bool isEnglish = Provider.of<AppState>(context).isEnglish;
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    return DirectionalityWrapper(
      child: Scaffold(
     
        body: Center(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,  // Centering the content vertically
              children: [
                Image.asset(
                  'images/no-internet.jpg',
                  width: 300,
                ),
                SizedBox(height: 16),
                Text(
                  isEnglish ? 'Opps' : 'عفوًا',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,  // Centering the text horizontally
                ),
                SizedBox(height: 8),
                Text(
                  isEnglish ? 'You haven\'t connected to the Internet' : 'أنت غير متصل بالإنترنت',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Text(
                  isEnglish ? 'Please try to connect to the Internet, and Mhfatha application will work automatically when connected to the Internet' : 'من فضلك حاول الاتصال بالانترنت و تطبيق محفظة سوف يعمل بشكل تلقائي عند الاتصال بالانترنت',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
