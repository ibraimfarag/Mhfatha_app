
import 'package:flutter/services.dart';
import 'package:mhfatha/settings/imports.dart';


class CustomTextField extends StatefulWidget {
  final String label;
  final bool isPassword;
  final TextEditingController controller;
  final bool isNumeric;
  final Color labelcolor;
  final Color color;
  final Function(String)? onValidMobileEntered; // Callback function for valid mobile number entered

  const CustomTextField({
    Key? key,
    required this.label,
    this.isPassword = false,
    required this.controller,
    required this.color,
    required this.labelcolor,
    this.isNumeric = false,
    this.onValidMobileEntered,
  }) : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _isKeyboardVisible = false;

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
            widget.label,
            style: TextStyle(
              color: widget.labelcolor,
              fontSize: 16,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: isDark ? Color.fromARGB(251, 34, 34, 34) : Color(0xFFF0F0F0),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: isDark ? Color.fromARGB(250, 17, 17, 17) : Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3),
              ),
            ],
          ),
          margin: EdgeInsets.only(left: 40, right: 40),
          child: TextField(
            obscureText: widget.isPassword,
            controller: widget.controller,
            keyboardType: widget.isNumeric ? TextInputType.phone : TextInputType.text,
            inputFormatters: widget.isNumeric ? [  FilteringTextInputFormatter.digitsOnly, // Allow only numeric input
                LengthLimitingTextInputFormatter(10)] : null,
            style: TextStyle(fontSize: 16, color: widget.labelcolor),
            decoration: InputDecoration(
              hintStyle: TextStyle(color: Colors.grey.shade700),
              filled: true,
              fillColor: widget.color,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(
                  color: isDark ? Color.fromARGB(0, 34, 34, 34) : Color.fromARGB(0, 0, 0, 0),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(
                  color: Color.fromARGB(0, 225, 226, 228),
                ),
              ),
            ),
           onChanged: (value) {
  if (widget.label.toLowerCase() == 'mobile number') {
    // Limit the length of the entered text to 10 characters
  if (value.length == 10) {
                  // Hide keyboard after entering 10 digits
                  FocusScope.of(context).requestFocus(FocusNode());
                }
  }
},

          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }
}
