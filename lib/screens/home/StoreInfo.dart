// lib/screens/store_info_screen.dart
import 'package:mhfatha/settings/imports.dart'; // Import your necessary files and packages

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
          title: Text(
            isEnglish ? 'Store Information' : 'معلومات المتجر',
          ),
        ),
        body: Container(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: ElevatedButton(
                  onPressed: () {
                    // Handle "Info about this store" option
                    Navigator.pop(context); // Close the screen
                  },
                  child: Text(
                    isEnglish ? 'Back' : 'العودة',
                  ),
                ),
              ),
              Container(
                width: 500,
                margin: const EdgeInsets.fromLTRB(8, 0, 8, 0),
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
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        children: [
                          // Container(
                          //   height: 100,
                          //   child: ClipRRect(
                          //     borderRadius: BorderRadius.only(
                          //       topLeft: Radius.circular(15),
                          //       topRight: Radius.circular(15),
                          //     ),
                          //     child: ShaderMask(
                          //       shaderCallback: (Rect bounds) {
                          //         return LinearGradient(
                          //           begin: Alignment.bottomCenter,
                          //           end: Alignment.topCenter,
                          //           colors: [
                          //             Colors.transparent,
                          //             Colors.black.withOpacity(0.8)
                          //           ],
                          //           stops: [0.0, 1.0],
                          //         ).createShader(bounds);
                          //       },
                          //       blendMode: BlendMode.dstIn,
                          //       child: Image.network(
                          //         'https://mhfatha.net/FrontEnd/assets/images/store_images/${store['photo']}',
                          //         fit: BoxFit.fill,
                          //       ),
                          //     ),
                          //   ),
                          // ),
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
                          // Container(
                          //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          //   child: Row(
                          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //     children: [
                          //       Row(
                          //         children: [
                          //           Icon(Icons.location_on,
                          //               color: Colors.white, size: 18),
                          //           const SizedBox(width: 1),
                          //           TextButton(
                          //             onPressed: () {
                          //               // Handle onPressed for "يبعد 5 كم" button
                          //             },
                          //             child: Text(
                          //               'يبعد  ${store['distance']}',
                          //               style: TextStyle(
                          //                 color: Colors.white,
                          //                 fontSize: 12,
                          //                 fontFamily: AppVariables.serviceFontFamily,
                          //               ),
                          //             ),
                          //           ),
                          //         ],
                          //       ),
                          //     ],
                          //   ),
                          // ),
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
    );
  }
}
