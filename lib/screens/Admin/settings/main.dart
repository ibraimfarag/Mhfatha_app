import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';

import 'package:mhfatha/settings/imports.dart';
import 'package:permission_handler/permission_handler.dart'
    as permission_handler;

class AdminViewRequests extends StatefulWidget {
  AdminViewRequests({Key? key}) : super(key: key);

  @override
  _AdminViewRequestsState createState() => _AdminViewRequestsState();
}

class _AdminViewRequestsState extends State<AdminViewRequests> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<dynamic> requestss = []; // Make it nullable
  List<dynamic> filteredRequests = []; // Define filteredStores list
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchDataFromApi(context);
  }

  Future<void> fetchDataFromApi(BuildContext context) async {
    try {
      final statisticsData = await AdminApi(context).fetchStatistics(context);
      final Map<String, dynamic> statisticss = statisticsData['statistics'];
      final List<dynamic> users = statisticsData['users'];
      final List<dynamic> stores = statisticsData['stores'];
      final List<dynamic> requests = statisticsData['requests'];
      final List<dynamic> userDiscounts = statisticsData['user_discounts'];

      setState(() {
        requestss = requests;
        filteredRequests = requestss;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

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
              isEnglish ? 'Requests' : 'الطلبات',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.03,
          ),
          if (requestss != null) ...[
            if (filteredRequests.isNotEmpty) ...[
              Container(
                padding: EdgeInsets.fromLTRB(
                    0, 0, 0, MediaQuery.of(context).size.height * 0.02),
                height: MediaQuery.of(context).size.height *
                    0.68, // Set the container height as needed
                child: SingleChildScrollView(
                  child: Column(
                    children: filteredRequests.map((usert) {
                      return Container(
                        padding: EdgeInsets.fromLTRB(20, 20, 20, 5),
                        margin:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                        decoration: BoxDecoration(
                          color: Color(0xFFFFFFFF),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    isEnglish
                                        ? '${usert['type_name_en']}'
                                        : '${usert['type_name_ar']}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '${usert['store_name']}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12),
                                  ),
                                  if (usert['differences'] != null)
                                    Text(
                                      isEnglish ? 'Changes' : 'التحديثات',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: (usert['differences'] ?? [])
                                        .map<Widget>((difference) {
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            isEnglish
                                                ? 'change: ${difference['attribute_name_en']}'
                                                : 'تغير: ${difference['attribute_name_ar']}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            isEnglish
                                                ? 'Old Value: ${difference['old_value_en'] ?? 'N/A'}'
                                                : 'القيمة القديمة: ${difference['old_value_ar'] ?? 'N/A'}',
                                          ),
                                          Text(
                                            isEnglish
                                                ? 'New Value: ${difference['new_value_en']}'
                                                : 'القيمة الجديده: ${difference['new_value_ar']}',
                                          ),
                                          SizedBox(height: 8),
                                        ],
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                                onTap: () {
                                  // Handle user selection here
                                },
                                child: PullDownButton(
                                  itemBuilder: (context) => [
                           
                                    PullDownMenuItem(
                                      onTap: () async {
                                        QuickAlert.show(
                                          context: context,
                                          type: QuickAlertType.confirm,
                                          customAsset: 'images/confirm.gif',
                                          text: isEnglish
                                              ? 'Are you sure to accept this request?'
                                              : 'هل أنت متأكد من الموافقة على الطلب؟',
                                          cancelBtnText:
                                              isEnglish ? 'No' : 'لا',
                                          confirmBtnText:
                                              isEnglish ? 'Yes' : 'نعم',
                                          confirmBtnColor: Color(0xFF0D2750),
                                          onConfirmBtnTap: () async {
                                           await AdminApi(context).RequestActions(
                                            context, '${usert['id']}', '1');
                                            fetchDataFromApi(context);
                                          },
                                        );
                                      },
                                      // enabled: usert['is_deleted'] == 0,
                                      title: isEnglish ? 'Accept' : 'قبول',
                                      isDestructive: false,

                                      // icon: CupertinoIcons.bag_badge_minus,
                                    ),
                                    PullDownMenuItem(
                                      onTap: () async {
                                        QuickAlert.show(
                                          context: context,
                                          type: QuickAlertType.confirm,
                                          customAsset: 'images/confirm.gif',
                                          text: isEnglish
                                              ? 'Are you sure to reject this request?'
                                              : 'هل أنت متأكد من الغاء الطلب ؟',
                                          cancelBtnText:
                                              isEnglish ? 'No' : 'لا',
                                          confirmBtnText:
                                              isEnglish ? 'Yes' : 'نعم',
                                          confirmBtnColor: Color(0xFF0D2750),
                                          onConfirmBtnTap: () async {
                                            await AdminApi(context)
                                                .RequestActions(context,
                                                    '${usert['id']}', '2');
                                            fetchDataFromApi(context);
                                          },
                                        );
                                      },
                                      // enabled: usert['is_deleted'] == 0,
                                      title: isEnglish ? 'Reject' : 'رفض',
                                      isDestructive: true,

                                      // icon: CupertinoIcons.bag_badge_minus,
                                    ),
                                  ],
                                  buttonBuilder: (context, showMenu) =>
                                      CupertinoButton(
                                    onPressed: showMenu,
                                    padding: EdgeInsets.zero,
                                    child: const Icon(
                                      Icons.more_vert,
                                      color: Color(0xFF0D2750),
                                    ),
                                  ),
                                )),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ] else ...[
              Text('No Requests found'),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildStatusWidget(String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      margin: EdgeInsets.symmetric(horizontal: 2),
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
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        );
      case 'delete_store':
        return Text(
          isEnglish ? 'Delete store' : 'حذف المتجر',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        );
      case 'delete_discount':
        return Text(
          isEnglish ? 'Delete store discount' : 'حذف خصم متجر',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        );
      default:
        return Container(); // Return an empty container for unknown types
    }
  }
}
