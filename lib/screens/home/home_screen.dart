// lib\screens\Auth\home\home_screen.dart
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:mhfatha/settings/imports.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';
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
  Api api = Api();
  // Declare a controller for the QR code scanner
  late QRViewController controller;

  List<Map<String, dynamic>> storeList = [];
bool isLoading = true;
  List<Map<String, dynamic>> filteredStores = [];
  Timer? locationTimer;
  Timer? reloadTimer;
late Timer network;
  @override
  void initState() {
    super.initState();
    _getLocation();
    // Set up a timer to check location changes every 90 seconds
    locationTimer = Timer.periodic(Duration(seconds: 10), (Timer timer) async {
      await _checkAndSendLocation();
    });

    reloadTimer = Timer.periodic(Duration(seconds: 5), (Timer timer) {
      if (filteredStores.isEmpty) {
        _reloadFilteredStores();
      }
    });

     Timer(Duration(seconds: 3), () {
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  });
  }
//  @override
// void dispose() {
  // Cancel the timer when the widget is disposed
  // locationTimer?.cancel();
  // super.dispose();
// }

  Future<void> _checkAndSendLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Check if the widget is still mounted before updating the state
      if (!mounted) {
        return;
      }

      // Check if the location has changed significantly
      if (latitude != position.latitude || longitude != position.longitude) {
        setState(() {
          latitude = position.latitude;
          longitude = position.longitude;
        });

        // Call the method to send location when the coordinates are available
        if (latitude != null && longitude != null) {
          await _sendLocation();
        }
      }
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  int calculateDaysRemaining(String endDate) {
    DateTime endDateTime = DateTime.parse(endDate);
    DateTime now = DateTime.now();
    Duration difference = endDateTime.difference(now);
    return difference.inDays;
  }

  // Function to get the correct Arabic word for days
  String getArabicDaysWord(int days) {
    return days > 10 ? 'يوم' : 'أيام';
  }

  String getEnglishDaysWord(int days) {
    return days > 1 ? 'Days' : 'Day';
  }

  Future<void> _getLocation() async {
      bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the 
    // App to enable the location services.
    return Future.error('Location services are disabled.');
  }
    permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale 
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }
  
  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately. 
    return Future.error(
      'Location permissions are permanently denied, we cannot request permissions.');
  } 

    // Check if the widget is still mounted
    if (!mounted) {
      return;
    }

    // Check if locationWhenInUse permission is granted
    var status = await Permission.locationWhenInUse.status;

    if (status.isDenied) {
      // Request locationWhenInUse permission if not granted
      status = await Permission.locationWhenInUse.request();

      if (!mounted) {
        return;
      }

      if (status.isDenied) {
        // Handle case when locationWhenInUse permission is still not granted
        print('Location permission is denied.');
        return;
      }
    }


    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Check if the widget is still mounted before updating the state
      if (!mounted) {
        return;
      }

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
Future<void> _reloadFilteredStores() async {
  // Check if the widget is still mounted before proceeding
  if (!mounted) {
    return;
  }

  // Add logic to reload filteredStores
  await _sendLocation();
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
                  String storeDetails = await Api().getStoreDetails(
                      authProvider, store['id'], latitude!, longitude!);

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

  void _showSubContextBottomMenu(
      BuildContext context, Map<String, dynamic> store) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        bool isEnglish = Provider.of<AppState>(context).isEnglish;
        AuthProvider authProvider =
            Provider.of<AuthProvider>(context, listen: false);

        return Container(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment:
                  isEnglish ? CrossAxisAlignment.start : CrossAxisAlignment.end,
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
                    isEnglish
                        ? 'No discounts available now'
                        : 'لا توجد خصومات متاحة الآن',
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
                          .map<Widget>((discount) {
                        return Container(
                            width: MediaQuery.of(context).size.width - 100,
                            margin: const EdgeInsets.all(10),
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      isEnglish
                                          ? 'Discount on: ${discount['category']} '
                                          : 'خصم على : ${discount['category']} ',
                                      style: TextStyle(fontSize: 14),
                                      textAlign: isEnglish
                                          ? TextAlign.left
                                          : TextAlign.right,
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      isEnglish
                                          ? 'Percent: ${discount['percent']}%'
                                          : 'نسبة الخصم : ${discount['percent']}% ',
                                      style: TextStyle(fontSize: 14),
                                      textAlign: isEnglish
                                          ? TextAlign.left
                                          : TextAlign.right,
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      isEnglish
                                          ? 'Days Remaining: ${calculateDaysRemaining(discount['end_date'])} ${getEnglishDaysWord(calculateDaysRemaining(discount['end_date']))}'
                                          : 'الأيام المتبقية: ${calculateDaysRemaining(discount['end_date'])} ${getArabicDaysWord(calculateDaysRemaining(discount['end_date']))}',
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.blue),
                                      textAlign: isEnglish
                                          ? TextAlign.left
                                          : TextAlign.right,
                                    ),
                                  ],
                                )
                              ],
                            ));
                      }).toList(),
                    ),
                  ),
                SizedBox(height: 20),
                Align(
                  alignment:
                      isEnglish ? Alignment.bottomRight : Alignment.bottomLeft,
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
          // height: 900,
          margin: const EdgeInsets.fromLTRB(8, 0, 8, 0),
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 3, 12, 19),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            children: [
              Container(
                width: 500,
                // height: 900,
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 5),
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

  @override
  Widget build(BuildContext context) {
    bool isEnglish = Provider.of<AppState>(context).isEnglish;
    Size size = MediaQuery.of(context).size;
    String lang = Provider.of<AppState>(context, listen: false).display;

    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    String authName = authProvider.user![
        'first_name']; // Replace with the actual property holding the user's name

    return DirectionalityWrapper(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();

          setState(() {
            storeList = [];
          });
        },
        child: Scaffold(
          body: Container(
            width: size.width, // Set the width of the container
            child: SingleChildScrollView(
              child: Stack(
                children: [
                  Column(
                    children: [
                      SizedBox(
                        height: 60,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 25),
                        child: Align(
                          alignment: isEnglish
                              ? Alignment.centerLeft
                              : Alignment.centerRight,
                          child: Text(
                            isEnglish
                                ? 'Welcome back $authName'
                                : 'مرحبًا $authName',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        child: Column(
                          children: [
                            TextField(
                              decoration: InputDecoration(
                                hintStyle:
                                    TextStyle(color: Colors.grey.shade700),
                                filled: true,
                                hintText: isEnglish
                                    ? 'Search stores'
                                    : 'ابحث عن متجر',
                                prefixIcon: Icon(Icons.search),
                                fillColor: Color.fromARGB(255, 225, 226, 228),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      color:
                                          Color.fromARGB(255, 225, 226, 228)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      color:
                                          Color.fromARGB(255, 225, 226, 228)),
                                ),
                              ),
                              onChanged: (query) {
                                // Call the API method to search stores with the entered query
                                api
                                    .searchStores(authProvider, query, lang)
                                    .then((result) {
                                  // print('Search Result: $result');

                                  // Parse the JSON response
                                  Map<String, dynamic> jsonResponse =
                                      jsonDecode(result);

                                  // Check if 'stores' key exists and its type is correct
                                  if (jsonResponse.containsKey('stores') &&
                                      jsonResponse['stores'] is List<dynamic>) {
                                    List<dynamic> stores =
                                        jsonResponse['stores'];

                                    // Convert each item in the list to a Map
                                    // List<Map<String, dynamic>> storeList = stores.whereType<Map<String, dynamic>>().toList();

                                    storeList = stores
                                        .whereType<Map<String, dynamic>>()
                                        .toList();
                                    setState(() {});
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        alignment: isEnglish
                            ? Alignment.centerLeft
                            : Alignment.centerRight,
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
   if (isLoading)
        Center(
          child: CircularProgressIndicator(), // Loading indicator
        )
      else if (filteredStores.isNotEmpty)
        Container(
          // Add your custom properties for the CarouselSlider...
          child: CarouselSlider(
            items: buildStoreContainers(),
            options: CarouselOptions(
              autoPlay: true,
              aspectRatio: 9 / 5,
              enlargeCenterPage: false,
              enableInfiniteScroll: true,
              autoPlayCurve: Curves.fastOutSlowIn,
              autoPlayAnimationDuration: Duration(milliseconds: 4000),
              viewportFraction: 0.5,
            ),
          ),
        )
      else
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            isEnglish
                ? "Unfortunately, there are no stores near you at the moment."
                : "للأسف لا توجد متاجر في الوقت الحالي بالقرب منك",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.red, // Customize the color as needed
            ),
            textAlign: TextAlign.center,
          ),
        ),                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            buildIconWithText(
                              Icons.qr_code,
                              'Scan QR',
                              'فحص كود',
                              'images/scan-qr.jpg', // Replace with the actual image path
                              () {
                                Navigator.pushNamed(context, '/qr-scanner');
                              },
                            ),

                            buildIconWithText(Icons.store, 'Nearby stores',
                                'متاجر قريبة', 'images/near-by.jpg', () {
                              Navigator.pushNamed(context, '/nearby',
                                  arguments: filteredStores);
                            }),
                            // buildIconWithText(Icons.search, 'Search', 'البحث', () {}),

                            buildIconWithText(Icons.local_offer, 'Top Discount',
                                'أعلى خصم', 'images/best-deal.jpg', () {
                                    Navigator.pushNamed(context, '/nointernet');

                            }),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (storeList.isNotEmpty)
                    Positioned(
                      top: 130, // Adjust the top position as needed
                      left: 20, // Adjust the left position as needed
                      child: Container(
                        constraints: BoxConstraints(maxHeight: 200),
                        width: size.width - 40,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 225, 226, 228),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          itemCount: storeList.length,
                          itemBuilder: (context, index) {
                            // Check if the index is within the valid range
                            if (index >= 0 && index < storeList.length) {
                              // Access individual store information using storeList[index]
                              Map<String, dynamic> stores = storeList[index];
                              String name = stores['name'].toString();
                              String id = stores['id'].toString();

                              // Wrap the ListTile with GestureDetector to make it tappable
                              return GestureDetector(
                                onTap: () async {
                                  // Handle the tap action here, e.g., navigate to a new screen
                                  print('Tapped on item with id: $id');
                                  String storeDetails = await Api()
                                      .getStoreDetails(authProvider,
                                          stores['id'], latitude!, longitude!);

                                  // Parse the store details JSON
                                  Map<String, dynamic> storeDetailsMap =
                                      jsonDecode(storeDetails);
                                  Map<String, dynamic> store =
                                      storeDetailsMap['store'];
                                  Navigator.pushNamed(context, '/store-info',
                                      arguments: store);

                                  print(store);
                                },
                                child: ListTile(
                                  title: Text(name),
                                  // subtitle: Text(store['description']),  // Replace 'description' with the actual key
                                  // Add more widgets to display additional information as needed
                                ),
                              );
                            } else {
                              // Handle the case where the index is out of bounds
                              return SizedBox.shrink();
                            }
                          },
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: BottomNav(initialIndex: 0),
        ),
      ),
    );
  }

  Widget buildIconWithText(IconData icon, String englishText, String arabicText,
      String imagePath, VoidCallback onTap) {
    final isEnglish = Provider.of<AppState>(context).isEnglish;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100, // Adjust the width as needed
        margin: const EdgeInsets.fromLTRB(8, 0, 8, 0),
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 238, 238, 238),
          border: Border.all(
            color: Color.fromARGB(
                5, 0, 0, 0), // You can customize the border color
            width: 2, // You can customize the border width
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
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
                        const Color.fromARGB(255, 238, 238, 238)
                            .withOpacity(0.8),
                      ],
                      stops: [0.0, 1.0],
                    ).createShader(bounds);
                  },
                  blendMode: BlendMode.dstIn,
                  child: Image.asset(
                    imagePath, // Use the provided image path
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Align(
                alignment:
                    isEnglish ? Alignment.centerLeft : Alignment.centerRight,
                child: Text(
                  isEnglish ? englishText : arabicText,
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontFamily: AppVariables.serviceFontFamily,
                    fontSize: 14,
                  ),
                  textAlign: isEnglish ? TextAlign.left : TextAlign.right,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
