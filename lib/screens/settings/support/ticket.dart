import 'package:mhfatha/settings/imports.dart'; // Import your dependencies
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';

class MHTicket extends StatefulWidget {
  const MHTicket({super.key});

  @override
  State<MHTicket> createState() => _MHTicketState();
}

class _MHTicketState extends State<MHTicket> {
  late AuthProvider authProvider;
  Api api = Api();
  Color backgroundColor = const Color.fromARGB(220, 255, 255, 255);
  Color ui = const Color.fromARGB(220, 233, 233, 233);
  Color ui2 = const Color.fromARGB(255, 113, 194, 110);
  Color colors = const Color(0xFF05204a);
  bool _isMounted = false;

  Map<String, dynamic>?
      ticketData; // Declare a variable to hold the ticket data
  List<dynamic> messages = [];
  final TextEditingController _messageController = TextEditingController();
  List<String> attachments = [];
  String ticketNumber = '';
  String ticketStatus = '';
  String idTicket = '';
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final arguments = ModalRoute.of(context)?.settings.arguments;
      setState(() {
        idTicket = '$arguments';
      });
      print(idTicket);
      _isMounted = true;

      Fetchdata();
      _startPolling();
    });
  }

  @override
  void dispose() {
    _isMounted = false;
    _stopPolling(); // Cancel the timer when the widget is disposed of

    // Clean up resources here
    super.dispose();
  }

  void _startPolling() {
    _timer = Timer.periodic(const Duration(seconds: 30), (timer) {
      if (mounted) {
        // Check if the widget is still mounted before fetching data
        Fetchdata();
      } else {
        _stopPolling(); // Cancel the timer if the widget is no longer mounted
      }
    });
  }

  void _stopPolling() {
    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    authProvider = Provider.of<AuthProvider>(context, listen: false);
    Api api = Api(); // Initialize vendorApi in initState
    final vendorApi = VendorApi(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  Future<void> _updateSupportRequest() async {
    // Example usage of updateSupportRequest method

    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dialog from closing on outside tap
      builder: (BuildContext context) {
        return const Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Center(
            child:
                CircularProgressIndicator(), // Replace QuickAlert with CircularProgressIndicator
          ),
        );
      },
    );
    try {
      String messageText = _messageController.text;
      Map<String, dynamic> statusCode = await Api().updateSupportRequest(
        context,
        id: idTicket, // Example id
        criteria: 'update', // Example id
        type: 'client',
        message: messageText,
        attachments: attachments,
      );

      if (statusCode['statusCode'] == 200) {
              _messageController.clear();

        // Do something if the request was successful
        print('Support request updated successfully!');

        print(statusCode['data']);

        setState(() {
          ticketNumber = statusCode['data']['ticketNumber'];
          ticketStatus = statusCode['data']['complaintSuggestion']['status'];

         
          // Ensure description is correctly parsed
          dynamic descriptionData =
              statusCode['data']['complaintSuggestion']['description'];
          List<dynamic> parsedDescription = json.decode(descriptionData);
          List<Map<String, dynamic>> allMessages = [];
          for (var item in parsedDescription) {
            allMessages.add({
              "message_type": item["message_type"],
              "message": item["message"],
              "date": item["date"],
              "read": item["read"],
              "attached": item["attached"]
            });
          }

          // Set messages state
          messages = allMessages;

          // Print the messages
          print(json.encode(messages));
        });

        Navigator.of(context).pop();
        _scrollToBottom();
      } else {
        // Handle other status codes or errors
        print('Failed to update support request. Status code: ');
      }
    } catch (e) {
      print('Failed to update support request: $e');
      // Handle error
    }
  }

  Future<void> Fetchdata() async {
    if (!_isMounted) {
      return; // Widget is already disposed of, exit early
    }
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );

    try {
      Map<String, dynamic> response = await Api().updateSupportRequest(
        context,
        id: idTicket, // Example id
        criteria: 'fetch',
      );

      if (response['statusCode'] == 200) {
        // print('Support request updated successfully!');
        // print(response['statusCode']); // Handle the response data here

        setState(() {
          ticketNumber = response['data']['ticketNumber'];
          ticketStatus = response['data']['complaintSuggestion']['status'];

          // Ensure description is correctly parsed
          dynamic descriptionData =
              response['data']['complaintSuggestion']['description'];
          List<dynamic> parsedDescription = json.decode(descriptionData);
          List<Map<String, dynamic>> allMessages = [];
          for (var item in parsedDescription) {
            allMessages.add({
              "message_type": item["message_type"],
              "message": item["message"],
              "date": item["date"],
              "read": item["read"],
              "attached": item["attached"]
            });
          }

          // Set messages state
          messages = allMessages;

          // Print the messages
          print(json.encode(messages));
        });

        if (ticketStatus == 'closed') {
          _stopPolling();
        }
        // print(messages);
        Navigator.of(context).pop();
        _scrollToBottom();
      } else {
        print(
            'Failed to fetch support request. Status code: ${response['statusCode']}');
      }
    } catch (e) {
      print('Failed to fetch support request: $e');
      Navigator.of(context).pop();
    }
  }

  final ScrollController _scrollController = ScrollController();
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isEnglish = Provider.of<AppState>(context).isEnglish;
    bool isDarkMode = Provider.of<AppState>(context).isDarkMode;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // Accessing ticket data example

    return DirectionalityWrapper(
      child: Scaffold(
        backgroundColor: const Color(0xFFF3F4F7),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
            color: const Color(0xFF080E27),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomAppBar(
                  onBackTap: () {
                    Navigator.pop(context);
                  },
                  marginTop: 30,
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 1, 20, 1),
                  child: Column(
                    children: [
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    isEnglish
                                        ? ticketNumber
                                        : ticketNumber,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    isEnglish
                                        ? ticketStatus
                                        : ticketStatus,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [],
                          ),
                          const SizedBox(height: 16),
                        ],
                      )
                    ],
                  ),
                ),
                Container(
                  // height: screenHeight,

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
                      const SizedBox(height: 20),
                      const Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [],
                      ),
                      SizedBox(
                        height: screenWidth * 1.05,
                        child: SingleChildScrollView(
                          controller: _scrollController,
                          child: Column(
                            children: messages.map<Widget>((message) {
                              String? messageType =
                                  message['message_type'] as String?;
                              String? messageContent =
                                  message['message'] as String?;
                              String? messageDate = message['date'] as String?;
                              Color messageColor = messageType == 'client'
                                  ? Colors.blue
                                  : Colors.green;
                              bool isClientMessage = messageType == 'client';
                              List<dynamic>? attachedFiles =
                                  message['attached'] as List<dynamic>?;

                              return Align(
                                child: Container(
                                  margin: const EdgeInsets.symmetric(vertical: 5),
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: messageColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    crossAxisAlignment: isClientMessage
                                        ? CrossAxisAlignment.start
                                        : CrossAxisAlignment.start,
                                    mainAxisAlignment: isClientMessage
                                        ? MainAxisAlignment.start
                                        : MainAxisAlignment.end,
                                    children: [
                                      Column(
                                        crossAxisAlignment: isClientMessage
                                            ? CrossAxisAlignment.start
                                            : CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            messageContent ?? 'No message',
                                            style:
                                                TextStyle(color: messageColor),
                                          ),
                                          if (attachedFiles != null &&
                                              attachedFiles.isNotEmpty)
                                            const Divider(),
                                          if (attachedFiles != null &&
                                              attachedFiles.isNotEmpty)
                                            Text(
                                              isEnglish
                                                  ? 'Attachments'
                                                  : 'المرفقات',
                                              style: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          if (attachedFiles != null &&
                                              attachedFiles.isNotEmpty)
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: attachedFiles
                                                  .map<Widget>((file) {
                                                if (file is String) {
                                                  String fileUrl =
                                                      'https://mhfatha.net/$file';
                                                  if (file.endsWith('.png') ||
                                                      file.endsWith('.jpg') ||
                                                      file.endsWith('.jpeg')) {
                                                    return GestureDetector(
                                                      onTap: () {
                                                        showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return AlertDialog(
                                                              title: Text(
                                                                isEnglish
                                                                    ? 'Image Preview'
                                                                    : 'عرض الصورة',
                                                              ),
                                                              content:
                                                                  Image.network(
                                                                fileUrl,
                                                                fit: BoxFit
                                                                    .contain, // Ensure the image fits inside the dialog
                                                              ),
                                                              actions: <Widget>[
                                                                // Add a button to close the dialog
                                                                TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop(); // Close the dialog
                                                                  },
                                                                  child: Text(
                                                                    isEnglish
                                                                        ? 'Close'
                                                                        : 'إغلاق',
                                                                  ),
                                                                ),
                                                                // Add a button to save the image
                                                                TextButton(
                                                                  onPressed:
                                                                      () async {
                                                                    // Download the image as bytes
                                                                    http.Response
                                                                        response =
                                                                        await http
                                                                            .get(Uri.parse(fileUrl));
                                                                    Uint8List
                                                                        bytes =
                                                                        response
                                                                            .bodyBytes;

                                                                    // Save the image to the gallery
                                                                    final result =
                                                                        await ImageGallerySaver.saveImage(
                                                                            bytes);
                                                                    if (result[
                                                                        'isSuccess']) {
                                                                      print(
                                                                          'Image saved successfully');
                                                                    } else {
                                                                      print(
                                                                          'Failed to save image');
                                                                    }
                                                                  },
                                                                  child: Text(
                                                                    isEnglish
                                                                        ? 'Save'
                                                                        : 'حفظ',
                                                                  ),
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        );
                                                      },
                                                      child: Image.network(
                                                        fileUrl,
                                                        width: 30,
                                                        height: 30,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    );
                                                  } else {
                                                    return Row(
                                                      children: [
                                                        const Icon(Icons.attach_file),
                                                        const SizedBox(width: 5),
                                                        Text(
                                                          'Attachment: $fileUrl',
                                                          style: const TextStyle(
                                                              color:
                                                                  Colors.grey),
                                                        ),
                                                      ],
                                                    );
                                                  }
                                                } else {
                                                  return Container();
                                                }
                                              }).toList(),
                                            ),
                                          const SizedBox(height: 5),
                                          Text(
                                            'Date: ${messageDate ?? 'No date'}',
                                            style:
                                                const TextStyle(color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                      if (messageType == 'support')
                                        const SizedBox(width: 10),
                                      if (messageType ==
                                          'support') // Add profile image for support messages
                                        const CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              'https://mhfatha.net/FrontEnd/assets/images/supporting/customer-service-support.png'), // Use the URL of the network image
                                        ),
                                      const SizedBox(
                                          width:
                                              10), // Add space between profile image and message content
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      Container(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 1, vertical: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          // color: Colors.white,
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: ticketStatus == 'closed'
                                ? (isEnglish
                                    ? '     Your ticket has been closed'
                                    : 'تم إغلاق تذكرتك')
                                : (isEnglish
                                    ? 'Type your message here...'
                                    : 'اكتب رسالتك هنا...'),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            prefixIcon: ticketStatus == 'closed'
                                ? null
                                : IconButton(
                            onPressed: () async {
  // Use FilePicker to pick files
  FilePickerResult? result = await FilePicker.platform.pickFiles();

  if (result != null) {
    // Loop through each selected file
    for (var file in result.files) {
      // Add file path to attachments list if not null
      if (file.path != null) {
        attachments.add(file.path!);
      }
    }

    // Show snackbar with the number of files selected
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${result.files.length} file(s) selected'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.fixed, // Keep the snackbar visible until dismissed
      ),
    );

    // Update UI if needed
    setState(() {});
  } else {
    // User canceled the picker
  }
},


                                    icon: const Icon(Icons.attach_file),
                                  ),
                            suffixIcon: ticketStatus == 'closed'
                                ? null
                                : IconButton(
                                    onPressed: () {
                                      _updateSupportRequest();
                                    },
                                    icon: const Icon(Icons.send),
                                  ),
                          ),
                          // You can use a TextEditingController to get the text input
                          enabled: ticketStatus != 'closed',
                          controller: _messageController,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        // bottomNavigationBar: NewNav(),
      ),
    );
  }
}
