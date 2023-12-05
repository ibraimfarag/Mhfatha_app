import 'package:mhfatha/settings/imports.dart';

class StoresCarousel extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Map<String, dynamic>> stores;

 StoresCarousel({
    required this.title,
    required this.icon,
    required this.stores,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Row with title and icon
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 60,
                color: AppVariables.themeColor,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    title,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                      fontFamily: AppVariables.serviceFontFamily,
                      color: AppVariables.themeColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Auto Carousel
        Container(
          // height: 200,
          margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: CarouselSlider(
            items: [







              
              // Your containers go here
              Container(
                width: 500,
                // height: 100,
                margin: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 3, 12, 19),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    // Image with gradient
                    Container(
                      height: 100,
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
                                Colors.black.withOpacity(0.8)
                              ],
                              stops: [0.0, 1.0],
                            ).createShader(bounds);
                          },
                          blendMode: BlendMode.dstIn,
                          child: Image.asset(
                            'assets/banner1.png',
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                    // Text widget for store name
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'اسم المتجر',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontFamily: AppVariables.serviceFontFamily,
                            fontSize: 18,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ),
                    // Row for buttons with icons
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.local_offer,
                                color: Colors.white,
                                size: 18,
                              ),
                              const SizedBox(width: 1),
                              TextButton(
                                onPressed: () {
                                  // Handle onPressed for "الخصومات" button
                                },
                                child: Text(
                                  'الخصومات',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontFamily: AppVariables.serviceFontFamily,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.location_on,
                                  color: Colors.white, size: 18),
                              const SizedBox(width: 1),
                              TextButton(
                                onPressed: () {
                                  // Handle onPressed for "يبعد 5 كم" button
                                },
                                child: Text(
                                  'يبعد 5 كم',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontFamily: AppVariables.serviceFontFamily,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
              // Add more containers as needed
        
        
        
        
        
        
        
        
        
            ],
            options: CarouselOptions(
              autoPlay: true,
              aspectRatio: 16 / 9,
              enlargeCenterPage: false,
              enableInfiniteScroll: true,
              autoPlayCurve: Curves.fastOutSlowIn,
              autoPlayAnimationDuration: Duration(milliseconds: 4000),
              viewportFraction: 0.6,
            ),
          ),
        ),
        //  if (stores.isNotEmpty)
        //   Column(
        //     children: stores.map((store) {
        //       return Text(
        //         'Store ID: ${store['id']}, Name: ${store['name']}, Distance: ${store['distance']}',
        //       );
        //     }).toList(),
        //   ),
      ],
    );
  }
}
