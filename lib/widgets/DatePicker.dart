import 'package:mhfatha/settings/imports.dart';

class DatePickerWidget extends StatelessWidget {
  final bool isEnglish;
  final DateTime? selectedDate;
  final Function(DateTime?) onDateSelected;
  final String label;

  const DatePickerWidget({
    Key? key,
    required this.isEnglish,
    required this.selectedDate,
    required this.onDateSelected,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 40, right: 40, top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isEnglish ? label : 'تاريخ الميلاد: ',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.normal,
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
                    color:  Color(0xFF05204a),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ElevatedButton(
                    onPressed: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );

                      if (pickedDate != null && pickedDate != selectedDate) {
                        onDateSelected(pickedDate);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.transparent,
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
                ),
              SizedBox(width: 8),
              if (selectedDate != null)
                GestureDetector(
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: selectedDate!,
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );

                    if (pickedDate != null && pickedDate != selectedDate) {
                      onDateSelected(pickedDate);
                    }
                  },
                  child: Text(
                    ' ${selectedDate!.year}-${selectedDate!.month}-${selectedDate!.day}',
                    style: TextStyle(
                      color: Colors.white,
                      // decoration: TextDecoration.underline,
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
