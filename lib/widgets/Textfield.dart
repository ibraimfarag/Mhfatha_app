
import 'package:mhfatha/settings/imports.dart';




class CustomTextField extends StatelessWidget {
  final String label;
  final bool isPassword;
  final TextEditingController controller;

  const CustomTextField({
    Key? key,
    required this.label,
    this.isPassword = false,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
      bool isEnglish = Provider.of<AppState>(context).isEnglish;
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
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        SizedBox(height: 8),
        Container(
          margin: EdgeInsets.only(left: 40, right: 40),
          child: TextField(
            obscureText: isPassword,
            controller: controller,
            style: TextStyle(fontSize: 16, color: Colors.white),
            decoration: InputDecoration(
              hintStyle: TextStyle(color: Colors.grey.shade700),
              filled: true,
              fillColor: Color(0xFF05204a),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Color(0xFF05204a)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Color(0xFF05204a)),
              ),
            ),
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }
}
