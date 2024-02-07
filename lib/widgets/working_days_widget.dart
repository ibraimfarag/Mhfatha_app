import 'package:mhfatha/settings/imports.dart';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class WeekdaysSelector extends StatefulWidget {
  final Function(Map<String, Map<String, String>>) onChanged;
  final Map<String, Map<String, String>> workingDays;

  WeekdaysSelector({required this.onChanged, required this.workingDays});

  @override
  _WeekdaysSelectorState createState() => _WeekdaysSelectorState();
}

class _WeekdaysSelectorState extends State<WeekdaysSelector> {
  Map<String, Map<String, String>> get workingDays => widget.workingDays;

  Map<String, TimeOfDay?> openingTimes = {};
  Map<String, TimeOfDay?> closingTimes = {};
  bool sundaySelected = false;
  bool mondaySelected = false;
  bool tuesdaySelected = false;
  bool wednesdaySelected = false;
  bool thursdaySelected = false;
  bool fridaySelected = false;
  bool saturdaySelected = false;

  @override
  void initState() {
    super.initState();
    initializeFromWorkingDays();
    print('this come from :');
    print( workingDays);
  }

  void initializeFromWorkingDays() {
    // Initialize selectedDays, openingTimes, and closingTimes from widget.workingDays
    widget.workingDays.forEach((day, times) {
      if (day == 'Sunday') {
        sundaySelected = true;
        openingTimes[day] = TimeOfDay.fromDateTime(DateTime.parse(times['from']!));
        closingTimes[day] = TimeOfDay.fromDateTime(DateTime.parse(times['to']!));
      } else if (day == 'Monday') {
        mondaySelected = true;
        openingTimes[day] = TimeOfDay.fromDateTime(DateTime.parse(times['from']!));
        closingTimes[day] = TimeOfDay.fromDateTime(DateTime.parse(times['to']!));
      } else if (day == 'Tuesday') {
        tuesdaySelected = true;
        openingTimes[day] = TimeOfDay.fromDateTime(DateTime.parse(times['from']!));
        closingTimes[day] = TimeOfDay.fromDateTime(DateTime.parse(times['to']!));
      } else if (day == 'Wednesday') {
        wednesdaySelected = true;
        openingTimes[day] = TimeOfDay.fromDateTime(DateTime.parse(times['from']!));
        closingTimes[day] = TimeOfDay.fromDateTime(DateTime.parse(times['to']!));
      } else if (day == 'Thursday') {
        thursdaySelected = true;
        openingTimes[day] = TimeOfDay.fromDateTime(DateTime.parse(times['from']!));
        closingTimes[day] = TimeOfDay.fromDateTime(DateTime.parse(times['to']!));
      } else if (day == 'Friday') {
        fridaySelected = true;
        openingTimes[day] = TimeOfDay.fromDateTime(DateTime.parse(times['from']!));
        closingTimes[day] = TimeOfDay.fromDateTime(DateTime.parse(times['to']!));
      } else if (day == 'Saturday') {
        saturdaySelected = true;
        openingTimes[day] = TimeOfDay.fromDateTime(DateTime.parse(times['from']!));
        closingTimes[day] = TimeOfDay.fromDateTime(DateTime.parse(times['to']!));
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    bool isEnglish = Provider.of<AppState>(context).isEnglish;

    return  Container(
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                    padding:  EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    decoration: BoxDecoration(
                      color: Color(0xFFFFFFFF),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        Text(
          isEnglish ? 'Select working Days' : 'حدد أيام العمل',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildSwitch('Sunday', isEnglish ? 'Sunday' : 'الأحد'),
            buildSwitch('Monday', isEnglish ? 'Monday' : 'الاثنين'),
            buildSwitch('Tuesday', isEnglish ? 'Tuesday' : 'الثلاثاء'),
            buildSwitch('Wednesday', isEnglish ? 'Wednesday' : 'الأربعاء'),
            buildSwitch('Thursday', isEnglish ? 'Thursday' : 'الخميس'),
            buildSwitch('Friday', isEnglish ? 'Friday' : 'الجمعة'),
            buildSwitch('Saturday', isEnglish ? 'Saturday' : 'السبت'),
          ],
        ),
      ],
    )
    );
  }

  Widget buildSwitch(String day, String localizedDay) {
    bool isEnglish = Provider.of<AppState>(context).isEnglish;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
              decoration: BoxDecoration(
                      color: Color.fromARGB(20, 71, 71, 71),
                      borderRadius: BorderRadius.circular(30),
                    ),
          child: Column(
            children: [
              Row(
                children: [
                  Switch(
                    value: getSwitchValue(day),
                    onChanged: (value) {
                      setState(() {
                        setSwitchValue(day, value);
                        if (value) {
                          openingTimes[day] = TimeOfDay.now();
                          closingTimes[day] = TimeOfDay.now();
                        } else {
                          openingTimes.remove(day);
                          closingTimes.remove(day);
                        }
                      });
                      updateWorkingDaysArray();
                      widget.onChanged(widget.workingDays);
                    },
                    activeColor: Color(0xFF1D365C),
                    inactiveThumbColor: Color(0xFF1D365C),
                    inactiveTrackColor: Color.fromARGB(255, 255, 255, 255),
                  ),
                  Text(
                    localizedDay,
                    style: TextStyle(
                      color: Color(0xFF1D365C),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              if (getSwitchValue(day)) ...[
                Row(
                  children: [
                    SizedBox(width: 20),
                    Text(isEnglish ? 'Open Time: ' : 'وقت الفتح: '),
                    TextButton(
                      onPressed: () async {
                        final selectedTime = await showTimePicker(
                          context: context,
                          initialTime: openingTimes[day] ?? TimeOfDay.now(),
                        );
                        if (selectedTime != null) {
                          setState(() {
                            openingTimes[day] = selectedTime;
                          });
                          updateWorkingDaysArray();
                          widget.onChanged(widget.workingDays);
                        }
                      },
                      child: Text(
                        openingTimes[day]?.format(context) ?? 'Select Time',
                        style: TextStyle(
                          color: Color(0xFF1D365C),
                        ),
                      ),
                    ),
                    SizedBox(width: 5),
                    Text(isEnglish ? 'Close Time: ' : 'وقت الإغلاق: '),
                    TextButton(
                      onPressed: () async {
                        final selectedTime = await showTimePicker(
                          context: context,
                          initialTime: closingTimes[day] ?? TimeOfDay.now(),
                        );
                        if (selectedTime != null) {
                          setState(() {
                            closingTimes[day] = selectedTime;
                          });
                          updateWorkingDaysArray();
                          widget.onChanged(widget.workingDays);
                        }
                      },
                      child: Text(
                        closingTimes[day]?.format(context) ?? 'Select Time',
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
  }

  bool getSwitchValue(String day) {
    switch (day) {
      case 'Sunday':
        return sundaySelected;
      case 'Monday':
        return mondaySelected;
      case 'Tuesday':
        return tuesdaySelected;
      case 'Wednesday':
        return wednesdaySelected;
      case 'Thursday':
        return thursdaySelected;
      case 'Friday':
        return fridaySelected;
      case 'Saturday':
        return saturdaySelected;
      default:
        return false;
    }
  }

  void setSwitchValue(String day, bool value) {
    switch (day) {
      case 'Sunday':
        sundaySelected = value;
        break;
      case 'Monday':
        mondaySelected = value;
        break;
      case 'Tuesday':
        tuesdaySelected = value;
        break;
      case 'Wednesday':
        wednesdaySelected = value;
        break;
      case 'Thursday':
        thursdaySelected = value;
        break;
      case 'Friday':
        fridaySelected = value;
        break;
      case 'Saturday':
        saturdaySelected = value;
        break;
    }
  }

  void updateWorkingDaysArray() {
    widget.workingDays.clear();

    if (sundaySelected) {
      widget.workingDays['Sunday'] = {
        'from': openingTimes['Sunday']?.format(context) ?? 'Select Time',
        'to': closingTimes['Sunday']?.format(context) ?? 'Select Time',
      };
    }
    if (mondaySelected) {
      widget.workingDays['Monday'] = {
        'from': openingTimes['Monday']?.format(context) ?? 'Select Time',
        'to': closingTimes['Monday']?.format(context) ?? 'Select Time',
      };
    }
    if (tuesdaySelected) {
      widget.workingDays['Tuesday'] = {
        'from': openingTimes['Tuesday']?.format(context) ?? 'Select Time',
        'to': closingTimes['Tuesday']?.format(context) ?? 'Select Time',
      };
    }
    if (wednesdaySelected) {
      widget.workingDays['Wednesday'] = {
        'from': openingTimes['Wednesday']?.format(context) ?? 'Select Time',
        'to': closingTimes['Wednesday']?.format(context) ?? 'Select Time',
      };
    }
    if (thursdaySelected) {
      widget.workingDays['Thursday'] = {
        'from': openingTimes['Thursday']?.format(context) ?? 'Select Time',
        'to': closingTimes['Thursday']?.format(context) ?? 'Select Time',
      };
    }
    if (fridaySelected) {
      widget.workingDays['Friday'] = {
        'from': openingTimes['Friday']?.format(context) ?? 'Select Time',
        'to': closingTimes['Friday']?.format(context) ?? 'Select Time',
      };
    }
    if (saturdaySelected) {
      widget.workingDays['Saturday'] = {
        'from': openingTimes['Saturday']?.format(context) ?? 'Select Time',
        'to': closingTimes['Saturday']?.format(context) ?? 'Select Time',
      };
    }

    print(jsonEncode(widget.workingDays));
  }
}
