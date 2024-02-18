// lib/screens/QR/qr_screen.dart

import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:math';

import 'package:mhfatha/settings/imports.dart';

class QrScanner extends StatefulWidget {
  @override
  _QrScannerState createState() => _QrScannerState();
}

class _QrScannerState extends State<QrScanner> with SingleTickerProviderStateMixin {
  late QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? scannedData; // Variable to store the scanned data

  late AnimationController _animationController;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2), // Adjust the duration as needed
    );
    _colorAnimation = ColorTween(
      begin: Colors.red,
      end: getRandomColor(),
    ).animate(_animationController);
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Color getRandomColor() {
    Random random = Random();
    return Color.fromRGBO(
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
      1,
    );
  }
  void didChangeDependencies() {
    super.didChangeDependencies();
    
  }
  @override
  Widget build(BuildContext context) {

    return DirectionalityWrapper(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomAppBar(
                onBackTap: () {
                  Navigator.pushReplacementNamed(context, '/home');
                },
                iconColor: Colors.black,
                marginTop: 30,
              ),
              Expanded(
                child: QRView(
                  key: qrKey,
                  onQRViewCreated: _onQRViewCreated,
                  overlay: QrScannerOverlayShape(
                    borderColor: _colorAnimation.value ?? Colors.redAccent, // Use the value property
                    borderRadius: 10,
                    borderLength: 30,
                    borderWidth: 10,
                    cutOutSize: 300.0, // Adjust the dimensions as needed
                  ),
                ),
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
        bottomNavigationBar: NewNav(),
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
  bool isEnglish = Provider.of<AppState>(context, listen: false).isEnglish;
    AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);

    this.controller = controller;
    bool scanHandled = false; // Flag to track if scan has been handled
    controller.scannedDataStream.listen((scanData) async {
      try {
        String lang = Provider.of<AppState>(context, listen: false).display;

        if (!scanHandled && scanData is Barcode) {
          scanHandled = true; // Set the flag to true to prevent further handling

          String qrText = scanData.code!;
          print('qr is $qrText');
          String response = await Api().getStoreDetailsByQR(authProvider, qrText, lang);

          if (response.contains('error')) {
            Map<String, dynamic> responseData = jsonDecode(response);
            String errorMessage = responseData['error'];
            // Show a dialog for 404 Not Found
            controller.stopCamera();




        QuickAlert.show(
              context: context,
              type: QuickAlertType.error,
              title: isEnglish ? 'Error' : 'خطأ',
              text: errorMessage,
              onConfirmBtnTap: () {
                Navigator.pop(context);
                controller.resumeCamera(); // Resume the camera
              });
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => QrResponse(responseData: response),
              ),
            );
            controller.stopCamera();
          }

          // Reset the flag after a delay to allow the next scan
          await Future.delayed(Duration(seconds: 1));
          scanHandled = false;
        }
      } catch (e) {
        print('Error handling QR data: $e');
      }
    });
  }
}
