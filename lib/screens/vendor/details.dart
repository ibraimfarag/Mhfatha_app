import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mhfatha/settings/imports.dart';
import 'package:permission_handler/permission_handler.dart';

class StoreDetails extends StatefulWidget {
  @override
  State<StoreDetails> createState() => _StoreDetailsState();
}

class _StoreDetailsState extends State<StoreDetails> {
  late AuthProvider authProvider; // Declare authProvider variable
  Api api = Api();
  Color backgroundColor = Color.fromARGB(220, 255, 255, 255);
  Color ui = Color.fromARGB(220, 233, 233, 233);
  Color ui2 = Color.fromARGB(255, 113, 194, 110);
  Color colors = Color(0xFF05204a);

  Map<String, dynamic>? store;
  Map<String, dynamic>? storeDetails;
  String? selectedMonth;
  List<String> months = [];
  String sumCountTimess = '';
  String sumTotalPaymentss = '';
  List<dynamic> discounts = [];

  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    Api api = Api(); // Initialize vendorApi in initState
    final vendorApi = VendorApi(context);
  }

  void didChangeDependencies() {
    super.didChangeDependencies();
    final arguments = ModalRoute.of(context)?.settings.arguments;

    if (arguments != null && arguments is Map<String, dynamic>) {
      store = arguments;
      storeDetails = arguments['userStores']?[0]['storeDetails'];
      if (store != null && store!['storeDetails'] != null) {
        months = (store!['storeDetails']['months'] as Map<String, dynamic>)
            .keys
            .toList();
        if (months.isNotEmpty) {
          selectedMonth = months[0];
          discounts =
              store!['storeDetails']['months'][selectedMonth]['discounts'];
        }
      }
      sumCountTimess = arguments['sumCountTimes'].toString();
      sumTotalPaymentss = arguments['sumTotalPayments'].toString();
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
                                  store?['name'] ?? '',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
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
                                Text(
                                  isEnglish
                                      ? 'Purchases Times'
                                      : 'عدد مرات الشراء',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  '$sumCountTimess',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ]),
                              SizedBox(width: 20),
                              Column(
                                children: [
                                  Text(
                                    isEnglish
                                        ? 'Total Profits'
                                        : 'الأرباح الإجمالية',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    isEnglish
                                        ? '$sumTotalPaymentss SAR'
                                        : '$sumTotalPaymentss ريال',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
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
                          children: [
                            if (months.isNotEmpty) ...[
                              Column(
                                children: [
                                  Text(
                                    isEnglish
                                        ? 'you get ${store!['storeDetails']['months'][selectedMonth]['discount_count']} discounts '
                                        : 'لقد حصلت على ${store!['storeDetails']['months'][selectedMonth]['discount_count']} خصومات  ',
                                    style: TextStyle(color: colors),
                                  ),
                                  Text(
                                    isEnglish
                                        ? 'and profit ${store!['storeDetails']['months'][selectedMonth]['total_after_discount']} SAR'
                                        : 'و بمبلغ ${store!['storeDetails']['months'][selectedMonth]['total_after_discount']} ريال  ',
                                    style: TextStyle(color: colors),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                    isEnglish ? 'at' : 'في',
                                    style: TextStyle(
                                        color: colors,
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),

                              SizedBox(
                                  width:
                                      10), // Optional: Add some space between the text and the dropdown
                              Container(
                                decoration: BoxDecoration(
                                  color:
                                      colors, // Background color of the container
                                  borderRadius: BorderRadius.circular(
                                      10), // Optional: Adjust border radius as needed
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal:
                                        10), // Optional: Adjust padding as needed
                                child: DropdownButton<String>(
                                  value: selectedMonth,
                                  items: months.map((String month) {
                                    return DropdownMenuItem<String>(
                                      value: month,
                                      child: Text(
                                        month,
                                        style: TextStyle(
                                            color: Colors
                                                .white), // Adjust text color as needed
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (newValue) {
                                    setState(() {
                                      selectedMonth = newValue!;
                                      discounts = store!['storeDetails']
                                              ['months'][selectedMonth]
                                          ['discounts'];
                                    });
                                  },
                                  dropdownColor:
                                      colors, // Set dropdown background color to match container
                                  iconEnabledColor: Colors.white,
                                  underline:
                                      Container(), // Remove default underline
                                ),
                              ),
                            ],
                          ],
                        ),
                        SingleChildScrollView(
                          child: Column(
                            children: discounts.map((discount) {
                              return Container(
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      isEnglish
                                          ? 'Discount Category: ${discount['discount_category_name']}'
                                          : 'فئة الخصم: ${discount['discount_category_name']}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      isEnglish
                                          ? 'Total Payment: ${discount['total_payment']} SAR'
                                          : 'الدفع الإجمالي: ${discount['total_payment']} ريال',
                                    ),
                                    Text(
                                      isEnglish
                                          ? 'After Discount: ${discount['after_discount']} SAR'
                                          : 'بعد الخصم: ${discount['after_discount']} ريال',
                                    ),
                                    Text(
                                      isEnglish
                                          ? 'Discount: ${discount['discount_percent']}%'
                                          : 'الخصم: ${discount['discount_percent']}%',
                                    ),
                                    Text(
                                      isEnglish
                                          ? 'start Date: ${discount['discount_start_date']}'
                                          : 'تاريخ البداية: ${discount['discount_start_date']}',
                                    ),
                                    Text(
                                      isEnglish
                                          ? 'end Date: ${discount['discount_end_date']}'
                                          : 'تاريخ الانتهاء: ${discount['discount_end_date']}',
                                    ),
                                  ],
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
