import 'package:flutter/material.dart';
import 'package:mhfatha/settings/imports.dart';

class ReportScreen extends StatefulWidget {
  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  String selectedReport = '';
  TextEditingController detailsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    bool isEnglish = Provider.of<AppState>(context).isEnglish;
    Map<String, dynamic>? store =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    String authName = authProvider.user![
        'first_name']; // Replace with the actual property holding the user's name

    return DirectionalityWrapper(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            IconButton(
              icon: Icon(Icons.arrow_forward),
              onPressed: () {
                // Navigate back to the previous screen
                Navigator.pop(context);
              },
              color: Color.fromARGB(255, 7, 0, 34),
            ),
          ],
        ),
        // ${store?['name']}
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 16),
                Text(
                  isEnglish ? 'Choose a Report Reason:' : 'اختر سبب البلاغ:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                // List of report options
                ListView(
                  shrinkWrap: true,
                  children: [
                    buildReportOption(isEnglish
                        ? 'The merchant refused the discount'
                        : 'رفض التاجر الخصم'),
                    buildReportOption(isEnglish
                        ? 'The discount period has expired prematurely'
                        : 'انتهاء فترة الخصم مبكرًا'),
                    buildReportOption(isEnglish
                        ? 'Refuse to repeat the discount'
                        : 'رفض تكرار الخصم'),
                    buildReportOption(isEnglish
                        ? 'The total invoice is incorrect'
                        : 'الفاتورة الإجمالية غير صحيحة'),
                    buildReportOption(isEnglish
                        ? 'The discount percentage is incorrect'
                        : 'نسبة الخصم غير صحيحة'),
                  ],
                ),
                SizedBox(height: 16),
                Text(
                  isEnglish ? 'Additional Details:' : ' تفاصيل إضافية:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                // Text field for additional details
                TextField(
                  controller: detailsController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: isEnglish
                        ? 'Write additional details...'
                        : 'اكتب تفاصيل إضافية...',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                // Button to submit the report
                ElevatedButton(
                  onPressed: () {
                    // Add logic to submit the report
                  },
                  child: Text(isEnglish ? 'Submit Report' : 'إرسال التقرير'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildReportOption(String option) {
    return RadioListTile(
      title: Text(option),
      value: option,
      groupValue: selectedReport,
      onChanged: (value) {
        setState(() {
          selectedReport = value.toString();
        });
      },
    );
  }
}
