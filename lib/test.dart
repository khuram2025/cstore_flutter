class SignupScreen extends StatefulWidget {
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // ... controllers and variables ...

  final ApiService apiService = ApiService(); // Assuming you have this service

  void _handleSignup() async {
    String fullName = nameController.text;
    String email = emailController.text;
    String mobile = mobileController.text;
    String password = passwordController.text;
    String confirmPassword = confirmPasswordController.text;

    if (password != confirmPassword) {
      // Show some error message to the user
      print('Passwords do not match');
      return;
    }

    try {
      final response = await apiService.signup(fullName, email, mobile, password);
      if (response['status'] == 'success') {
        // Navigate to the next screen or show success message
        print('Signup successful');
      } else {
        // Handle different types of errors (like user already exists, etc.)
        print('Signup failed: ${response['message']}');
      }
    } catch (e) {
      // Handle network errors, etc.
      print('Error during signup: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // ... existing widget build method ...

    // Replace the onPressed for the ElevatedButton
    ElevatedButton(
      child: Text('Sign Up', style: TextStyle(fontSize: 16)),
      style: ElevatedButton.styleFrom(
        primary: primaryColor,
        onPrimary: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 15.0),
      ),
      onPressed: _handleSignup, // Attach the signup handler here
    ),

    // ... rest of your widget build method ...
  }
}
