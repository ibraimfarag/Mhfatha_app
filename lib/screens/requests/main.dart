import 'dart:convert';

import 'package:mhfatha/settings/imports.dart';

class RequestsScreen extends StatefulWidget {
  @override
  _RequestsScreenState createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> {
  String userDiscountsResponse = '';
  String totalDiscount = '';
  String totalSavings = '';
  int totalDiscountsCount = 0;

  List<dynamic> userDiscounts = [];

  List<dynamic> parseAndSortUserDiscounts(String response) {
    Map<String, dynamic> responseData = jsonDecode(response);

    totalDiscount = responseData['total_discount'];
    totalSavings = responseData['total_savings'];
    totalDiscountsCount = responseData['total_discounts_count'];

    List<dynamic> discounts = jsonDecode(response)['user_discounts'];
    discounts.sort((a, b) => a['date'].compareTo(b['date']));
    return discounts;
  }

  Future<void> getUserDiscounts() async {
    try {
      String response = await Api().getUserDiscounts(context);
      setState(() {
        userDiscountsResponse = response;
        userDiscounts = parseAndSortUserDiscounts(response);
        userDiscounts.sort((a, b) => b['date'].compareTo(a['date']));
      });
      print('User Discounts Response: $response');
    } catch (e) {
      print('Error getting user discounts: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    getUserDiscounts();
  }

  @override
  Widget build(BuildContext context) {
    bool isEnglish = Provider.of<AppState>(context, listen: false).isEnglish;
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    String authName = authProvider.user![
        'first_name']; // Replace with the actual property holding the user's name

    return DirectionalityWrapper(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
            color: Color(0xFF080E27), // Set background color to #080e27
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 5),
                  // height: 200,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 30,
                            ),
                            Text(
                              isEnglish
                                  ? 'Welcome back, $authName!'
                                  : 'مرحبًا  $authName!',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            Text(
                              isEnglish
                                  ? ' Gained $totalDiscountsCount discount'
                                  : ' نفذت $totalDiscountsCount خصم  ',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              isEnglish
                                  ? ' total payments'
                                  : ' اجمالي المدفوعات  ',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            Text(
                              isEnglish
                                  ? '  $totalDiscount SAR'
                                  : '  $totalDiscount ريال  ',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              isEnglish
                                  ? ' total savings '
                                  : ' اجمالي التوفير ',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            Text(
                              isEnglish
                                  ? '   $totalSavings SAR'
                                  : '  $totalSavings ريال  ',
                              style: TextStyle(
                                  fontSize: 14,
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
                            Image.asset(
                              'images/Wallet.gif', // Replace with the actual path to your GIF image
                              height: 100, // Adjust the height as needed
                            ),
                          ],
                        ),
                      ]),
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
                  child: Column(children: [
                    if (userDiscounts.isEmpty)
                      Container(
                        padding: EdgeInsets.fromLTRB(20, 20, 20, 5),
                        margin:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                        decoration: BoxDecoration(
                          color: Color(0xFFFFFFFF),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Center(
                          child: Text(
                            isEnglish
                                ? 'You haven\'t received any discounts yet.'
                                : 'لم تتلقى أي خصومات حتى الآن.',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    for (var discount in userDiscounts)
                      Container(
                        padding: EdgeInsets.fromLTRB(20, 20, 20, 5),
                        margin:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                        decoration: BoxDecoration(
                          color: Color(0xFFFFFFFF),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isEnglish
                                  ? ' ${discount['discount_category']} from ${discount['store_name']}'
                                  : ' ${discount['discount_category']} من ${discount['store_name']}',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '${isEnglish ? 'Total Payment' : 'المبلغ الإجمالي'}: ${isEnglish ? '${discount['total_payment']} SAR' : '${discount['total_payment']} ريال'}',
                              style: TextStyle(fontSize: 16),
                            ),
                            Text(
                              '${isEnglish ? 'After Discount' : 'بعد الخصم'}: ${isEnglish ? '${discount['after_discount']} SAR' : '${discount['after_discount']} ريال'} ',
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  '${discount['date']}',
                                  style: TextStyle(fontSize: 14),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  '${discount['hour']} ',
                                  style: TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                  ]),
                )
                // Display the user discounts information
              ],
            ),
          ),
        ),
        // bottomNavigationBar: BottomNavBar(initialIndex: 1),
        bottomNavigationBar: NewNav(),
      ),
    );
  }
}
