import 'package:mhfatha/settings/imports.dart';

class Nointernet extends StatefulWidget {
  @override
  _NointernetState createState() => _NointernetState();
}

class _NointernetState extends State<Nointernet> {
  @override
  Widget build(BuildContext context) {
    return DirectionalityWrapper(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            Builder(
              builder: (BuildContext builderContext) {
                return IconButton(
                  icon: Icon(Icons.arrow_forward),
                  onPressed: () {
                    Navigator.pop(builderContext);
                  },
                  color: Color.fromARGB(255, 7, 0, 34),
                );
              },
            ),
          ],
        ),
        body: Center(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'images/no-internet.jpg',
                  width: 300,
                ),
                SizedBox(height: 16),
                Text(
                  'Your Title',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Your Subtitle',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
