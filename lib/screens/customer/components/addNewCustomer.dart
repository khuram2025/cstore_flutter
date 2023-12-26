import 'package:cstore_flutter/API/api_service.dart';
import 'package:cstore_flutter/models/customers.dart';
import 'package:flutter/material.dart';

class AddNewCustomerScreen extends StatefulWidget {
  @override
  _AddNewCustomerScreenState createState() => _AddNewCustomerScreenState();
}

class _AddNewCustomerScreenState extends State<AddNewCustomerScreen> {
  final _formKey = GlobalKey<FormState>();
  final ApiService apiService = ApiService();

  // TextEditingControllers for form input
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Customer'),
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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'Customer Information',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  suffixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the customer\'s name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  suffixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the customer\'s email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone',
                  suffixIcon: Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the customer\'s phone number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: addressController,
                decoration: InputDecoration(
                  labelText: 'Address',
                  suffixIcon: Icon(Icons.location_on),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the customer\'s address';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                child: Text('Add Customer'),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      await apiService.addCustomer(
                        Customer(

                          name: nameController.text,
                          email: emailController.text,
                          mobile: phoneController.text,
                          address: addressController.text,
                          storeId: 11,
                        ),
                      );
                      // Optionally, clear the form or navigate away
                    } catch (e) {
                      print('Error adding customer: $e');
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
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
