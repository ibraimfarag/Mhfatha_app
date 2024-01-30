// lib\screens\settings\settings.dart

import 'dart:io';

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mhfatha/settings/imports.dart';

class MainStores extends StatefulWidget {
  @override
  State<MainStores> createState() => _MainStoresState();
}

class _MainStoresState extends State<MainStores> {
  late AuthProvider authProvider; // Declare authProvider variable
  late VendorApi vendorApi; // Declare vendorApi variable

  Color backgroundColor = Color.fromARGB(220, 255, 255, 255);
  Color ui = Color.fromARGB(220, 233, 233, 233);
  Color ui2 = Color.fromARGB(255, 113, 194, 110);
  Color colors = Color(0xFF05204a);

  List<Map<String, dynamic>> vendorStoresDataa =
      []; // Declare vendorStoresData here
  String verifiedStoresCountt = '';
  String pendingStoresCountt = '';
  String sumCountTimess = '';
  String sumTotalPaymentss = '';
  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    vendorApi = VendorApi(context); // Initialize vendorApi in initState
    fetchVendorStores(); // Call fetchVendorStores after initializing vendorApi
  }

  // Method to fetch vendor stores data
  Future<void> fetchVendorStores() async {
    try {
      // Check if vendorApi is not null before calling createVendorStores

      // Call createVendorStores method from vendorApi
      final Map<String, dynamic> vendorData =
          await vendorApi.createVendorStores();

      // Extract vendor stores data directly with type casting
      final List<Map<String, dynamic>> vendorStoresData =
          (vendorData['userStores'] as List<dynamic>)
              .cast<Map<String, dynamic>>();

      // Extract additional keys
      final verifiedStoresCount =
          vendorData['verifiedStoresCount']?.toString() ?? '';
      final pendingStoresCount =
          vendorData['pendingStoresCount']?.toString() ?? '';
      final sumCountTimes = vendorData['sumCountTimes']?.toString() ?? '';
      final sumTotalPayments = vendorData['sumTotalPayments']?.toString() ?? '';

      setState(() {
        vendorStoresDataa = vendorStoresData;
        verifiedStoresCountt = verifiedStoresCount;
        pendingStoresCountt = pendingStoresCount;
        sumCountTimess = sumCountTimes;
        sumTotalPaymentss = sumTotalPayments;
      });
    } catch (e) {
      // Handle error
      print('Error fetching vendor stores: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isEnglish = Provider.of<AppState>(context).isEnglish;
    bool isDarkMode = Provider.of<AppState>(context).isDarkMode;
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    String lang = Provider.of<AppState>(context, listen: false).display;
    return DirectionalityWrapper(
        child: Scaffold(
      body: SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
            color: Color(0xFF080E27), // Set background color to #080e27
            child: Column(
                // crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 5),
                    // height: 200,
                    child: Column(children: [
                      Row(
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
                                  isEnglish ? ' welcome ' : ' مرحبا بك',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  ' ${authProvider.user!['first_name']}',
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
                                CircleAvatar(
                                  radius: 60,
                                  // Add your profile image here
                                  backgroundImage: NetworkImage(
                                      'https://mhfatha.net/FrontEnd/assets/images/user_images/${authProvider.user!['photo']}'),
                                ),
                              ],
                            ),
                          ]),
                      SizedBox(height: 16),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isEnglish
                                    ? 'Purchases times: $sumCountTimess'
                                    : 'مرات الشراء: $sumCountTimess',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(width: 20),
                              Text(
                                isEnglish
                                    ? 'Total profits: $sumTotalPaymentss SAR'
                                    : 'الأرباح الإجمالية: $sumTotalPaymentss ريال',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                isEnglish
                                    ? 'Verified Stores: $verifiedStoresCountt'
                                    : 'المتاجر الموثقة: $verifiedStoresCountt',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(width: 20),
                              Text(
                                isEnglish
                                    ? 'Pending Stores: $pendingStoresCountt'
                                    : 'المتاجر المعلقة: $pendingStoresCountt',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    ]),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          // Add your logic for when the plus icon is clicked
                        },
                        child: Container(
                          // width: 100,
                          margin: EdgeInsets.fromLTRB(30, 0, 30, 20),
                          padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
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
                              isEnglish ? Icon(Icons.add) : Container(),
                              Text(
                                isEnglish
                                    ? 'Add store'
                                    : 'اضافة متجر', // Text based on language
                              ),
                              SizedBox(width: 5), // Space between icon and text
                              isEnglish
                                  ? Container()
                                  : Icon(Icons.add), // Plus icon
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
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
                        SizedBox(
                          height: 24,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            for (var store in vendorStoresDataa)
                              buildStoreContainer(store),
                          ],
                        ),
                      ],
                    ),
                  )
                ])),
      ),
      bottomNavigationBar: NewNav(),
    ));
  }

  Widget buildStoreContainer(Map<String, dynamic> store) {
    final isEnglish = Provider.of<AppState>(context).isEnglish;

    return GestureDetector(
      onTap: () async {
        // Navigator.pushNamed(context, '/store-info', arguments: store);
      },
      child: FadeInRight(
        child: Container(
          width: MediaQuery.of(context).size.width,
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: Align(
                          alignment: isEnglish
                              ? Alignment.centerLeft
                              : Alignment.centerRight,
                          child: Text(
                            '${store['name']}',
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign:
                                isEnglish ? TextAlign.left : TextAlign.right,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
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
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign:
                                isEnglish ? TextAlign.left : TextAlign.right,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 0),
                        child: Align(
                          alignment: isEnglish
                              ? Alignment.centerLeft
                              : Alignment.centerRight,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Display colored circle based on verification status
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 0),
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: store['verifcation'] == 1
                                      ? Colors.green
                                      : store['verifcation'] == 0
                                          ? Colors.orange
                                          : Colors.red,
                                ),
                              ),
                              SizedBox(width: 5),
                              // Display status text
                              Text(
                                isEnglish
                                    ? '${store['verifcation'] == 0 ? 'Pending Verify' : store['verifcation'] == 1 ? 'Verified' : 'Rejected'}'
                                    : '${store['verifcation'] == 0 ? 'قيد التحقق' : store['verifcation'] == 1 ? 'تم التحقق' : 'مرفوض'}',
                                style: TextStyle(
                                  color: store['verifcation'] == 0
                                      ? Colors.orange
                                      : store['verifcation'] == 1
                                          ? Colors.green
                                          : Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                                textAlign: isEnglish
                                    ? TextAlign.left
                                    : TextAlign.right,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Context Menu Button
                  PopupMenuButton(
                    icon: Icon(Icons.more_vert),
                    // offset: Offset(0, 100), // Example offset
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        child: GestureDetector(
                          onTap: () {
                            // Handle option 1
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            // width: 120, // Set width for the container
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  isEnglish ? 'Edit' : 'تعديل',
                                ),
                                SizedBox(width: 8),
                                Icon(Icons.edit), // Edit icon
                              ],
                            ),
                          ),
                        ),
                      ),
                      PopupMenuItem(
                        child: GestureDetector(
                          onTap: () {
                            // Handle option 1
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            // width: 200, // Set width for the container
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  isEnglish ? 'Discounts' : 'الخصومات',
                                ),
                                SizedBox(width: 8),
                                Icon(Icons.discount), // Edit icon
                              ],
                            ),
                          ),
                        ),
                      ),
                      PopupMenuItem(
                        child: GestureDetector(
                          onTap: () {
                            // Handle option 2
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            // width: 120, // Set width for the container
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  isEnglish ? 'Delete' : 'حذف',
                                  style: TextStyle(
                                      color: Colors
                                          .red), // Text style with red color
                                ),
                                SizedBox(width: 8),
                                Icon(Icons.delete,
                                    color: Colors
                                        .red), // Delete icon with red color
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
