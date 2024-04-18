import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:provider/provider.dart';
import 'package:mhfatha/settings/imports.dart';

class ProfilePhotoWidget extends StatefulWidget {
  final bool isEnglish;
  final String label;
  final String selectPhotoText;
  final String changePhotoText;
  final String removeText;
  final String? endurl;
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
    this.endurl,
  }) : super(key: key);

  @override
  _ProfilePhotoWidgetState createState() => _ProfilePhotoWidgetState();
}

class _ProfilePhotoWidgetState extends State<ProfilePhotoWidget> {
  XFile? _imageFile;

  @override
  Widget build(BuildContext context) {
    bool isDark = Provider.of<AppState>(context).isDarkMode;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(45, 20, 45, 0),
            padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.label,
                  style: TextStyle(
                    color: widget.labelcolor,
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                SizedBox(height: 2),
                _imageFile != null
                    ? FutureBuilder<String>(
                        future: compressImage(_imageFile!),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            return Container(
                              height: 200,
                              width: 200,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  image: FileImage(File(snapshot.data!)),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          }
                        },
                      )
                    : widget.endurl != null
                        ? Container(
                            height: 200,
                            width: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: NetworkImage(
                                    'https://mhfatha.net/FrontEnd/assets/images/${widget.endurl}'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        : Container(),
                SizedBox(height: 16),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        final ImagePicker _picker = ImagePicker();
                        final XFile? image = await _picker.pickImage(
                          source: ImageSource.gallery,
                        );

                        if (image != null) {
                          String compressedImagePath =
                              await compressImage(image);
                          setState(() {
                            _imageFile = XFile(compressedImagePath);
                            widget.onPhotoSelected(compressedImagePath);
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
                        primary: widget.color,
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
                        : Container(),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
Future<String> compressImage(XFile imageFile) async {
  // Check if the image is already compressed
  if (imageFile.path.contains('compressed_')) {
    return imageFile.path; // Return the path of the already compressed image
  }

  Uint8List? result = await FlutterImageCompress.compressWithFile(
    imageFile.path,
    quality: 20, // Adjust the quality as needed
  );

  // Get the filename and extension of the original image file
  String fileName = imageFile.path.split('/').last;
  String compressedFileName = 'compressed_$fileName';

  final compressedFile = File('${imageFile.path.replaceFirst(fileName, compressedFileName)}');
  await compressedFile.writeAsBytes(result!);

  // Print the size of the compressed file
  int compressedSize = await compressedFile.length();
  print('Compressed image size: ${compressedSize / 1024} KB');

  return compressedFile.path;
}


}
