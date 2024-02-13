// lib\screens\QR\get_discount.dart

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:mhfatha/settings/imports.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';

class FiteredStroes extends StatefulWidget {
  @override
  _FiteredStroesState createState() => _FiteredStroesState();
}

class _FiteredStroesState extends State<FiteredStroes> {
  Api api = Api(); // Create an instance of the Api class

  String selectedRegion =
      '0'; // Initialize with an empty string or default value
  String selectedCategory =
      '0'; // Initialize with an empty string or default value
  List<dynamic> filteredStores = [];
  List<dynamic> regionList = [];
  List<dynamic> categoryList = [];
  double? latitude;
  double? longitude;
  @override
  void initState() {
    super.initState();
    // Call the fetchRegionList method from the Api class when the widget is initialized
    _getLocation();
    fetchFilteredStores();
  }

// Inside _FilteredStoresState class
  void fetchFilteredStores() async {
    String userLatitude = "$latitude";
    String userLongitude = "$longitude";

    try {
      Map<String, dynamic> result = await api.filterStores(
        context,
        selectedRegion,
        selectedCategory,
        userLatitude,
        userLongitude,
      );

      // Now you can access the filtered stores, regionList, and categoryList
      List<dynamic> stores = result['filteredStores'];
      List<dynamic> regions = result['regionList'];
      List<dynamic> category = result['categoryList'];

      setState(() {
        filteredStores = stores;
        regionList = regions;
        categoryList = category;
      });
    } catch (e) {
      // Handle errors
      print('Error fetching filtered stores: $e');
    }
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
// print('${validStores}');
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

  @override
  Widget build(BuildContext context) {
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
              color: Color(0xFF080E27),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomAppBar(
                      onBackTap: () {
                        Navigator.pop(context);
                      },
                      marginTop: 30),
                  // SizedBox(height: 3),
                  Container(
                    // width: 320,
                    // padding: const EdgeInsets.all(1.0),
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isEnglish ? 'Stores' : 'المتاجر',
                                style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              // Add some space between the text and the dropdowns
                          
                                  // First Dropdown
                                  Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                              SizedBox(height: 20),
                                    
                                            Text(
                                              isEnglish ? 'Region' : 'المدينة',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                              
                                            ),
                                                   SizedBox(height: 10),
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 1, horizontal: 20),
                                              decoration: BoxDecoration(
                                                color: Colors.grey[200],
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                              child: DropdownButton(
                                                value: selectedRegion,
                                                items: regionList.map((region) {
                                                  return DropdownMenuItem(
                                                    value: region['region_id']
                                                        .toString(), // Use region_id as the value
                                                    child: Text(
                                                        region['region_name']),
                                                  );
                                                }).toList(),
                                                onChanged: (value) {
                                                  setState(() {
                                                    selectedRegion =
                                                        value.toString();
                                                    // Perform actions when a region is selected, if needed
                                                  });
                                                  fetchFilteredStores();
                                                },
                                                underline: Container(),
                                              ),
                                            ),
                                
                                      ]),
                                 
                                 SizedBox(height: 10),
                                 
                                  Row(children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          isEnglish ? 'Categorie' : 'الفئة',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        
                                 SizedBox(height: 10),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 3, horizontal: 20),
                                          decoration: BoxDecoration(
                                            color: Colors.grey[200],
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          child: DropdownButton(
                                            value: selectedCategory,
                                            items: categoryList.map((category) {
                                              return DropdownMenuItem(
                                                value: category['category_id']
                                                    .toString(), // Use category_id as the value
                                                child: Text(
                                                    category['category_name']),
                                              );
                                            }).toList(),
                                            onChanged: (value) {
                                              setState(() {
                                                selectedCategory =
                                                    value.toString();

                                                // Perform actions when a category is selected, if needed
                                              });
                                              fetchFilteredStores();
                                            },
                                            underline: Container(),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ]),
                          
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
                              // Image.asset(
                              //   'images/FiteredStroes.gif', // Replace with the actual path to your GIF image
                              //   height: 80, // Adjust the height as needed
                              // ),
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
                        for (dynamic store in filteredStores)
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

  Widget buildStoreContainer(dynamic store) {
    final isEnglish = Provider.of<AppState>(context).isEnglish;

    return GestureDetector(
      onTap: () async {
        Navigator.pushNamed(context, '/store-info', arguments: store);
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
