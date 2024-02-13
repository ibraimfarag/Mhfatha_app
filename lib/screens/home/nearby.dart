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
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return DirectionalityWrapper(
      child: Scaffold(
        body: Container(
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
        Navigator.pushReplacementNamed(context, '/home');
                    },
                    marginTop:30
                  ),
                  // SizedBox(height: 3),
                  Container(
                    // width: 320,
                    // padding: const EdgeInsets.all(1.0),
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 1),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 1,
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
        // bottomNavigationBar: BottomNavBar(initialIndex: 0),
        bottomNavigationBar: NewNav(),
      ),
    );
  }

  // Function to build a container for each store
  Widget buildStoreContainer(Map<String, dynamic> store) {
    final isEnglish = Provider.of<AppState>(context).isEnglish;

    return GestureDetector(
      onTap: () async {
        Navigator.pushReplacementNamed(context, '/store-info', arguments: store);
      },
      child: FadeInRight(
          child: Container(
        // width: MediaQuery.of(context).size.width * 0.9, // 90% of screen width
        width: MediaQuery.of(context).size.width,
        // height: 150,
        margin: const EdgeInsets.fromLTRB(8, 10, 8, 10),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 5,
              blurRadius: 3,
              offset: Offset(0, 1),
            ),
          ],
          // color: Color(0xFFF3F4F7),
          color: Color(0xFFFFFFFF),
          border: Border.all(
            color: Color.fromARGB(5, 0, 0, 0),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                      child: Align(
                        alignment: isEnglish
                            ? Alignment.centerLeft
                            : Alignment.centerRight,
                        child: Text(
                          '${store['name']}',
                          style: TextStyle(
                              color: Colors.black87,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                          textAlign:
                              isEnglish ? TextAlign.left : TextAlign.right,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                      child: Align(
                        alignment: isEnglish
                            ? Alignment.centerLeft
                            : Alignment.centerRight,
                        child: Text(
                          isEnglish
                              ? '${store['category_name_en']}'
                              : '${store['category_name_ar']}',
                          style: TextStyle(
                              color: Colors.black87,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                          textAlign:
                              isEnglish ? TextAlign.left : TextAlign.right,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 0),
                      child: Align(
                        alignment: isEnglish
                            ? Alignment.centerLeft
                            : Alignment.centerRight,
                        child: Text(
                          '${store['distance']}',
                          style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                            fontFamily: AppVariables.serviceFontFamily,
                            fontSize: 12,
                          ),
                          textAlign:
                              isEnglish ? TextAlign.left : TextAlign.right,
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Container(
                      height: 100,

                      // width: double.infinity,
                      width: 100,
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                          bottomLeft: Radius.circular(30),
                        ),
                        child: Image.network(
                          'https://mhfatha.net/FrontEnd/assets/images/store_images/${store['photo']}', // Replace with the actual image path
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      )),
    );
  }
}
