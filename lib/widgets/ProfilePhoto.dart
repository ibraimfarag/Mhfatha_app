// lib\widgets\ProfilePhoto.dart


import 'dart:io';

import 'package:mhfatha/settings/imports.dart';


class ProfilePhotoWidget extends StatefulWidget {
  final bool isEnglish;
  final String label;
  final String selectPhotoText;
  final String changePhotoText;
  final String removeText;
  final Function(String?) onPhotoSelected;
  final Color labelcolor;
  final Color color;

  const ProfilePhotoWidget({
    Key? key,
    required this.isEnglish,
    required this.label,
    required this.selectPhotoText,
    required this.changePhotoText,
    required this.removeText,
    required this.onPhotoSelected,
    required this.labelcolor,
    required this.color,

  }) : super(key: key);

  @override
  _ProfilePhotoWidgetState createState() => _ProfilePhotoWidgetState();
}

class _ProfilePhotoWidgetState extends State<ProfilePhotoWidget> {
  XFile? _imageFile;

  @override
  Widget build(BuildContext context) {
            bool isDark = Provider.of<AppState>(context).isDarkMode;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          //  decoration: BoxDecoration(
                                // color: isDark? Color.fromARGB(251, 34, 34, 34):Color(0xFFF0F0F0),
                              //   borderRadius: BorderRadius.circular(30),
                              //   boxShadow: [
                              //     BoxShadow(
                              //       color:isDark? Color.fromARGB(250, 17, 17, 17): Colors.grey.withOpacity(0.5),
                              //       spreadRadius:
                              //           5, // Negative spreadRadius makes the shadow inside
                              //       blurRadius: 7,
                              //       offset: Offset(0,
                              //           3), // changes the position of the shadow
                              //     ),
                              //   ],
                              // ),
          margin: EdgeInsets.fromLTRB(45, 20, 45, 0),
          padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.isEnglish ? widget.label : 'الصورة الشخصية: ',
                style: TextStyle(
                  color:widget.labelcolor,
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
              ),
              SizedBox(height: 2),
              // Display the selected image preview
              _imageFile != null
                  ? Container(
                      height: 200,
                      width: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: FileImage(File(_imageFile!.path)),
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  : Container(), // Placeholder if no image is selected
              SizedBox(height: 16),
              // Option to remove the selected image
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      // Open the image picker
                      final ImagePicker _picker = ImagePicker();
                      final XFile? image = await _picker.pickImage(
                        source: ImageSource.gallery,
                      );

                      if (image != null) {
                        setState(() {
                          _imageFile = image;
                          widget.onPhotoSelected(image.path);
                        });
                      }
                    },
                    child: _imageFile != null
                        ? Text(
                            widget.isEnglish
                                ? widget.changePhotoText
                                : 'تغير  الصورة',
                            style: TextStyle(
                              color: widget.labelcolor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          )
                        : Text(
                            widget.isEnglish
                                ? widget.selectPhotoText
                                : 'اختر صورة',
                            style: TextStyle(
                              color: widget.labelcolor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                    style: ElevatedButton.styleFrom(
                      primary:                   widget.color,

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  _imageFile != null
                      ? ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _imageFile = null;
                              widget.onPhotoSelected(null);
                            });
                          },
                          child: Text(
                            widget.isEnglish ? widget.removeText : 'إزالة',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        )
                      : Container(), // Placeholder if no image is selected
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}
