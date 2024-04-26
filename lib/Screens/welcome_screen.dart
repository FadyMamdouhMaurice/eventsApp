import 'package:flutter/material.dart';
import 'package:symstax_events/Screens/login_screen.dart';
import 'package:symstax_events/Screens/signup_screen.dart';
import 'package:symstax_events/shared/reusable_widgets.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key,});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: screenWidth * 0.7,
              height: screenHeight * 0.07,
              child: MyButtonWidget(
                text: 'Login',
                onClicked: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                  );
                },
              ),
            ),
            SizedBox(height: screenHeight * 0.02), // Add some spacing between buttons
            SizedBox(
              width: screenWidth * 0.7,
              height: screenHeight * 0.07,
              child: MyButtonWidget(
                text: 'SignUp',
                onClicked: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignupScreen()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}