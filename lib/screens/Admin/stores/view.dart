import 'package:flutter/cupertino.dart';

import 'package:mhfatha/settings/imports.dart';

class AdminViewStores extends StatefulWidget {
  const AdminViewStores({Key? key}) : super(key: key);

  @override
  _AdminViewStoresState createState() => _AdminViewStoresState();
}

class _AdminViewStoresState extends State<AdminViewStores> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<dynamic> storess = []; // Make it nullable
  List<dynamic> filteredStores = []; // Define filteredStores list
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
        storess = stores;
        filteredStores = storess;
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
              isEnglish ? 'Stores' : 'المتاجر',
              style: const TextStyle(
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
          ...[
          TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: isEnglish ? 'Search by name ' : 'البحث بالاسم/السجل التجاري /رقم جوال',
              prefixIcon: const Icon(Icons.search),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF080E27)),
              ),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF080E27)),
              ),
            ),
            onChanged: (value) {
              setState(() {
                if (value.isEmpty) {
                  // If the TextField is empty, display all users
                  filteredStores = storess.toList();
                } else {
                  // Otherwise, filter the user list based on the search criteria
                  filteredStores = storess
                      .where((storess) =>
                          (storess['name'] != null &&
                              storess['name']
                                  .toLowerCase()
                                  .contains(value.toLowerCase())) ||
                          (storess['tax_number'] != null &&
                              storess['tax_number']
                                  .toLowerCase()
                                  .contains(value.toLowerCase())) ||
                          (storess['phone'] != null &&
                              storess['phone']
                                  .toLowerCase()
                                  .contains(value.toLowerCase())))
                      .toList();
                }
              });
            },

            // Unfocus the TextField when the user leaves
            onSubmitted: (_) {
              FocusScope.of(context).requestFocus(FocusNode());
            },
          ),
          if (filteredStores.isNotEmpty) ...[
            Container(
              padding: EdgeInsets.fromLTRB(
                  0, 0, 0, MediaQuery.of(context).size.height * 0.02),
              height: MediaQuery.of(context).size.height *
                  0.6, // Set the container height as needed
              child: SingleChildScrollView(
                child: Column(
                  children: filteredStores.map((usert) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(
                                'https://mhfatha.net/FrontEnd/assets/images/store_images/${usert['photo']}'),
                            // Placeholder avatar if no photo available
                            // child: Icon(Icons.person),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${usert['name']}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Row(
                                    // mainAxisAlignment:
                                    //     MainAxisAlignment.spaceAround,
                                    children: [
                                      if (usert['verifcation'] == 1)
                                        _buildStatusWidget(
                                          isEnglish ? 'Verifcation' : 'موثق',
                                          const Color(0xFF080E27),
                                        ),
                                      if (usert['is_bann'] == 1)
                                        _buildStatusWidget(
                                          isEnglish ? 'Banned' : 'محظور',
                                          Colors.red,
                                        ),
                                      if (usert['is_deleted'] == 1)
                                        _buildStatusWidget(
                                          isEnglish ? 'Deleted' : 'محذوف',
                                          Colors.red,
                                        ),
                                    ]),
                              ],
                            ),
                          ),
                          // Add onTap to handle user selection
                          GestureDetector(
                              onTap: () {
                                // Handle user selection here
                              },
                              child: PullDownButton(
                                itemBuilder: (context) => [
                                 
                                  //  Icon(Icons.barcode_reader)

                                  PullDownMenuItem(
                                    onTap: () async {
                                      await VendorApi(context)
                                          .getStoreQRImage(
                                              '${usert['id']}', context);
                                    },
                                    enabled: usert['is_deleted'] == 0,

                                    title: isEnglish ? 'QR' : 'الباركود',
                                    icon: CupertinoIcons.qrcode_viewfinder,
                                    // enabled: store['verifcation'] == 1,
                                  ),
                                  //  Icon(Icons.barcode_reader)

                                  if (usert['is_bann'] == 1)
                                    PullDownMenuItem(
                                      onTap: () async {
                                        QuickAlert.show(
                                          context: context,
                                          type: QuickAlertType.confirm,
                                          customAsset: 'images/confirm.gif',
                                          text: isEnglish
                                              ? 'Are you sure to perform the action?'
                                              : 'هل أنت متأكد من القيام بالإجراء؟',
                                          cancelBtnText:
                                              isEnglish ? 'No' : 'لا',
                                          confirmBtnText:
                                              isEnglish ? 'Yes' : 'نعم',
                                          confirmBtnColor: const Color(0xFF0D2750),
                                          onConfirmBtnTap: () async {
                                            // Perform the action for banning here
                                            // Example: await YourApi(context).performBanningAction('${usert['id']}', context);
                                            await AdminApi(context).Storeactions(
                                                context,
                                                '${usert['id']}',
                                                'unban');
                                            fetchDataFromApi(context);
                                          },
                                        );
                                      },
                                      enabled: usert['is_deleted'] == 0,
                                      title:
                                          isEnglish ? 'Unban' : 'رفع الحظر',
                                      icon: CupertinoIcons.bag_badge_minus,
                                    )
                                  else
                                    PullDownMenuItem(
                                      onTap: () async {
                                        QuickAlert.show(
                                          context: context,
                                          type: QuickAlertType.confirm,
                                          customAsset: 'images/confirm.gif',
                                          text: isEnglish
                                              ? 'Are you sure?'
                                              : 'هل أنت متأكد؟',
                                          cancelBtnText:
                                              isEnglish ? 'No' : 'لا',
                                          confirmBtnText:
                                              isEnglish ? 'Yes' : 'نعم',
                                          confirmBtnColor: const Color(0xFF0D2750),
                                          onConfirmBtnTap: () async {
                                            // Perform the general action here
                                            // Example: await YourApi(context).performAction('${usert['id']}', context);
                                            await AdminApi(context).Storeactions(
                                                context,
                                                '${usert['id']}',
                                                'ban');
                                            fetchDataFromApi(context);
                                          },
                                        );
                                      },
                                      enabled: usert['is_deleted'] == 0,
                                      isDestructive: true,
                                      title: isEnglish ? 'Bann' : 'حظر',
                                      icon: CupertinoIcons.bag_badge_minus,
                                    ),

                                  PullDownMenuItem(
                                    onTap: () {
                                      QuickAlert.show(
                                        context: context,
                                        type: QuickAlertType.confirm,
                                        customAsset: 'images/confirm.gif',
                                        text: isEnglish
                                            ? 'are you sure  ?'
                                            : 'هل انت متأكد؟',
                                        cancelBtnText:
                                            isEnglish ? 'No' : 'لا',
                                        confirmBtnText:
                                            isEnglish ? 'yes' : 'نعم',
                                        confirmBtnColor: const Color(0xFF0D2750),
                                        onConfirmBtnTap: () async {
                                          await AdminApi(context).Storeactions(
                                              context,
                                              '${usert['id']}',
                                              'delete');
                                          fetchDataFromApi(context);
                                        },
                                      );
                                    },
                                    enabled: usert['is_deleted'] == 0,
                                    title: isEnglish ? 'Delete' : 'حذف',
                                    isDestructive: true,
                                    icon: CupertinoIcons.delete,
                                  ),
                                ],
                                buttonBuilder: (context, showMenu) =>
                                    CupertinoButton(
                                  onPressed: showMenu,
                                  padding: EdgeInsets.zero,
                                  // child: const Icon(CupertinoIcons.ellipsis_circle),
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
