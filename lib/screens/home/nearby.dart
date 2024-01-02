// lib\screens\QR\get_discount.dart

import 'package:mhfatha/settings/imports.dart';

class NearBy extends StatefulWidget {
  @override
  _NearByState createState() => _NearByState();
}

class _NearByState extends State<NearBy> {
  @override
  Widget build(BuildContext context) {
    List<dynamic> filteredStores =
        ModalRoute.of(context)!.settings.arguments as List<dynamic>;
    final isEnglish = Provider.of<AppState>(context).isEnglish;

    return DirectionalityWrapper(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
            // leading: 
          actions: [
            IconButton(
              icon: Icon(Icons.arrow_forward),
              onPressed: () {
                Navigator.pop(context);
              },
              color: Color.fromARGB(255, 7, 0, 34),
            ),
            
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
              // width: 320,
            // padding: const EdgeInsets.all(1.0),
            margin: EdgeInsets.symmetric(horizontal:20 ,vertical:10 ),
            child: Text(
                isEnglish ? 'Near by Stores' : ' المتاجر القريبة',  
              style: TextStyle(
                color: Color.fromARGB(255, 7, 0, 34),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
                SizedBox(height: 16),
                // Build containers dynamically based on filteredStores
                for (var store in filteredStores) buildStoreContainer(store),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomNav(initialIndex: 1),
      ),
    );
  }

  // Function to build a container for each store
  Widget buildStoreContainer(Map<String, dynamic> store) {
    final isEnglish = Provider.of<AppState>(context).isEnglish;

    return GestureDetector(
      onTap: () async {
        Navigator.pushNamed(context, '/store-info', arguments: store);
      },
      child:   FadeInRight(
                      child: Container(
        width: 100,
        margin: const EdgeInsets.fromLTRB(8, 10, 8, 10),
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 238, 238, 238),
          border: Border.all(
            color: Color.fromARGB(5, 0, 0, 0),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            Container(
              height: 100,
              width: double.infinity,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
                child: ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.transparent,
                        const Color.fromARGB(255, 238, 238, 238)
                            .withOpacity(0.8),
                      ],
                      stops: [0.0, 1.0],
                    ).createShader(bounds);
                  },
                  blendMode: BlendMode.dstIn,
                  child: Image.network(
                    'https://mhfatha.net/FrontEnd/assets/images/store_images/${store['photo']}', // Replace with the actual image path
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
              child: Align(
                alignment:
                    isEnglish ? Alignment.centerLeft : Alignment.centerRight,
                child: Text(
                  '${store['name']}',
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontFamily: AppVariables.serviceFontFamily,
                    fontSize: 14,
                  ),
                  textAlign: isEnglish ? TextAlign.left : TextAlign.right,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
              child: Align(
                alignment:
                    isEnglish ? Alignment.centerLeft : Alignment.centerRight,
                child: Text(
                  '${store['distance']}',
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontFamily: AppVariables.serviceFontFamily,
                    fontSize: 12,
                  ),
                  textAlign: isEnglish ? TextAlign.left : TextAlign.right,
                ),
              ),
            ),
          ],
        ),
      )
      ),
    );
  }
}
