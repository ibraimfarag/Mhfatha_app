// lib\screens\settings\settings.dart

import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mhfatha/settings/imports.dart';
import 'package:permission_handler/permission_handler.dart';

class MainStores extends StatefulWidget {
  @override
  State<MainStores> createState() => _MainStoresState();
}

class _MainStoresState extends State<MainStores> {
  late AuthProvider authProvider; // Declare authProvider variable
  Api api = Api();
  Color backgroundColor = Color.fromARGB(220, 255, 255, 255);
  Color ui = Color.fromARGB(220, 233, 233, 233);
  Color ui2 = Color.fromARGB(255, 113, 194, 110);
  Color colors = Color(0xFF05204a);

  // List<Map<String, dynamic>> vendorStoresDataa =
  //     []; // Declare vendorStoresData here
  String vendorStoresDataa = '';
  String verifiedStoresCountt = '';
  String pendingStoresCountt = '';
  String sumCountTimess = '';
  String sumTotalPaymentss = '';
  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    Api api = Api(); // Initialize vendorApi in initState
    final vendorApi = VendorApi(context);

    getVendorStores(); // Call fetchVendorStores after initializing vendorApi
  }

  // Method to fetch vendor stores data

  List<dynamic> VendorStores = [];

  List<dynamic> parseAndSortUserDiscounts(String response) {
    Map<String, dynamic> responseData = jsonDecode(response);

    verifiedStoresCountt = responseData['verifiedStoresCount'].toString();
    pendingStoresCountt = responseData['pendingStoresCount'].toString();
    sumCountTimess = responseData['sumCountTimes'].toString();
    sumTotalPaymentss = responseData['sumTotalPayments'].toString();

    List<dynamic> discounts = jsonDecode(response)['userStores'];

    return discounts;
  }

  Future<void> getVendorStores() async {
    try {
      String response = await Api().fetchVendorStores(context);
      setState(() {
        vendorStoresDataa = response;
        VendorStores = parseAndSortUserDiscounts(response);
        // VendorStores.sort((a, b) => b['date'].compareTo(a['date']));
      });
      // print('User Discounts Response: $response');
    } catch (e) {
      print('Error getting user discountssss: $e');
    }
  }
    void didChangeDependencies() {
    super.didChangeDependencies();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  }
  @override
  Widget build(BuildContext context) {
    bool isEnglish = Provider.of<AppState>(context).isEnglish;
    bool isDarkMode = Provider.of<AppState>(context).isDarkMode;
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);

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
                    padding: EdgeInsets.fromLTRB(20,60, 20, 5),
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
                                  isEnglish ? ' Welcome ' : ' مرحبا بك',
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
                              Column(children: [
                                Text(
                                  isEnglish ? 'Purchases Times' : 'مرات الشراء',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  isEnglish
                                      ? ' $sumCountTimess'
                                      : '$sumCountTimess',
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
                          Navigator.pushNamed(context, '/createstore');
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
                                    ? 'Add Store'
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
                        SizedBox(
                          height: 24,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            for (var store in VendorStores)
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
                 
                  PullDownButton(
                    itemBuilder: (context) => [
                      PullDownMenuItem(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/editstore',
                            arguments:
                                store, // Pass the store data to the route
                          );
                        },
                        title: isEnglish ? 'Edit' : 'تعديل',
                        icon: Icons.edit,
                        // enabled: store['verifcation'] == 1,
                      ),
                    //  Icon(Icons.barcode_reader)
                      PullDownMenuItem(
                        onTap: () async {  await VendorApi(context)
                                .getStoreQRImage('${store['id']}', context);},
                        title:isEnglish ? 'QR' : 'الباركود',
                          enabled: store['verifcation'] == 1,
                        icon: CupertinoIcons.qrcode_viewfinder,
                      ),
                      PullDownMenuItem(
                        onTap: () {Navigator.pushNamed(
                              context,
                              '/storediscounts',
                              arguments:
                                  store, // Pass the store data to the route
                            );},
                        title: isEnglish ? 'Discounts' : 'الخصومات',
                              enabled: store['verifcation'] == 1,

                        icon: Icons.discount,
                      ),
                      PullDownMenuItem(
                        onTap: () { QuickAlert.show(
                              context: context,
                              type: QuickAlertType.confirm,
                              text: isEnglish
                                  ? 'are you sure you want to delete store ${store['name']} ?'
                                  : '؟ ${store['name']} هل انت متأكد من حذف متجر ',
                              cancelBtnText: isEnglish ? 'No' : 'لا',
                              confirmBtnText: isEnglish ? 'yes' : 'نعم',
                              confirmBtnColor: Colors.greenAccent,
                              onConfirmBtnTap: () async {
                                await VendorApi(context)
                                    .deleteStore('${store['id']}', context);
                              },
                            );},
                        title: isEnglish ? 'Delete' : 'حذف',
                        
                        isDestructive: true,
                        icon: CupertinoIcons.delete,
                      ),
                    ],
                    buttonBuilder: (context, showMenu) => CupertinoButton(
                      onPressed: showMenu,
                      padding: EdgeInsets.zero,
                      // child: const Icon(CupertinoIcons.ellipsis_circle),
                      child: const Icon(Icons.more_vert),
                    ),
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
