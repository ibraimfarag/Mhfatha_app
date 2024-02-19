import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mhfatha/settings/imports.dart';
import 'package:latlong2/latlong.dart';
import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';

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
  TextEditingController latitude = TextEditingController();
  TextEditingController longitude = TextEditingController();
  TextEditingController mobile = TextEditingController();
  TextEditingController taxNumber = TextEditingController();
  late String selectedRegion; // Declare selectedRegion variable
  late String selectedCategory; // Declare selectedRegion variable
  String? _selectedProfileImagePath;
  Map<String, bool> selectedDays = {
    'Sunday': false,
    'Monday': false,
    'Tuesday': false,
    'Wednesday': false,
    'Thursday': false,
    'Friday': false,
    'Saturday': false,
  };

  Map<String, TimeOfDay?> openingTimes = {};
  Map<String, TimeOfDay?> closingTimes = {};
  Map<String, Map<String, String>> workingDays = {};

  LatLng? selectedLocation;

  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    vendorApi = VendorApi(context); // Initialize vendorApi in initState

    authProvider.updateUserData(context);
    selectedRegion = '${authProvider.user!['region']}';
    selectedCategory = '${authProvider.user!['region']}';

    // List<String> days = [
    //   'Sunday',
    //   'Monday',
    //   'Tuesday',
    //   'Wednesday',
    //   'Thursday',
    //   'Friday',
    //   'Saturday',
    // ];

    // for (String day in days) {
    //   openingTimes[day] =
    //       TimeOfDay(hour: 00, minute: 00); // Set default opening time
    //   closingTimes[day] =
    //       TimeOfDay(hour: 18, minute: 0); // Set default closing time
    // }
  }

  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    bool isEnglish = Provider.of<AppState>(context).isEnglish;
    bool isDarkMode = Provider.of<AppState>(context).isDarkMode;
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);

    String lang = Provider.of<AppState>(context, listen: false).display;
    return DirectionalityWrapper(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
            color: Color(0xFF080E27), // Set background color to #080e27
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomAppBar(
                  onBackTap: () {
                    Navigator.pop(context);
                  },
                  marginTop: 30,
                ),
Container(
  margin: EdgeInsets.fromLTRB(20, 0, 20, 5),
  height: 200,
  child: Column(
    children: [
      Expanded( // Wrap Row with Expanded
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible( // Wrap Text with Flexible
              child: Text(
                isEnglish ? 'Create New Store' : 'انشاء متجر جديد',
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.05, // Adjust the multiplier as needed
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            Image.asset(
              'images/output-store.gif',
              height: MediaQuery.of(context).size.width * 0.3, // Adjust the multiplier as needed
            ),
          ],
        ),
      ),
    ],
  ),
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
                      SizedBox(height: 24),
                      Column(
                        children: [
                          ProfilePhotoWidget(
                            isEnglish: isEnglish,
                            labelcolor: colors,
                            color: ui,
                            label:
                                isEnglish ? 'Store Photo: ' : 'صورة المتجر: ',
                            selectPhotoText:
                                isEnglish ? 'Select Photo' : 'اختر صورة',
                            changePhotoText:
                                isEnglish ? 'Change Photo' : 'تغير  الصورة',
                            removeText: isEnglish ? 'Remove' : 'إزالة',
                            onPhotoSelected: (path) {
                              setState(() {
                                _selectedProfileImagePath = path;
                              });
                              print('path : $path');
                            },
                          ),
                          buildSettingItem(
                            context,
                            'Store Name',
                            'اسم المتجر',
                            () {},
                            store_name,
                            ' ',
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(
                              vertical: 5,
                              horizontal: 0,
                            ),
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
                                    CategorySelection(
                                      color: ui,
                                      labelcolor: colors,
                                      onCategorySelected: (value) {
                                        print('onCategorySelected: $value');

                                        setState(() {
                                          print(
                                              'selectedCategory in AccountScreen: $selectedCategory');
                                          selectedCategory = value;
                                        });
                                      },
                                      selectedCategory: selectedCategory,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(
                              vertical: 5,
                              horizontal: 0,
                            ),
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
                                        });
                                      },
                                      selectedRegion: selectedRegion,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              _openMap();
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                vertical: 5,
                                horizontal: 0,
                              ),
                              padding: EdgeInsets.fromLTRB(20, 30, 20, 30),
                              decoration: BoxDecoration(
                                color: Color(0xFFFFFFFF),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Row(
                                children: [
                                  SizedBox(width: 10),
                                  Text(isEnglish
                                      ? 'Select On Map'
                                      : 'حدد على الخريطة'),
                                ],
                              ),
                            ),
                          ),
                          buildSettingItem(
                            context,
                            'Address',
                            'العنوان',
                            () {},
                            address,
                            '',
                          ),
                          buildSettingItem(
                            context,
                            'Mobile Number',
                            'رقم الجوال',
                            () {},
                            mobile,
                            '',
                          ),
                          buildSettingItem(
                            context,
                            'Commercial Register',
                            'السجل التجاري',
                            () {},
                            taxNumber,
                            '',
                          ),
                          Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 0),
                              padding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 0),
                              decoration: BoxDecoration(
                                color: Color(0xFFFFFFFF),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Column(
                                children: [
                                  SizedBox(height: 20),
                                  Text(
                                    isEnglish
                                        ? 'Select Working Days and times'
                                        : 'حدد أيام و أوقات العمل',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  buildDayTimeSelector('Sunday'),
                                  buildDayTimeSelector('Monday'),
                                  buildDayTimeSelector('Tuesday'),
                                  buildDayTimeSelector('Wednesday'),
                                  buildDayTimeSelector('Thursday'),
                                  buildDayTimeSelector('Friday'),
                                  buildDayTimeSelector('Saturday'),
                                ],
                              )),
                          ElevatedButton(
                            onPressed: () {
                              QuickAlert.show(
                                  context: context,
                                  type: QuickAlertType.confirm,
                                  customAsset: 'images/confirm.gif',
                                  text: isEnglish
                                      ? 'are you sure store info?'
                                      : 'هل انت متأكد من معلومات المتجر؟',
                                  confirmBtnText: isEnglish ? 'Yes' : 'نعم',
                                  cancelBtnText: isEnglish ? 'No' : 'لا',
                                  confirmBtnColor: Color(0xFF0D2750),
                                  onConfirmBtnTap: () async {
                                    bool success = await vendorApi.createstore(
                                        context: context,
                                        store_name: store_name.text,
                                        address: address.text,
                                        latitude: latitude.text,
                                        longitude: longitude.text,
                                        workingdays: workingDays,
                                        region: selectedRegion,
                                        categoryId: selectedCategory,
                                        mobile: mobile.text,
                                        tax_number: taxNumber.text,
                                        imageFile: _selectedProfileImagePath !=
                                                null
                                            ? File(
                                                _selectedProfileImagePath ?? '')
                                            : null);
                                  });
                            },
                            style: ElevatedButton.styleFrom(
                              primary: ui, // Set the background color
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: Text(
                              isEnglish ? 'Create Store' : 'انشاء المتجر',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: NewNav(),
      ),
    );
  }

  Widget buildSettingItem(
    BuildContext context,
    String englishTitle,
    String arabicTitle,
    VoidCallback onTap,
    TextEditingController controller,
    String preFilledText,
  ) {
    bool isEnglish = Provider.of<AppState>(context).isEnglish;
    controller.text = controller.text;

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
                SizedBox(width: 10),
                Text(isEnglish ? englishTitle : arabicTitle),
              ],
            ),
            SizedBox(height: 10),
            if (englishTitle.toLowerCase() == 'mobile number' ||
                englishTitle.toLowerCase() == 'commercial register')
              TextField(
                obscureText: false,
                controller: controller,
                style: TextStyle(fontSize: 16, color: colors),
                keyboardType:
                    TextInputType.phone, // Set the keyboard type to phone
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                      RegExp(r'[0-9]')), // Allow only numbers
                  LengthLimitingTextInputFormatter(
                      10), // Limit the length to 10 characters
                ],
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
                onChanged: (value) {
                  if (value.length == 10) {
                    // If the input length is 10, remove focus from the TextField
                    // This will close the keyboard
                    FocusScope.of(context).unfocus();
                  }
                },
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

