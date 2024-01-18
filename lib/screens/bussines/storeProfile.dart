import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';

class StoreProfilePage extends StatefulWidget {
  @override
  _StoreProfilePageState createState() => _StoreProfilePageState();
}

class _StoreProfilePageState extends State<StoreProfilePage> {
  final ImagePicker _picker = ImagePicker();
  XFile? _storeCoverImage;
  XFile? _storeProfileImage;
  bool _isAdvancedSettingsExpanded = false;
  final List<String> _categories = ['Electronics', 'Fashion', 'Books', 'Others'];
  List<String> _selectedCategories = [];
  String? _selectedCity;
  final List<String> _cities = ['New York', 'Los Angeles', 'Chicago', 'Houston'];

  Future<void> _pickImage(ImageSource source, bool isCoverImage) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        if (isCoverImage) {
          _storeCoverImage = pickedFile;
        } else {
          _storeProfileImage = pickedFile;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Store Profile'),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            _buildImageSection(),
            _buildBasicInfoSection(),
            _buildAdvancedSettingsSection(),
            SizedBox(height: 20),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return Column(
      children: [
        _buildImagePicker(
          image: _storeCoverImage,
          onTap: () => _pickImage(ImageSource.gallery, true),
          title: 'Store Cover Image',
          icon: Icons.image_aspect_ratio,
        ),
        SizedBox(height: 20),
        _buildImagePicker(
          image: _storeProfileImage,
          onTap: () => _pickImage(ImageSource.gallery, false),
          title: 'Store Profile Image',
          icon: Icons.person,
        ),
        SizedBox(height: 20),
      ],
    );
  }

  Widget _buildBasicInfoSection() {
    return Column(
      children: [
        _buildTextField(hint: 'Store Name'),
        _buildTextField(hint: 'Description', maxLines: 3),
        _buildTextField(hint: 'Mobile Number'),
        _buildTextField(hint: 'Address'),
        _buildMultiSelectCategories(),
        _buildTypeAheadCityField(),
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

  Widget _buildAdvancedSettingsSection() {
    return ExpansionTile(
      title: Text('Advanced Settings'),
      initiallyExpanded: _isAdvancedSettingsExpanded,
      children: [
        _buildTextField(hint: 'Facebook URL'),
        _buildTextField(hint: 'Twitter Handle'),
        _buildTextField(hint: 'Youtube Channel'),
        _buildTextField(hint: 'Instagram Handle'),
        _buildTextField(hint: 'Web URL'),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          // Handle form submission
        },
        child: Text('Create Profile'),
        style: ElevatedButton.styleFrom(
          primary: Colors.deepPurple,
          onPrimary: Colors.white,
        ),
      ),
    );
  }

  Widget _buildImagePicker({
    required XFile? image,
    required VoidCallback onTap,
    required String title,
    required IconData icon,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 200,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: image != null
            ? Image.file(File(image.path), fit: BoxFit.cover)
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Colors.grey),
            Text(title, style: TextStyle(fontSize: 18, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String hint,
    int maxLines = 1,
    IconData? icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: hint,
          labelText: hint,
          prefixIcon: icon != null ? Icon(icon) : null,
        ),
        maxLines: maxLines,
      ),
    );
  }

}
