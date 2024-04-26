import 'package:flutter/material.dart';

class MyButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onClicked;

  const MyButtonWidget({super.key,
    required this.text,
    required this.onClicked,
  });

  @override
  Widget build(BuildContext context) => ElevatedButton(
    onPressed: onClicked,
    child: Text(
      text,
    ),
  );
}