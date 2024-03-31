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

class MainAdminContainer extends StatefulWidget {
  final List<Widget>? additionalWidgets;
  final Widget? child;
  final bool showCustomAppBar;

   MainAdminContainer({
    Key? key,
    this.additionalWidgets,
    this.child,
    this.showCustomAppBar = false, // Default value to show custom app bar
  }) : super(key: key);


  @override
  _MainAdminContainerState createState() => _MainAdminContainerState();
}

class _MainAdminContainerState extends State<MainAdminContainer> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isDrawerOpen = false;

  @override
  Widget build(BuildContext context) {
    bool isEnglish = Provider.of<AppState>(context, listen: false).isEnglish;
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    String authName = authProvider.user!['first_name'];

    return DirectionalityWrapper(
      child: Scaffold(
        backgroundColor: Color(0xFFF3F4F7),
        key: _scaffoldKey,
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
            color: Color(0xFF080E27),
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.stretch,
              // mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(20, 20, 20, 5),
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  IconButton(
                                    onPressed: _toggleDrawer,
                                    icon: const Icon(Icons.menu,
                                        color:
                                            Color.fromARGB(253, 255, 255, 255)),
                                  ),
                                  // Add other widgets as needed
                                ],
                              ),

                              // other widgets here
                            ],
                          ),
                        ],
                      ),
                    ),
                     if (widget.showCustomAppBar)
                    CustomAppBar(
                      onBackTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),

                Container(
                    child: Column(children: [
                  if (widget.additionalWidgets != null)
                    ...widget.additionalWidgets!,
                ])),
                SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  decoration: BoxDecoration(
                    color: Color(0xFFF3F4F7),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  child: Column(
                    children: [
                      if (widget.child != null) widget.child!,
                      // Add other widgets here
                    ],
                  ),
                ),
                // Display the user discounts information
              ],
            ),
          ),
        ),
        drawer: Drawer(
          width: double.infinity,
          backgroundColor: Colors.transparent,
          child: Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.45,
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/admin');
                      },
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Icon(Icons.dashboard),
                            SizedBox(width: 16),
                            Text(isEnglish ? 'Dashboard' : 'احصائيات'),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/admin/users');
                        // Handle drawer item 2 tap
                      },
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Icon(Icons.manage_accounts_outlined),
                            SizedBox(width: 16),
                            Text(isEnglish ? 'Users' : 'الاعضاء'),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/admin/stores');
                      },
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Icon(Icons.store_mall_directory_rounded),
                            SizedBox(width: 16),
                            Text(isEnglish ? 'Stores' : 'المتاجر'),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Handle drawer item 2 tap
                        Navigator.pushNamed(context, '/admin/ViewSettings');
                      },
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Icon(Icons.settings),
                            SizedBox(width: 16),
                            Text(isEnglish ? 'Settings' : 'الاعدادات'),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/admin/notification');
                      },
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Icon(Icons.notifications_on_outlined),
                            SizedBox(width: 16),
                            Text(isEnglish ? 'Notifications' : 'الاشعارات'),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/admin/requests');
                      },
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Icon(Icons.help_outline_sharp),
                            SizedBox(width: 16),
                            Text(isEnglish ? 'Requests' : 'الطلبات'),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/admin/accounts');
                      },
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Icon(Icons.help_outline_sharp),
                            SizedBox(width: 16),
                            Text(isEnglish ? 'Accounts' : 'الحسابات'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  _closeDrawer();
                  Navigator.of(context).pop();
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.55,
                  color: Color.fromARGB(0, 0, 0, 0),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: NewNav(),
      ),
    );
  }

  void _toggleDrawer() {
    setState(() {
      _isDrawerOpen = !_isDrawerOpen;
    });

    if (_isDrawerOpen) {
      _scaffoldKey.currentState?.openDrawer();
    } else {
      _scaffoldKey.currentState?.openEndDrawer();
    }
  }

  void _closeDrawer() {
    if (_isDrawerOpen) {
      setState(() {
        _isDrawerOpen = false;
      });
    }
  }
}
