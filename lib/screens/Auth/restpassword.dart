// lib\screens\settings\settings.dart


import 'package:mhfatha/settings/imports.dart';

class RestPassword extends StatefulWidget {
  const RestPassword({super.key});

  @override
  State<RestPassword> createState() => _RestPasswordState();
}

class _RestPasswordState extends State<RestPassword> {
  Color backgroundColor = const Color.fromARGB(220, 255, 255, 255);
  Color ui = const Color.fromARGB(220, 233, 233, 233);
  Color ui2 = const Color.fromARGB(255, 113, 194, 110);
  Color colors = const Color(0xFF05204a);
  String Userid = '';
  String OTPMsg = '';
  String passMsg = '';
  int currentStep = 1;
  TextEditingController emailOrMobileController = TextEditingController();
  TextEditingController NewPasswordController = TextEditingController();
  TextEditingController ConfirmNewPasswordController = TextEditingController();
  OtpFieldController otpController = OtpFieldController();
  String enteredOtp = '';

  Api api = Api();
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    bool isEnglish = Provider.of<AppState>(context).isEnglish;
    //

    return DirectionalityWrapper(
      child: Scaffold(
        backgroundColor: const Color(0xFFF3F4F7),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
            color: const Color(0xFF080E27),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                          icon: const Icon(Icons.arrow_forward),
                          onPressed: () {
                            Navigator.pop(
                                context); // Navigate back to the previous screen
                          },
                          color: Colors.white)
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  decoration: const BoxDecoration(
                    color: Color(0xFFF3F4F7),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 130),
                      // Steps content here

                      buildStepContent(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        // bottomNavigationBar: BottomNavBar(initialIndex: 2),
      ),
    );
  }

  Widget buildStepContent() {
    switch (currentStep) {
      case 1:
        return buildStep1();
      case 2:
        return buildStep2();
      case 3:
        return buildStep3();
      default:
        return buildStep1();
    }
  }

  Widget buildStep1() {
    bool isEnglish = Provider.of<AppState>(context).isEnglish;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Step 1 content here
        buildSettingItem(
          context,
          'Enter the registered mobile number or email',
          'ادخل رقم الجوال المسجل او البريد الالكتروني',
          () {
            // Implement report logic
          },
          emailOrMobileController,
          ' ',
        ),
        const SizedBox(
          height: 24,
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: () async {
            String emailOrMobile = emailOrMobileController.text;

            // Call the restPassword method with the mobile number
            Map<String, dynamic> message = await api.restPassword(
              context,
              emailOrMobile,
            );
            // print(message);
            // Handle the response message here
            if (message['success'] == true && message['step'] == 2) {
              setState(() {
                currentStep = 2; // Move to the second step
                OTPMsg = message['message'];
                Userid = emailOrMobile;
              });
            }
          },
          style: ElevatedButton.styleFrom(
            primary: ui,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          child: Text(
            isEnglish ? 'Continue' : 'متابعة',
            style: TextStyle(color: colors, fontSize: 20),
          ),
        ),
      ],
    );
  }

  Widget buildStep2() {
    bool isEnglish = Provider.of<AppState>(context).isEnglish;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Step 2 content here
        Text(OTPMsg,
            style: const TextStyle(fontSize: 15), textAlign: TextAlign.center),
        const SizedBox(
          height: 10,
        ),
        Directionality(
          textDirection: TextDirection.ltr,
          child: OTPTextField(
            controller: otpController,
            length: 5,
            width: MediaQuery.of(context).size.width,
            fieldWidth: 30,
            style: const TextStyle(fontSize: 17),
            textFieldAlignment: MainAxisAlignment.center,
            fieldStyle: FieldStyle.underline,
            onCompleted: (pin) {
              enteredOtp = pin;
              print("Completed: $pin");
            },
          ),
        ),

        const SizedBox(
          height: 24,
        ),

        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () async {
                String emailOrMobile = Userid;
                String otp = enteredOtp; // Get the entered OTP

                // Call the restPassword method with the mobile number and entered OTP
                Map<String, dynamic> message = await api.restPassword(
                  context,
                  emailOrMobile,
                  otp,
                );
                // print(message);
                // Handle the response message here
                if (message['step'] == 3) {
                  setState(() {
                    currentStep = 3; // Move to the third step
                    passMsg = message['message'];
                  });
                } else if (message['error'] != null) {
                  setState(() {
                    // Handle the error message here
                  });
                   
                  QuickAlert.show(
                    context: context,
                    title: '',
                    type: QuickAlertType.error,
                    text: message['error'],
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                primary: ui,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: Text(
                isEnglish ? 'Continue' : 'متابعة',
                style: TextStyle(color: colors, fontSize: 20),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                setState(() {
                  currentStep = 1; // Move to the second step
                });
              },
              style: ElevatedButton.styleFrom(
                primary: ui,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: Text(
                isEnglish ? 'edit' : 'تعديل',
                style: TextStyle(color: colors, fontSize: 20),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildStep3() {
    bool isEnglish = Provider.of<AppState>(context).isEnglish;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(passMsg,
            style: const TextStyle(fontSize: 15), textAlign: TextAlign.center),
        const SizedBox(
          height: 10,
        ),
        buildSettingItem(
            context, 'Enter new password', 'ادخل كلمة السر الجديده', () {
          // Implement report logic
        }, NewPasswordController, ' '),
        buildSettingItem(
            context, 'Enter confirm password', 'ادخل تأكيد كلمة السر', () {
          // Implement report logic
        }, ConfirmNewPasswordController, ' '),
        const SizedBox(
          height: 24,
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: () async {
            String emailOrMobile = Userid;
            String otp = enteredOtp; // Get the entered OTP
            String newPassword = NewPasswordController.text;
            String newPasswordConfirmation =
                ConfirmNewPasswordController.text;

            // Call the restPassword method with the mobile number and entered OTP
            Map<String, dynamic> message = await api.restPassword(context,
                emailOrMobile, otp, newPassword, newPasswordConfirmation);
            print(message);
            // Handle the response message here
            if (message['step'] == 3) {
              String war = message['message'];
              QuickAlert.show(
                context: context,
                title: '',
                type: QuickAlertType.error,
                text: war,
              );
            }

            // Navigator.pushNamed(context, '/restpassword');

            if (message['Success'] == true && message['reseted'] == true) {
              String war = message['message'];
              QuickAlert.show(
                context: context,
                type: QuickAlertType.success,
                customAsset: 'images/success.gif',
                text: war,
                onConfirmBtnTap: () {
                  Navigator.pushNamed(context, '/login');
                },
                confirmBtnColor: const Color(0xFF0D2750),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            primary: ui,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          child: Text(
            isEnglish ? 'Continue' : 'تحديث كلمة السر',
            style: TextStyle(color: colors, fontSize: 20),
          ),
        ),
      ],
    );
  }

  Widget buildSettingItem(
    BuildContext context,
    // IconData icon,
    String englishTitle,
    String arabicTitle,
    VoidCallback onTap,
    TextEditingController controller,
    String? preFilledText,
  ) {
    bool isEnglish = Provider.of<AppState>(context).isEnglish;

    // Determine the text to be displayed in the text field
    String initialText = preFilledText ??
        ''; // Use preFilledText if not null, otherwise use an empty string

    // Trim leading and trailing whitespace from the initial text
    initialText = initialText.trim();

    controller.text = initialText;

    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
        padding: const EdgeInsets.fromLTRB(20, 30, 20, 30),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Column(
          children: [
            Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    // Icon(icon),
    const SizedBox(width: 10),
    Flexible(
      child: Text(
        isEnglish ? englishTitle : arabicTitle,
        softWrap: true,
      ),
    ),
  ],
),

            const SizedBox(height: 10),
            // Add TextField here
            TextField(
              obscureText: false,
              controller: controller,
              style: TextStyle(fontSize: 16, color: colors),
              onChanged: (value) {
                // Update the text only when modified by the user, not programmatically
                if (value != controller.text.trim()) {
                  // Trim leading and trailing whitespace from the entered text
                  controller.text = value.trim();
                  controller.selection = TextSelection.fromPosition(
                    TextPosition(offset: controller.text.length),
                  ); // Move the cursor to the end of the text
                }
              },
              decoration: InputDecoration(
                hintStyle: TextStyle(color: Colors.grey.shade700),
                filled: true,
                fillColor: ui,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: backgroundColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: backgroundColor),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
