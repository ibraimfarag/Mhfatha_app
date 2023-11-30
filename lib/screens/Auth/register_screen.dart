// lib\screens\Auth\login_screen.dart

import 'package:intl/intl.dart';
import 'package:mhfatha/settings/imports.dart';
import 'package:flutter/cupertino.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  Color colors = Color.fromARGB(220, 255, 255, 255);
  Color backgroundColor = Color(0xFF05204a);
  String selectedGender = 'male'; // Default gender selection
  DateTime? selectedDate;
// Declare variables to store selected region and city

  String selectedRegion = 'riyadh';


  
  @override
  Widget build(BuildContext context) {
    bool isEnglish = Provider.of<AppState>(context).isEnglish;
    Size size = MediaQuery.of(context).size;
    GlobalKey<CSCPickerState> _cscPickerKey = GlobalKey();
List<DropdownMenuItem<String>> citiesDropdownItems = [
  DropdownMenuItem(
    value: 'riyadh',
    child: Text(isEnglish ? 'Riyadh' : 'الرياض'),
  ),
  DropdownMenuItem(
    value: 'makkah',
    child: Text(isEnglish ? 'Makkah Al-Mukarramah' : 'مكة المكرمة'),
  ),
  DropdownMenuItem(
    value: 'madinah',
    child: Text(isEnglish ? 'Al-Madinah Al-Munawwarah' : 'المدينة المنورة'),
  ),
  DropdownMenuItem(
    value: 'eastern',
    child: Text(isEnglish ? 'Eastern Province' : 'المنطقة الشرقية'),
  ),
  DropdownMenuItem(
    value: 'qassim',
    child: Text(isEnglish ? 'Qassim' : 'القصيم'),
  ),
  DropdownMenuItem(
    value: 'tabuk',
    child: Text(isEnglish ? 'Tabuk' : 'تبوك'),
  ),
  DropdownMenuItem(
    value: 'northern',
    child: Text(isEnglish ? 'Northern Borders' : 'الحدود الشمالية'),
  ),
  DropdownMenuItem(
    value: 'jazan',
    child: Text(isEnglish ? 'Jazan' : 'جازان'),
  ),
  DropdownMenuItem(
    value: 'hail',
    child: Text(isEnglish ? 'Hail' : 'حائل'),
  ),
  DropdownMenuItem(
    value: 'asir',
    child: Text(isEnglish ? 'Asir' : 'عسير'),
  ),
  DropdownMenuItem(
    value: 'aljouf',
    child: Text(isEnglish ? 'Al-Jouf' : 'الجوف'),
  ),
  DropdownMenuItem(
    value: 'najran',
    child: Text(isEnglish ? 'Najran' : 'نجران'),
  ),
  DropdownMenuItem(
    value: 'bahah',
    child: Text(isEnglish ? 'Al Bahah' : 'الباحة'),
  ),
];

    return DirectionalityWrapper(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/backgound.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: <Widget>[
                // Background Image

                Positioned(
                  top: 40,
                  right: 20,
                  child: Container(
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: EdgeInsets.all(1),
                    child: Row(
                      children: [
                        PopupMenuButton<String>(
                          icon: Icon(Icons.language,
                              color: Color.fromARGB(146, 255, 255, 255)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          onSelected: (String value) {
                            if (value == 'en' || value == 'ar') {
                              Provider.of<AppState>(context, listen: false)
                                  .toggleLanguage();
                            }
                          },
                          itemBuilder: (BuildContext context) {
                            return <PopupMenuEntry<String>>[
                              PopupMenuItem<String>(
                                value: 'en',
                                child: Text('English'),
                              ),
                              PopupMenuItem<String>(
                                value: 'ar',
                                child: Text('العربية'),
                              ),
                              // Add more languages as needed
                            ];
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                Column(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 40,
                    ),
                    Image.asset(
                      'images/logo.png', // Replace with the path to your image
                      height: 20, // Adjust the height as needed
                      // width: 100, // Adjust the width as needed
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      isEnglish
                          ? 'time to get discounts'
                          : 'وقت للحصول على الخصومات',
                      style:
                          TextStyle(color: Colors.grey.shade500, fontSize: 16),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    // /* -------------------------------------------------------------------------- */
                    // /* ------------------------------- field name ------------------------------- */
                    // /* -------------------------------------------------------------------------- */
                    Container(
                      margin:  EdgeInsets.fromLTRB ( 45, 0, 45, 0), // Adjust the padding as needed
                      alignment: isEnglish
                          ? Alignment.centerLeft
                          : Alignment.centerRight,
                      child: Text(
                        isEnglish
                            ? 'Name'
                            : 'الاسم',
                        style: TextStyle(
                            color: colors,
                            fontSize: 16,
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                    SizedBox(height: 8), // Adjust the height as needed
                    Container(
                      margin: EdgeInsets.only(left: 40, right: 40),
                      child: TextField(
                        style: TextStyle(fontSize: 16, color: Colors.white),
                        decoration: InputDecoration(
                          hintStyle: TextStyle(color: Colors.grey.shade700),
                          filled: true,
                          fillColor:  backgroundColor,
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: backgroundColor)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: backgroundColor)),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    // /* -------------------------------------------------------------------------- */
                    // /* ------------------------------- family name ------------------------------- */
                    // /* -------------------------------------------------------------------------- */
                    Container(
                      margin:  EdgeInsets.fromLTRB ( 45, 0, 45, 0), // Adjust the padding as needed
                      alignment: isEnglish
                          ? Alignment.centerLeft
                          : Alignment.centerRight,
                      child: Text(
                        isEnglish
                            ? 'Family Name'
                            : 'لقب العائلة',
                        style: TextStyle(
                            color: colors,
                            fontSize: 16,
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                    SizedBox(height: 8), // Adjust the height as needed
                    Container(
                      margin: EdgeInsets.only(left: 40, right: 40),
                      child: TextField(
                        style: TextStyle(fontSize: 16, color: Colors.white),
                        decoration: InputDecoration(
                          hintStyle: TextStyle(color: Colors.grey.shade700),
                          filled: true,
                          fillColor:  backgroundColor,
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: backgroundColor)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: backgroundColor)),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    // /* -------------------------------------------------------------------------- */
                   // /* ---------------------------- Gender selection ---------------------------- */
                   // /* -------------------------------------------------------------------------- */
    Container(
  margin: EdgeInsets.only(left: 40, right: 40, top: 10), // Adjust the margin as needed
  child: Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Text(
        isEnglish ? 'Gender: ' : 'الجنس: ',
        style: TextStyle(
          color: colors,
          fontSize: 16,
          fontWeight: FontWeight.normal,
        ),
      ),
      Radio(
        value: 'male',
        groupValue: selectedGender,
        onChanged: (value) {
          setState(() {
            selectedGender = value.toString();
          });
        },
      ),
      Text(
        isEnglish ? 'Male' : 'ذكر',
        style: TextStyle(color: colors, fontSize: 16),
      ),
      Radio(
        value: 'female',
        groupValue: selectedGender,
        onChanged: (value) {
          setState(() {
            selectedGender = value.toString();
          });
        },
      ),
      Text(
        isEnglish ? 'Female' : 'أنثى',
        style: TextStyle(color: colors, fontSize: 16),
      ),
    ],
  ),
),

                    // /* -------------------------------------------------------------------------- */
                   // /* ---------------------------- Birthday selection ---------------------------- */
                   // /* -------------------------------------------------------------------------- */

                Container(
  margin: EdgeInsets.only(left: 40, right: 40, top: 10), // Adjust the margin as needed
  child:Row(
  mainAxisAlignment: MainAxisAlignment.start,
  children: [
    Text(
      isEnglish ? 'Birthday: ' : 'تاريخ الميلاد: ',
      style: TextStyle(
        color: colors,
        fontSize: 16,
        fontWeight: FontWeight.normal,
      ),
    ),
    ElevatedButton(
      onPressed: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );

        if (pickedDate != null && pickedDate != selectedDate) {
          setState(() {
            selectedDate = pickedDate;
          });
        }
      },
      style: ElevatedButton.styleFrom(
        primary: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(
        isEnglish ? 'Pick a Date' : 'اختر تاريخ',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    ),
    SizedBox(width: 8),
    selectedDate != null
        ? Text(
            ' ${DateFormat('yyyy-MM-dd').format(selectedDate!)}',
            style: TextStyle(color: colors),
          )
        : Container(),
  ],
),

),

                Row(
  mainAxisAlignment: MainAxisAlignment.start,
  children: [
    // Gender Dropdown
    Container(
      margin: EdgeInsets.only(right: 16),
      child: DropdownButton<String>(
        value: selectedGender,
        onChanged: (String? value) {
          setState(() {
            selectedGender = value!;
          });
        },
        items: [
          DropdownMenuItem(
            value: 'male',
            child: Text(isEnglish ? 'Male' : 'ذكر'),
          ),
          DropdownMenuItem(
            value: 'female',
            child: Text(isEnglish ? 'Female' : 'أنثى'),
          ),
        ],
      ),
    ),
    
       Container(
      margin: EdgeInsets.only(right: 16),
      child: DropdownButton<String>(
        value: selectedRegion,
        onChanged: (String? value) {
          setState(() {
            selectedRegion = value!;
          });
        },
        items: citiesDropdownItems,
      ),
    ),

    
   
   
  ],
),



                      Container(
                      margin:  EdgeInsets.fromLTRB ( 45, 0, 45, 0), // Adjust the padding as needed

                      alignment: isEnglish
                          ? Alignment.centerLeft
                          : Alignment.centerRight,
                      child: Text(
                        isEnglish
                            ?  "Password" : "كلمة السر",
                        style: TextStyle(
                            color: colors,
                            fontSize: 16,
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                      SizedBox(
                      height: 8,
                    ),
                                           Container(
                      margin: EdgeInsets.only(left: 40, right: 40),
                      child: TextField(
                                                obscureText: true,

                        style: TextStyle(fontSize: 16, color: Colors.white),
                        decoration: InputDecoration(
                          hintStyle: TextStyle(color: Colors.grey.shade700),
                          filled: true,
                          fillColor:backgroundColor,
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: backgroundColor)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: backgroundColor)),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    
Row(
  mainAxisAlignment: MainAxisAlignment.end, // Align items to the start (left)
  children: [
    Container(
      height: 50,
      width: 100,
      margin: EdgeInsets.only(left: 40, right: 40),
      child: ElevatedButton(
        onPressed: () {
          // Implement your logic when the button is pressed
        },
        style: ElevatedButton.styleFrom(
          primary: backgroundColor, // Set the background color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          isEnglish ? "SIGN UP" : "تسجيل",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    ),
  ],
),

                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
