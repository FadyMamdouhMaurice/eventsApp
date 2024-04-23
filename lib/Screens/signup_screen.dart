import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:symstax_events/Screens/home_screen.dart';
import 'package:symstax_events/shared/firebase_functions.dart';
import '../shared/reusable_widgets.dart';

final TextEditingController emailController = TextEditingController();
final TextEditingController passwordController = TextEditingController();

class SignupScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, watch) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Consumer(builder: (context, ref, _) {
        return Padding(
          padding: EdgeInsets.all(screenWidth * 0.05), // Adjust padding based on screen width
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: screenHeight * 0.1), // Add vertical spacing
              SizedBox(
                width: screenWidth * 0.9, // Adjust width based on screen width
                child: TextField(
                  controller: emailController,
                  decoration: InputDecoration(
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
                  decoration: InputDecoration(
                    labelText: 'Password',
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.02), // Add vertical spacing
              SizedBox(
                width: screenWidth * 0.9, // Adjust width based on screen width
                child: MyButtonWidget(
                  text: 'Sign Up',
                  onClicked: () async {
                    bool success = await FirebaseFunctions().signUpWithEmailAndPassword(
                      emailController.text.trim(),
                      passwordController.text.trim(),
                    );
                    if (success) {
                      // Navigate to the next screen if signup is successful
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()), // Replace with the actual next screen
                      );
                    } else {
                      // Show an error message or handle signup failure
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Sign up failed. Please try again.'),
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
