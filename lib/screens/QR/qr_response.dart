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
        body: SingleChildScrollView( // Wrap the Column with SingleChildScrollView
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Display the "Discount for Store" text
                Row(
                  children: [
                    Center(
                      child: Text(
                        isEnglish ? 'Discount for Store' : 'خصومات متجر',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Center(
                      child: Text(
                        storeName,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Display the discounts' category and percent
                    for (var discount in discounts)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 300,
                              margin: const EdgeInsets.all(10),
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child:Column(children: [
                                Row(children: [Text(
                                isEnglish
                                    ? 'Discount on: ${discount['category']} '
                                    : 'خصم على : ${discount['category']} ',
                                style: TextStyle(fontSize: 14),
                                textAlign: isEnglish ? TextAlign.left : TextAlign.right,
                              )],),
                                Row(children: [Text(
                                isEnglish
                                    ? 'Percent: ${discount['percent']}%'
                                    : 'نسبة الخصم : ${discount['percent']}% ',
                                style: TextStyle(fontSize: 14),
                                textAlign: isEnglish ? TextAlign.left : TextAlign.right,
                              ),],)
                              ],) 
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomNav(initialIndex: 1),
      ),
    );
  }
}
