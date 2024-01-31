// lib\screens\settings\settings.dart

import 'dart:io';

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mhfatha/settings/imports.dart';

class CreateStore extends StatefulWidget {
  @override
  State<CreateStore> createState() => _CreateStoreState();
}

class _CreateStoreState extends State<CreateStore> {
  late AuthProvider authProvider; // Declare authProvider variable
  late VendorApi vendorApi; // Declare vendorApi variable

  Color backgroundColor = Color.fromARGB(220, 255, 255, 255);
  Color ui = Color.fromARGB(220, 233, 233, 233);
  Color ui2 = Color.fromARGB(255, 113, 194, 110);
  Color colors = Color(0xFF05204a);
  TextEditingController store_name = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController mobile = TextEditingController();
  late String selectedRegion; // Declare selectedRegion variable
  String? _selectedProfileImagePath;
  List<String> selectedDays = []; // Holds selected days of the week

  Map<String, TimeOfDay?> openingTimes = {};
  Map<String, TimeOfDay?> closingTimes = {};
  Map<String, Map<String, String>> workingDays = {};

 // Default location (Cairo, Egypt)


  
  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    vendorApi = VendorApi(context); // Initialize vendorApi in initState

    authProvider.updateUserData(context);
    selectedRegion = '${authProvider.user!['region']}';
  }

  // Method to fetch vendor stores data
