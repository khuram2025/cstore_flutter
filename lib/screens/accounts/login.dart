import 'package:cstore_flutter/screens/accounts/sighnup.dart';
import 'package:flutter/material.dart';
import 'package:cstore_flutter/API/api_service.dart';
import 'package:cstore_flutter/screens/inventory/product_list.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController mobileController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final ApiService apiService = ApiService();
  bool _obscureText = true;

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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: sectionWidth,
                        child: Center(
                          child: Text(
                            "Innovative Channab: Bridging Businesses Globally",
                            style: TextStyle(fontSize: 24, color: primaryColor, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: sectionWidth,
                        child: Center(
                          child: _buildLoginForm(context, primaryColor, fadedTextColor),
                        ),
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
      constraints: BoxConstraints(maxWidth: 350),
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
                hintText: '+923478181583', // Added helping text
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0), // Rounded corners
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: primaryColor),
                  borderRadius: BorderRadius.circular(10.0), // Rounded corners
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
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0), // Rounded corners
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: primaryColor),
                  borderRadius: BorderRadius.circular(10.0), // Rounded corners
                ),
                labelStyle: TextStyle(color: primaryColor),
                suffixIcon: IconButton(
                  icon: Icon(Icons.visibility), // Show/hide password icon
                  onPressed: () {
                    // Toggle password visibility
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                ),
              ),
              obscureText: _obscureText,
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
                    // Displaying a more informative message
                    String message = response['message'] ?? 'An unexpected error occurred';
                    if (response['status'] == 'error' && message.contains('Incorrect password')) {
                      message = 'Incorrect password. Please try again.';
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(message)),
                    );
                  }
                } catch (e) {
                  // Handling any kind of exception
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to login. Please check your network and try again.')),
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
                  WidgetSpan(
                    child: InkWell(
                      onTap: () {
                        // Navigate to the SignupScreen
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignupScreen()),
                        );
                      },
                      child: Text(
                        'Sign up',
                        style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
                      ),
                    ),
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

