// lib\screens\QR\get_discount.dart

import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:mhfatha/settings/imports.dart';

class GetDiscount extends StatefulWidget {
  @override
  _GetDiscountState createState() => _GetDiscountState();
}

Color themeColor = const Color(0xFF43D19E);

class _GetDiscountState extends State<GetDiscount> {
  // Define a text controller for the cost input
  final TextEditingController _costController = TextEditingController();
  String _discountResponseMessage = ''; // Add this line

  // Variable to track the current screen
  int _currentScreen = 1;
  Color backgroundColor = Color.fromARGB(255, 236, 236, 236);
  bool _isNextButtonEnabled = false;
  Color textColor = const Color(0xFF32567A);
 void didChangeDependencies() {
    super.didChangeDependencies();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
  }
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    // Access store and discount data
    Map<String, dynamic> store = data['store'];
    Map<String, dynamic> discount = data['discount'];

    bool isEnglish = Provider.of<AppState>(context).isEnglish;

    int userID = Provider.of<AuthProvider>(context, listen: false).userId!;
    int storeID = store['id'];
    int discountID = discount['id'];
    double totalPayment = double.tryParse(_costController.text) ??
        0.0; // Replace 0.0 with a default value or handle it as needed
    String lang = Provider.of<AppState>(context, listen: false).display;