//  final Completer<GoogleMapController> _controller =
      // Completer<GoogleMapController>();



  @override
  Widget build(BuildContext context) {
    bool isEnglish = Provider.of<AppState>(context).isEnglish;
    bool isDarkMode = Provider.of<AppState>(context).isDarkMode;
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    String lang = Provider.of<AppState>(context, listen: false).display;
    return DirectionalityWrapper(
        child: Scaffold(
      body: SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
            color: Color(0xFF080E27), // Set background color to #080e27
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                // mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(20, 20, 20, 5),
                    // height: 200,
                    child: Column(children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              isEnglish
                                  ? 'Create new store'
                                  : 'انشاء متجر جديد',
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            Image.asset(
                              'images/output-store.gif', // Replace with the actual path to your GIF image
                              height: 140, // Adjust the height as needed
                            ),
                          ]),
                      // SizedBox(height: 16),
                    ]),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    decoration: BoxDecoration(
                      color: Color(0xFFF3F4F7),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20),
                        SizedBox(
                          height: 24,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            buildSettingItem(
                                context, 'store name', 'اسم المتجر', () {
                              // Navigate to account settings screen
                              // Navigator.pushNamed(context, Routes.accountSettings);
                            }, store_name, ' '),
                            Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 0),
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 15),
                              decoration: BoxDecoration(
                                color: Color(0xFFFFFFFF),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Column(
                                    children: [
                                      RegionSelection(
                                        color: ui,
                                        labelcolor: colors,
                                        onRegionSelected: (value) {
                                          print('onRegionSelected: $value');

                                          setState(() {
                                            print(
                                                'selectedRegion in AccountScreen: $selectedRegion');
                                            selectedRegion = value;
                                            // Update City with the value of selectedRegion
                                          });

                                          print(
                                              'selectedRegion in AccountScreen: $selectedRegion');
                                        },
                                        selectedRegion: selectedRegion,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            buildSettingItem(context, 'Address', 'العنوان', () {
                              // Implement privacy logic
                            }, address, ' '),
                            buildSettingItem(
                                context, 'mobile number', 'رقم الجوال', () {
                              // Implement report logic
                            }, mobile, ''),
                            buildWeekdaysSelector(), // Add weekday selector
 
     

                          ],
                        ),
                      ],
                    ),
                  )
                ])),
      ),
      bottomNavigationBar: NewNav(),
    ));
  }

  Widget buildSettingItem(
    BuildContext context,
    // IconData icon,
    String englishTitle,
    String arabicTitle,
    VoidCallback onTap,
    TextEditingController controller,
    String preFilledText,
  ) {
    bool isEnglish = Provider.of<AppState>(context).isEnglish;
    controller.text = preFilledText;

    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
        padding: EdgeInsets.fromLTRB(20, 30, 20, 30),
        decoration: BoxDecoration(
          color: Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Column(
          children: [
            Row(
              children: [
                // Icon(icon),
                SizedBox(width: 10),
                Text(isEnglish ? englishTitle : arabicTitle),
              ],
            ),
            SizedBox(height: 10),
            // Add TextField here
            if (englishTitle.toLowerCase() ==
                'birthday') // Check if it's the birthday field
              InkWell(
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );

                  if (pickedDate != null && pickedDate != DateTime.now()) {
                    controller.text =
                        DateFormat('yyyy-MM-dd').format(pickedDate);
                  }
                },
                child: AbsorbPointer(
                  child: TextField(
                    controller: controller,
                    style: TextStyle(fontSize: 16, color: colors),
                    decoration: InputDecoration(
                      hintStyle: TextStyle(color: Colors.grey.shade700),
                      filled: true,
                      fillColor: ui,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(color: backgroundColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(color: backgroundColor),
                      ),
                    ),
                  ),
                ),
              )
            else
              TextField(
                obscureText: false,
                controller: controller,
                style: TextStyle(fontSize: 16, color: colors),
                decoration: InputDecoration(
                  hintStyle: TextStyle(color: Colors.grey.shade700),
                  filled: true,
                  fillColor: ui,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: backgroundColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: backgroundColor),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget buildWeekdaysSelector() {
    bool isEnglish = Provider.of<AppState>(context).isEnglish;

    List<String> englishDays = [
      'Sun',
      'Mon',
      'Tue',
      'Wed',
      'Thu',
      'Fri',
      'Sat'
    ];
    List<String> arabicDays = [
      'الأحد',
      'الاثنين',
      'الثلاثاء',
      'الأربعاء',
      'الخميس',
      'الجمعة',
      'السبت'
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        Text(
          isEnglish ? 'Select working Days:' : 'حدد أيام العمل:',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        Wrap(
          children: List.generate(
            7,
            (index) {
              final day = isEnglish ? englishDays[index] : arabicDays[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 15),
                    decoration: BoxDecoration(
                      color: Color(0xFFFFFFFF),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                           Checkbox(
                              value: selectedDays.contains(day),
                              onChanged: (value) {
                                setState(() {
                                  if (value != null && value) {
                                    selectedDays.add(day);
                                    openingTimes[day] = TimeOfDay.now();
                                    closingTimes[day] = TimeOfDay.now();
                                  } else {
                                    selectedDays.remove(day);
                                    openingTimes.remove(day);
                                    closingTimes.remove(day);
                                  }
                                });
                                updateWorkingDaysArray();
                              },
                              activeColor: Color(0xFF1D365C),
                            ),
                            Text(
                              day,
                              style: TextStyle(
                                  color: Color(0xFF1D365C),
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        if (selectedDays.contains(day)) ...[
                          // SizedBox(height: 5),
                          Row(
                            children: [
                              SizedBox(width: 20),
                              Text(
                                isEnglish ? 'Open Time: ' : 'وقت الفتح: ',
                              ),
                              TextButton(
                                onPressed: () async {
                                  final selectedTime = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now(),
                                  );
                                  if (selectedTime != null) {
                                    setState(() {
                                      openingTimes[day] = selectedTime;
                                    });
                                  }
                                },
                                child: Text(
                                  openingTimes[day]?.format(context) ??
                                      'Select Time',
                                  style: TextStyle(color: Color(0xFF1D365C)),
                                ),
                              ),
                              SizedBox(width: 5),
                              Text(
                                isEnglish ? 'Close Time: ' : 'وقت الإغلاق: ',
                              ),
                              TextButton(
                                onPressed: () async {
                                  final selectedTime = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now(),
                                  );
                                  if (selectedTime != null) {
                                    setState(() {
                                      closingTimes[day] = selectedTime;
                                    });
                                  }
                                },
                                child: Text(
                                  closingTimes[day]?.format(context) ??
                                      'Select Time',
                                  style: TextStyle(color: Color(0xFF1D365C)),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

void updateWorkingDaysArray() {
  workingDays.clear();
  List<String> arabicDays = [
    'الأحد',
    'الاثنين',
    'الثلاثاء',
    'الأربعاء',
    'الخميس',
    'الجمعة',
    'السبت'
  ];
  List<String> englishDays = [
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday'
  ];

  for (String day in selectedDays) {
    int index = arabicDays.indexOf(day);
    String englishDay = englishDays[index];
     workingDays['"$englishDay"']  = {
      '"from"': '"${openingTimes[day]?.format(context) ?? 'Select Time'}"',
      '"to"': '"${closingTimes[day]?.format(context) ?? 'Select Time'}"',
    };
  }
  print(workingDays);
}


}
