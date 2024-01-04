// Import necessary packages at the beginning of your file
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
            // Wrap the IconButton in a Builder widget
            Builder(
              builder: (BuildContext builderContext) {
                return IconButton(
                  icon: Icon(Icons.arrow_forward),
                  onPressed: () {
                    // Use the Builder's context for navigation
                    Navigator.pop(builderContext);
                  },
                  color: Color.fromARGB(255, 7, 0, 34),
                );
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Add your image asset
                Image.asset(
                  'images/no-internet.jpg', // Replace with the actual image file path
                  // height: 200, // Adjust the height as needed
                  width: 200, // Adjust the width as needed
                ),
                SizedBox(height: 16),
                // Add your title
                Text(
                  'Your Title',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                // Add your subtitle
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
