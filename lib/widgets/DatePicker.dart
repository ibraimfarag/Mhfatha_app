import 'package:mhfatha/settings/imports.dart';

class DatePickerWidget extends StatelessWidget {
  final bool isEnglish;
  final DateTime? selectedDate;
  final Function(DateTime?) onDateSelected;
  final String label;
  final Color labelcolor;
  final Color color;

  const DatePickerWidget({
    Key? key,
    required this.isEnglish,
    required this.selectedDate,
    required this.onDateSelected,
    required this.label,
    required this.labelcolor,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isDark = Provider.of<AppState>(context).isDarkMode;

    return Container(
      margin: EdgeInsets.only(left: 40, right: 40, top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isEnglish ? label : 'تاريخ الميلاد: ',
            style: TextStyle(
              color: labelcolor,
              fontSize: 16,
              fontWeight: FontWeight.normal,
            ),
          ),
          Text(
            isEnglish ? '(optional)' : '(اختياري)',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (selectedDate == null)
                Container(
                  width: 200,
                  decoration: BoxDecoration(
                    // color: isDark? Color.fromARGB(251, 34, 34, 34):Color(0xFFF0F0F0),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: isDark
                            ? Color.fromARGB(250, 17, 17, 17)
                            : Colors.grey.withOpacity(0.5),
                        spreadRadius:
                            5, // Negative spreadRadius makes the shadow inside
                        blurRadius: 7,
                        offset:
                            Offset(0, 3), // changes the position of the shadow
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime(2013),
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2013),
                      );

                      if (pickedDate != null && pickedDate != selectedDate) {
                        onDateSelected(pickedDate);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      primary: color,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(360),
                        side: BorderSide(color: color, width: 0),
                      ),
                    ),
                    child: Text(
                      isEnglish ? 'Pick a Date' : 'اختر تاريخ',
                      style: TextStyle(
                        color: labelcolor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              SizedBox(width: 8),
              if (selectedDate != null)
                GestureDetector(
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: selectedDate!,
                      firstDate: DateTime(1900),
                      lastDate: DateTime(2013),
                    );

                    if (pickedDate != null && pickedDate != selectedDate) {
                      onDateSelected(pickedDate);
                    }
                  },
                  child: Text(
                    ' ${selectedDate!.year}-${selectedDate!.month}-${selectedDate!.day}',
                    style: TextStyle(
                      color:
                          labelcolor, // decoration: TextDecoration.underline,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