    void _postDiscountDetails() async {
      try {
        Response response = await Api().scannedstore(
          Provider.of<AuthProvider>(context, listen: false),
          userID,
          storeID,
          discountID,
          totalPayment,
          lang,
        );

        // Parse the response as JSON
        dynamic responseBody = response.body;

        // Check if the response body is a string, and parse it accordingly
        Map<String, dynamic> jsonResponse = responseBody is String
            ? json.decode(responseBody)
            : {'message': 'Unexpected response format', 'after_discount': 0};

        if (response.statusCode == 200) {
          // The response contains the expected fields
          setState(() {
            _discountResponseMessage =
                jsonResponse['after_discount'].toString();
            _currentScreen = 2;
          });
        } else {
          // The response is not in the expected format
          // _showErrorDialog();
        }
      } catch (e) {
        // Print the caught exception for debugging
        print('Caught exception during _postDiscountDetails: $e');

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                isEnglish ? 'Error' : 'خطأ',
              ),
              content: Text(
                isEnglish
                    ? 'Failed to get discount. Please try again.'
                    : 'فشل في الحصول على الخصم. الرجاء المحاولة مرة أخرى.',
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(isEnglish ? 'OK' : 'حسنا'),
                ),
              ],
            );
          },
        );
      }
    }

    Future<void> _showConfirmationDialog() async {
      bool confirm = await QuickAlert.show(
          context: context,
          type: QuickAlertType.confirm,
          text: isEnglish
              ? 'Are you sure you want to proceed?'
              : 'هل أنت متأكد أنك تريد المتابعة؟',
          confirmBtnText: isEnglish ? 'Yes' : 'نعم',
          cancelBtnText: isEnglish ? 'No' : 'لا',
          confirmBtnColor: Colors.green,
          onConfirmBtnTap: () async {
            Navigator.of(context).pop(true);
          });
      // Navigator.of(context).pop(false); // No

      if (confirm == true) {
        _postDiscountDetails();
      }
    }

    return DirectionalityWrapper(
      child: Scaffold(
       
        body: SingleChildScrollView(
            child: Column(
          children: [
              CustomAppBar(
                  onBackTap: () {
                    Navigator.pop(context);
                  },iconColor:const Color.fromARGB(146, 0, 0, 0),
                                    marginTop: 30,

                ),
            SizedBox(height: 20),
            if (_currentScreen == 1)
              Image.asset(
                'images/discounted.png', // Replace with your image path
                width: MediaQuery.of(context)
                    .size
                    .width, // Set the width to the device width
              ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Display different content based on the current screen
                  if (_currentScreen == 1)
                    Column(
                      children: [
                        Text(
                          isEnglish
                              ? 'You have chosen discount on'
                              : 'لقد اخترت خصم على',
                          style: TextStyle(fontSize: 18),
                          textAlign:
                              isEnglish ? TextAlign.center : TextAlign.center,
                        ),
                        Text(
                          isEnglish
                              ? ' ${discount['category']} from ${store['name']}'
                              : '${discount['category']} من  ${store['name']}',
                          style: TextStyle(fontSize: 18),
                          textAlign:
                              isEnglish ? TextAlign.center : TextAlign.center,
                        ),

                        SizedBox(height: 16),
                        // TextField for entering cost
                        Container(
                          width: 200, // Set your desired width
                          child: TextField(
                            controller: _costController,
                            keyboardType: TextInputType
                                .number, // Set the keyboard type to number
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9]')), // Allow only numeric input
                            ],
                            style: TextStyle(
                              fontSize: 22, // Adjust the font size
                              fontWeight: FontWeight.bold, // Make the text bold
                            ),
                            textAlign: TextAlign.center, // Center the text
                            maxLines:
                                1, // Set maxLines to 1 to restrict the height
                            onChanged: (text) {
                              // Enable or disable the button based on whether the text is empty or not
                              setState(() {
                                _isNextButtonEnabled = text.isNotEmpty;
                              });
                            },
                            decoration: InputDecoration(
                              hintStyle: TextStyle(color: Colors.grey.shade700),
                              filled: true,
                              fillColor: backgroundColor,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: backgroundColor),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: backgroundColor),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        // Button to move to the next screen
                        ElevatedButton(
                          onPressed: _isNextButtonEnabled
                              ? () {
                                  // Move to the next screen
                                  // setState(() {
                                  //   _currentScreen = 2;
                                  // });

                                  _showConfirmationDialog();
                                }
                              : null, // Disable the button if _isNextButtonEnabled is false
                          child: Text(isEnglish ? 'Next' : 'التالي'),
                        ),
                      ],
                    ),

                  /* -------------------------------------------------------------------------- */
/* ----------------------------- SCREEN SUCCESS ----------------------------- */
/* -------------------------------------------------------------------------- */
                  if (_currentScreen == 2)
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 170,
                          padding: EdgeInsets.all(35),
                          decoration: BoxDecoration(
                            color: themeColor,
                            shape: BoxShape.circle,
                          ),
                          child: Image.asset(
                            "images/card.png",
                            fit: BoxFit.contain,
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.1),
                        Text(
                          isEnglish ? 'Congratulations! ' : 'تهانينا!',
                          style: TextStyle(
                            color: themeColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 36,
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01),
                        Text(
                          isEnglish
                              ? ' You have earned a discount of '
                              : 'لقد حصلت على خصم ',
                          style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w400,
                            fontSize: 17,
                          ),
                        ),
                        Text(
                          isEnglish
                              ? ' ${discount['category']} from ${store['name']}.'
                              : '${discount['category']} من ${store['name']}.',
                          style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w400,
                            fontSize: 17,
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02),
                        Text(
                          isEnglish
                              ? "Please pay ${_discountResponseMessage} SAR to the merchant"
                              : " يرجى دفع ${_discountResponseMessage} ريال للتاجر",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.06),
                        // Row for buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                QuickAlert.show(
                                    context: context,
                                    type: QuickAlertType.success,
                                    text: isEnglish
                                        ? 'Thank you, the discount has been successfully registered with the merchant'
                                        : 'شكرا لك , لقد تم تسجيل الخصم بنجاح عند التاجر ',
                                    confirmBtnText: isEnglish
                                        ? 'Back to home '
                                        : 'العودة للرئيسية',
                                    onConfirmBtnTap: () async {
                                      Navigator.pushNamed(
                                        context,
                                        '/home',
                                      );
                                    },
                                    confirmBtnColor: themeColor);
                              },
                              child: Text(
                                isEnglish ? 'Accepted' : 'مقبولة',
                                style: TextStyle(color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                primary:
                                    themeColor, // Set your desired color for accept button
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      20), // Adjust the radius as needed
                                ),
                              ),
                            ),
                            SizedBox(width: 16),
                            ElevatedButton(
                              onPressed: () {
                                QuickAlert.show(
                                  context: context,
                                  type: QuickAlertType.warning,
                                  showCancelBtn: true,
                                  text: isEnglish
                                      ? 'Are you sure there is an error in the process of obtaining a discount? If you choose yes, you will send a complaint to the administration.'
                                      : 'هل انت متاكد ان هناك خطأ في عملية الحصول على خصم؟  في حالة اختيار نعم سوف تقوم بارسال شكوي الي الادارة',
                                  confirmBtnText: isEnglish ? 'yes ' : 'نعم',
                                  cancelBtnText: isEnglish ? 'no ' : 'لا',
                                  onConfirmBtnTap: () async {
                                    Navigator.pop(context);
                                    Navigator.pushNamed(context, '/report',
                                        arguments: store);
                                  },
// confirmBtnColor:themeColor
                                );
                              },
                              child: Text(
                                isEnglish ? 'Canceled' : 'غير مقبولة',
                                style: TextStyle(color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                primary: Colors
                                    .red, // Set your desired color for cancel button
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      20), // Adjust the radius as needed
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                  // Add more screens if needed
                ],
              ),
            ),
          ],
        )),
        // bottomNavigationBar: BottomNavBar(initialIndex: 1),
        bottomNavigationBar: NewNav(),
      ),
    );
  }
}
