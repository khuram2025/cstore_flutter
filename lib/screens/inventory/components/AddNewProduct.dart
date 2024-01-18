
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

class AddNewProductScreen extends StatefulWidget {
  @override
  _AddNewProductScreenState createState() => _AddNewProductScreenState();
}

class _AddNewProductScreenState extends State<AddNewProductScreen> {

  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();

  String _selectedCategory = '';
  String _selectedCity = '';

  // Dummy data for categories and cities
  final List<String> categories = ['Electronics', 'Clothing', 'Books', 'Home & Garden'];
  final List<String> cities = ['New York', 'Los Angeles', 'Chicago', 'Houston'];


  @override
  void dispose() {
    _categoryController.dispose();
    _cityController.dispose();
    super.dispose();
  }
  final _formKey = GlobalKey<FormState>();
  String? imagePath;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      print("Image picked: ${image.path}");
      setState(() { // Add this line
        imagePath = image.path;
      });
    } else {
      print("No image selected");
    }
  }


  // TextEditingController instances for form fields
  // ...

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Product'),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
              // Handle more menu
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Product Information',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(labelText: 'Product Title'),
                // controller: titleController,
              ),
              SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(labelText: 'Product Description'),
                keyboardType: TextInputType.multiline,
                maxLines: 3,
                // controller: descriptionController,
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'Stock Qty'),
                      keyboardType: TextInputType.number,
                      // controller: stockQtyController,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'Opening Stock'),
                      keyboardType: TextInputType.number,
                      // controller: openingStockController,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'Threshold'),
                      keyboardType: TextInputType.number,
                      // controller: thresholdController,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Category selection
                  Expanded(
                    child: TypeAheadFormField<String>(
                      textFieldConfiguration: TextFieldConfiguration(
                        controller: _categoryController,
                        decoration: InputDecoration(
                          labelText: 'Select Category',
                          suffixIcon: _selectedCategory.isNotEmpty
                              ? IconButton(
                            icon: Icon(Icons.clear),
                            onPressed: () {
                              setState(() {
                                _selectedCategory = '';
                                _categoryController.clear();
                              });
                            },
                          )
                              : null,
                        ),
                      ),
                      suggestionsCallback: (pattern) {
                        return categories.where((item) => item.toLowerCase().contains(pattern.toLowerCase())).toList();
                      },
                      itemBuilder: (context, suggestion) {
                        return ListTile(title: Text(suggestion));
                      },
                      onSuggestionSelected: (suggestion) {
                        setState(() {
                          _selectedCategory = suggestion.toString();
                          _categoryController.text = _selectedCategory;
                        });
                      },
                    ),
                  ),
                  SizedBox(width: 10),
                  // City selection
                  Expanded(
                    child: TypeAheadFormField<String>(
                      textFieldConfiguration: TextFieldConfiguration(
                        controller: _cityController,
                        decoration: InputDecoration(
                          labelText: 'Select City',
                          suffixIcon: _selectedCity.isNotEmpty
                              ? IconButton(
                            icon: Icon(Icons.clear),
                            onPressed: () {
                              setState(() {
                                _selectedCity = '';
                                _cityController.clear();
                              });
                            },
                          )
                              : null,
                        ),
                      ),
                      suggestionsCallback: (pattern) {
                        return cities.where((item) => item.toLowerCase().contains(pattern.toLowerCase())).toList();
                      },
                      itemBuilder: (context, suggestion) {
                        return ListTile(title: Text(suggestion));
                      },
                      onSuggestionSelected: (suggestion) {
                        setState(() {
                          _selectedCity = suggestion.toString();
                          _cityController.text = _selectedCity;
                        });
                      },
                    ),
                  ),

                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'Purchase Price'),
                      keyboardType: TextInputType.number,
                      // controller: purchasePriceController,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'Sale Price'),
                      keyboardType: TextInputType.number,
                      // controller: salePriceController,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: InkWell(
                  onTap: _pickImage,
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.camera_alt, size: 24, color: Colors.grey),
                        SizedBox(width: 8),
                        Text(
                          imagePath == null ? 'Add Picture' : 'Change Picture',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (imagePath != null)
                ImagePreviewWidget(imagePath: imagePath),

              SizedBox(height: 20),
              ElevatedButton(
                child: Text('Add Product'),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    // Submit data logic
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                  onPrimary: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class ImagePreviewWidget extends StatelessWidget {
  final String? imagePath;

  const ImagePreviewWidget({Key? key, required this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        image: DecorationImage(
          image: FileImage(File(imagePath!)),  // Use FileImage here
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

