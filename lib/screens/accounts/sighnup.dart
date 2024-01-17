import 'package:cstore_flutter/screens/accounts/login.dart';
import 'package:flutter/material.dart';
import 'package:cstore_flutter/API/api_service.dart'; // Assuming you have a similar service for signup

class SignupScreen extends StatefulWidget {
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  final ApiService apiService = ApiService(); // Assuming you have this service

  void _handleSignup() async {
    String fullName = nameController.text;
    String email = emailController.text;
    String mobile = mobileController.text;
    String password = passwordController.text;
    String confirmPassword = confirmPasswordController.text;

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    try {
      final response = await apiService.signup(fullName, email, mobile, password);
      if (response['status'] == 'success') {
        _showCongratulationsDialog(context);
        // Optionally, navigate to the login page or another screen after closing the dialog
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Signup failed: ${response['message']}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error during signup: $e')),
      );
    }
  }


  void _showCongratulationsDialog(BuildContext context) {
    const TextStyle messageStyle = TextStyle(

      color: Color(0xFF09AA29), // grey
      fontSize: 16,
    );

    const TextStyle buttonStyle = TextStyle(
      color: Color(0xFFFC8019), // amberSea
      fontWeight: FontWeight.bold,
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFF9F9F9E), // green background
          title: Text(
            "Congratulations! 🎉 Welcome to Channab! 🎉",
            style: TextStyle(color: Colors.white), // white text for the title
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[

                SizedBox(height: 10),
                Text(
                  "Your journey to global reach begins! Dive into a dynamic marketplace and connect with the world.",
                  style: messageStyle,
                ),
                SizedBox(height: 5),
                Text(
                  "Let's grow together!",
                  style: messageStyle,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Login', style: buttonStyle),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.of(context).pushReplacement( // Navigate to the login screen
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF09AA29);
    const Color fadedTextColor = Color(0xFF9f9f9e);

    bool isDesktop = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: AppBar(title: Text('Sign Up')),
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
                      "Join Our Community",
                      style: TextStyle(fontSize: 24, color: primaryColor, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(
                  width: sectionWidth,
                  child: Center(
                    child: _buildSignupForm(context, primaryColor, fadedTextColor),
                  ),
                ),
              ],
            );
          })
              : _buildSignupForm(context, primaryColor, fadedTextColor),
        ),
      ),
    );
  }

  Widget _buildSignupForm(BuildContext context, Color primaryColor, Color fadedTextColor) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 350),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Full Name Field
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Full Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: primaryColor),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                labelStyle: TextStyle(color: primaryColor),
              ),
            ),
            SizedBox(height: 16.0),

            // Mobile Number Field
            TextFormField(
              controller: mobileController,
              decoration: InputDecoration(
                labelText: 'Mobile Number',
                hintText: '+923478181583',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: primaryColor),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                labelStyle: TextStyle(color: primaryColor),
              ),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 16.0),

            // Email Field (Optional)
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email (Optional)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: primaryColor),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                labelStyle: TextStyle(color: primaryColor),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 16.0),

            // Password Field
            TextFormField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: primaryColor),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                labelStyle: TextStyle(color: primaryColor),
                suffixIcon: IconButton(
                  icon: Icon(Icons.visibility),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
              obscureText: _obscurePassword,
            ),
            SizedBox(height: 16.0),

            // Confirm Password Field
            TextFormField(
              controller: confirmPasswordController,
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: primaryColor),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                labelStyle: TextStyle(color: primaryColor),
                suffixIcon: IconButton(
                  icon: Icon(Icons.visibility),
                  onPressed: () {
                    setState(() {
                      _obscureConfirmPassword = !_obscureConfirmPassword;
                    });
                  },
                ),
              ),
              obscureText: _obscureConfirmPassword,
            ),
            SizedBox(height: 24.0),

            // Signup Button
            ElevatedButton(
              child: Text('Sign Up', style: TextStyle(fontSize: 16)),
              style: ElevatedButton.styleFrom(
                primary: primaryColor,
                onPrimary: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 15.0),
              ),
              onPressed: _handleSignup, // Attach the signup handler here
            ),

            SizedBox(height: 50),

            // Link to Login
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
                          MaterialPageRoute(builder: (context) => LoginScreen()),
                        );
                      },
                      child: Text(
                        'Login',
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
