import 'package:intl/intl.dart';
import 'package:mhfatha/settings/imports.dart';
import 'package:flutter/cupertino.dart';



// region_selection.dart

import 'package:flutter/material.dart';

class RegionSelection extends StatefulWidget {
  final ValueChanged<String> onRegionSelected;

  const RegionSelection({Key? key, required this.onRegionSelected}) : super(key: key);

  @override
  State<RegionSelection> createState() => _RegionSelectionState();
}

class _RegionSelectionState extends State<RegionSelection> {
  String selectedRegion = 'riyadh';
Color colors = Color.fromARGB(220, 255, 255, 255);
  Color backgroundColor = Color(0xFF05204a);
  @override
  Widget build(BuildContext context) {
    bool isEnglish = Provider.of<AppState>(context).isEnglish;

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

    return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        SizedBox(height: 20),
         Container(
                                        margin: EdgeInsets.only(left: 45, right: 45),

                                width: 50,
                                alignment: isEnglish
                                    ? Alignment.centerLeft
                                    : Alignment.centerRight,
                                child: Text(
                                  isEnglish ? 'Region' : 'المنطقة',
                                  style: TextStyle(
                                    color: colors,
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
        SizedBox(height: 14),
        Container(
          margin: EdgeInsets.only(left: 45, right: 45),
          decoration: BoxDecoration(
            color: backgroundColor, // Set the background color as needed
            borderRadius: BorderRadius.circular(10),
          ),
          child: DropdownButton<String>(
            value: selectedRegion,
            onChanged: (String? value) {
              setState(() {
                selectedRegion = value!;
                widget.onRegionSelected(selectedRegion);
              });
            },
            items: citiesDropdownItems
                .map((DropdownMenuItem<String> item) {
              return DropdownMenuItem<String>(
                value: item.value,
                child: Container(
                  padding: EdgeInsets.only(right: 10, left: 10),
                  width: 100,
                  alignment: Alignment.center,
                  child: item.child,
                ),
              );
            }).toList(),
            style: TextStyle(color: Colors.white),
            underline: Container(),
            dropdownColor: backgroundColor, // Set the background color for the dropdown menu items
          ),
        ),
      ],
    );
  }
}
