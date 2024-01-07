
import 'package:flutter/services.dart';
import 'package:mhfatha/settings/imports.dart';




class CustomTextField extends StatelessWidget {
  final String label;
  final bool isPassword;
  final TextEditingController controller;
  final bool isNumeric;
  final Color labelcolor;
  final Color color;
  // final int maxLength;

  const CustomTextField({
    Key? key,
    required this.label,
    this.isPassword = false,
    required this.controller,
    required this.color,
    required this.labelcolor,
    this.isNumeric = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isEnglish = Provider.of<AppState>(context).isEnglish;
        bool isDark = Provider.of<AppState>(context).isDarkMode;

    Size size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.fromLTRB(45, 0, 45, 0),
          alignment: isEnglish
              ? Alignment.centerLeft
              : Alignment.centerRight,
          child: Text(
            label,
            style: TextStyle(
              color: labelcolor,
              fontSize: 16,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        SizedBox(height: 8),
        Container(
           padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: isDark? Color.fromARGB(251, 34, 34, 34):Color(0xFFF0F0F0),
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: [
                                  BoxShadow(
                                    color:isDark? Color.fromARGB(250, 17, 17, 17): Colors.grey.withOpacity(0.5),
                                    spreadRadius:
                                        5, // Negative spreadRadius makes the shadow inside
                                    blurRadius: 7,
                                    offset: Offset(0,
                                        3), // changes the position of the shadow
                                  ),
                                ],
                              ),
          margin: EdgeInsets.only(left: 40, right: 40),
          child: TextField(
            obscureText: isPassword,
            controller: controller,
            keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
            inputFormatters: isNumeric
                ? [FilteringTextInputFormatter.digitsOnly]
                : null, // Allow only numeric input
            // maxLength: maxLength,
            style: TextStyle(fontSize: 16, color:labelcolor),
            decoration: InputDecoration(
              hintStyle: TextStyle(color: Colors.grey.shade700),
              filled: true,
              fillColor: color,
 enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide(
                                      color: isDark? Color.fromARGB(0, 34, 34, 34):Color.fromARGB(0, 0, 0, 0),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide(
                                      color: Color.fromARGB(0, 225, 226, 228),
                                    ),
                                  ),
                                ),
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }
}
