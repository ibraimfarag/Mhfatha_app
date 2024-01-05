// lib\screens\QR\get_discount.dart

import 'package:mhfatha/settings/imports.dart';

class NearBy extends StatefulWidget {
  @override
  _NearByState createState() => _NearByState();
}

class _NearByState extends State<NearBy> {
  @override
  Widget build(BuildContext context) {
    List<dynamic> filteredStores =
        ModalRoute.of(context)!.settings.arguments as List<dynamic>;
    final isEnglish = Provider.of<AppState>(context).isEnglish;

    return DirectionalityWrapper(
      child: Scaffold(
        body:  Container(
            decoration: BoxDecoration(
              color: Color(0xFF080E27), // Set your desired background color
            ),
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                color: Color(0xFF080E27),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                     CustomAppBar(
            onBackTap: () {
              Navigator.pop(context);
            },
          ),
                    // SizedBox(height: 3),
                    Container(
                      // width: 320,
                      // padding: const EdgeInsets.all(1.0),
                      margin:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 1),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 30,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  isEnglish
                                      ? 'Near by Stores'
                                      : ' المتاجر القريبة',
                                  style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 30,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                Image.asset(
                                  'images/nearby.gif', // Replace with the actual path to your GIF image
                                  height: 80, // Adjust the height as needed
                                ),
                              ],
                            ),
                          ]),
                    ),
                    SizedBox(height: 16),
                    // Build containers dynamically based on filteredStores
                    Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFF3F4F7),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(40),
                          ),
                        ),
                        child: Column(children: [
                          SizedBox(
                            height: 20,
                          ),
                          for (var store in filteredStores)
                            buildStoreContainer(store),
                        ])),
                  ],
                ),
              ),
            ),
          ),
       
        bottomNavigationBar: BottomNav(initialIndex: 0),
      ),
    );
  }

  // Function to build a container for each store
  Widget buildStoreContainer(Map<String, dynamic> store) {
    final isEnglish = Provider.of<AppState>(context).isEnglish;

    return GestureDetector(
      onTap: () async {
        Navigator.pushNamed(context, '/store-info', arguments: store);
      },
      child: FadeInRight(
          child: Container(
        // width: MediaQuery.of(context).size.width * 0.9, // 90% of screen width
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.fromLTRB(8, 10, 8, 10),
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 238, 238, 238),
          border: Border.all(
            color: Color.fromARGB(5, 0, 0, 0),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Column(
          children: [
            Container(
              height: 100,
              width: double.infinity,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                child: ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.transparent,
                        const Color.fromARGB(255, 238, 238, 238)
                            .withOpacity(0.8),
                      ],
                      stops: [0.0, 1.0],
                    ).createShader(bounds);
                  },
                  blendMode: BlendMode.dstIn,
                  child: Image.network(
                    'https://mhfatha.net/FrontEnd/assets/images/store_images/${store['photo']}', // Replace with the actual image path
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
              child: Align(
                alignment:
                    isEnglish ? Alignment.centerLeft : Alignment.centerRight,
                child: Text(
                  '${store['name']}',
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontFamily: AppVariables.serviceFontFamily,
                    fontSize: 17,
                  ),
                  textAlign: isEnglish ? TextAlign.left : TextAlign.right,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
              child: Align(
                alignment:
                    isEnglish ? Alignment.centerLeft : Alignment.centerRight,
                child: Text(
                  '${store['distance']}',
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontFamily: AppVariables.serviceFontFamily,
                    fontSize: 12,
                  ),
                  textAlign: isEnglish ? TextAlign.left : TextAlign.right,
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
