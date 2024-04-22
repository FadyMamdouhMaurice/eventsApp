import 'package:flutter/material.dart';

class MyButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onClicked;

  const MyButtonWidget({
    required this.text,
    required this.onClicked,
  });

  @override
  Widget build(BuildContext context) => ElevatedButton(
    child: Text(
      text,
      style: TextStyle(fontSize: 24),
    ),
    onPressed: onClicked,
  );
}