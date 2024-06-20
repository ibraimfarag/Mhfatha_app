// import 'dart:js';

import 'package:mhfatha/settings/imports.dart';


class MainAdminContainer extends StatefulWidget {
  final List<Widget>? additionalWidgets;
  final Widget? child;
  final bool showCustomAppBar;

  const MainAdminContainer({
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
  int? RequestspadgesCount; // Simulating the padges count from API response
  int? AccountsspadgesCount; // Simulating the padges count from API response
  Map<String, dynamic>? statistics; // Make it nullable

  bool _isDrawerOpen = false;
  @override
  void initState() {
    super.initState();
    // Call the method to fetch data from the API
    fetchDataFromApi(context);
  }

  Future<void> fetchDataFromApi(BuildContext context) async {
    try {
      final statisticsData = await AdminApi(context).fetchStatistics(context);
      final Map<String, dynamic> statisticss = statisticsData['statistics'];

      setState(() {
        statistics = statisticss;
        RequestspadgesCount = statistics!['requests_count'];
        AccountsspadgesCount = statistics!['accounts_count'];
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
    String authName = authProvider.user!['first_name'];
    bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom != 0.0;

    return DirectionalityWrapper(
      child: Scaffold(
// resizeToAvoidBottomInset: false,
        backgroundColor: const Color(0xFFF3F4F7),
        key: _scaffoldKey,
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
            color: const Color(0xFF080E27),
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.stretch,
              // mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 5),
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
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  decoration: const BoxDecoration(
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
              Flexible(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.60,
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.fromLTRB(
                            10, 40, 10, 20), // Set the margins
                        child: Image.network(
                          'https://mhfatha.net/FrontEnd/assets/images/logo/dr-logo.png',
                          width: MediaQuery.of(context).size.width * 0.50,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/admin');
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              const Icon(Icons.dashboard),
                              const SizedBox(width: 16),
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
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              const Icon(Icons.manage_accounts_outlined),
                              const SizedBox(width: 16),
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
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              const Icon(Icons.store_mall_directory_rounded),
                              const SizedBox(width: 16),
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
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              const Icon(Icons.settings),
                              const SizedBox(width: 16),
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
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              const Icon(Icons.notifications_on_outlined),
                              const SizedBox(width: 16),
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
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              const Icon(Icons.help_outline_sharp),
                              const SizedBox(width: 16),
                              Text(isEnglish ? 'Requests' : 'الطلبات'),
                              // Conditionally display the badge based on padges_count
                              if (RequestspadgesCount !=
                                  0) // Assuming padgesCount is the variable holding the count from API
                                Container(
                                  padding: const EdgeInsets.all(4),
                                  margin: const EdgeInsets.only(left: 10, right: 10),
                                  decoration: BoxDecoration(
                                    color: Colors
                                        .red, // Customize the badge color as needed
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Text(
                                    RequestspadgesCount.toString(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      // Add GestureDetector for "Accounts" drawer item
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/admin/accounts');
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              const Icon(Icons.account_balance_rounded),
                              const SizedBox(width: 16),
                              Flexible(
                                fit: FlexFit
                                    .tight, // Ensures that the Row occupies all available space
                                child: Text(
                                  isEnglish ? 'Accounts' : 'الحسابات',
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              // Conditionally display the badge based on adminBadgesCount
                              if (AccountsspadgesCount != null &&
                                  AccountsspadgesCount! > 0)
                                Container(
                                  padding: const EdgeInsets.all(4),
                                  margin: const EdgeInsets.only(left: 10, right: 10),
                                  decoration: BoxDecoration(
                                    color: Colors
                                        .red, // Customize the badge color as needed
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Text(
                                    AccountsspadgesCount!.toString(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),

                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/admin/supporting/view');
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              const Icon(Icons.support_agent_outlined),
                              const SizedBox(width: 16),
                              Flexible(
                                fit: FlexFit
                                    .tight, // Ensures that the Row occupies all available space
                                child: Text(
                                  isEnglish ? 'Tech support' : 'الدعم الفني',
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              // Conditionally display the badge based on adminBadgesCount
                              // if (AccountsspadgesCount != null &&
                              //     AccountsspadgesCount! > 0)
                              //   Container(
                              //     padding: EdgeInsets.all(4),
                              //     margin: EdgeInsets.only(left: 10, right: 10),
                              //     decoration: BoxDecoration(
                              //       color: Colors
                              //           .red, // Customize the badge color as needed
                              //       borderRadius: BorderRadius.circular(30),
                              //     ),
                              //     child: Text(
                              //       AccountsspadgesCount!.toString(),
                              //       style: TextStyle(
                              //         color: Colors.white,
                              //         fontWeight: FontWeight.bold,
                              //       ),
                              //     ),
                              //   ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  _closeDrawer();
                  Navigator.of(context).pop();
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.45,
                  color: const Color.fromARGB(0, 0, 0, 0),
                ),
              ),
            ],
          ),
        ),

        bottomNavigationBar: const NewNav(),
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
