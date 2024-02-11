// lib\screens\settings\settings.dart

import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mhfatha/settings/imports.dart';
import 'package:permission_handler/permission_handler.dart';

class MainDiscounts extends StatefulWidget {
  @override
  State<MainDiscounts> createState() => _MainDiscountsState();
}

class _MainDiscountsState extends State<MainDiscounts> {
  late AuthProvider authProvider; // Declare authProvider variable
  Api api = Api();
  Color backgroundColor = Color.fromARGB(220, 255, 255, 255);
  Color ui = Color.fromARGB(220, 233, 233, 233);
  Color ui2 = Color.fromARGB(255, 113, 194, 110);
  Color colors = Color(0xFF05204a);

  Map<String, dynamic>? store;
  List<dynamic> discounts = [];
  String Storeid = '';
  String empty = '';
  String image = 'market.png';

  String percent = '';
  String category = '';
  String startDate = '';
  String endDate = '';

  final startDateController = TextEditingController();
  final endDateController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    Api api = Api(); // Initialize vendorApi in initState
    final vendorApi = VendorApi(context);

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      setState(() {
        store =
            ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

        Storeid = '${store?['id']}' ?? '';
        image = '${store?['photo']}' ?? '';
      });
      fetchDiscounts();
    });
  }

  Future<dynamic> fetchDiscounts() async {
    try {
      final fetchedDiscounts =
          await VendorApi(context).fetchDiscounts('${store?['id']}', context);
      setState(() {
        if (fetchedDiscounts is List<dynamic>) {
          discounts = fetchedDiscounts;
        } else if (fetchedDiscounts is String) {
          empty = fetchedDiscounts;
        }
      });
    } catch (e) {
      // Handle errors gracefully
      print('Error fetching discounts: $e');
    }
  }

  Future<void> selectDate(TextEditingController controller) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      controller.text = DateFormat('yyyy-MM-dd').format(pickedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isEnglish = Provider.of<AppState>(context).isEnglish;
    bool isDarkMode = Provider.of<AppState>(context).isDarkMode;
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    // final Map<String, dynamic> store = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

    String lang = Provider.of<AppState>(context, listen: false).display;
    return DirectionalityWrapper(
        child: Scaffold(
      key: _scaffoldKey,
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
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 5),
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
                                  isEnglish
                                      ? ' Discounts store '
                                      : 'خصومات متجر',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  '${store?['name']}',
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
                                      'https://mhfatha.net/FrontEnd/assets/images/store_images/${image}'),
                                ),
                              ],
                            ),
                          ]),
                      SizedBox(height: 16),
                    ]),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            barrierDismissible: true,
                            builder: (context) {
                              bool isEnglish = Provider.of<AppState>(context)
                                  .isEnglish; // Retrieve the isEnglish value

                              return AlertDialog(
                                title: Text(
                                  isEnglish ? 'Add Discount' : 'إضافة خصم',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: isEnglish
                                      ? TextAlign.left
                                      : TextAlign.right,
                                ),
                                content: SingleChildScrollView(
                                  // Wrap content with SingleChildScrollView
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        isEnglish
                                            ? 'Enter discount information'
                                            : 'أدخل بيانات الخصم',
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                        textAlign: isEnglish
                                            ? TextAlign.left
                                            : TextAlign.right,
                                      ),
                                      SizedBox(height: 10),
                                      TextFormField(
                                        decoration: InputDecoration(
                                          labelText: isEnglish
                                              ? 'Percent'
                                              : 'النسبة المئوية',
                                          hintText: isEnglish
                                              ? 'Enter Percent'
                                              : 'أدخل النسبة المئوية',
                                          prefixIcon: Icon(Icons.percent),
                                        ),
                                        keyboardType: TextInputType.number,
                                        onChanged: (value) => percent = value,
                                        textAlign: isEnglish
                                            ? TextAlign.left
                                            : TextAlign.right,
                                      ),
                                      SizedBox(height: 10),
                                      TextFormField(
                                        decoration: InputDecoration(
                                          labelText:
                                              isEnglish ? 'Category' : 'الفئة',
                                          hintText: isEnglish
                                              ? 'Enter Category'
                                              : 'أدخل الفئة',
                                          prefixIcon: Icon(Icons.category),
                                        ),
                                        onChanged: (value) => category = value,
                                        textAlign: isEnglish
                                            ? TextAlign.left
                                            : TextAlign.right,
                                      ),
                                      SizedBox(height: 10),
                                      GestureDetector(
                                        onTap: () =>
                                            selectDate(startDateController),
                                        child: AbsorbPointer(
                                          child: TextFormField(
                                            controller: startDateController,
                                            decoration: InputDecoration(
                                              labelText: isEnglish
                                                  ? 'Start Date'
                                                  : 'تاريخ البدء',
                                              hintText: isEnglish
                                                  ? 'Select Start Date'
                                                  : 'اختر تاريخ البدء',
                                              prefixIcon:
                                                  Icon(Icons.calendar_today),
                                            ),
                                            textAlign: isEnglish
                                                ? TextAlign.left
                                                : TextAlign.right,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      GestureDetector(
                                        onTap: () =>
                                            selectDate(endDateController),
                                        child: AbsorbPointer(
                                          child: TextFormField(
                                            controller: endDateController,
                                            decoration: InputDecoration(
                                              labelText: isEnglish
                                                  ? 'End Date'
                                                  : 'تاريخ الانتهاء',
                                              hintText: isEnglish
                                                  ? 'Select End Date'
                                                  : 'اختر تاريخ الانتهاء',
                                              prefixIcon:
                                                  Icon(Icons.calendar_today),
                                            ),
                                            textAlign: isEnglish
                                                ? TextAlign.left
                                                : TextAlign.right,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      // Your logic to handle the fields' values here
                                      startDate = startDateController.text;
                                      endDate = endDateController.text;
                                      print('Store ID: $Storeid');
                                      print('Percent: $percent');
                                      print('Category: $category');
                                      print('Start Date: $startDate');
                                      print('End Date: $endDate');
                                      Navigator.pop(
                                          context); // Close the alert dialog

                                      VendorApi(context).createDiscount(
                                          Storeid,
                                          percent,
                                          category,
                                          startDate,
                                          endDate,
                                          store!,                                          
                                          _scaffoldKey.currentState!.context);
                                    },
                                    child: Text(
                                      isEnglish ? 'Add' : 'إضافة',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
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
                                    ? 'Add disscount'
                                    : 'اضافة خصم', // Text based on language
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (empty.isNotEmpty)
                              Center(
                                child: Text(
                                  '$empty',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Color(
                                        0xFF080E27), // Set background color to #080e27
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            else
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
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          isEnglish
                                              ? 'Number of Discounts: ${discounts.length}'
                                              : 'عدد الخصومات : ${discounts.length}',
                                        ),
                                        // Iterate over discounts and build store containers
                                        for (var discount in discounts)
                                          buildStoreContainer(discount),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
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

  Widget buildStoreContainer(Map<String, dynamic> Discounts) {
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
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Text(
                          isEnglish?'Discount on : ${Discounts['category']}':'خصم : ${Discounts['category']}',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign:
                              isEnglish ? TextAlign.left : TextAlign.right,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(2, 0,2, 0),
                        child: Text(
                         isEnglish? ' percent : ${Discounts['percent']?.replaceAll(RegExp(r'\.0+$'), '')}%': ' قيمة الخصم : ${Discounts['percent']?.replaceAll(RegExp(r'\.0+$'), '')}%',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign:
                              isEnglish ? TextAlign.left : TextAlign.right,
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
                            QuickAlert.show(
                              context: context,
                              type: QuickAlertType.confirm,
                              text: isEnglish
                                  ? 'are you sure you want to delete store ${Discounts['category']} ?'
                                  : '؟ ${Discounts['category']} هل انت متأكد من حذف خصم ',
                              cancelBtnText: isEnglish ? 'No' : 'لا',
                              confirmBtnText: isEnglish ? 'yes' : 'نعم',
                              confirmBtnColor: Colors.greenAccent,
                              onConfirmBtnTap: () async {
                                await VendorApi(context).deleteDiscount(
                                    '${Discounts['id']}', context);
                              },
                            );
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
