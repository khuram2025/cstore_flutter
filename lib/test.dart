import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'dart:io';

class StoreProfilePage extends StatefulWidget {
  // ... existing code
}

class _StoreProfilePageState extends State<StoreProfilePage> {
  // ... existing variables

  @override
  Widget build(BuildContext context) {
    // ... existing build method
  }

  Widget _buildBasicInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ... other fields
        _buildMultiSelectCategories(),
        _buildTypeAheadCityField(),
        // ... other fields
      ],
    );
  }

  Widget _buildMultiSelectCategories() {
    return MultiSelectDialogField(
      items: _categories.map((category) => MultiSelectItem(category, category)).toList(),
      title: Text("Categories"),
      selectedItemsTextStyle: TextStyle(color: Colors.black),
      selectedColor: Colors.blue,
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.all(Radius.circular(40)),
        border: Border.all(
          color: Colors.blue,
          width: 2,
        ),
      ),
      buttonIcon: Icon(
        Icons.category,
        color: Colors.blue,
      ),
      buttonText: Text(
        "Select Categories",
        style: TextStyle(
          color: Colors.blue[800],
          fontSize: 16,
        ),
      ),
      onConfirm: (results) {
        _selectedCategories = results.cast<String>();
      },
    );
  }

  Widget _buildTypeAheadCityField() {
    return TypeAheadFormField(
      textFieldConfiguration: TextFieldConfiguration(
        decoration: InputDecoration(labelText: 'Select City'),
      ),
      suggestionsCallback: (pattern) {
        return _cities.where((city) => city.toLowerCase().contains(pattern.toLowerCase()));
      },
      itemBuilder: (context, suggestion) {
        return ListTile(
          title: Text(suggestion),
        );
      },
      onSuggestionSelected: (suggestion) {
        setState(() {
          _selectedCity = suggestion;
        });
      },
    );
  }

// ... remaining widgets and methods
}
