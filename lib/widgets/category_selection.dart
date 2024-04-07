import 'package:intl/intl.dart';
import 'package:mhfatha/settings/imports.dart';
import 'package:flutter/cupertino.dart';

// Category_selection.dart

import 'package:flutter/material.dart';

class CategorySelection extends StatefulWidget {
  final ValueChanged<String> onCategorySelected;
  final Color labelcolor;
  final Color color;
  String selectedCategory; // Make it mutable

  CategorySelection({
    Key? key,
    required this.onCategorySelected,
    required this.color,
    required this.labelcolor,
    required this.selectedCategory,
  }) : super(key: key);

  // Add a method to update selectedCategory
  void updateSelectedCategory(String newValue) {
  selectedCategory= newValue;
}
  @override
  State<CategorySelection> createState() => _CategorySelectionState();
}


class _CategorySelectionState extends State<CategorySelection> {
  List<DropdownMenuItem<String>> citiesDropdownItems = [];

  // late String selectedCategory; // Make it mutable


  // Method to update selectedCategoryexternally
void updateSelectedCategory(String newCategory) {
  setState(() {
    widget.onCategorySelected(newCategory);
  });
}
void fetchCategorysAndCities() async {
  try {
    bool isEnglish = Provider.of<AppState>(context, listen: false).isEnglish;

    Map<String, dynamic>? result;

    // Retry fetching until a non-null result is obtained
    while (result == null) {
      result = await Api().getcategories(context);
      if (result == null) {
        print('Retrying fetching categories and cities...');
        await Future.delayed(Duration(seconds: 1)); // Add a delay before retrying
      }
    }

    // Process the result once a non-null value is obtained
    List<dynamic> Categorys = result['Category'];

    // Clear existing items
    citiesDropdownItems.clear();

    // Process each Category and add a DropdownMenuItem for each
    Categorys.forEach((Category) {
      int CategoryId = Category['id'];
      String CategoryAr = Category['category_name_ar'];
      String CategoryEn = Category['category_name_en'];

      // Add a DropdownMenuItem for the current Category
      citiesDropdownItems.add(
        DropdownMenuItem(
          value: CategoryId.toString(),
          child: Text(isEnglish ? CategoryEn : CategoryAr),
        ),
      );
    });

    // Trigger a rebuild of the widget with the updated data
    setState(() {});
  } catch (e) {
    // Handle errors
    // print('Error fetching categories and cities: $e');

    // Retry fetching after an error occurs
    await Future.delayed(Duration(seconds: 1)); // Add a delay before retrying
    fetchCategorysAndCities(); // Retry fetching
  }
}

  @override
  void initState() {
    super.initState();
    fetchCategorysAndCities();
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
            isEnglish ? 'Category' : 'الفئة',
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
            value: widget.selectedCategory,
          onChanged: (String? value) {
  setState(() {
    widget.updateSelectedCategory(value ?? ""); // Use an empty string as a default
          widget.onCategorySelected(widget.selectedCategory);

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
