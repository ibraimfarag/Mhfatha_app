import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mhfatha/settings/imports.dart';
import 'package:latlong2/latlong.dart';
import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';

class EditStore extends StatefulWidget {
  @override
  State<EditStore> createState() => _EditStoreState();
}

class _EditStoreState extends State<EditStore> {
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
  String selectedRegion = '1';
  String selectedCategory = '1';
  String? _selectedProfileImagePath;
  String storeimage = 'Market.png';
  String store_idd = '';

  // List<String> selectedDays = []; // Holds selected days of the week
  Map<String, TimeOfDay?> openingTimes = {};
  Map<String, TimeOfDay?> closingTimes = {};
  Map<String, Map<String, String>> workingDayss = {};

  LatLng? selectedLocation;
  // Map<String, dynamic>? storeData;

  Map<String, dynamic>? storeData; // Move the declaration here
  Map<String, bool> selectedDays = {
    'Sunday': false,
    'Monday': false,
    'Tuesday': false,
    'Wednesday': false,
    'Thursday': false,
    'Friday': false,
    'Saturday': false,
  };

  // Initialize the opening and closing times for each day
  void initializeTimes() {
    // Initialize with default values or values from storeData if available
    // For simplicity, let's initialize with null for now
    // You can set default values based on your requirements
    // For example: openingTimes['Monday'] = TimeOfDay(hour: 9, minute: 0);
    //              closingTimes['Monday'] = TimeOfDay(hour: 18, minute: 0);
    // Repeat this for all days of the week
  }

  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    vendorApi = VendorApi(context);

