import 'package:flutter/material.dart';
import 'package:symstax_events/Screens/login_screen.dart';
import 'package:symstax_events/Screens/signup_screen.dart';
import 'package:symstax_events/shared/reusable_widgets.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MyButtonWidget(text: 'Login', onClicked: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            }),
            MyButtonWidget(text: 'SignUp', onClicked: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SignupScreen()),
              );
            }),
          ],
        ),
      ),
    );
  }
}
