// lib/screens/QR/qr_screen.dart

import 'package:crypto/crypto.dart';
import 'dart:convert';

import 'package:mhfatha/settings/imports.dart';
class QrScanner extends StatefulWidget {
  @override
  _QrScannerState createState() => _QrScannerState();
}

class _QrScannerState extends State<QrScanner> {
  late QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? scannedData; // Variable to store the scanned data

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ... (unchanged code)

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
              // Change the color of the back button icon
              color: Color.fromARGB(255, 7, 0, 34),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: QRView(
                  key: qrKey,
                  onQRViewCreated: _onQRViewCreated,
                ),
              ),
              SizedBox(height: 16),
           
            ],
          ),
        ),
        // bottomNavigationBar: BottomNavBar(initialIndex: 1),
        bottomNavigationBar: NewNav(),
      ),
    );
  }

void _onQRViewCreated(QRViewController controller) {
  AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);

  this.controller = controller;
  controller.scannedDataStream.listen((scanData) async {
    try {
            String lang = Provider.of<AppState>(context, listen: false).display;

      if (scanData is Barcode) {
        String qrText = scanData.code!;

     
            String lang = Provider.of<AppState>(context, listen: false).display;

        String response = await Api().getStoreDetailsByQR(authProvider, qrText, lang);
Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QrResponse(responseData: response),
          ),
        );
          controller.stopCamera();


        // print('Store QR Response: $response');
      }
    } catch (e) {
      print('Error handling QR data: $e');
    }
  });
}
}
