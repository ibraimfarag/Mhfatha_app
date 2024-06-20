import 'package:flutter/cupertino.dart';

import 'package:mhfatha/settings/imports.dart';

class AdminViewUser extends StatefulWidget {
  const AdminViewUser({Key? key}) : super(key: key);

  @override
  _AdminViewUserState createState() => _AdminViewUserState();
}

class _AdminViewUserState extends State<AdminViewUser> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<dynamic> user = []; // Make it nullable
  List<dynamic> filteredUser = []; // Define filteredUser list
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
        user = users;
        filteredUser = users;
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
              isEnglish ? 'Users' : 'المستخدمين',
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
              hintText: isEnglish ? 'Search by name' : 'البحث بالاسم',
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
                  filteredUser = (user).toList();
                } else {
                  // Otherwise, filter the user list based on the search criteria
                  filteredUser = user
                      .where((user) =>
                          user['first_name']
                              .toLowerCase()
                              .contains(value.toLowerCase()) ||
                          user['last_name']
                              .toLowerCase()
                              .contains(value.toLowerCase()) ||
                          user['mobile']
                              .toLowerCase()
                              .contains(value.toLowerCase()) ||
                          user['email']
                              .toLowerCase()
                              .contains(value.toLowerCase()) ||
                          user['region']
                              .toString()
                              .toLowerCase()
                              .contains(value.toLowerCase()))
                      .toList();
                }
              });
            },
            // Unfocus the TextField when the user leaves
            onSubmitted: (_) {
              FocusScope.of(context).requestFocus(FocusNode());
            },
          ),
          if (filteredUser.isNotEmpty) ...[
            Container(
              padding: EdgeInsets.fromLTRB(
                  0, 0, 0, MediaQuery.of(context).size.height * 0.02),
              height: MediaQuery.of(context).size.height *
                  0.6, // Set the container height as needed
              child: SingleChildScrollView(
                child: Column(
                  children: filteredUser.map((usert) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // CircleAvatar(
                          //   backgroundImage: NetworkImage(
                          //       'https://mhfatha.net/FrontEnd/assets/images/user_images/${usert['photo']}'),
                          //   // Placeholder avatar if no photo available
                          //   // child: Icon(Icons.person),
                          // ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${usert['first_name']} ${usert['last_name']}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Row(
                                    // mainAxisAlignment:
                                    //     MainAxisAlignment.spaceAround,
                                    children: [
                                      if (usert['is_vendor'] == 1)
                                        _buildStatusWidget(
                                          isEnglish ? 'Vendor' : 'تاجر',
                                          const Color(0xFF080E27),
                                        ),
                                      if (usert['is_admin'] == 1)
                                        _buildStatusWidget(
                                          isEnglish ? 'Admin' : 'مدير',
                                          const Color(0xFF080E27),
                                        ),
                                      if (usert['is_banned'] == 1)
                                        _buildStatusWidget(
                                          isEnglish ? 'Banned' : 'محظور',
                                          Colors.red,
                                        ),
                                      if (usert['is_deleted'] == 1)
                                        _buildStatusWidget(
                                          isEnglish ? 'Deleted' : 'محذوف',
                                          Colors.red,
                                        ),
                                      if (usert['is_temporarily'] == 1)
                                        _buildStatusWidget(
                                          isEnglish ? 'Temporarily' : 'مؤقت',
                                          Colors.orange,
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
                                  PullDownMenuItem(
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        '/admin/users/edit',
                                        arguments:
                                            usert, // Pass the user data to the destination screen
                                      );
                                    },
                                    title: isEnglish ? 'Edit' : 'تعديل',
                                    icon: Icons.edit,
                                    // enabled: store['verifcation'] == 1,
                                  ),
                                  //  Icon(Icons.barcode_reader)
                                  if (usert['is_temporarily'] == 1)
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
                                            // Perform the action for temporarily here
                                            // Example: await YourApi(context).performTemporarilyAction('${usert['id']}', context);
                                            await AdminApi(context).actions(
                                                context,
                                                '${usert['id']}',
                                                'restore_temporary');
                                            fetchDataFromApi(context);
                                          },
                                        );
                                      },
                                      title: isEnglish
                                          ? 'Stop Temporarily'
                                          : 'الغاء ايقاف مؤقت',
                                      icon: CupertinoIcons.pause_circle,
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
                                            await AdminApi(context).actions(
                                                context,
                                                '${usert['id']}',
                                                'temporarily');
                                            fetchDataFromApi(context);
                                          },
                                        );
                                      },
                                      title: isEnglish
                                          ? 'Temporarily'
                                          : 'ايقاف مؤقت',
                                      icon: CupertinoIcons.pause_circle,
                                    ),

                                  if (usert['is_banned'] == 1)
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
                                            await AdminApi(context).actions(
                                                context,
                                                '${usert['id']}',
                                                'unban');
                                            fetchDataFromApi(context);
                                          },
                                        );
                                      },
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
                                            await AdminApi(context).actions(
                                                context,
                                                '${usert['id']}',
                                                'ban');
                                            fetchDataFromApi(context);
                                          },
                                        );
                                      },
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
                                          await AdminApi(context).actions(
                                              context,
                                              '${usert['id']}',
                                              'delete');
                                          fetchDataFromApi(context);
                                        },
                                      );
                                    },
                                    title: isEnglish ? 'Delete' : 'حذف',
                                    isDestructive: true,
                                    icon: CupertinoIcons.delete,
                                  ),
                                  if (usert['is_admin'] == 1)
                                    PullDownMenuItem(
                                      onTap: () {
                                        QuickAlert.show(
                                          context: context,
                                          type: QuickAlertType.confirm,
                                          customAsset: 'images/confirm.gif',
                                          text: isEnglish
                                              ? 'Are you sure to remove admin role?'
                                              : 'هل أنت متأكد من إزالة دور المدير؟',
                                          cancelBtnText:
                                              isEnglish ? 'No' : 'لا',
                                          confirmBtnText:
                                              isEnglish ? 'Yes' : 'نعم',
                                          confirmBtnColor: const Color(0xFF0D2750),
                                          onConfirmBtnTap: () async {
                                            // Perform the action to remove admin role here
                                            // Example: await YourApi(context).removeAdminRole('${usert['id']}', context);
                                            await AdminApi(context).actions(
                                                context,
                                                '${usert['id']}',
                                                'remove_admin');
                                            fetchDataFromApi(context);
                                          },
                                        );
                                      },
                                      title: isEnglish
                                          ? 'Remove Admin'
                                          : 'إزالة المدير',
                                      isDestructive: true,
                                      icon: CupertinoIcons.control,
                                    )
                                  else
                                    PullDownMenuItem(
                                      onTap: () {
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
                                            await AdminApi(context).actions(
                                                context,
                                                '${usert['id']}',
                                                'make_admin');
                                            fetchDataFromApi(context);
                                          },
                                        );
                                      },
                                      title: isEnglish
                                          ? 'Make Admin'
                                          : 'تعين كـ مدير',
                                      isDestructive: false,
                                      icon: CupertinoIcons.control,
                                    ),

                                  if (usert['is_vendor'] == 1)
                                    PullDownMenuItem(
                                      onTap: () {
                                        QuickAlert.show(
                                          context: context,
                                          type: QuickAlertType.confirm,
                                          customAsset: 'images/confirm.gif',
                                          text: isEnglish
                                              ? 'Are you sure to remove vendor role?'
                                              : 'هل أنت متأكد من إزالة دور التاجر؟',
                                          cancelBtnText:
                                              isEnglish ? 'No' : 'لا',
                                          confirmBtnText:
                                              isEnglish ? 'Yes' : 'نعم',
                                          confirmBtnColor: const Color(0xFF0D2750),
                                          onConfirmBtnTap: () async {
                                            // Perform the action to remove vendor role here
                                            // Example: await YourApi(context).removeVendorRole('${usert['id']}', context);
                                            await AdminApi(context).actions(
                                                context,
                                                '${usert['id']}',
                                                'remove_vendor');
                                            fetchDataFromApi(context);
                                          },
                                        );
                                      },
                                      title: isEnglish
                                          ? 'Remove Vendor'
                                          : 'إزالة التاجر',
                                      isDestructive: true,
                                      icon: CupertinoIcons
                                          .square_fill_line_vertical_square_fill,
                                    )
                                  else
                                    PullDownMenuItem(
                                      onTap: () {
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
                                            await AdminApi(context).actions(
                                                context,
                                                '${usert['id']}',
                                                'make_vendor');
                                            fetchDataFromApi(context);
                                          },
                                        );
                                      },
                                      title: isEnglish
                                          ? 'Make Vendor'
                                          : 'تعين كـ تاجر',
                                      isDestructive: false,
                                      icon: CupertinoIcons
                                          .square_fill_line_vertical_square_fill,
                                    )
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
