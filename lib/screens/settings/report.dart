import 'package:mhfatha/settings/imports.dart';
import 'dart:io'; // Import dart:io library for File class

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  String selectedReport = '';
  TextEditingController detailsController = TextEditingController();
  TextEditingController additionalPhoneController = TextEditingController();
  bool isLoading = true;
  List<Map<String, dynamic>> supportReasons = [];
  int? selectedReportId;
List<File> selectedFiles = []; // List to store selected files
List<String> fileNames = []; // List to store selected file names
  Map<String, dynamic>? store;
  dynamic discounts;

  @override
  void initState() {
    super.initState();
    Api api = Api(); // Initialize vendorApi in initState
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchSupportReasons();
    });
    additionalPhoneController.addListener(() {
      if (additionalPhoneController.text.length == 10) {
        FocusScope.of(context).unfocus(); // Hide keyboard
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Map<String, dynamic>? arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    if (arguments != null) {
      store = arguments['store'] as Map<String, dynamic>?;
      discounts = arguments['discount'];
    }
  }

  Future<void> fetchSupportReasons() async {
    try {
      final reasons = await Api().getSupportReasons(context, 'vendor');
      setState(() {
        supportReasons = reasons;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // Handle the error appropriately in your app
      print('Error fetching support reasons: $e');
    }
  }

  void submitReport() {
  bool isEnglish = Provider.of<AppState>(context, listen: false).isEnglish;

  // Extract the necessary data for creating the support request
  int? optionId = selectedReportId;
  String details = detailsController.text.trim();
  String additionalPhone = additionalPhoneController.text.trim();

  // Check if the phone number is valid
  if (additionalPhone.length != 10) {
    // Show an error message or handle the case where the phone number is invalid
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(isEnglish
              ? 'Phone number must be exactly 10 digits.'
              : 'يجب أن يكون رقم الهاتف مكونًا من 10 أرقام.')),
    );
    return;
  }

  // Call createSupportRequest function with the necessary data
  Api()
      .createSupportRequest(
    context,
    optionId: optionId,
    message: details,
    parentId: 2,
    storeId: store!['id'],
    discountId: discounts!['id'],
    additionalPhone:additionalPhone,
    attachments: selectedFiles.map((file) => file.path).toList(),

  )
      .then((_) {
    // Handle success if necessary
    print('Support request submitted successfully.');
  }).catchError((error) {
    // Handle error if necessary
    print('Error submitting support request: $error');
  });
}


  @override
  Widget build(BuildContext context) {
    bool isEnglish = Provider.of<AppState>(context).isEnglish;
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    String authName = authProvider.user![
        'first_name']; // Replace with the actual property holding the user's name

    return DirectionalityWrapper(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomAppBar(
                  onBackTap: () {
                    Navigator.pop(context);
                  },
                  iconColor: const Color.fromARGB(146, 0, 0, 0),
                  marginTop: 30,
                ),
                const SizedBox(height: 16),
                Text(
                  isEnglish ? 'Choose a Report Reason:' : 'اختر سبب البلاغ:',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Container(
                        margin: const EdgeInsets.only(left: 2, right: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0F0F0),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: DropdownButtonFormField<int>(
                            value: selectedReportId,
                            onChanged: (int? newValue) {
                              setState(() {
                                selectedReportId = newValue;
                              });
                            },
                            items: supportReasons
                                .map<DropdownMenuItem<int>>((reason) {
                              return DropdownMenuItem<int>(
                                value: reason['id'],
                                child: Text(
                                  isEnglish
                                      ? reason['option_en']
                                      : reason['option_ar'],
                                ),
                              );
                            }).toList(),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                            ),
                            hint: Text(
                              isEnglish
                                  ? 'Tap here to choose'
                                  : 'اضغط هنا للاختيار',
                              style: TextStyle(color: Colors.grey.shade700),
                            ),
                          ),
                        ),
                      ),

                const SizedBox(height: 16),
                Text(
                  isEnglish ? 'Additional Details:' : 'تفاصيل إضافية:',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                // Text field for additional details
                Container(
                  margin: const EdgeInsets.only(left: 2, right: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F0F0),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: detailsController,
                    maxLines: 5,
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                    decoration: InputDecoration(
                      hintText: isEnglish
                          ? 'Write additional details...'
                          : 'اكتب تفاصيل إضافية...',
                      hintStyle: TextStyle(color: Colors.grey.shade700),
                      filled: true,
                      fillColor: const Color(0xFFF0F0F0),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(color: Colors.transparent),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(color: Colors.transparent),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Text field for additional phone
                Text(
                  isEnglish ? 'Additional Phone' : 'رقم الجوال الإضافي',
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Container(
                  margin: const EdgeInsets.only(left: 2, right: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F0F0),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: additionalPhoneController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 20), // Adjust padding as needed
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  isEnglish ? 'Upload File:' : 'تحميل الملف:',
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 10),

                GestureDetector(
                  onTap: () async {
                    FilePickerResult? result =
                        await FilePicker.platform.pickFiles();

                    if (result != null) {
                      // Handle selected file
                      PlatformFile file = result.files.first;
                      print('File picked: ${file.name}');
                      // Implement further processing or storage of the selected file
                    } else {
                      // User canceled the picker
                      print('No file selected.');
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.only(left: 2, right: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F0F0),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            readOnly: true,
                            onTap: () async {
                                     
            if (selectedFiles.length >= 5) {
              // Show a message or dialog indicating that the maximum limit has been reached
              print('Maximum limit reached. You can select up to 5 files.');
              return;
            }
            
            FilePickerResult? result = await FilePicker.platform.pickFiles();

            if (result != null) {
              PlatformFile file = result.files.first;
              setState(() {
                selectedFiles.add(File(file.path!));
                fileNames.add(file.name);
              });
            } else {
              // User canceled the picker
              print('No file selected.');
            }
      

                            },
                            decoration: InputDecoration(
                              hintText: isEnglish
                                  ? 'Upload your file...'
                                  : 'قم بتحميل ملفك...',
                              hintStyle: TextStyle(color: Colors.grey.shade700),
                              filled: true,
                              fillColor: const Color(0xFFF0F0F0),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide:
                                    const BorderSide(color: Colors.transparent),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide:
                                    const BorderSide(color: Colors.transparent),
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.attach_file),
                                    onPressed: () async {
            if (selectedFiles.length >= 5) {
              // Show a message or dialog indicating that the maximum limit has been reached
              print('Maximum limit reached. You can select up to 5 files.');
              return;
            }
            
            FilePickerResult? result = await FilePicker.platform.pickFiles();

            if (result != null) {
              PlatformFile file = result.files.first;
              setState(() {
                selectedFiles.add(File(file.path!));
                fileNames.add(file.name);
              });
            } else {
              // User canceled the picker
              print('No file selected.');
            }
          },
                        ),
                      ],
                    ),
                  ),
                ),
                  const SizedBox(height: 16),
SingleChildScrollView(
  scrollDirection: Axis.horizontal,
  child: Row(
    children: selectedFiles.asMap().entries.map((entry) {
      int index = entry.key;
      File file = entry.value;
      String fileName = fileNames[index];
      if (fileName.length > 15) {
        fileName = '${fileName.substring(0, 12)}...';
      }
      return Stack(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F0F0),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: [
                file.path.toLowerCase().endsWith('.jpg') ||
                        file.path.toLowerCase().endsWith('.png') ||
                        file.path.toLowerCase().endsWith('.jpeg')
                    ? Image.file(file, width: 100, height: 100, fit: BoxFit.cover) // Display image preview
                    : const Icon(Icons.insert_drive_file), // Display file icon
                const SizedBox(height: 10),
                Text(fileName), // Display file name
              ],
            ),
          ),
          Positioned(
            top: 5,
            left: 5,
            child: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                setState(() {
                  selectedFiles.removeAt(index);
                  fileNames.removeAt(index);
                });
              },
            ),
          ),
        ],
      );
    }).toList(),
  ),
)
,


                const SizedBox(height: 16),
                // Button to submit the report
                ElevatedButton(
                  onPressed: selectedReportId == null ? null : submitReport,
                  child: Text(isEnglish ? 'Submit Report' : 'إرسال التقرير'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
