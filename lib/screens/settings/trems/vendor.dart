// lib\screens\settings\settings.dart

import 'dart:io';

import 'package:intl/intl.dart';
import 'package:mhfatha/settings/imports.dart';

class VendorTrems extends StatefulWidget {
  @override
  State<VendorTrems> createState() => _VendorTremsState();
}

class _VendorTremsState extends State<VendorTrems> {
  late AuthProvider authProvider; // Declare authProvider variable

  Color backgroundColor = Color.fromARGB(220, 255, 255, 255);
  Color ui = Color.fromARGB(220, 233, 233, 233);
  Color ui2 = Color.fromARGB(255, 113, 194, 110);
  Color colors = Color(0xFF05204a);

  Map<String, dynamic>? termsData; // Variable to hold terms and conditions data

  Api api = Api();
  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      fetchTermsData();
    });
  }

  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  void fetchTermsData() async {
    try {
      // Fetch the terms data using the termsRequestActions method from the Api class
      Map<String, dynamic> data =
          await api.tremsRequestActions(context, 'vendor');
      setState(() {
        termsData = data['terms_and_conditions'];
      });
      print(termsData);
    } catch (e) {
      // Handle any errors that occur during the fetch
      print('Error fetching terms data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isEnglish = Provider.of<AppState>(context).isEnglish;
    bool isDarkMode = Provider.of<AppState>(context).isDarkMode;
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);

    String lang = Provider.of<AppState>(context, listen: false).display;
    return DirectionalityWrapper(
        child: Scaffold(
      backgroundColor: Color(0xFFF3F4F7),
      body: SingleChildScrollView(
        child: Container(
            color: Color(0xFF080E27), // Set background color to #080e27
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomAppBar(
                    onBackTap: () {
                      Navigator.pop(context);
                    },
                    marginTop: 30,
                  ),
                  SizedBox(height: 16),
                  Container(
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    decoration: BoxDecoration(
                      color: Color(0xFFF3F4F7),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 30),
                        if (termsData != null)
                          ...termsData!.entries.map((entry) {
                            String sectionTitle = entry.key;
                            dynamic sectionData = entry.value;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: Text(
                                    sectionTitle,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),

                                SizedBox(height: 8),
                                // Check if sectionData is a map
                                if (sectionData is Map<String, dynamic>)
                                  ...sectionData.entries.map((termEntry) {
                                    String termTitle = termEntry.key;
                                    dynamic termDescription = termEntry.value;

                                    // Convert termDescription to a string representation
                                    String descriptionString = termDescription
                                        .entries
                                        .map((e) => '${e.key}: ${e.value}')
                                        .join('\n');

                                    return ListTile(
                                      title: Text(
                                        termTitle,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      subtitle: Text(descriptionString),
                                    );
                                  }).toList(),
                                SizedBox(height: 16),
                              ],
                            );
                          }).toList(),
                      ],
                    ),
                  )
                ])),
      ),
      // bottomNavigationBar: BottomNavBar(initialIndex: 2),

      bottomNavigationBar: authProvider.isAuthenticated
          ? NewNav() // Render the bottom navigation bar if the user is authenticated
          : null,
    ));
  }
}