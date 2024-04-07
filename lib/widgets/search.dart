import 'package:mhfatha/settings/imports.dart';

class SuggestionTextField extends StatefulWidget {
  @override
  _SuggestionTextFieldState createState() => _SuggestionTextFieldState();
}

class _SuggestionTextFieldState extends State<SuggestionTextField> {
  TextEditingController _textEditingController = TextEditingController();
  List<String> _suggestions = ['Apple', 'Banana', 'Orange', 'Mango', 'Pineapple'];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
          padding: EdgeInsets.all(screenWidth * 0.02), // Adjust padding based on screen width
          margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.05), // Adjust margin based on screen width
          decoration: BoxDecoration(
            color: Color(0xFFF0F0F0),
            borderRadius: BorderRadius.circular(screenWidth * 0.1), // Adjust border radius based on screen width
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: screenWidth * 0.01, // Adjust spread radius based on screen width
                blurRadius: screenWidth * 0.02, // Adjust blur radius based on screen width
                offset: Offset(0, screenWidth * 0.03), // Adjust offset based on screen width
              ),
            ],
          ),
          child: Column( // Wrap the TextField and suggestions list inside a Column
            children: [
              TextField(
                controller: _textEditingController,
                onChanged:_fetchSuggestions,
                decoration: InputDecoration(
                  hintStyle: TextStyle(color: Color(0xFFA9A7B2)),
                  filled: true,
                  prefixIcon: Icon(Icons.search),
                  fillColor: Color(0xFFF0F0F0),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(screenWidth * 0.1), // Adjust border radius based on screen width
                    borderSide: BorderSide(
                      color: Color.fromARGB(0, 0, 0, 0),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(screenWidth * 0.1), // Adjust border radius based on screen width
                    borderSide: BorderSide(
                      color: Color.fromARGB(0, 225, 226, 228),
                    ),
                  ),
                ),
              ),
              SizedBox(height: screenWidth * 0.02), // Adjust SizedBox height based on screen width
              _buildSuggestionsList(), // Call function to build suggestions list
            ],
          ),
        );
    
  }
  void _fetchSuggestions(String query) {
    // Simulate fetching suggestions based on the query
    // For testing purposes, here we'll filter suggestions containing the query
    setState(() {
      _suggestions = ['Apple', 'Banana', 'Orange', 'Mango', 'Pineapple']
          .where((suggestion) => suggestion.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  Widget _buildSuggestionsList() {
    return Container(
      color: Colors.white, // Adjust as needed
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: _suggestions.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_suggestions[index]),
            onTap: () {
              // Implement action when suggestion is tapped
              // For example, you can set the suggestion as the text in the TextField
              _textEditingController.text = _suggestions[index];
            },
          );
        },
      ),
    );
  }

}
