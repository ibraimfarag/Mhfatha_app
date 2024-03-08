import 'dart:convert';
import 'dart:io';

import 'package:mhfatha/settings/imports.dart';
import 'package:permission_handler/permission_handler.dart'
    as permission_handler;

class MainAdmin extends StatefulWidget {
  MainAdmin({Key? key}) : super(key: key);

  @override
  _MainAdminState createState() => _MainAdminState();
}

class _MainAdminState extends State<MainAdmin> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Map<String, dynamic>? statistics; // Make it nullable

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
        statistics = statisticss;
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
              isEnglish ? 'Dashboard' : 'لوحة التحكم',
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
          Text(
            isEnglish ? 'Statistics' : 'احصائيات',
            style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.05,
                fontWeight: FontWeight.bold),
          ),
          if (statistics != null) ...[
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.05,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.03,
                          height: MediaQuery.of(context).size.width * 0.03,
                          color: Color(0xFF16276B),
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.01),
                        Text(isEnglish ? 'Users' : 'المستفدين'),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.03,
                          height: MediaQuery.of(context).size.width * 0.03,
                          color: Color(0xFF080E27),
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.01),
                        Text(isEnglish ? 'Vendors' : 'التجار'),
                      ],
                    ),
                  ],
                ),
                Container(
                  height: MediaQuery.of(context).size.width * 0.3,
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 0,
                      centerSpaceRadius:
                          MediaQuery.of(context).size.width * 0.12,
                      sections: [
                        PieChartSectionData(
                          color: Color(0xFF080E27),
                          value: statistics!['vendors_count'].toDouble(),
                          title: '${statistics!['vendors_percentage']} ',
                          radius: MediaQuery.of(context).size.width * 0.1,
                          titleStyle: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.032,
                            fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(255, 255, 255, 255),
                          ),
                        ),
                        PieChartSectionData(
                          color: Color(0xFF16276B),
                          value: statistics!['non_vendors_count'].toDouble(),
                          title: ' ${statistics!['non_vendors_percentage']}',
                          radius: MediaQuery.of(context).size.width * 0.1,
                          titleStyle: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.032,
                            fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(255, 255, 255, 255),
                          ),
                        ),
                      ],
                    ),
                    swapAnimationDuration: Duration(milliseconds: 800),
                    swapAnimationCurve: Curves.easeInOutBack,
                  ),
                ),
              ],
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.width * 0.3,
              margin: EdgeInsets.fromLTRB(
                  0,
                  MediaQuery.of(context).size.width * 0.12,
                  0,
                  MediaQuery.of(context).size.width * 0.02),
              decoration: BoxDecoration(
                color: Color(0xFF080E27),
                borderRadius: BorderRadius.circular(15),
              ),
              padding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.width * 0.025,
                horizontal: MediaQuery.of(context).size.width * 0.005,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    isEnglish
                        ? ' Users: ${statistics!['non_vendors_count']}'
                        : ' المستفدين: ${statistics!['non_vendors_count']}',
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    '  |  ',
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    isEnglish
                        ? ' Vendors: ${statistics!['vendors_count']}'
                        : 'التجار: ${statistics!['vendors_count']}',
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.35,
                  height: MediaQuery.of(context).size.width * 0.35,
                  margin: EdgeInsets.only(
                      bottom: MediaQuery.of(context).size.width * 0.02),
                  decoration: BoxDecoration(
                    color: Color(0xFF080E27),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.width * 0.015,
                    horizontal: MediaQuery.of(context).size.width * 0.005,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Text(
                            '${statistics!['working_discounts_count']}',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.15),
                          ),
                          Text(
                            isEnglish?'Current discounts':'الخصومات الحالية',
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.35,
                  height: MediaQuery.of(context).size.width * 0.35,
                  margin: EdgeInsets.only(
                      bottom: MediaQuery.of(context).size.width * 0.02),
                  decoration: BoxDecoration(
                    color: Color(0xFF080E27),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.width * 0.015,
                    horizontal: MediaQuery.of(context).size.width * 0.005,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Text(
                            '${statistics!['user_discounts_count']}',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.15),
                          ),
                          Text(
                            isEnglish?'Discounts':'خصومات المستفيدين',
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.width * 0.3,
                  margin: EdgeInsets.only(
                      bottom: MediaQuery.of(context).size.width * 0.02),
                  decoration: BoxDecoration(
                    color: Color(0xFF080E27),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.width * 0.015,
                    horizontal: MediaQuery.of(context).size.width * 0.005,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Text(
                            '${statistics!['total_payments_sum']}',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.1),
                          ),
                          Text(
                            isEnglish?'Vendors sales':'مبيعات التجار',
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.width * 0.3,
                  margin: EdgeInsets.only(
                      bottom: MediaQuery.of(context).size.width * 0.02),
                  decoration: BoxDecoration(
                    color: Color(0xFF080E27),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.width * 0.015,
                    horizontal: MediaQuery.of(context).size.width * 0.005,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Text(
                            '${statistics!['profits']}',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.1),
                          ),
                          Text(
                            isEnglish?'Residual earnings':'ارباح متبقية',
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