Widget buildDayTimeSelector(String day) {
  bool isEnglish = Provider.of<AppState>(context).isEnglish;
  double screenWidth = MediaQuery.of(context).size.width;

  return Container(
    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
    decoration: BoxDecoration(
      color: Color.fromARGB(20, 71, 71, 71),
      borderRadius: BorderRadius.circular(30),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Checkbox for selecting the day
        Row(
          children: [
            Checkbox(
              value: selectedDays[day] ?? false,
              onChanged: (value) {
                setState(() {
                  selectedDays[day] = value!;
                  if (value!) {
                    // If the day is selected, set default opening and closing times
                    openingTimes[day] = TimeOfDay(hour: 8, minute: 0);
                    closingTimes[day] = TimeOfDay(hour: 12, minute: 0);
                    
                    // Update workingDays with the selected opening and closing times
                    workingDays[day] ??= {}; // Ensure the inner map is initialized
                    workingDays[day]!['from'] = openingTimes[day]!.format(context);
                    workingDays[day]!['to'] = closingTimes[day]!.format(context);
                  } else {
                    // If the day is deselected, remove its entry from workingDays
                    workingDays.remove(day);
                  }
                  // Print updated workingDays
                  print('Updated workingDays: $workingDays');
                });
              },
              activeColor: Color(0xFF1D365C),
            ),
            Text(
              isEnglish ? getEnglishDayName(day) : getArabicDayName(day),
              style: TextStyle(
                color: Color(0xFF1D365C),
                fontSize: screenWidth * 0.04, // Adjust the font size dynamically
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        // Display open and close times if the day is selected
        if (selectedDays[day] ?? false)
          Row(
            children: [
              SizedBox(width: screenWidth * 0.03), // Adjust spacing dynamically
              Text(
                isEnglish ? 'Open Time: ' : 'وقت الافتتاح: ',
                style: TextStyle(
                  fontSize: screenWidth * 0.035, // Adjust the font size dynamically
                ),
              ),
              TextButton(
                onPressed: () async {
                  final selectedTime = await showTimePicker(
                    context: context,
                    initialTime: openingTimes[day] ?? TimeOfDay(hour: 9, minute: 0),
                  );
                  if (selectedTime != null) {
                    setState(() {
                      openingTimes[day] = selectedTime;
                      // Update workingDays with the selected opening time
                      workingDays[day] ??= {}; // Ensure the inner map is initialized
                      workingDays[day]!['from'] = selectedTime.format(context);
                      // Print updated workingDays
                      print('Updated workingDays: $workingDays');
                    });
                  }
                },
                child: Text(
                  openingTimes[day]?.format(context) ?? '- - : - -',
                  style: TextStyle(
                    fontSize: screenWidth * 0.035, // Adjust the font size dynamically
                    color: Color(0xFF1D365C),
                  ),
                ),
              ),
              SizedBox(width: screenWidth * 0.02), // Adjust spacing dynamically
              Text(
                isEnglish ? 'Close Time: ' : 'وقت الإغلاق: ',
                style: TextStyle(
                  fontSize: screenWidth * 0.035, // Adjust the font size dynamically
                ),
              ),
              TextButton(
                onPressed: () async {
                  final selectedTime = await showTimePicker(
                    context: context,
                    initialTime: closingTimes[day] ?? TimeOfDay(hour: 12, minute: 0),
                  );
                  if (selectedTime != null) {
                    setState(() {
                      closingTimes[day] = selectedTime;
                      // Update workingDays with the selected closing time
                      workingDays[day] ??= {}; // Ensure the inner map is initialized
                      workingDays[day]!['to'] = selectedTime.format(context);
                      // Print updated workingDays
                      print('Updated workingDays: $workingDays');
                    });
                  }
                },
                child: Text(
                  closingTimes[day]?.format(context) ?? '- - : - -',
                  style: TextStyle(
                    fontSize: screenWidth * 0.035, // Adjust the font size dynamically
                    color: Color(0xFF1D365C),
                  ),
                ),
              ),
            ],
          ),
      ],
    ),
  );
}


// Helper method to get English day name
  String getEnglishDayName(String day) {
    switch (day) {
      case 'Sunday':
        return 'Sunday';
      case 'Monday':
        return 'Monday';
      case 'Tuesday':
        return 'Tuesday';
      case 'Wednesday':
        return 'Wednesday';
      case 'Thursday':
        return 'Thursday';
      case 'Friday':
        return 'Friday';
      case 'Saturday':
        return 'Saturday';
      default:
        return day;
    }
  }

// Helper method to get Arabic day name
  String getArabicDayName(String day) {
    switch (day) {
      case 'Sunday':
        return 'الأحد';
      case 'Monday':
        return 'الاثنين';
      case 'Tuesday':
        return 'الثلاثاء';
      case 'Wednesday':
        return 'الأربعاء';
      case 'Thursday':
        return 'الخميس';
      case 'Friday':
        return 'الجمعة';
      case 'Saturday':
        return 'السبت';
      default:
        return day;
    }
  }

  // Method to show time picker and update selected time
  Future<void> _selectTime(String day, {required bool isOpeningTime}) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isOpeningTime
          ? openingTimes[day] ?? TimeOfDay.now()
          : closingTimes[day] ?? TimeOfDay.now(),
    );
    setState(() {
      if (isOpeningTime) {
        openingTimes[day] = picked;
      } else {
        closingTimes[day] = picked;
      }
    });
  }

  void _openMap() async {
    final selectedLocation = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MapScreen(
          onLocationSelected: (addressName, location) {
            // Update the address text field with the selected location
            address.text = '$addressName';
            latitude.text = '${location.latitude}';
            longitude.text = '${location.longitude}';
            print('${latitude.text},${longitude.text},${address.text}');
          },
        ),
      ),
    );
  }
}

class MapScreen extends StatefulWidget {
  final Function(String, LatLng) onLocationSelected;

  const MapScreen({Key? key, required this.onLocationSelected})
      : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  Widget build(BuildContext context) {
    bool isEnglish = Provider.of<AppState>(context).isEnglish;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEnglish ? 'Select Location' : 'حدد موقع المتجر'),
      ),
      body: OpenStreetMapSearchAndPick(
        buttonTextStyle:
            const TextStyle(fontSize: 18, fontStyle: FontStyle.normal),
        buttonColor: Color(0xFF080E27),
        buttonText: isEnglish ? 'Set Current Location' : 'اختر الموقع الحالي',
        locationPinIconColor: Colors.red,
        locationPinText: '',
        onPicked: (pickedData) {
          final LatLng location =
              LatLng(pickedData.latLong.latitude, pickedData.latLong.longitude);
          final String addressName = pickedData.addressName;
          // Call the onLocationSelected callback to pass the selected location to the parent widget
          widget.onLocationSelected(addressName, location);

          // Return back with the picked data
          Navigator.pop(context);
        },
      ),
    );
  }
}
