// lib\screens\QR\get_discount.dart

import 'package:mhfatha/settings/imports.dart';

class NearBy extends StatefulWidget {
  @override
  _NearByState createState() => _NearByState();
}

class _NearByState extends State<NearBy> {


  @override
  Widget build(BuildContext context) {

    return DirectionalityWrapper(
      child: Scaffold(
// /* -------------------------------------------------------------------------- */
// /* --------------------------------- AppBar --------------------------------- */
// /* -------------------------------------------------------------------------- */

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
// /* -------------------------------------------------------------------------- */
// /* ---------------------------------- Body ---------------------------------- */
// /* -------------------------------------------------------------------------- */

        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
             
              SizedBox(height: 16),
             
            ],
          ),
        ),
      ),
        bottomNavigationBar: BottomNav(initialIndex: 1),
    )
    );
  }

}
