// lib\screens\Auth\home\home_screen.dart
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:mhfatha/settings/imports.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double? latitude;
  double? longitude;
 // Declare a GlobalKey for the QR code scanner
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // Declare a controller for the QR code scanner
  late QRViewController controller;

  List<Map<String, dynamic>> filteredStores = [];

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  Future<void> _getLocation() async {
    // Check if permission is granted
    var status = await Permission.locationWhenInUse.status;

    if (status.isDenied) {
      // Request permission if not granted

      status = await Permission.locationWhenInUse.request();

      // status = await Permission.location.request();
// await requestLocationPermission();
      // await Permission.location.request();
      //  bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();

      // await Geolocator.checkPermission();
      await Geolocator.requestPermission();

      if (status.isDenied) {
        // Handle case when permission is still not granted
        print('Location permission is denied.');

        return;
      }
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      LocationPermission permission;
      permission = await Geolocator.requestPermission();

      setState(() {
        latitude = position.latitude;
        longitude = position.longitude;
      });

      // Call the method to send location when the coordinates are available
      if (latitude != null && longitude != null) {
        await _sendLocation();
      }
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  Future<void> _sendLocation() async {
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);

    try {
      // Get the language display value from the app state
      String language = Provider.of<AppState>(context, listen: false).display;

      final response = await Api().sendLocation(
        authProvider,
        latitude!,
        longitude!,
        language, // Include the language in the request
      );

      if (response.isNotEmpty) {
        // Parse the JSON string to get the list of stores
        Map<String, dynamic> jsonResponse = jsonDecode(response);

        // Check if 'filteredStores' key exists and its type is correct
        if (jsonResponse.containsKey('filteredStores') &&
            jsonResponse['filteredStores'] is List<dynamic>) {
          List<dynamic> stores = jsonResponse['filteredStores'];

          // Convert each item in the list to a Map
          List<Map<String, dynamic>> validStores =
              stores.whereType<Map<String, dynamic>>().toList();

          setState(() {
            filteredStores = validStores;
          });
        } else {
          print('Invalid response format: ${response.toString()}');
        }
      }
    } catch (e) {
      print('Error during sending location: $e');
    }
  }

  void _showStoreOptions(BuildContext context, Map<String, dynamic> store) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        bool isEnglish = Provider.of<AppState>(context).isEnglish;
        AuthProvider authProvider =
            Provider.of<AuthProvider>(context, listen: false);

        return Container(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () {
                  // Handle "Info about this store" option
                  Navigator.pop(context); // Close the bottom sheet
                  // Add your logic to show store info
Navigator.pushNamed(context, '/store-info', arguments: store);

                },
                child: Text(
                  isEnglish ? 'Info about this store' : 'معلومات عن هذا المتجر',
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  // Handle "Show discounts" option
                  Navigator.pop(context); // Close the bottom sheet

                  // Display sub-context bottom menu
                  _showSubContextBottomMenu(context, store);
                  // Add the logic to get store details by calling the API

                  // Get store ID
                  int storeId = store['id'];

                  // Call the API to get store details
                  String storeDetails =
                      await Api().getStoreDetails(authProvider, store['id']);

                  // Parse the store details JSON
                  Map<String, dynamic> storeDetailsMap =
                      jsonDecode(storeDetails);

                  // Access the "discounts" list
                  List<dynamic> discounts =
                      storeDetailsMap['store']['discounts'];

                  // Iterate over each discount
                  for (var discount in discounts) {
                    // Access discount properties
                    int id = discount['id'];
                    double percent = double.parse(discount['percent']);
                    String category = discount['category'];
                    // ... access other properties as needed

                    // Now, you can use these properties as needed.
                    // print('Discount ID: $id, Percent: $percent, Category: $category');
                  }
                },
                child: Text(
                  isEnglish ? 'Show discounts' : 'عرض الخصومات',
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showSubContextBottomMenu(BuildContext context, Map<String, dynamic> store) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      bool isEnglish = Provider.of<AppState>(context).isEnglish;
      AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);

      return Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: isEnglish ? CrossAxisAlignment.start : CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isEnglish
                  ? 'Discounts ${store['name']}'
                  : 'خصومات  ${store['name']}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              if (store['discounts'] == null || store['discounts'].isEmpty)
                Text(
                  isEnglish ? 'No discounts available now' : 'لا توجد خصومات متاحة الآن',
                  style: TextStyle(fontSize: 16),
                )
              else
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Column(
                    // children: store['discounts'].entries.map<Widget>((entry) {
                    //   Map<String, dynamic> discount = entry.value as Map<String, dynamic>;
children: (store?['discounts'] is List<dynamic>
  ? (store?['discounts'] as List<dynamic>)
  : [])
  .map<Widget>((discount) {                      return Container(
                        width: MediaQuery.of(context).size.width - 100,
                        margin: const EdgeInsets.all(10),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          isEnglish
                            ? 'Discount on: ${discount['category']} Percent: ${discount['percent']}%'
                            : '%${discount['percent']}:نسبة الخصم  ${discount['category']}:خصم على',
                          style: TextStyle(fontSize: 16),
                          textAlign: isEnglish ? TextAlign.left : TextAlign.right,
                        ),
                      );
                    }).toList(),
                  ),
                ),

              SizedBox(height: 20),
              Align(
                alignment: isEnglish ? Alignment.bottomRight : Alignment.bottomLeft,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _showStoreOptions(context, store);
                  },
                  child: Text(
                    isEnglish ? 'Back' : 'العودة',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}


  List<Widget> buildStoreContainers() {
    return filteredStores.map((store) {
      return GestureDetector(
        onTap: () {
          _showStoreOptions(context, store);
        },
        child: Container(
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
                // height: 100,
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 3, 12, 19),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    // Image with gradient
                    Container(
                      height: 100,
                      width: 180,
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
                            'https://mhfatha.net/FrontEnd/assets/images/store_images/${store['photo']}', // Replace with your actual image URL
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    // Text widget for store name
                  Container(
  padding: const EdgeInsets.all(15),
  child: Align(
    alignment: Provider.of<AppState>(context).isEnglish
        ? Alignment.centerLeft
        : Alignment.centerRight,
    child: Text(
      ' ${store['name']}',
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontFamily: AppVariables.serviceFontFamily,
        fontSize: 14,
      ),
      textAlign: Provider.of<AppState>(context).isEnglish
          ? TextAlign.left
          : TextAlign.right,
    ),
  ),
),

                    // Row for buttons with icons
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.location_on,
                                  color: Colors.white, size: 18),
                              const SizedBox(width: 1),
                              TextButton(
                                onPressed: () {
                                  // Handle onPressed for "يبعد 5 كم" button
                                },
                                child: Text(
  '${Provider.of<AppState>(context).isEnglish ? 'Distance: ' : 'يبعد '}${store['distance']}',
  style: TextStyle(
    color: Colors.white,
    fontSize: 12,
    fontFamily: AppVariables.serviceFontFamily,
  ),
),

                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );
    }).toList();
  }
 // Function to show the QR code scanner
  void _showQRScanner() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 300,
          child: QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
          ),
        );
      },
    );
  }

  // Function to handle QR code view creation
  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      // Handle the scanned QR code data
      print("Scanned QR code data: $scanData");

      // Add your logic here to process the scanned QR code data
      // For example, you can navigate to a new screen or perform an action based on the data.
    });
  }
  @override
  Widget build(BuildContext context) {
    bool isEnglish = Provider.of<AppState>(context).isEnglish;
    Size size = MediaQuery.of(context).size;

    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);

    return DirectionalityWrapper(
      child: Scaffold(
        body: Container(
          width: size.width, // Set the width of the container
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 100,
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  alignment:
                      isEnglish ? Alignment.centerLeft : Alignment.centerRight,
                  child: Row(
                    children: [
                      Icon(Icons.store, color: Colors.black, size: 24),
                      SizedBox(width: 10),
                      Text(
                        isEnglish ? 'Nearby Stores' : 'متاجر قريبة',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                if (filteredStores.isNotEmpty)
                  Container(
                    // Add your custom properties for the CarouselSlider...
                    child: CarouselSlider(
                      items: buildStoreContainers(),
                      options: CarouselOptions(
                        autoPlay: true,
                        aspectRatio: 22 / 12,
                        enlargeCenterPage: false,
                        enableInfiniteScroll: true,
                        autoPlayCurve: Curves.fastOutSlowIn,
                        autoPlayAnimationDuration: Duration(milliseconds: 4000),
                        viewportFraction: 0.5,
                      ),
                    ),
                  ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildIconWithText(Icons.qr_code, 'Scan QR', 'فحص كود'),
                      buildIconWithText(Icons.store, 'Nearby', 'قريبة'),
                      buildIconWithText(Icons.search, 'Search', 'البحث'),
                      buildIconWithText(
                          Icons.local_offer, 'Top Discount', 'أعلى خصم'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomNav(initialIndex: 0),
      ),
    );
  }

  Widget buildIconWithText(
      IconData icon, String englishText, String arabicText) {
    final isEnglish = Provider.of<AppState>(context).isEnglish;

    return GestureDetector(
      onTap: () {        _showQRScanner();
},
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.blue,
            child: Icon(
              icon,
              color: Colors.white,
              size: 30,
            ),
          ),
          SizedBox(height: 8),
          Text(
            isEnglish ? englishText : arabicText,
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}
