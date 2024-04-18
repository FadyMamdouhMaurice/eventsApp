import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:symstax_events/Models/user_model.dart';
import 'package:symstax_events/Provider/riverpod.dart';
import 'package:symstax_events/shared/auth_view_model.dart';

final authViewModelProvider = Provider<AuthViewModel>((ref) => AuthViewModel());

class SignupScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
        actions: [
          Consumer(builder: (context, watch, _) {
            final container = ProviderScope.containerOf(context, listen: false);
            final isDarkModeEnabled = watch.read(themeProvider);
            return IconButton(
              icon: Icon(isDarkModeEnabled ? Icons.light_mode : Icons.dark_mode),
              onPressed: () {
                container.read(themeProvider.notifier).toggleTheme();
              },
            );
          }),
        ],
      ),
      body: Consumer(builder: (context, ref, _) {
        final authViewModel = ref.read(authViewModelProvider);
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
              ElevatedButton(
                onPressed: () async {
                  String email = emailController.text.trim();
                  String password = passwordController.text.trim();

                  if (email.isNotEmpty && password.isNotEmpty) {
                    UserModel? user =
                    await authViewModel.signUp(email, password);
                    if (user != null) {
                      // Navigate to home screen or do something else
                    } else {
                      // Show error message
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Sign up failed'),
                      ));
                    }
                  } else {
                    // Show error message
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Please fill in all fields'),
                    ));
                  }
                },
                child: Text('Sign Up'),
              ),
            ],
          ),
        );
      }),
    );
  }
}
