import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:symstax_events/Screens/home_screen.dart';
import 'package:symstax_events/shared/firebase_functions.dart';
import '../shared/reusable_widgets.dart';

final TextEditingController emailController = TextEditingController();
final TextEditingController passwordController = TextEditingController();

class SignupScreen extends ConsumerWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context, watch) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: Consumer(builder: (context, ref, _) {
        return Padding(
          padding: EdgeInsets.all(screenWidth * 0.05), // Adjust padding based on screen width
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: screenHeight * 0.1), // Add vertical spacing
              SizedBox(
                width: screenWidth * 0.9,
                child: TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.02), // Add vertical spacing
              SizedBox(
                width: screenWidth * 0.9,
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
                width: screenWidth * 0.9,
                height: screenHeight * 0.05,
                child: MyButtonWidget(
                  text: 'Sign Up',
                  onClicked: () async {
                    bool success = await FirebaseFunctions().signUpWithEmailAndPassword(
                      emailController.text.trim(),
                      passwordController.text.trim(),
                    );
                    if (success) {
                      emailController.clear();
                      passwordController.clear();
                      // Navigate to the next screen if signup is successful
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const HomeScreen()), // Replace with the actual next screen
                      );
                    } else {
                      // Show an error message or handle signup failure
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
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