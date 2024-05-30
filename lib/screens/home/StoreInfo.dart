// lib/screens/store_info_screen.dart
import 'dart:convert';

import 'package:mhfatha/settings/imports.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

class StoreInfoScreen extends StatefulWidget {
  const StoreInfoScreen({Key? key}) : super(key: key);

  @override
  State<StoreInfoScreen> createState() => _StoreInfoScreenState();
}

class _StoreInfoScreenState extends State<StoreInfoScreen> {
  String parseWorkDays(Map<String, dynamic> workDays, bool isEnglish) {
    // Define day names in English and Arabic
    Map<String, String> dayNames = {
      'sunday': isEnglish ? 'Sunday' : 'الأحد',
      'monday': isEnglish ? 'Monday' : 'الاثنين',
      'tuesday': isEnglish ? 'Tuesday' : 'الثلاثاء',
      'wednesday': isEnglish ? 'Wednesday' : 'الأربعاء',
      'thursday': isEnglish ? 'Thursday' : 'الخميس',
      'friday': isEnglish ? 'Friday' : 'الجمعة',
      'saturday': isEnglish ? 'Saturday' : 'السبت',
    };

    // Create a list to store the formatted work day information
    List<String> formattedWorkDays = [];

    // Iterate through each day and format the information
    workDays.forEach((day, time) {
      String from = time['from'];
      String to = time['to'];

      // Use the day name based on the language
      String dayName = dayNames[day] ?? day;

      String formattedTime = '$from - $to';

      // Add the formatted information to the list
      formattedWorkDays.add('$dayName: $formattedTime');
    });

    // Join the formatted information with line breaks
    return formattedWorkDays.join('\n');
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

  void didChangeDependencies() {
    super.didChangeDependencies();
    
  }

  @override
  Widget build(BuildContext context) {
    // Retrieve the 'store' argument
    Map<String, dynamic>? storeData =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    bool isEnglish = Provider.of<AppState>(context).isEnglish;

    return DirectionalityWrapper(
      child: Scaffold(
        body:  Stack(
          children: [SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
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
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            
                            Container(
                            width: 500,
                            margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 3, 12, 19),
                              borderRadius: BorderRadius.circular(0),
                            ),
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(0),
                                    topRight: Radius.circular(0),
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
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: 200,
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: isEnglish? Alignment.topLeft:Alignment.topRight,
                                  child: IconButton(
                                    icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                            
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 15),
                              child: Align(
                                alignment:
                                    Provider.of<AppState>(context).isEnglish
                                        ? Alignment.centerLeft
                                        : Alignment.centerRight,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${storeData?['name']}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontFamily:
                                            AppVariables.serviceFontFamily,
                                        fontSize: 22,
                                      ),
                                      textAlign: Provider.of<AppState>(context)
                                              .isEnglish
                                          ? TextAlign.left
                                          : TextAlign.right,
                                    ),
                                    Text(
                                      '${Provider.of<AppState>(context).isEnglish ? '${storeData?['category_name_en']}' : '${storeData?['category_name_ar']}'}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.normal,
                                        fontFamily:
                                            AppVariables.serviceFontFamily,
                                        fontSize: 14,
                                      ),
                                      textAlign: Provider.of<AppState>(context)
                                              .isEnglish
                                          ? TextAlign.left
                                          : TextAlign.right,
                                    ),
                                    Text(
                                      '${Provider.of<AppState>(context).isEnglish ? 'Distance: ' : ' على بعد '}${storeData?['distance']}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.normal,
                                        fontFamily:
                                            AppVariables.serviceFontFamily,
                                        fontSize: 14,
                                      ),
                                      textAlign: Provider.of<AppState>(context)
                                              .isEnglish
                                          ? TextAlign.left
                                          : TextAlign.right,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                //  /* ------------------------------ store actions ------------------------------ */
                Container(
                  margin: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 223, 223, 223),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(0),
                      topRight:
                          Radius.circular(0), // Change to 0 for bottom right
                      bottomLeft:
                          Radius.circular(30), // Change to 0 for bottom left
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          buildIconButton(
                              Icons.call, isEnglish ? 'Call' : 'اتصال', () {
                            // Handle the call action
                            final phoneNumber = storeData?['phone'];
                            if (phoneNumber != null && phoneNumber.isNotEmpty) {
                              FlutterPhoneDirectCaller.callNumber(phoneNumber);
                            } else {
                              // Handle the case where the phone number is not available
                            }
                          }),
                          VerticalDivider(color: Colors.black),
                          buildIconButton(Icons.directions,
                              isEnglish ? 'Directions' : 'الاتجاهات', () async {
                            // Handle the directions action
                            // Example coordinates (adjust with your store location)
                            double latitude =
                                double.parse('${storeData?['latitude']}');
                            double longitude =
                                double.parse('${storeData?['longitude']}');
                            String label = '${storeData?['name']}';
                            String description = isEnglish?'${storeData?['category_name_en']}':'${storeData?['category_name_ar']}';

                            // launch(
                            //     'https://www.google.com/maps/dir/?api=1&destination=$latitude,$longitude');

                            // MapsLauncher.launchCoordinates(latitude, longitude);
                            final availableMaps =
                                await MapLauncher.isMapAvailable(MapType.google);
                            print(
                                availableMaps); // [AvailableMap { mapName: Google Maps, mapType: google }, ...]

                            await MapLauncher.showMarker(
                              mapType: MapType.google,
                              coords: Coords(latitude, longitude),
                              title: "$label",
                                    description: description,

                            );
                          }),
                          // buildIconButton(
                          //     Icons.message, isEnglish ? 'Message' : 'رسالة',
                          //     () {
                          //   // Handle the message action
                          //   // You can add your logic for handling messages
                          //   // For example, opening a messaging app
                          // }),
                        ],
                      )
                    ],
                  ),
                ),

                if (storeData?['discounts'] == null ||
                    storeData?['discounts'].isEmpty)
                  Container(
                      width: MediaQuery.of(context).size.width - 100,
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        isEnglish
                            ? 'No discounts available now'
                            : 'لا توجد خصومات متاحة الآن',
                        style: TextStyle(fontSize: 16),
                      ))
                else
                  // /* ------------------------------ Discounts ------------------------------ */
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          Provider.of<AppState>(context).isEnglish
                              ? 'Discounts:'
                              : 'الخصومات:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          constraints: BoxConstraints(
                            minHeight: 100,
                            maxHeight: 250,
                          ),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                              children:
                                  (storeData?['discounts'] is List<dynamic>
                                          ? (storeData?['discounts']
                                              as List<dynamic>)
                                          : [])
                                      .map<Widget>((discount) {
                                return Container(
                                    width: 300,
                                    margin: const EdgeInsets.all(10),
                                    padding: const EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                          255, 228, 224, 224),
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
                                                  fontSize: 12,
                                                  color: Colors.blue),
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
                        )
                      ],
                    ),
                  ),

                //  /* ------------------------------ store address ------------------------------ */
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Provider.of<AppState>(context).isEnglish
                            ? 'Store Address :'
                            : 'عنوان المتجر',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Text(
                            Provider.of<AppState>(context).isEnglish
                                ? 'City: '
                                : 'المدينة: ',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            // Parse and format the city
                            '${storeData?[isEnglish ? 'region_name_en' : 'region_name_ar']}',
                            style: TextStyle(fontSize: 16),
                          ),
                          // SizedBox(width: 10), // Add some space between the two texts
                          // Text(
                          //   Provider.of<AppState>(context).isEnglish ? 'Region: ' : 'المنطقة: ',
                          //   style: TextStyle(
                          //     fontSize: 16,
                          //     fontWeight: FontWeight.bold,
                          //   ),
                          // ),
                          // Text(
                          //   // Parse and format the region
                          //   '${storeData?['region']}',
                          //   style: TextStyle(fontSize: 16),
                          // ),
                        ],
                      ),
                      Text(
                        // Parse and format the working days and hours
                        '${storeData?['location']}',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
                //  /* ------------------------------ store number ------------------------------ */
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Provider.of<AppState>(context).isEnglish
                            ? 'Telephone / Store Number'
                            : 'جوال / هاتف المتجر',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        // Parse and format the working days and hours
                        '${storeData?['phone']}',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),

// /* ----------------------------- Days and hours ----------------------------- */
                if (storeData?['work_days'] != null)
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          Provider.of<AppState>(context).isEnglish
                              ? 'Working Hours:'
                              : 'ساعات العمل',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          // Parse and format the working days and hours
                          parseWorkDays(
                            jsonDecode(storeData?['work_days']),
                            Provider.of<AppState>(context).isEnglish,
                          ),
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
        ])
      ),
    );
  }

  Widget buildIconButton(IconData icon, String text, VoidCallback onPressed) {
    return Column(
      children: [
        IconButton(
          icon: Icon(icon),
          onPressed: onPressed,
          // Customize the color and size as needed
        ),
        Text(
          text,
          // Customize the style as needed
        ),
      ],
    );
  }
}
