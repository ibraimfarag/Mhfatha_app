
import 'package:mhfatha/settings/imports.dart';

class MHTicket extends StatefulWidget {
  const MHTicket({super.key});

  @override
  State<MHTicket> createState() => _MHTicketState();
}

class _MHTicketState extends State<MHTicket> {
  late AuthProvider authProvider; // Declare authProvider variable
  Api api = Api();
  Color backgroundColor = const Color.fromARGB(220, 255, 255, 255);
  Color ui = const Color.fromARGB(220, 233, 233, 233);
  Color ui2 = const Color.fromARGB(255, 113, 194, 110);
  Color colors = const Color(0xFF05204a);



  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    Api api = Api(); // Initialize vendorApi in initState
    final vendorApi = VendorApi(context);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arguments = ModalRoute.of(context)?.settings.arguments;
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
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                              ]),
                            ],
                          ),
                          const SizedBox(height: 16),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(children: [
     
                                
                              ]),
                              SizedBox(width: 20),
                              Column(
                                children: [],
                              )
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
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                         

                          ],
                        ),
                        SingleChildScrollView(
                          child: Column(
                            children: [


                              
                            ]
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
