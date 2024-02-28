import 'dart:convert';
import 'dart:io';
// import 'dart:js';
import 'package:permission_handler/permission_handler.dart'
    as permission_handler;

import 'package:mhfatha/settings/imports.dart';
import 'dart:convert';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart'
    as permission_handler;

import 'package:mhfatha/settings/imports.dart';

class MainAdmin extends StatefulWidget {


  MainAdmin({Key? key}) : super(key: key);

  @override
  _MainAdminState createState() => _MainAdminState();
}

class _MainAdminState extends State<MainAdmin> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

 

  @override
  Widget build(BuildContext context) {
    return MainAdminContainer(
      additionalWidgets: [
        Text('Additional Widget 1'),
        Text('Additional Widget 2'),
        // Add more widgets as needed
      ],
      child: Column(
        children: [
          Text('Child Widget 1'),
          Text('Child Widget 2'),
          // Add more child widgets as needed
        ],
      ),
    );
  }

}


// Future<void> fetchDataFromApi(BuildContext context) async {
//   try {
//     final statisticsData = await AdminApi(context).fetchStatistics();
//     final Map<String, dynamic> statistics = statisticsData['statistics'];
//     final List<dynamic> users = statisticsData['users'];
//     final List<dynamic> stores = statisticsData['stores'];
//     final List<dynamic> requests = statisticsData['requests'];
//     final List<dynamic> userDiscounts = statisticsData['user_discounts'];

//     // Call the callback function to update the statistics
//     updateStatistics({
//       'statistics': statistics,
//       'users': users,
//       'stores': stores,
//       'requests': requests,
//       'userDiscounts': userDiscounts,
//     });

//   } catch (e) {
//     print('Error: $e');
//   }
// }
