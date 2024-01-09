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

    // Determine if it's a desktop view
    bool isDesktop = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: isDesktop
              ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Image.asset(
                  'path/to/your/image.jpg', // Replace with your image path
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                width: 450, // Max width for login form
                child: _buildLoginForm(context, primaryColor, fadedTextColor),
              ),
            ],
          )
              : _buildLoginForm(context, primaryColor, fadedTextColor),
        ),
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context, Color primaryColor, Color fadedTextColor) {
    // ... (same as before)
  }
}
