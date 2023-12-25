// lib\screens\QR\get_discount.dart

import 'package:flutter/services.dart';
import 'package:mhfatha/settings/imports.dart';

class GetDiscount extends StatefulWidget {
  @override
  _GetDiscountState createState() => _GetDiscountState();
}

class _GetDiscountState extends State<GetDiscount> {
  // Define a text controller for the cost input
  final TextEditingController _costController = TextEditingController();

  // Variable to track the current screen
  int _currentScreen = 1;
  Color backgroundColor = Color.fromARGB(255, 236, 236, 236);
  bool _isNextButtonEnabled = false;

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    // Access store and discount data
    Map<String, dynamic> store = data['store'];
    Map<String, dynamic> discount = data['discount'];

    bool isEnglish = Provider.of<AppState>(context).isEnglish;

void _showSuccessDialog() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          isEnglish ? 'Congratulations' : 'تهانينا',
        ),
        content: Text(
          isEnglish
              ? 'You have successfully applied the discount. Please pay for the vendor.'
              : 'لقد قمت بتطبيق الخصم بنجاح. يرجى دفع المبلغ للبائع.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // You can navigate to the next screen or perform other actions here
            },
            child: Text(
              isEnglish ? 'OK' : 'حسنا',
            ),
          ),
        ],
      );
    },
  );
}

void _postDiscountDetails() async {
  int userID = Provider.of<AuthProvider>(context, listen: false).userId!;
  int storeID = store['id'];
  int discountID = discount['id'];
  double totalPayment = double.tryParse(_costController.text) ?? 0.0; // Replace 0.0 with a default value or handle it as needed
  String lang = Provider.of<AppState>(context, listen: false).display;

  bool success = await Api().postDiscountDetails(
    Provider.of<AuthProvider>(context, listen: false),
    userID,
    storeID,
    discountID,
    totalPayment,
    lang,
  );

  if (success) {
    // If the API call is successful, update the state and move to the next screen
    setState(() {
      _currentScreen = 2;
    });
  } else {
    // Handle the case when the API call fails (optional)
    // You might want to show an error message or take appropriate action
showDialog(
  context: context,
  builder: (BuildContext context) {
    return AlertDialog(
      title: Text(
        isEnglish ? 'Error' : 'خطأ',
      ),
      content: Text(
        isEnglish
            ? 'Failed to get discount . Please try again.'
            : 'فشل في الحصول على الخصم. الرجاء المحاولة مرة أخرى.',
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(isEnglish
            ? 'OK':'حسنا'),
        ),
      ],
    );
  },
);

  }
}




    Future<void> _showConfirmationDialog() async {
      bool confirm = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
  title: Text(
    isEnglish ? 'Confirmation' : 'تأكيد',
  ),
  content: Text(
    isEnglish
        ? 'Are you sure you want to proceed?'
        : 'هل أنت متأكد أنك تريد المتابعة؟',
  ),
  actions: [
    TextButton(
      onPressed: () {
        Navigator.of(context).pop(false); // No
      },
      child: Text(isEnglish ? 'No' : 'لا'),
    ),
    TextButton(
      onPressed: () {
        Navigator.of(context).pop(true); // Yes
      },
      child: Text(isEnglish ? 'Yes' : 'نعم'),
    ),
  ],
);

        },
      );

      if (confirm == true) {
        _postDiscountDetails();
      }
    }

    return DirectionalityWrapper(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            // Show the back button only on screen 2 and 3
            if (_currentScreen > 1)
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  // Navigate back to the previous screen
                  setState(() {
                    _currentScreen--;
                  });
                },
                color: Color.fromARGB(255, 7, 0, 34),
              ),
          ],
        ),
        body: SingleChildScrollView(
            child: Column(
          children: [
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
                              ? 'You have chosen discount on: ${discount['category']} from ${store['name']}'
                              : 'لقد اخترت خصم على: ${discount['category']} من  ${store['name']}',
                          style: TextStyle(fontSize: 14),
                          textAlign:
                              isEnglish ? TextAlign.left : TextAlign.right,
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
    children: [
      // Display congratulatory message
      Text(
        isEnglish
            ? 'Congratulations! You have earned a discount of ${discount['category']} from ${store['name']}.'
            : 'تهانينا! لقد حصلت على خصم ${discount['category']} من ${store['name']}.',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 18),
      ),
     
      SizedBox(height: 16),
      // Buttons for accepting or canceling
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              // Perform action for accepting
            },
            child: Text(isEnglish ? 'Accept' : 'قبول'),
          ),
          SizedBox(width: 16),
          ElevatedButton(
            onPressed: () {
              // Perform action for canceling
            },
            child: Text(isEnglish ? 'Cancel' : 'إلغاء'),
          ),
        ],
      ),
      SizedBox(height: 16),
      // Add your asset image here
      Image.asset(
        'images/asse.png', // Replace with the actual asset image path
        height: 60, // Set your desired height
        fit: BoxFit.cover, // Adjust the fit as needed
      ),
    ],
  ),

                  // Add more screens if needed
                ],
              ),
            ),
          ],
        )),
        bottomNavigationBar: BottomNav(initialIndex: 1),
      ),
    );
  }


}
