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
  List<Map<String, dynamic>> filteredStores = [];


  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  Future<void> _getLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        latitude = position.latitude;
        longitude = position.longitude;
     

      });

      // Call the method to send location when the coordinates are available
      if (latitude != null && longitude != null ) {
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
      language,  // Include the language in the request
    );

      if (response.isNotEmpty) {
        // Parse the JSON string to get the list of stores
        Map<String, dynamic> jsonResponse = jsonDecode(response);

        // Check if 'filteredStores' key exists and its type is correct
        if (jsonResponse.containsKey('filteredStores') &&
            jsonResponse['filteredStores'] is List<dynamic>) {
          List<dynamic> stores = jsonResponse['filteredStores'];

          // Convert each item in the list to a Map
          List<Map<String, dynamic>> validStores = stores
              .whereType<Map<String, dynamic>>()
              .toList();

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


  List<Widget> buildStoreContainers() {
    return filteredStores.map((store) {
      return Container(
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
                      // width: 250,
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
  fit: BoxFit.fill,
),
                        ),
                      ),
                    ),
                    // Text widget for store name
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          ' ${store['name']}',
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
                                  'يبعد  ${store['distance']}',
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
              // Add more containers as needed



          ],
        ),
      );
    }).toList();
  }
  @override

  Widget build(BuildContext context) {
    bool isEnglish = Provider.of<AppState>(context).isEnglish;
    Size size = MediaQuery.of(context).size;

    AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);

    return DirectionalityWrapper(
      child: Scaffold(
      body:  Container(
    width: size.width, // Set the width of the container
    child:SingleChildScrollView(
        child: Column(
          children: [
           SizedBox(
            height: 100,
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

 
          ],
        ),
      ),
      ),
      bottomNavigationBar: BottomNav(initialIndex: 0),
    ),
    );
  }


}


      // appBar: AppBar(
      //   title:  Text(' ${authProvider.user!['first_name']}'),
      // ),
      // body:
      //             Text('${authProvider.token}'),
                 