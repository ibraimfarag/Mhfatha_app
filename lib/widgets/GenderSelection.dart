import 'package:mhfatha/settings/imports.dart';

class GenderSelection extends StatelessWidget {
  final bool isEnglish;
  final String selectedGender;
  final Function(String) onGenderSelected;
  final Color labelcolor;

  const GenderSelection({
    Key? key,
    required this.isEnglish,
    required this.selectedGender,
    required this.onGenderSelected,
    required this.labelcolor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 40, right: 40, top: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(children: [
                SizedBox(height: 12,),
              Text(
                isEnglish ? 'Gender: ' : 'الجنس: ',
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
              ],),

              Radio(
                value: 'male',
                groupValue: selectedGender,
                onChanged: (value) {
                  onGenderSelected(value.toString());
                },
              ),
              Text(
                isEnglish ? 'Male' : 'ذكر',
                style: TextStyle(color: labelcolor, fontSize: 16),
              ),
              Radio(
                value: 'female',
                groupValue: selectedGender,
                onChanged: (value) {
                  onGenderSelected(value.toString());
                },
              ),
              Text(
                isEnglish ? 'Female' : 'أنثى',
                style: TextStyle(color: labelcolor, fontSize: 16),
              ),
            ],
          ),

          
        ],
      ),
    );
  }
}
