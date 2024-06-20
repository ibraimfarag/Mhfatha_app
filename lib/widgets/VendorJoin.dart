import 'package:mhfatha/settings/imports.dart';


class VendorJoinWidget extends StatefulWidget {
  final bool isEnglish;
  final String labelText;
  final String yesText;
  final String noText;
  final Function(bool) onSelectionChanged;
  final Color labelcolor;

  const VendorJoinWidget({
    Key? key,
    required this.isEnglish,
    required this.labelText,
    required this.yesText,
    required this.noText,
    required this.onSelectionChanged,
    required this.labelcolor,
  }) : super(key: key);

  @override
  _VendorJoinWidgetState createState() => _VendorJoinWidgetState();
}

class _VendorJoinWidgetState extends State<VendorJoinWidget> {
  bool isVendor = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 40, right: 40, top: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.isEnglish ? widget.labelText : 'هل تريد الانضمام كـ تاجر؟ ',
            style: TextStyle(
              color: widget.labelcolor,
              fontSize: 16,
              fontWeight: FontWeight.normal,
            ),
          ),
          const SizedBox(width: 8),
          Row(
                    mainAxisAlignment: MainAxisAlignment.end,

            children: [
              Radio(
                value: true,
                groupValue: isVendor,
                onChanged: (value) {
                  setState(() {
                    isVendor = value as bool;
                    widget.onSelectionChanged(isVendor);
                  });
                },
              ),
              Text(
                widget.isEnglish ? widget.yesText : 'نعم',
                style: TextStyle(color:widget.labelcolor, fontSize: 16),
              ),
              Radio(
                value: false,
                groupValue: isVendor,
                onChanged: (value) {
                  setState(() {
                    isVendor = value as bool;
                    widget.onSelectionChanged(isVendor);
                  });
                },
              ),
              Text(
                widget.isEnglish ? widget.noText : 'لا',
                style: TextStyle(color: widget.labelcolor, fontSize: 16),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
