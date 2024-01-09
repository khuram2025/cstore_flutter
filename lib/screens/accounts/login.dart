import 'package:flutter/material.dart';
import 'package:cstore_flutter/API/api_service.dart';
import 'package:cstore_flutter/screens/inventory/product_list.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final ApiService apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    // Define colors
    const Color primaryColor = Color(0xFF09AA29);
    const Color fadedTextColor = Color(0xFF9f9f9e);

    bool isDesktop = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: isDesktop
              ? LayoutBuilder(builder: (context, constraints) {
            double sectionWidth = constraints.maxWidth / 2;
                  return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                  SizedBox(
                    width: sectionWidth,
                    child: Image.asset(
                      'path/to/your/image.jpg', // Replace with your image path
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(
                    width: sectionWidth,

                    child: _buildLoginForm(context, primaryColor, fadedTextColor),
                  ),
                              ],
                            );
                }
              )
              : _buildLoginForm(context, primaryColor, fadedTextColor),
        ),
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context, Color primaryColor, Color fadedTextColor) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 450),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
      
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
            SizedBox(height: 32.0), // Added space
        Text(
        'Welcome to Cahnnab',
        style: TextStyle(fontSize: 24, color: primaryColor, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
        ),
        SizedBox(height: 32.0), // Increased space
        TextFormField(
        controller: mobileController,
        decoration: InputDecoration(
        labelText: 'Mobile',
        border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: primaryColor),
          ),
          labelStyle: TextStyle(color: primaryColor),
        ),
          keyboardType: TextInputType.phone,
        ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: primaryColor),
                  ),
                  labelStyle: TextStyle(color: primaryColor),
                ),
                obscureText: true,
              ),
              SizedBox(height: 24.0),
              ElevatedButton(
      
                child: Text('Login', style: TextStyle(fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  primary: primaryColor,
                  onPrimary: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 15.0), // Increased button height
                ),
                onPressed: () async {
                  try {
                    var response = await apiService.login(
                      mobileController.text,
                      passwordController.text,
                    );
                    if (response['status'] == 'success') {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => ProductListScreen(companyName: "Your Company Name")),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(response['message'])),
                      );
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(e.toString())),
                    );
                  }
                },
              ),
              SizedBox(height: 50),
      
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: 'Don\'t have an account? ',
                  style: TextStyle(color: fadedTextColor),
                  children: [
                    TextSpan(
                      text: 'Sign up',
                      style: TextStyle(color: primaryColor),
                    ),
                  ],
                ),
              ),
            ],
        ),
      ),
    );
  }
}

