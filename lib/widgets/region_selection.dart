import 'package:intl/intl.dart';
import 'package:mhfatha/settings/imports.dart';
import 'package:flutter/cupertino.dart';

// region_selection.dart

import 'package:flutter/material.dart';

class RegionSelection extends StatefulWidget {
  final ValueChanged<String> onRegionSelected;
  final Color labelcolor;
  final Color color;
  String selectedRegion; // Make it mutable

  RegionSelection({
    Key? key,
    required this.onRegionSelected,
    required this.color,
    required this.labelcolor,
    required this.selectedRegion,
  }) : super(key: key);

  // Add a method to update selectedRegion
  void updateSelectedRegion(String newValue) {
  selectedRegion = newValue;
}
  @override
  State<RegionSelection> createState() => _RegionSelectionState();
}


class _RegionSelectionState extends State<RegionSelection> {
  List<DropdownMenuItem<String>> citiesDropdownItems = [];

  // late String selectedRegion; // Make it mutable


  // Method to update selectedRegion externally
void updateSelectedRegion(String newRegion) {
  setState(() {
    widget.onRegionSelected(newRegion);
  });
}
  void fetchRegionsAndCities() async {
    try {
      bool isEnglish =
          Provider.of<AppState>(context, listen: false).isEnglish;

      Map<String, dynamic>? result =
          await Api().getRegionsAndCities(context);

      if (result != null) {
        // Access the 'regions' data from the result
        List<dynamic> regions = result['regions'];

        // Clear existing items
        citiesDropdownItems.clear();

        // Process each region and add a DropdownMenuItem for each
        regions.forEach((region) {
          int regionId = region['id'];
          String regionAr = region['region_ar'];
          String regionEn = region['region_en'];

          // Add a DropdownMenuItem for the current region
          citiesDropdownItems.add(
            DropdownMenuItem(
              value: regionId.toString(),
              child: Text(isEnglish ? regionEn : regionAr),
            ),
          );
        });

        // Trigger a rebuild of the widget with the updated data
        setState(() {});
      } else {
        print('Error fetching regions and cities: Result is null');
      }
    } catch (e) {
      // Handle errors
      print('Error fetching regions and cities: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchRegionsAndCities();
  }

  @override
  Widget build(BuildContext context) {
    bool isEnglish =
        Provider.of<AppState>(context, listen: false).isEnglish;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        Container(
          margin: EdgeInsets.only(left: 45, right: 45),
          alignment:
              isEnglish ? Alignment.centerLeft : Alignment.centerRight,
          child: Text(
            isEnglish ? 'Region' : 'المنطقة',
            style: TextStyle(
              color: widget.labelcolor,
              fontSize: 16,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        SizedBox(height: 14),
Container(
  margin: EdgeInsets.only(left: 45, right: 45),
  padding: EdgeInsets.only(left: 10, right: 10),
  decoration: BoxDecoration(
    color: widget.color,
    borderRadius: BorderRadius.circular(10),
  ),
  child:  DropdownButton<String>(
            value: widget.selectedRegion,
          onChanged: (String? value) {
  setState(() {
    widget.updateSelectedRegion(value ?? ""); // Use an empty string as a default
          widget.onRegionSelected(widget.selectedRegion);

  });
},

            items: citiesDropdownItems,
            style: TextStyle(color: widget.labelcolor),
            underline: Container(),
            dropdownColor: widget.color,
          ),
),
      ],
    );
  }
}
