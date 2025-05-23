// lib\screens\settings\settings.dart


import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:mhfatha/settings/imports.dart';

class MainDiscounts extends StatefulWidget {
  const MainDiscounts({super.key});

  @override
  State<MainDiscounts> createState() => _MainDiscountsState();
}

class _MainDiscountsState extends State<MainDiscounts> {
  late AuthProvider authProvider; // Declare authProvider variable
  Api api = Api();
  Color backgroundColor = const Color.fromARGB(220, 255, 255, 255);
  Color ui = const Color.fromARGB(220, 233, 233, 233);
  Color ui2 = const Color.fromARGB(255, 113, 194, 110);
  Color colors = const Color(0xFF05204a);

  Map<String, dynamic>? store;
  List<dynamic> discounts = [];
  String Storeid = '';
  String empty = '';
  String image = 'market.png';

  String percent = '';
  String category = '';
  String startDate = '';
  String endDate = '';

  final startDateController = TextEditingController();
  final endDateController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    Api api = Api(); // Initialize vendorApi in initState
    final vendorApi = VendorApi(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        store =
            ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

        Storeid = '${store?['id']}' ?? '';
        image = '${store?['photo']}' ?? '';
      });
      fetchDiscounts();
    });
  }

  Future<dynamic> fetchDiscounts() async {
    try {
      final fetchedDiscounts =
          await VendorApi(context).fetchDiscounts('${store?['id']}', context);
      setState(() {
        if (fetchedDiscounts is List<dynamic>) {
          discounts = fetchedDiscounts;
        } else if (fetchedDiscounts is String) {
          empty = fetchedDiscounts;
        }
      });
    } catch (e) {
      // Handle errors gracefully
      print('Error fetching discounts: $e');
    }
  }

  Future<void> selectDate(
      BuildContext context, TextEditingController controller) async {
    try {
      DateTime currentDate = await Api().fetchCurrentDateFromApi();
      DateTime? selectedDate = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: currentDate,
        lastDate: DateTime(2101),
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData.light().copyWith(
              primaryColor:
                  const Color(0xFF080E27), // Change this to your desired color
              colorScheme: const ColorScheme.light(
                primary: Color(0xFF080E27), // Change this to your desired color
              ),
              buttonTheme: const ButtonThemeData(
                textTheme: ButtonTextTheme.primary,
              ),
            ),
            child: child!,
          );
        },
      );

      if (selectedDate != null) {
        controller.text = DateFormat('yyyy-MM-dd').format(selectedDate);
      }
    } catch (e) {
      // Handle errors here, possibly showing an error message or logging the error
      print("Error fetching current date: $e");
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    bool isEnglish = Provider.of<AppState>(context).isEnglish;
    bool isDarkMode = Provider.of<AppState>(context).isDarkMode;
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    // final Map<String, dynamic> store = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

    String lang = Provider.of<AppState>(context, listen: false).display;
    return DirectionalityWrapper(
        child: Scaffold(
      backgroundColor: const Color(0xFFF3F4F7),
      key: _scaffoldKey,
      body: SingleChildScrollView(
        child: Container(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
            color: const Color(0xFF080E27), // Set background color to #080e27
            child: Column(
                // crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomAppBar(
                    onBackTap: () {
                      Navigator.pop(context);
                    },
                    marginTop: 30,
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
                    // height: 200,
                    child: Column(children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 30,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  isEnglish
                                      ? ' Discounts store '
                                      : 'خصومات متجر',
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  '${store?['name']}',
                                  style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ],
                            ),
                            const SizedBox(
                              width: 30,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                CircleAvatar(
                                  radius: 60,
                                  // Add your profile image here
                                  backgroundImage: NetworkImage(
                                      'https://mhfatha.net/FrontEnd/assets/images/store_images/$image'),
                                ),
                              ],
                            ),
                          ]),
                      const SizedBox(height: 16),
                    ]),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            barrierDismissible: true,
                            builder: (context) {
                              bool isEnglish = Provider.of<AppState>(context)
                                  .isEnglish; // Retrieve the isEnglish value

                              return AlertDialog(
                                title: Text(
                                  isEnglish ? 'Add Discount' : 'إضافة خصم',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: isEnglish
                                      ? TextAlign.left
                                      : TextAlign.right,
                                ),
                                content: SingleChildScrollView(
                                  // Wrap content with SingleChildScrollView
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        isEnglish
                                            ? 'Enter discount information'
                                            : 'أدخل بيانات الخصم',
                                        style: const TextStyle(
                                          fontSize: 16,
                                        ),
                                        textAlign: isEnglish
                                            ? TextAlign.left
                                            : TextAlign.right,
                                      ),
                                      const SizedBox(height: 10),
                                      TextField(
                                        decoration: InputDecoration(
                                          labelText: isEnglish
                                              ? 'Percent'
                                              : 'النسبة المئوية',
                                          hintText: isEnglish
                                              ? 'Enter Percent'
                                              : 'أدخل النسبة المئوية',
                                          prefixIcon: const Icon(Icons.percent),
                                          focusedBorder: const UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color(
                                                    0xFF080E27)), // Bottom border color when focused
                                          ),
                                          labelStyle: const TextStyle(
                                              color: Color(
                                                  0xFF080E27)), // Label text color
                                          hintStyle: const TextStyle(
                                              color: Color(
                                                  0xFF080E27)), // Hint text color
                                        ),
                                        keyboardType: TextInputType.number,
                                        onChanged: (value) => percent = value,
                                        textAlign: isEnglish
                                            ? TextAlign.left
                                            : TextAlign.right,
                                      ),
                                      const SizedBox(height: 10),
                                      TextFormField(
                                        decoration: InputDecoration(
                                          labelText:
                                              isEnglish ? 'Category' : 'الفئة',
                                          hintText: isEnglish
                                              ? 'Enter Category'
                                              : 'أدخل الفئة',
                                          prefixIcon: const Icon(Icons.category),
                                          focusedBorder: const UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color(
                                                    0xFF080E27)), // Bottom border color when focused
                                          ),
                                          labelStyle: const TextStyle(
                                              color: Color(
                                                  0xFF080E27)), // Label text color
                                          hintStyle: const TextStyle(
                                              color: Color(
                                                  0xFF080E27)), // Hint text color
                                        ),
                                        onChanged: (value) => category = value,
                                        textAlign: isEnglish
                                            ? TextAlign.left
                                            : TextAlign.right,
                                      ),
                                      const SizedBox(height: 10),
                                      GestureDetector(
                                        onTap: () => selectDate(context,
                                            startDateController), // Pass `context` explicitly here
                                        child: AbsorbPointer(
                                          child: TextFormField(
                                            controller: startDateController,
                                            decoration: InputDecoration(
                                              labelText: isEnglish
                                                  ? 'Start Date'
                                                  : 'تاريخ البدء',
                                              hintText: isEnglish
                                                  ? 'Select Start Date'
                                                  : 'اختر تاريخ البدء',
                                              prefixIcon:
                                                  const Icon(Icons.calendar_today),
                                              focusedBorder:
                                                  const UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Color(0xFF080E27)),
                                              ),
                                              labelStyle: const TextStyle(
                                                  color: Color(0xFF080E27)),
                                              hintStyle: const TextStyle(
                                                  color: Color(0xFF080E27)),
                                            ),
                                            textAlign: isEnglish
                                                ? TextAlign.left
                                                : TextAlign.right,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      GestureDetector(
                                        onTap: () => selectDate(context,
                                            endDateController), // Corrected to include `context`
                                        child: AbsorbPointer(
                                          child: TextFormField(
                                            controller: endDateController,
                                            decoration: InputDecoration(
                                              labelText: isEnglish
                                                  ? 'End Date'
                                                  : 'تاريخ الانتهاء',
                                              hintText: isEnglish
                                                  ? 'Select End Date'
                                                  : 'اختر تاريخ الانتهاء',
                                              prefixIcon:
                                                  const Icon(Icons.calendar_today),
                                              focusedBorder:
                                                  const UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Color(
                                                        0xFF080E27)), // Bottom border color when focused
                                              ),
                                              labelStyle: const TextStyle(
                                                  color: Color(
                                                      0xFF080E27)), // Label text color
                                              hintStyle: const TextStyle(
                                                  color: Color(
                                                      0xFF080E27)), // Hint text color
                                            ),
                                            textAlign: isEnglish
                                                ? TextAlign.left
                                                : TextAlign.right,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      // Your logic to handle the fields' values here
                                      startDate = startDateController.text;
                                      endDate = endDateController.text;
                                      print('Store ID: $Storeid');
                                      print('Percent: $percent');
                                      print('Category: $category');
                                      print('Start Date: $startDate');
                                      print('End Date: $endDate');
                                      Navigator.pop(
                                          context); // Close the alert dialog

                                      VendorApi(context).createDiscount(
                                          Storeid,
                                          percent,
                                          category,
                                          startDate,
                                          endDate,
                                          store!,
                                          _scaffoldKey.currentState!.context);
                                    },
                                    child: Text(
                                      isEnglish ? 'Add' : 'إضافة',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF080E27),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Container(
                          // width: 100,
                          margin: const EdgeInsets.fromLTRB(30, 0, 30, 20),
                          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                          decoration: const BoxDecoration(
                            color: Color(0xFFF3F4F7),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                            ),
                          ),
                          child: Row(
                            children: [
                              isEnglish ? const Icon(Icons.add) : Container(),
                              Text(
                                isEnglish
                                    ? 'Add Disscount'
                                    : 'اضافة خصم', // Text based on language
                              ),
                              const SizedBox(width: 5), // Space between icon and text
                              isEnglish
                                  ? Container()
                                  : const Icon(Icons.add), // Plus icon
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (empty.isNotEmpty)
                              Center(
                                child: Text(
                                  empty,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Color(
                                        0xFF080E27), // Set background color to #080e27
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            else
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          isEnglish
                                              ? 'Number of Discounts: ${discounts.length}'
                                              : 'عدد الخصومات : ${discounts.length}',
                                        ),
                                        // Iterate over discounts and build store containers
                                        for (var discount in discounts)
                                          buildStoreContainer(discount),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  )
                ])),
      ),
      bottomNavigationBar: const NewNav(),
    ));
  }

  Widget buildStoreContainer(Map<String, dynamic> Discounts) {
    final isEnglish = Provider.of<AppState>(context).isEnglish;

    return GestureDetector(
      onTap: () async {
        // Navigator.pushNamed(context, '/store-info', arguments: store);
      },
      child: FadeInRight(
        child: Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.fromLTRB(8, 10, 8, 10),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 5,
                blurRadius: 3,
                offset: const Offset(0, 1),
              ),
            ],
            color: const Color(0xFFFFFFFF),
            border: Border.all(
              color: const Color.fromARGB(5, 0, 0, 0),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: Row(
                    children: [
                      Text(
                        isEnglish
                            ? 'Discount on : ${Discounts['category']}'
                            : 'خصم : ${Discounts['category']}',
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: isEnglish ? TextAlign.left : TextAlign.right,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                  child: Row(
                    children: [
                      Text(
                        isEnglish
                            ? ' percent : ${Discounts['percent']?.replaceAll(RegExp(r'\.0+$'), '')}%'
                            : ' قيمة الخصم : ${Discounts['percent']?.replaceAll(RegExp(r'\.0+$'), '')}%',
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: isEnglish ? TextAlign.left : TextAlign.right,
                      ),
                    ],
                  ),
                ),
              ]),
              // Context Menu Button
              PullDownButton(
                itemBuilder: (context) => [
                  PullDownMenuItem(
                    onTap: () {
                      QuickAlert.show(
                        context: context,
                        type: QuickAlertType.confirm,
                        customAsset: 'images/confirm.gif',
                        text: isEnglish
                            ? 'are you sure you want to delete store ${Discounts['category']} ?'
                            : '؟ ${Discounts['category']} هل انت متأكد من حذف خصم ',
                        cancelBtnText: isEnglish ? 'No' : 'لا',
                        confirmBtnText: isEnglish ? 'yes' : 'نعم',
                        confirmBtnColor: const Color(0xFF0D2750),
                        onConfirmBtnTap: () async {
                          await VendorApi(context)
                              .deleteDiscount('${Discounts['id']}', context);
                        },
                      );
                    },
                    title: isEnglish ? 'Delete' : 'حذف',
                    isDestructive: true,
                    icon: CupertinoIcons.delete,
                  ),
                ],
                buttonBuilder: (context, showMenu) => CupertinoButton(
                  onPressed: showMenu,
                  padding: EdgeInsets.zero,
                  // child: const Icon(CupertinoIcons.ellipsis_circle),
                  child: const Icon(Icons.more_vert),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
