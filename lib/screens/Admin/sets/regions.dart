import 'dart:convert';

import 'package:mhfatha/settings/imports.dart';

class AdminViewRegions extends StatefulWidget {
  const AdminViewRegions({Key? key}) : super(key: key);

  @override
  _AdminViewRegionsState createState() => _AdminViewRegionsState();
}

class _AdminViewRegionsState extends State<AdminViewRegions> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<dynamic> storess = []; // Make it nullable
  List<dynamic> filteredStores = []; // Define filteredStores list

  @override
  void initState() {
    super.initState();
    fetchDataFromApi(context);
  }

  Future<void> fetchDataFromApi(BuildContext context) async {
    try {
      final statisticsData = await AdminApi(context).fetchStatistics(context);
      final Map<String, dynamic> statisticss = statisticsData['statistics'];
      final List<dynamic> regions = statisticsData['regions'];

      setState(() {
        storess = regions;
        filteredStores = storess;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  void showAddRegionDialog(BuildContext context) {
    TextEditingController englishController = TextEditingController();
    TextEditingController arabicController = TextEditingController();
    bool isEnglish = Provider.of<AppState>(context, listen: false).isEnglish;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Region'), // Dialog title
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: englishController,
                decoration: InputDecoration(
                  labelText:
                      isEnglish ? 'English Region' : 'اسم المنطقة بالانجليزية',
                ),
              ),
              TextField(
                controller: arabicController,
                decoration: InputDecoration(
                  labelText:
                      isEnglish ? 'Arabic Region' : 'اسم المنطقة بالعربيه',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Close the dialog
                Navigator.of(context).pop();
              },
              child: Text(isEnglish ? 'Cancel' : 'الغاء'),
            ),
            TextButton(
              onPressed: () {
                // Save the new region
                final Map<String, dynamic> updateData = {
                  "region_ar": arabicController.text,
                  "region_en": englishController.text,
                };

                final jsonData =
                    jsonEncode(updateData); // Convert map to JSON string
                AdminApi(context).AdminSets(
                  context,
                  "add",
                  "Region",
                  jsonData, // Pass JSON string instead of map
                );
                fetchDataFromApi(context);

                print(jsonData);
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(isEnglish ? 'add' : 'اضافة'),
            ),
          ],
        );
      },
    );
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
              isEnglish ? 'Regions' : 'المناطق',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    // Show dialog to add new region
                    showAddRegionDialog(context);
                  },
                ),
                GestureDetector(
                  onTap: () {
                    // Show dialog to add new region
                    showAddRegionDialog(context);
                  },
                  child: Text(
                    isEnglish ? 'Add new region' : 'إضافة منطقة جديدة',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
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
          if (filteredStores.isNotEmpty) ...[
            Container(
              padding: EdgeInsets.fromLTRB(
                  0, 0, 0, MediaQuery.of(context).size.height * 0.02),
              // height: MediaQuery.of(context).size.height *
              //     0.50, // Set the container height as needed
              child: SingleChildScrollView(
                child: Column(
                  children: filteredStores.map((usert) {
                    return Container(
                      margin:
                          const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                      padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFFFF),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  isEnglish
                                      ? '${usert['region_en']}'
                                      : '${usert['region_ar']}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Add onTap to handle user selection
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  // Show dialog when edit icon is tapped
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      TextEditingController
                                          englishController =
                                          TextEditingController(
                                              text: usert['region_en']);
                                      TextEditingController arabicController =
                                          TextEditingController(
                                              text: usert['region_ar']);

                                      return AlertDialog(
                                        title: Text(isEnglish
                                            ? 'Edit Region'
                                            : 'تعديل المنطقة'), // Dialog title
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            TextField(
                                              controller:
                                                  englishController, // Controller for English region text field
                                              decoration: InputDecoration(
                                                  labelText: isEnglish
                                                      ? 'English Region'
                                                      : 'اسم المنطقة بالانجليزي'), // First text field for editing English region
                                            ),
                                            TextField(
                                              controller:
                                                  arabicController, // Controller for Arabic region text field
                                              decoration: InputDecoration(
                                                  labelText: isEnglish
                                                      ? 'Arabic Region'
                                                      : 'اسم المنطقه بالعربيه'), // Second text field for editing Arabic region
                                            ),
                                          ],
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              final Map<String, dynamic>
                                                  updateData = {
                                                "id": "${usert['id']}",
                                                "region_ar":
                                                    arabicController.text,
                                                "region_en":
                                                    englishController.text
                                              };
                                              final jsonData = jsonEncode(
                                                  updateData); // Convert map to JSON string
                                              AdminApi(context).AdminSets(
                                                context,
                                                "edit",
                                                "Region",
                                                jsonData, // Pass JSON string instead of map
                                              );
                                              fetchDataFromApi(context);
                                              Navigator.of(context)
                                                  .pop(); // Close the dialog

                                              print(jsonData);
                                            },
                                            child: Text(isEnglish
                                                ? 'Update'
                                                : 'تحديث'), // Update button
                                          ),
                                          TextButton(
                                            onPressed: () {
                                            
                                            },
                                            child: Text(isEnglish
                                                ? 'Cancel'
                                                : 'الغاء'), // Cancel button
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete,
                                    color: Colors.redAccent),
                                onPressed: () {
                                    QuickAlert.show(
                                                context: context,
                                                type: QuickAlertType.confirm,
                                                customAsset:
                                                    'images/confirm.gif',
                                                text: isEnglish
                                                    ? 'are you sure delete region ${usert['region_en']} ?'
                                                    : 'هل انت متأكد من حذف منطقة ${usert['region_ar']} ؟',
                                                cancelBtnText:
                                                    isEnglish ? 'No' : 'لا',
                                                confirmBtnText:
                                                    isEnglish ? 'yes' : 'نعم',
                                                confirmBtnColor:
                                                    const Color(0xFF0D2750),
                                                onConfirmBtnTap: () async {
                                                  final Map<String, dynamic>
                                                      updateData = {
                                                    "id": "${usert['id']}",
                                                   
                                                  };
                                                  final jsonData = jsonEncode(
                                                      updateData); // Convert map to JSON string
                                                  AdminApi(context).AdminSets(
                                                    context,
                                                    "delete",
                                                    "Region",
                                                    jsonData, // Pass JSON string instead of map
                                                  );
                                                  fetchDataFromApi(context);

                                                  print(jsonData);
                                                  Navigator.of(context)
                                                      .pop(); // Close the dialog
                                                },
                                              );
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ] else ...[
            // Display a message if no users match the search criteria
            const Text('No users found'),
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
}
