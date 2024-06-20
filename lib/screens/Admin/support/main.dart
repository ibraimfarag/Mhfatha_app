
import 'package:intl/intl.dart';
import 'package:mhfatha/settings/imports.dart';

class MainAdminSupporting extends StatefulWidget {
  const MainAdminSupporting({super.key});

  @override
  State<MainAdminSupporting> createState() => _MainAdminSupportingState();
}

class _MainAdminSupportingState extends State<MainAdminSupporting> {
  late AuthProvider authProvider; // Declare authProvider variable
  Api api = Api();
  Color backgroundColor = const Color.fromARGB(220, 255, 255, 255);
  Color ui = const Color.fromARGB(220, 233, 233, 233);
  Color ui2 = const Color.fromARGB(255, 113, 194, 110);
  Color colors = const Color(0xFF05204a);

  List<Map<String, dynamic>> supportTickets = []; // Add this line
  List<Map<String, dynamic>> filteredTickets = []; // Add this line
  TextEditingController searchController =
      TextEditingController(); // Add this line

  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    Api api = Api(); // Initialize vendorApi in initState
    final vendorApi = VendorApi(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {});
    fetchSupportTickets();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  String _formatDateTime(String dateTimeString) {
    // Parse the dateTimeString into a DateTime object
    DateTime dateTime = DateTime.parse(dateTimeString);

    // Format the date part (e.g., "27 May 2024")
    String formattedDate = DateFormat.yMMMMd().format(dateTime);

    // Format the time part (e.g., "09:13 AM")
    String formattedTime = DateFormat.jm().format(dateTime);

    return '$formattedDate, $formattedTime';
  }
  Future<void> fetchSupportTickets() async {
    try {
      List<Map<String, dynamic>> tickets =
          await Api().getSupportTickets(criteria: 'all', context: context);

      print(tickets);
      setState(() {
        supportTickets = tickets;
        filteredTickets =
            tickets; // Initialize filteredTickets with all tickets
      });
    } catch (e) {
      // Handle the error
      // print('Failed to fetch support tickets: $e');
      if (e is FormatException) {
        // Print the response body for more information
        // print('Response body: ${e.source}');
      }
    }
  }

