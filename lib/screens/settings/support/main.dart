import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mhfatha/settings/imports.dart';
import 'package:permission_handler/permission_handler.dart';

class MainSupporting extends StatefulWidget {
  @override
  State<MainSupporting> createState() => _MainSupportingState();
}

class _MainSupportingState extends State<MainSupporting> {
  late AuthProvider authProvider; // Declare authProvider variable
  Api api = Api();
  Color backgroundColor = Color.fromARGB(220, 255, 255, 255);
  Color ui = Color.fromARGB(220, 233, 233, 233);
  Color ui2 = Color.fromARGB(255, 113, 194, 110);
  Color colors = Color(0xFF05204a);

  List<Map<String, dynamic>> supportTickets = []; // Add this line

  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    Api api = Api(); // Initialize vendorApi in initState
    final vendorApi = VendorApi(context);
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      fetchSupportTickets();
    });
  }

  void didChangeDependencies() {
    super.didChangeDependencies();
  }
String _formatDateTime(String dateTimeString) {
  // Parse the dateTimeString into a DateTime object
  DateTime dateTime = DateTime.parse(dateTimeString);

  // Format the date part (e.g., "27 May 2024")
  String formattedDate = DateFormat.yMMMMd().format(dateTime);

  // Format the time part (e.g., "09:13 AM")
  String formattedTime = DateFormat.jm().format(dateTime);

  return '$formattedDate, $formattedTime';
}

  Future<void> fetchSupportTickets() async {
    try {
      List<Map<String, dynamic>> tickets =
          await Api().getSupportTickets(criteria: 'user', context: context);
      setState(() {
        supportTickets = tickets;
      });
    } catch (e) {
      // Handle the error
      print('Failed to fetch support tickets: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isEnglish = Provider.of<AppState>(context).isEnglish;
    bool isDarkMode = Provider.of<AppState>(context).isDarkMode;
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    double screenWidth = MediaQuery.of(context).size.width;

    String lang = Provider.of<AppState>(context, listen: false).display;
    return DirectionalityWrapper(
        child: Scaffold(
      backgroundColor: Color(0xFFF3F4F7),
      body: SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
            color: Color(0xFF080E27), // Set background color to #080e27
            child: Column(
                // crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomAppBar(
                    onBackTap: () {
                      Navigator.pop(context);
                    },
                    marginTop: 30,
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(20, 1, 20, 5),
                    // height: 200,
                    child: Column(children: [
                      SizedBox(height: 1),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(children: [
                                Text(
                                  isEnglish
                                      ? 'Technical Support'
                                      : 'الدعم الفني',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ]),
                            ],
                          ),
                          SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, '/support/report');
                                  },
                                  child: Container(
                                    // width: 100,
                                    margin: EdgeInsets.fromLTRB(30, 0, 30, 20),
                                    padding:
                                        EdgeInsets.fromLTRB(20, 10, 20, 10),
                                    decoration: BoxDecoration(
                                      color: Color(0xFFF3F4F7),
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20),
                                        bottomRight: Radius.circular(20),
                                        bottomLeft: Radius.circular(20),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        isEnglish
                                            ? Icon(Icons.add)
                                            : Container(),
                                        Text(
                                          isEnglish
                                              ? 'New Request'
                                              : 'طلب جديد', // Text based on language
                                        ),
                                        SizedBox(
                                            width:
                                                5), // Space between icon and text
                                        isEnglish
                                            ? Container()
                                            : Icon(Icons.add), // Plus icon
                                      ],
                                    ),
                                  ),
                                ),
                              ]),
                              SizedBox(width: 20),
                              Column(
                                children: [],
                              )
                            ],
                          ),
                          SizedBox(height: 16),
                        ],
                      )
                    ]),
                  ),
                  SizedBox(height: 6),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
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
                        SizedBox(height: 20),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [],
                        ),
                        SingleChildScrollView(
                          child: Column(
                            children: supportTickets.map((ticket) {
                              return GestureDetector(
                                onTap: () {
                                  //  print(ticket['updated_at']);
                                  Navigator.pushNamed(
                                      context, '/support/ticket',
                                      arguments: ticket['id']);
                                },
                                child: Container(
                                  width: screenWidth * 0.9,
                                  margin: EdgeInsets.symmetric(vertical: 10),
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.2),
                                        spreadRadius: 5,
                                        blurRadius: 7,
                                        offset: Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        isEnglish
                                            ? 'Ticket Number: ${ticket['ticket_number'].toString()}'
                                            : 'رقم التذكرة: ${ticket['ticket_number'].toString()}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        isEnglish
                                            ? 'Status: ${ticket['status']}'
                                            : 'الحالة: ${ticket['status']}',
                                      ),
                                      Text(
  isEnglish
      ? 'Date: ${_formatDateTime(ticket['updated_at'])}'
      : 'التاريخ: ${_formatDateTime(ticket['updated_at'])}',
),

                                     
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ])),
      ),
      bottomNavigationBar: NewNav(),
    ));
  }
}
