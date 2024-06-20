
import 'package:mhfatha/settings/imports.dart';

class AdminViewStoreAccounts extends StatefulWidget {
  const AdminViewStoreAccounts({Key? key}) : super(key: key);

  @override
  _AdminViewStoreAccountsState createState() => _AdminViewStoreAccountsState();
}

class _AdminViewStoreAccountsState extends State<AdminViewStoreAccounts> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<dynamic> storesDiscountss = []; // Make it nullable
  List<dynamic> filteredRequests = []; // Define filteredStores list
  List<dynamic> unobtainedDiscounts = []; // Define filteredStores list
  TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    fetchDataFromApi(context);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Receive the user data passed from the previous screen
    List<dynamic> unobtainedDiscountss =
        ModalRoute.of(context)!.settings.arguments as List<dynamic>;
    unobtainedDiscounts = unobtainedDiscountss;
  }

  Future<void> fetchDataFromApi(BuildContext context) async {
    try {
      final statisticsData = await AdminApi(context).fetchStatistics(context);
      final Map<String, dynamic> statisticss = statisticsData['statistics'];
      final List<dynamic> users = statisticsData['users'];
      final List<dynamic> stores = statisticsData['stores'];
      final List<dynamic> requests = statisticsData['requests'];
      final List<dynamic> userDiscounts = statisticsData['user_discounts'];
      final List<dynamic> storesDiscounts = statisticsData['storesDiscounts'];

      setState(() {
        storesDiscountss = storesDiscounts;
        filteredRequests = storesDiscountss;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  double calculateSum() {
    double sum = 0.0;
    for (var usert in unobtainedDiscounts) {
      if (usert['selected'] == true) {
        sum += double.parse(usert['obtained']);
      }
    }
    return sum;
  }

  void selectAll() {
    setState(() {
      for (var usert in unobtainedDiscounts) {
        usert['selected'] = true;
      }
    });
  }

  void unselectAll() {
    setState(() {
      for (var usert in unobtainedDiscounts) {
        usert['selected'] = false;
      }
    });
  }

  void obtainedAction() async {
    bool isEnglish = Provider.of<AppState>(context, listen: false).isEnglish;

    List<String> selectedIds = [];
    for (var usert in unobtainedDiscounts) {
      if (usert['selected'] == true) {
        selectedIds.add('${usert['id']}');
      }
    }

    if (selectedIds.isNotEmpty) {
      await AdminApi(context)
          .acceptDiscounts(context, '', 'selected', selectedIds);
      Navigator.pushNamed(
        context,
        '/admin/accounts',
      );
    } else {
      // Show a message or perform any other action if no items are selected
      // Use isEnglish to display the message accordingly
      String message = isEnglish
          ? 'Please select at least one item to proceed.'
          : 'الرجاء تحديد عنصر واحد على الأقل للمتابعة.';

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title:
                Text(isEnglish ? 'No items selected' : 'لم يتم تحديد العناصر'),
            content: Text(message),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(isEnglish ? 'OK' : 'موافق'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isEnglish = Provider.of<AppState>(context, listen: false).isEnglish;
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);

    return MainAdminContainer(
            showCustomAppBar: true,

      additionalWidgets: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              isEnglish ? 'parts' : 'تجزئة ',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Visibility(
              visible: calculateSum() != 0,
              child: Text(
                isEnglish
                    ? 'Sum obtained: ${calculateSum()}'
                    : ' ${calculateSum()}مجموع المحدد ',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: selectAll,
                  child: Text(isEnglish ? 'Select all' : 'تحديد الكل'),
                ),
                ElevatedButton(
                  onPressed: unselectAll,
                  child: Text(isEnglish ? 'Unselect' : 'إلغاء التحديد'),
                ),
                ElevatedButton(
                  onPressed: obtainedAction,
                  child: Text(isEnglish ? 'Obtained' : 'الحصول عليها'),
                ),
              ],
            ),
          ],
        ),
      ],
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.03,
          ),
          ...[
          if (unobtainedDiscounts.isNotEmpty) ...[
            Container(
              padding: EdgeInsets.fromLTRB(
                  0, 0, 0, MediaQuery.of(context).size.height * 0.02),
              height: MediaQuery.of(context).size.height *
                  0.68, // Set the container height as needed
              child: SingleChildScrollView(
                child: Column(
                  children: unobtainedDiscounts.map((usert) {
                    return Container(
                      padding: const EdgeInsets.fromLTRB(20, 15, 20, 5),
                      margin:
                          const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFFFF),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Checkbox(
                            value: usert['selected'] ?? false,
                            onChanged: (bool? value) {
                              setState(() {
                                usert['selected'] = value;
                              });
                            },
                          ),
                          // SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 15),
                                Text(
                                  isEnglish
                                      ? ' ${usert['obtained']} SAR'
                                      : 'ريال ${usert['obtained']}',
                                  style:
                                      const TextStyle(fontWeight: FontWeight.bold),
                                ),

                                // SizedBox(
                                //   height: MediaQuery.of(context).size.height *
                                //       0.04,
                                // )
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ] else ...[
            const Text('No Requests found'),
          ],
        ],
        ],
      ),
    );
  }

  Widget _buildStatusWidget(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: MediaQuery.of(context).size.width * 0.025),
      ),
    );
  }

  Widget _buildUserInformation(String userType, bool isEnglish) {
    switch (userType) {
      case 'update_store':
        return Text(
          isEnglish ? 'Update store information' : 'تحديث معلومات المتجر',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        );
      case 'delete_store':
        return Text(
          isEnglish ? 'Delete store' : 'حذف المتجر',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        );
      case 'delete_discount':
        return Text(
          isEnglish ? 'Delete store discount' : 'حذف خصم متجر',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        );
      default:
        return Container(); // Return an empty container for unknown types
    }
  }
}
