import 'dart:convert';
import 'package:permission_handler/permission_handler.dart'
    as permission_handler;

import 'package:mhfatha/settings/imports.dart';

class RequestsScreen extends StatefulWidget {
  const RequestsScreen({super.key});

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
      // print('User Discounts Response: $response');
    } catch (e) {
      print('Error getting user discounts: $e');
    }
  }

  String _platformVersion = 'Unknown',
      _imeiNo = "",
      _modelName = "",
      _manufacturerName = "",
      _deviceName = "",
      _productName = "",
      _cpuType = "",
      _hardware = "";
  var _apiLevel;

  @override
  void initState() {
    super.initState();
    getUserDiscounts();
    requestPermissions();

    // initPlatformState();
  }

  Future<void> requestPermissions() async {
    // Check if permissions are already granted
    permission_handler.PermissionStatus permissionStatus =
        await permission_handler.Permission.phone.status;
    if (permissionStatus != permission_handler.PermissionStatus.granted) {
      // Request permissions
      permission_handler.PermissionStatus status =
          await permission_handler.Permission.phone.request();
      if (status != permission_handler.PermissionStatus.granted) {
        // Handle permission denied
        // You can display a message to the user or take appropriate action
        print('Permission denied');
        return;
      }
    }

    // Permissions granted, proceed with accessing device information
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    late String platformVersion,
        imeiNo = '',
        modelName = '',
        manufacturer = '',
        deviceName = '',
        productName = '',
        cpuType = '',
        hardware = '';
    var apiLevel;
    // Platform messages may fail,
    // so we use a try/catch PlatformException.
    try {
      platformVersion = await DeviceInformation.platformVersion;
      imeiNo = await DeviceInformation.deviceIMEINumber;
      modelName = await DeviceInformation.deviceModel;
      manufacturer = await DeviceInformation.deviceManufacturer;
      apiLevel = await DeviceInformation.apiLevel;
      deviceName = await DeviceInformation.deviceName;
      productName = await DeviceInformation.productName;
      cpuType = await DeviceInformation.cpuName;
      hardware = await DeviceInformation.hardware;
    } on PlatformException catch (e) {
      platformVersion = '${e.message}';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
      _imeiNo = imeiNo;
      _modelName = modelName;
      _manufacturerName = manufacturer;
      _apiLevel = apiLevel;
      _deviceName = deviceName;
      _productName = productName;
      _cpuType = cpuType;
      _hardware = hardware;
    });

    print(_platformVersion);
    print(_modelName);
    print(_productName);
    print(_apiLevel);
    print(_manufacturerName);
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
        backgroundColor: const Color(0xFFF3F4F7),

        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
            color: const Color(0xFF080E27), // Set background color to #080e27
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 5),
                  // height: 200,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 30,
                            ),
                            Text(
                              isEnglish
                                  ? 'Welcome back, $authName!'
                                  : 'مرحبًا  $authName!',
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            Text(
                              isEnglish
                                  ? ' Gained $totalDiscountsCount Discount'
                                  : ' حصلت على $totalDiscountsCount خصم  ',
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              isEnglish
                                  ? ' Total Payments'
                                  : ' اجمالي المدفوعات  ',
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            Text(
                              isEnglish
                                  ? '  $totalDiscount SAR'
                                  : '  $totalDiscount ريال  ',
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              isEnglish
                                  ? ' Total Savings '
                                  : ' اجمالي التوفير ',
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            Text(
                              isEnglish
                                  ? '   $totalSavings SAR'
                                  : '  $totalSavings ريال  ',
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const SizedBox(
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
                const SizedBox(height: 16),
                Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFFF3F4F7),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  child: Column(children: [
                    if (userDiscounts.isEmpty)
                      Container(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 5),
                        margin:
                            const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFFFFF),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Center(
                          child: Text(
                            isEnglish
                                ? 'You haven\'t received any discounts yet.'
                                : 'لم تتلقى أي خصومات حتى الآن.',
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    for (var discount in userDiscounts)
                      Container(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 5),
                        margin:
                            const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFFFFF),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isEnglish
                                  ? ' ${discount['discount_category']} from ${discount['store_name']}'
                                  : ' ${discount['discount_category']} من ${discount['store_name']}',
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '${isEnglish ? 'Total Payment' : 'المبلغ الإجمالي'}: ${isEnglish ? '${discount['total_payment']} SAR' : '${discount['total_payment']} ريال'}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            Text(
                              '${isEnglish ? 'After Discount' : 'بعد الخصم'}: ${isEnglish ? '${discount['after_discount']} SAR' : '${discount['after_discount']} ريال'} ',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  '${discount['date']}',
                                  style: const TextStyle(fontSize: 14),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  '${discount['hour']} ',
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                  ]),
                ),
                // Display the user discounts information
              ],
            ),
          ),
        ),
        // bottomNavigationBar: BottomNavBar(initialIndex: 1),
        bottomNavigationBar: const NewNav(),
      ),
    );
  }
}
