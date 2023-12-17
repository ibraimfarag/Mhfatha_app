// lib/screens/store_info_screen.dart
import 'dart:convert';

import 'package:mhfatha/settings/imports.dart';

class StoreInfoScreen extends StatelessWidget {
  const StoreInfoScreen({Key? key}) : super(key: key);
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

  @override
  Widget build(BuildContext context) {
    // Retrieve the 'store' argument
    Map<String, dynamic>? storeData =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    bool isEnglish = Provider.of<AppState>(context).isEnglish;

    return DirectionalityWrapper(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
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
                          mainAxisAlignment: MainAxisAlignment.start,
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
  alignment: Provider.of<AppState>(context).isEnglish
      ? Alignment.centerLeft
      : Alignment.centerRight,
  child: Column(
    children: [
      Text(
        '${storeData?['name']}',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontFamily: AppVariables.serviceFontFamily,
          fontSize: 22,
        ),
        textAlign: Provider.of<AppState>(context).isEnglish
            ? TextAlign.left
            : TextAlign.right,
      ),
      Text(
        '${Provider.of<AppState>(context).isEnglish ? 'Distance: ' : ' على بعد '}${storeData?['distance']}',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.normal,
          fontFamily: AppVariables.serviceFontFamily,
          fontSize: 14,
        ),
        textAlign: Provider.of<AppState>(context).isEnglish
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
      topRight: Radius.circular(0), // Change to 0 for bottom right
      bottomLeft: Radius.circular(30), // Change to 0 for bottom left
      bottomRight: Radius.circular(30),
    ),                  ),
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
  launch('tel:$phoneNumber');
} else {
  // Handle the case where the phone number is not available
}
                          }),
                  VerticalDivider(color: Colors.black),        
              buildIconButton(Icons.directions,
                              isEnglish ? 'Directions' : 'الاتجاهات', () {
                            // Handle the directions action
                            // Example coordinates (adjust with your store location)
                            double latitude =
                                double.parse('${storeData?['latitude']}');
                            double longitude =
                                double.parse('${storeData?['longitude']}');
                            String label = '${storeData?['name']}';

                            launch(
                                'https://www.google.com/maps/dir/?api=1&destination=$latitude,$longitude');
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
      Provider.of<AppState>(context).isEnglish ? 'City: ' : 'المدينة: ',
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    ),
    Text(
      // Parse and format the city
      '${storeData?['city']}',
      style: TextStyle(fontSize: 16),
    ),
    SizedBox(width: 10), // Add some space between the two texts
    Text(
      Provider.of<AppState>(context).isEnglish ? 'Region: ' : 'المنطقة: ',
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    ),
    Text(
      // Parse and format the region
      '${storeData?['region']}',
      style: TextStyle(fontSize: 16),
    ),
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
                            ? 'store phone :'
                            : 'جوال المتجر',
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
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Column(
                            children: storeData?['discounts']
                                .entries
                                .map<Widget>((entry) {
                              Map<String, dynamic> discount =
                                  entry.value as Map<String, dynamic>;

                              return Container(
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
                                  // textAlign: isEnglish ? TextAlign.left : TextAlign.right,
                                ),
                              );
                            }).toList(),
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


