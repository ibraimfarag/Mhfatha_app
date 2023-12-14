// lib/screens/store_info_screen.dart
import 'package:mhfatha/settings/imports.dart';

class StoreInfoScreen extends StatelessWidget {
  const StoreInfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Retrieve the 'store' argument
    Map<String, dynamic>? storeData =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    bool isEnglish = Provider.of<AppState>(context).isEnglish;

    return DirectionalityWrapper(
      child: Scaffold(
        appBar: AppBar(
          // title: Text(
          //   'Store Information',
          // Uncomment the lines below if you want to provide localized titles
          // isEnglish ? 'Store Information' : 'معلومات المتجر',
          // ),
          // Make the AppBar transparent
          backgroundColor: Colors.transparent,
          elevation: 0, // Remove the shadow
          // Add the IconButton to the actions
          actions: [
            IconButton(
              icon: Icon(Icons.arrow_forward),
              onPressed: () {
                // Navigate back to the previous screen
                Navigator.pop(context);
              },
              // Change the color of the back button icon
              color: Color.fromARGB(255, 7, 0, 34),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 600,
                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 3, 12, 19),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 500,
                        margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 3, 12, 19),
                          borderRadius: BorderRadius.circular(0),
                        ),
                        child: Column(
                          children: [
                            Container(
                              height: 200,
                              child: ClipRRect(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  topRight: Radius.circular(15),
                                ),
                                child: ShaderMask(
                                  shaderCallback: (Rect bounds) {
                                    return LinearGradient(
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                      colors: [
                                        Colors.transparent,
                                        Colors.black.withOpacity(0.8)
                                      ],
                                      stops: [0.0, 1.0],
                                    ).createShader(bounds);
                                  },
                                  blendMode: BlendMode.dstIn,
                                  child: Image.network(
                                    'https://mhfatha.net/FrontEnd/assets/images/store_images/${storeData?['photo']}',
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  '${storeData?['name']}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: AppVariables.serviceFontFamily,
                                    fontSize: 14,
                                  ),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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
