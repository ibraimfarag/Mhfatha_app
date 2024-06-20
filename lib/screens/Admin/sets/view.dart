import 'dart:convert';

import 'package:mhfatha/settings/imports.dart';

class AdminViewSettings extends StatefulWidget {
  const AdminViewSettings({Key? key}) : super(key: key);

  @override
  _AdminViewSettingsState createState() => _AdminViewSettingsState();
}

class _AdminViewSettingsState extends State<AdminViewSettings> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Map<String, dynamic> storesDiscountss = {}; // Make it nullable
  final TextEditingController CommissionController = TextEditingController();
  final TextEditingController MapDistanceController = TextEditingController();
  @override
  void initState() {
    super.initState();

        WidgetsBinding.instance.addPostFrameCallback((_) {
         fetchDataFromApi(context);
    });
  }
Future<void> fetchDataFromApi(BuildContext context) async {
  try {
    final statisticsData = await AdminApi(context).fetchStatistics(context);
    final Map<String, dynamic> statisticss = statisticsData['statistics'];
    final Map<String, dynamic> storesDiscounts = statisticsData['websiteManager'];

    setState(() {
      storesDiscountss = storesDiscounts;
    });

    // If the storesDiscounts map is not empty, extract the values
    if (storesDiscounts.isNotEmpty) {
      final String commissionValue = storesDiscounts.containsKey('commission')
          ? storesDiscounts['commission'].toString()
          : '';
      final String nearbyDistanceValue = storesDiscounts.containsKey('map_distance')
          ? storesDiscounts['map_distance'].toString()
          : '';

      // Set the values to the corresponding controllers
      CommissionController.text = commissionValue;
      MapDistanceController.text = nearbyDistanceValue;

      // Print relevant information for debugging
      print(storesDiscounts);
      print(commissionValue);
      print(nearbyDistanceValue);
    }
  } catch (e) {
    print('Error: $e');
  }
}



  Color backgroundColor = const Color.fromARGB(220, 255, 255, 255);
  Color ui = const Color.fromARGB(220, 233, 233, 233);
  Color ui2 = const Color.fromARGB(255, 113, 194, 110);
  Color colors = const Color(0xFF05204a);

  @override
  Widget build(BuildContext context) {
    bool isEnglish = Provider.of<AppState>(context, listen: false).isEnglish;
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);

    return MainAdminContainer(
      additionalWidgets: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              isEnglish ? 'Settings' : 'الاعدادات',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
      child: Column(children: [
        SizedBox(
          height: MediaQuery.of(context).size.width * 0.03,
        ),
        // if (storesDiscountss != null) ...[
        // if (filteredRequests.isNotEmpty) ...[
        Container(
          padding: EdgeInsets.fromLTRB(
              0, 0, 0, MediaQuery.of(context).size.height * 0.02),
          height: MediaQuery.of(context).size.height *
              0.68, // Set the container height as needed
          child: SingleChildScrollView(
            child: Column(
              children: [
                buildTextFieldWithButton(
                  context,
                  'Commission', // English label
                  'عمولة', // Arabic label
                  CommissionController,
                  () {
                    final Map<String, dynamic> updateData = {
                      "commission": CommissionController.text,
                    };
                    final jsonData =
                        jsonEncode(updateData); // Convert map to JSON string
                    AdminApi(context).AdminSets(
                      context,
                      "update",
                      "WebsiteManager",
                      jsonData, // Pass JSON string instead of map
                    );
                  },
                  isEnglish ? 'Update' : 'تحديث',
                  CommissionController.text,
                ),
                buildTextFieldWithButton(
                    context,
                    'Nearby Distance ', // English label
                    'مسافة قريبة', // Arabic label
                    MapDistanceController, () {
                  final Map<String, dynamic> updateData = {
                    "map_distance": MapDistanceController.text,
                  };
                  final jsonData =
                      jsonEncode(updateData); // Convert map to JSON string
                  AdminApi(context).AdminSets(
                    context,
                    "update",
                    "WebsiteManager",
                    jsonData, // Pass JSON string instead of map
                  );
                }, isEnglish ? 'Update' : 'تحديث', MapDistanceController.text),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                  padding: const EdgeInsets.fromLTRB(40, 30, 40, 30),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFFFF),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(children: [
                    // Text link
                    GestureDetector(
                      onTap: () {
                         Navigator.pushNamed(context, '/admin/ViewSettings/Regions');
                      },
                      child: Text(
                        isEnglish?'Regions':'المناطق',
                        style: TextStyle(
                          color: colors, // You can customize the link color
                        ),
                      ),
                    ),
                  ]),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                  padding: const EdgeInsets.fromLTRB(40, 30, 40, 30),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFFFF),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(children: [
                    // Text link
                    GestureDetector(
                      onTap: () {
                         Navigator.pushNamed(context, '/admin/ViewSettings/Categoriess');
                      },
                      child: Text(
                        isEnglish?'Categories':'الفئات',
                        style: TextStyle(
                          color: colors, // You can customize the link color
                        ),
                      ),
                    ),
                  ]),
                )
              ],
            ),
          ),
        ),
      ]),
    );
  }

  Widget buildTextFieldWithButton(
    BuildContext context,
    String englishLabel,
    String arabicLabel,
    TextEditingController controller,
    VoidCallback onButtonPressed,
    String buttonText,
    String preFilledText,
  ) {
    bool isEnglish = Provider.of<AppState>(context).isEnglish;
    controller.text = preFilledText;
    return InkWell(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
        padding: const EdgeInsets.fromLTRB(20, 30, 20, 30),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const SizedBox(width: 10),
                      Text(isEnglish ? englishLabel : arabicLabel),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: controller,
                    style: TextStyle(fontSize: 16, color: colors),
                    keyboardType:
                        TextInputType.number, // Set keyboard type to number
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(
                          RegExp(r'[0-9]')), // Only allow digits
                    ],
                    decoration: InputDecoration(
                      hintStyle: TextStyle(color: Colors.grey.shade700),
                      filled: true,
                      fillColor: ui,
                      enabledBorder: isEnglish
                          ? OutlineInputBorder(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(30),
                                bottomLeft: Radius.circular(30),
                              ),
                              borderSide: BorderSide(color: backgroundColor),
                            )
                          : OutlineInputBorder(
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(30),
                                bottomRight: Radius.circular(30),
                              ),
                              borderSide: BorderSide(color: backgroundColor),
                            ),
                      focusedBorder: isEnglish
                          ? OutlineInputBorder(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(30),
                                bottomLeft: Radius.circular(30),
                              ),
                              borderSide: BorderSide(color: backgroundColor),
                            )
                          : OutlineInputBorder(
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(30),
                                bottomRight: Radius.circular(30),
                              ),
                              borderSide: BorderSide(color: backgroundColor),
                            ),
                    ),
                  ),
                ],
              ),
            ),
            // SizedBox(width: 10),
            Container(
              decoration: const BoxDecoration(
                // color: ui,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              margin: const EdgeInsets.fromLTRB(0, 30, 0, 0),
              child: SizedBox(
                height: 60, // Set the height of the button
                child: ElevatedButton(
                  onPressed: onButtonPressed,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        colors), // Set the button color
                    shape: MaterialStateProperty.all(
                      isEnglish
                          ? const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(30),
                                bottomRight: Radius.circular(30),
                              ),
                            )
                          : const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                bottomLeft: Radius.circular(30),
                              ),
                            ),
                    ),
                  ),
                  child: Text(
                    buttonText,
                    style: const TextStyle(color: Colors.white), // Set the text color
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