  void filterTickets(String query) {
    setState(() {
      filteredTickets = supportTickets
          .where((ticket) => ticket['ticket_number']
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isEnglish = Provider.of<AppState>(context).isEnglish;
    bool isDarkMode = Provider.of<AppState>(context).isDarkMode;
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    double screenWidth = MediaQuery.of(context).size.width;

    String lang = Provider.of<AppState>(context, listen: false).display;
    return DirectionalityWrapper(
        child: Scaffold(
      backgroundColor: const Color(0xFFF3F4F7),
      body: SingleChildScrollView(
        child: Container(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
            color: const Color(0xFF080E27), // Set background color to #080e27
            child: Column(
                // crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomAppBar(
                    onBackTap: () {
                      Navigator.pop(context);
                    },
                    marginTop: 30,
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 1, 20, 5),
                    // height: 200,
                    child: Column(children: [
                      const SizedBox(height: 1),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(children: [
                                Text(
                                  isEnglish
                                      ? 'Technical Support'
                                      : 'الدعم الفني',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ]),
                            ],
                          ),
                          const SizedBox(height: 16),
                        ],
                      )
                    ]),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    decoration: const BoxDecoration(
                      color: Color(0xFFF3F4F7),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          controller: searchController,
                          onChanged: (value) {
                            filterTickets(value);
                          },
                          decoration: InputDecoration(
                            labelText: isEnglish
                                ? 'Search by Ticket Number'
                                : 'البحث برقم التذكرة',
                            hintText: isEnglish
                                ? 'Enter ticket number'
                                : 'أدخل رقم التذكرة',
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [],
                        ),
                        SingleChildScrollView(
                          child: Column(
                            children: filteredTickets.map((ticket) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, '/admin/supporting/update',
                                      arguments: ticket['id']);
                                },
                                child: Container(
                                  width: screenWidth * 0.9,
                                  margin: const EdgeInsets.symmetric(vertical: 10),
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.2),
                                        spreadRadius: 5,
                                        blurRadius: 7,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            isEnglish
                                                ? 'Ticket Number: ${ticket['ticket_number']}'
                                                : 'رقم التذكرة: ${ticket['ticket_number']}',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          PopupMenuButton<String>(
                                            icon: const Icon(Icons.more_vert),
                                            itemBuilder:
                                                (BuildContext context) {
                                              List<PopupMenuEntry<String>>
                                                  items = [];

                                              // Add "Process" option if the ticket status is not "Closed"
                                              if (ticket['status'] ==
                                                  'closed') {
                                                items.add(
                                                  PopupMenuItem<String>(
                                                    value: 'under processer',
                                                    child: Text(isEnglish
                                                        ? 'Process'
                                                        : 'معالجة'),
                                                  ),
                                                );
                                              }

                                              // Add "Close" option if the ticket status is "Under Process"
                                              if (ticket['status'] ==
                                                  'under processer') {
                                                items.add(
                                                  PopupMenuItem<String>(
                                                    value: 'closed',
                                                    child: Text(isEnglish
                                                        ? 'Close'
                                                        : 'إغلاق'),
                                                  ),
                                                );
                                              }

                                              return items;
                                            },
                                         onSelected: (String value) async {
  String action = ''; // Variable to store the action for the success message
  String actionText = ''; // Variable to store the action text based on language

  if (value == 'under processer') {
    action = 'underProcess';
    actionText = isEnglish ? 'Process' : 'معالجة';
    try {
      Map<String, dynamic> response = await Api().changeStatusSupportTickets(
        status: 'under processer',
        postId: ticket['id'].toString(), // Convert int to String
        context: context,
      );

      if (response['statusCode'] == 200 && response['data'] != null) {
        String message = response['data']['message'];
        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          customAsset: 'images/success.gif',
          confirmBtnColor: const Color(0xFF0D2750),
          text: isEnglish 
                ? 'Ticket ${ticket['ticket_number']} status changed to $actionText successfully'
                : 'تم تغيير حالة التذكرة ${ticket['ticket_number']} إلى $actionText بنجاح',
        );
        setState(() {
          ticket['status'] = 'under processer';
        });
      } else {
        throw Exception('Failed to change status: ${response['statusCode']}');
      }
    } catch (e) {
      print('Error: $e');
    }
  } else if (value == 'closed') {
    action = 'closed';
    actionText = isEnglish ? 'Close' : 'إغلاق';
    try {
      Map<String, dynamic> response = await Api().changeStatusSupportTickets(
        status: 'closed',
        postId: ticket['id'].toString(), // Convert int to String
        context: context,
      );

      if (response['statusCode'] == 200 && response['data'] != null) {
        String message = response['data']['message'];
        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          customAsset: 'images/success.gif',
          confirmBtnColor: const Color(0xFF0D2750),
          text: isEnglish 
                ? 'Ticket ${ticket['ticket_number']} status changed to $actionText successfully'
                : 'تم تغيير حالة التذكرة ${ticket['ticket_number']} إلى $actionText بنجاح',
        );
        setState(() {
          ticket['status'] = 'closed';
        });
      } else {
        throw Exception('Failed to change status: ${response['statusCode']}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
},

                                          ),
                                        ],
                                      ),
                                   
                                       
                                 
                                      Text(
                                        isEnglish
                                            ? 'Status: ${ticket['status']}'
                                            : 'الحالة: ${ticket['status']}',
                                      ),
                                      Text(
                                        isEnglish
                                            ? 'Date: ${_formatDateTime(ticket['updated_at'])}'
                                            : 'التاريخ: ${_formatDateTime(ticket['updated_at'])}',
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ])),
      ),
      bottomNavigationBar: const NewNav(),
    ));
  }
}
