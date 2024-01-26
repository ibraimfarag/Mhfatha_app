import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mhfatha/settings/imports.dart';

class QrResponse extends StatefulWidget {
  final String responseData;

  const QrResponse({Key? key, required this.responseData}) : super(key: key);

  @override
  _QrResponseState createState() => _QrResponseState();
}

class _QrResponseState extends State<QrResponse> {
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

  @override
  Widget build(BuildContext context) {
    // Parse the JSON response data
    Map<String, dynamic> responseDataMap = jsonDecode(widget.responseData);

    // Access the "discounts" field
    List<dynamic> discounts = responseDataMap['discounts'];
    Map<String, dynamic> store = responseDataMap['store'];

    // Determine store name based on language
    String storeName = store['name'];

    bool isEnglish = Provider.of<AppState>(context).isEnglish;
    return DirectionalityWrapper(
      child: Scaffold(
        body: SingleChildScrollView(
          // Wrap the Column with SingleChildScrollView
          child: Container(
            decoration: BoxDecoration(
              color: Color(0xFF080E27), // Set your desired background color
            ),
            // padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Display the "Discount for Store" text
                  CustomAppBar(
                      onBackTap: () {
                        Navigator.pop(context);
                      },
                    ),
                Row(
                  children: [
                  
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
                                  height: 30,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  isEnglish
                                      ? 'Discount for Store'
                                      : 'خصومات متجر',
                                  style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                Text(
                                  storeName,
                                  style: TextStyle(
                                      fontSize: 24,
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
                                // Image.asset(
                                //   'images/nearby.gif', // Replace with the actual path to your GIF image
                                //   height: 50, // Adjust the height as needed
                                // ),
                              ],
                            ),
                          ]),
                    ),
                    SizedBox(height: 16),
                  ],
                ),

                SizedBox(height: 16),
                Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFF3F4F7),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Display the discounts' category and percent
                        for (var discount in discounts)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: GestureDetector(
                              onTap: () {
                                // Create a Map to hold both store and discount data
                                Map<String, dynamic> data = {
                                  'store': store,
                                  'discount': discount,
                                };

                                // Navigate to the new screen when the Container is tapped
                                Navigator.pushNamed(
                                  context,
                                  '/get-discount',
                                  arguments:
                                      data, // Pass the combined data to the new screen
                                );
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                      width: 300,
                                      margin: const EdgeInsets.all(10),
                                      padding: const EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
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
                                      )),
                                ],
                              ),
                            ),
                          ),
                      ],
                    )),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomNavBar(initialIndex: 1),
      ),
    );
  }
}