    // Fetch store data from ModalRoute settings

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      setState(() {
        storeData =
            ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
        workingDayss = Map<String, Map<String, String>>.from(
          (jsonDecode(storeData?['work_days'] ?? '{}') as Map<String, dynamic>)
              .map((key, value) => MapEntry(
                    key,
                    Map<String, String>.from(value),
                  )),
        );
        workingDayss.forEach((day, times) {
          selectedDays[day] = true;

          openingTimes[day] = _getTimeOfDayFromString(times['from']);
          closingTimes[day] = _getTimeOfDayFromString(times['to']);
        });

        store_name.text = '${storeData?['name']}' ?? '';
        address.text = '${storeData?['location']}' ?? '';
        latitude.text = '${storeData?['latitude']}' ?? '';
        longitude.text = '${storeData?['longitude']}' ?? '';
        mobile.text = '${storeData?['phone']}' ?? '';
        taxNumber.text = '${storeData?['tax_number']}' ?? '';
        selectedRegion =
            '${storeData?['region']}' ?? '${authProvider.user!['region']}';
        selectedCategory = '${storeData?['category_id']}';
        storeimage = '${storeData?['photo']}' ?? 'Market.png';
        store_idd = '${storeData?['id']}' ?? '';
        print('example :  $workingDayss');
        // print('Days:  $selectedDays');
      });
    });
    print(openingTimes);
    print(closingTimes);
    // Get authProvider and selectedRegion after fetching storeData
    authProvider.updateUserData(context);
  }

  TimeOfDay _getTimeOfDayFromString(String? timeString) {
    if (timeString != null && timeString.isNotEmpty) {
      // Replace any non-breaking space characters with regular spaces
      timeString = timeString.replaceAll('\u202F', ' ');

      // Try parsing with multiple formats to handle different time representations
      final List<String> formats = ['hh:mm a', 'h:mm a', 'H:mm'];
      for (final format in formats) {
        try {
          final dateTime = DateFormat(format).parse(timeString);
          return TimeOfDay.fromDateTime(dateTime);
        } catch (_) {
          continue; // Try the next format if parsing fails
        }
      }
      // If none of the formats match, return a default time
      print('Failed to parse time: $timeString');
    }
    // Return a default time if the input is invalid
    return TimeOfDay(hour: 0, minute: 0);
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

    // Initialize UI properties after getting storeData

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
  child: Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible( // Wrap Text with Flexible
            child: Text(
              '${storeData?['name']}',
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.06, // Adjust the multiplier as needed
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          // Adjust the height of the image dynamically
          Image.asset(
            'images/output-store.gif',
            height: MediaQuery.of(context).size.width * 0.25, // Adjust the multiplier as needed
          ),
        ],
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
                      SizedBox(height: 20),
                      SizedBox(height: 24),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
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
                            endurl: 'store_images/$storeimage',
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
                            '',
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
                                      selectedRegion: selectedRegion!,
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
                                        ? 'Select Working Days and Time'
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
                                      ? 'Are you sure store info?'
                                      : 'هل انت متأكد من معلومات المتجر؟',
                                  confirmBtnText: isEnglish ? 'Yes' : 'نعم',
                                  cancelBtnText: isEnglish ? 'No' : 'لا',
                                  confirmBtnColor: Color(0xFF0D2750),
                                  onConfirmBtnTap: () async {
                                    bool success = await vendorApi.updatestore(
                                        context: context,
                                        store_id: store_idd,
                                        store_name: store_name.text,
                                        address: address.text,
                                        latitude: latitude.text,
                                        longitude: longitude.text,
                                        workingdays: workingDayss,
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
                              isEnglish ? 'Edit Store' : 'تحديث المتجر',
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
                    // If the day is selected, initialize the opening and closing times if not already initialized
                    if (openingTimes[day] == null) {
                      openingTimes[day] = TimeOfDay(hour: 8, minute: 0); // Set default opening time to 08:00 AM
                    }
                    if (closingTimes[day] == null) {
                      closingTimes[day] = TimeOfDay(hour: 12, minute: 0); // Set default closing time to 12:00 PM
                    }
                  } else {
                    // If the day is deselected, remove its entry from workingDays
                    workingDayss.remove(day);
                  }
                  // Print updated workingDays
                  print('Updated workingDays: $workingDayss');
                });
              },
              activeColor: Color(0xFF1D365C),
            ),
            Text(
              isEnglish ? getEnglishDayName(day) : getArabicDayName(day),
              style: TextStyle(
                color: Color(0xFF1D365C),
                fontSize: MediaQuery.of(context).size.width * 0.04, // Adjust the multiplier as needed
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
                    initialTime: openingTimes[day] ?? TimeOfDay(hour: 8, minute: 0), // Default to 08:00 AM if not initialized
                  );
                  if (selectedTime != null) {
                    setState(() {
                      openingTimes[day] = selectedTime;
                      // Update workingDays with the selected opening time
                      workingDayss[day] ??= {};
                      workingDayss[day]!['from'] = selectedTime.format(context);
                      // Print updated workingDays
                      print('Updated workingDays: $workingDayss');
                    });
                  }
                },
                child: Text(
                  openingTimes[day]?.format(context) ?? '- - : - -',
                  style: TextStyle(
                    color: Color(0xFF1D365C),
                    fontSize: MediaQuery.of(context).size.width * 0.035, // Adjust the multiplier as needed
                  ),
                ),
              ),
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
                    initialTime: closingTimes[day] ?? TimeOfDay(hour: 12, minute: 0), // Default to 12:00 PM if not initialized
                  );
                  if (selectedTime != null) {
                    setState(() {
                      closingTimes[day] = selectedTime;
                      // Update workingDays with the selected closing time
                      workingDayss[day] ??= {};
                      workingDayss[day]!['to'] = selectedTime.format(context);
                      // Print updated workingDays
                      print('Updated workingDays: $workingDayss');
                    });
                  }
                },
                child: Text(
                  closingTimes[day]?.format(context) ?? '- - : - -',
                  style: TextStyle(
                    color: Color(0xFF1D365C),
                    fontSize: MediaQuery.of(context).size.width * 0.035, // Adjust the multiplier as needed
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

  Widget buildSettingItem(
    BuildContext context,
    String englishTitle,
    String arabicTitle,
    VoidCallback onTap,
    TextEditingController controller,
    String preFilledText,
  ) {
    bool isEnglish = Provider.of<AppState>(context).isEnglish;

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

  void _openMap() async {
    final selectedLocation = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditMapScreen(
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

class EditMapScreen extends StatefulWidget {
  final Function(String, LatLng) onLocationSelected;

  const EditMapScreen({Key? key, required this.onLocationSelected})
      : super(key: key);

  @override
  _EditMapScreenState createState() => _EditMapScreenState();
}

class _EditMapScreenState extends State<EditMapScreen> {
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
