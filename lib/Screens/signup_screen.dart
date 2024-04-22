import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:symstax_events/Provider/riverpod.dart';
import 'package:symstax_events/Screens/home_screen.dart';
import 'package:symstax_events/shared/firebase_functions.dart';
import '../shared/reusable_widgets.dart';

final themeProvider =
    StateNotifierProvider<ThemeNotifier, bool>((ref) => ThemeNotifier());

final TextEditingController emailController = TextEditingController();
final TextEditingController passwordController = TextEditingController();

class SignupScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, watch) {
    final myTheme = watch.read(themeProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
        actions: [
          IconButton(
            icon: Icon(myTheme ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              watch.read(themeProvider.notifier).toggleTheme();
            },
          )
        ],
      ),
      body: Consumer(builder: (context, ref, _) {
        return Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                ),
              ),
              SizedBox(height: 16.0),
              MyButtonWidget(
                text: 'Sign Up',
                onClicked: () async {
                  bool success = await FirebaseFunctions().signUpWithEmailAndPassword(
                      emailController.text.trim(),
                      passwordController.text.trim());if (success) {
                    // Navigate to the next screen if login is successful
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()), // Replace with the actual next screen
                    );
                  } else {
                    // Show an error message or handle login failure
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Login failed. Please check your credentials.'),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        );
      }),
    );
  }
}