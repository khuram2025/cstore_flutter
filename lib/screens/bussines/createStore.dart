import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'dart:html' as html;

import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../API/api_service.dart';
import '../../models/company.dart';

class CreateStorePage extends StatefulWidget {
  @override
  _CreateStorePageState createState() => _CreateStorePageState();
}

class _CreateStorePageState extends State<CreateStorePage> {

  final _formKey = GlobalKey<FormBuilderState>();
  final List<String> _cities = ['New York', 'Los Angeles', 'Chicago', 'Houston'];
  final List<String> _categories = ['Electronics', 'Fashion', 'Books', 'Others'];
  List<String> _selectedCategories = [];

  void _submitForm() {
    if (_formKey.currentState!.saveAndValidate()) {
      var formValues = _formKey.currentState!.value;

      var companyProfile = CompanyProfile(
        name: formValues['storeName'],
        about: "Sample About",  // Replace with actual about from form if available
        phone: formValues['mobileNumber'],
        address: formValues['address'],
        categories: _selectedCategories,
        cityId: "1",  // Replace with actual city ID from form

      );

      createProfile(companyProfile);
    }
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('authToken');
    print('Retrieved token: $token'); // Debug print
    return token;
  }

  void createProfile(CompanyProfile profile) async {
    try {
      String? token = await getToken();
      if (token != null) {
        var response = await ApiService().createCompanyProfile(profile, token);
        print('Company Profile Created: $response');
      } else {
        print('Authentication token not found');
      }
    } catch (e) {
      print('Error creating company profile: $e');
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Store'),
        backgroundColor: Colors.deepPurple,
      ),
      body: FormBuilder(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            children: <Widget>[
              FormBuilderTextField(
                name: 'storeName',
                decoration: InputDecoration(labelText: 'Store Name'),
              ),
              FormBuilderTextField(
                name: 'mobileNumber',
                decoration: InputDecoration(labelText: 'Mobile Number'),
                keyboardType: TextInputType.phone,
              ),
              _buildCityDropdown(),
              FormBuilderTextField(
                name: 'address',
                decoration: InputDecoration(labelText: 'Address'),
              ),
              _buildCategoryMultiSelect(),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Create Store'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.deepPurple,
                  onPrimary: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCityDropdown() {
    return TypeAheadFormField<String>(
      textFieldConfiguration: TextFieldConfiguration(
        controller: TextEditingController(),
        decoration: InputDecoration(labelText: 'Select City'),
      ),
      suggestionsCallback: (pattern) {
        return _cities.where((city) => city.toLowerCase().contains(pattern.toLowerCase()));
      },
      itemBuilder: (context, String suggestion) {
        return ListTile(title: Text(suggestion));
      },
      onSuggestionSelected: (String suggestion) {
        // Set state or handle the selection here
      },
    );
  }


  Widget _buildCategoryMultiSelect() {
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


}
