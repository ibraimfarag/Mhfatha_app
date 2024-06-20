import 'package:mhfatha/settings/imports.dart';

class Nointernet extends StatefulWidget {
  const Nointernet({super.key});

  @override
  _NointernetState createState() => _NointernetState();
}

class _NointernetState extends State<Nointernet> {
  @override

      void didChangeDependencies() {
    super.didChangeDependencies();
    
  }
  @override


  Widget build(BuildContext context) {

    bool isEnglish = Provider.of<AppState>(context).isEnglish;

    return DirectionalityWrapper(
      child: Scaffold(
     
        body: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,  // Centering the content vertically
              children: [
                Image.asset(
                  'images/no-internet.jpg',
                  width: 300,
                ),
                const SizedBox(height: 16),
                Text(
                  isEnglish ? 'Opps' : 'عفوًا',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,  // Centering the text horizontally
                ),
                const SizedBox(height: 8),
                Text(
                  isEnglish ? 'You haven\'t connected to the Internet' : 'أنت غير متصل بالإنترنت',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  isEnglish ? 'Please try to connect to the Internet, and Mhfatha application will work automatically when connected to the Internet' : 'من فضلك حاول الاتصال بالانترنت و تطبيق محفظة سوف يعمل بشكل تلقائي عند الاتصال بالانترنت',
                  style: const TextStyle(
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
