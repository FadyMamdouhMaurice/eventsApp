import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:symstax_events/Screens/home_screen.dart';
import 'package:symstax_events/shared/firebase_functions.dart';
import 'package:symstax_events/shared/reusable_widgets.dart';

final TextEditingController emailController = TextEditingController();
final TextEditingController passwordController = TextEditingController();
FirebaseFunctions firebaseFunctions = FirebaseFunctions();
class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.05), // Adjust padding based on screen width
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: screenHeight * 0.1), // Add vertical spacing
            SizedBox(
              width: screenWidth * 0.9, // Adjust width based on screen width
              child: TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.02), // Add vertical spacing
            SizedBox(
              width: screenWidth * 0.9, // Adjust width based on screen width
              child: TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.02), // Add vertical spacing
            SizedBox(
              width: screenWidth * 0.9, // Adjust width based on screen width
              child: SizedBox(
                width: screenWidth * 0.9,
                height: screenHeight * 0.05,
                child: MyButtonWidget(
                  text: 'Log In',
                  onClicked: () async {
                    bool success = await FirebaseFunctions().loginWithEmailAndPassword(
                      emailController.text.trim(),
                      passwordController.text.trim(),
                    );
                    if (success) {
                      emailController.clear();
                      passwordController.clear();
                      // Navigate to the next screen if login is successful
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const HomeScreen()), // Replace with the actual next screen
                      );
                    } else {
                      // Show an error message or handle login failure
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Login failed. Please check your credentials.'),
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}