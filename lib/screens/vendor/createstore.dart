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
  List<String> selectedDays = []; // Holds selected days of the week

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
  }

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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            isEnglish ? 'Create new store' : 'انشاء متجر جديد',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Image.asset(
                            'images/output-store.gif',
                            height: 120,
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
                                isEnglish ? 'Store photo: ' : 'صورة المتجر: ',
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
                            'store name',
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
                                      ? 'select on map'
                                      : 'حدد على الخريطة'),
                                ],
                              ),
                            ),
                          ),
                          buildSettingItem(
                            context,
                            'address',
                            'العنوان',
                            () {},
                            address,
                            '',
                          ),
                          buildSettingItem(
                            context,
                            'mobile number',
                            'رقم الجوال',
                            () {},
                            mobile,
                            '',
                          ),
                          buildSettingItem(
                            context,
                            'Tax number',
                            'الرقم الضريبي',
                            () {},
                            taxNumber,
                            '',
                          ),
                          buildWeekdaysSelector(),
                          ElevatedButton(
                            onPressed: () {
                              QuickAlert.show(
                                  context: context,
                                  type: QuickAlertType.confirm,
                                  text: isEnglish
                                      ? 'are you sure store info?'
                                      : 'هل انت متأكد من معلومات المتجر؟',
                                  confirmBtnText: isEnglish ? 'Yes' : 'نعم',
                                  cancelBtnText: isEnglish ? 'No' : 'لا',
                                  confirmBtnColor: Colors.green,
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
                              isEnglish ? 'create store' : 'انشاء المتجر',
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
            if (englishTitle.toLowerCase() == 'birthday')
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
      'Sunday',
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday'
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
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        if (selectedDays.contains(day)) ...[
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
                                  style: TextStyle(
                                    color: Color(0xFF1D365C),
                                  ),
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
                                  style: TextStyle(
                                    color: Color(0xFF1D365C),
                                  ),
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
      'sunday',
      'monday',
      'tuesday',
      'wednesday',
      'thursday',
      'friday',
      'saturday'
    ];

    for (String day in selectedDays) {
      int index = arabicDays.indexOf(day);
      String englishDay = englishDays[index];
      workingDays['$englishDay'] = {
        'from': openingTimes[day]?.format(context) ?? 'Select Time',
        'to': closingTimes[day]?.format(context) ?? 'Select Time',
      };
    }
    print(jsonEncode(workingDays));
    // print(workingDays);
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Location'),
      ),
      body: OpenStreetMapSearchAndPick(
        buttonTextStyle:
            const TextStyle(fontSize: 18, fontStyle: FontStyle.normal),
        buttonColor: Colors.blue,
        buttonText: 'Set Current Location',
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