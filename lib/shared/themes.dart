import 'package:flutter/material.dart';

class MyThemeData {
  static Color greyTextColor = Colors.grey;
  static Color whiteTextColor = Colors.white;
  static Color darkColor = Colors.grey[900]!;

  static ThemeData lightTheme(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return ThemeData(
      primaryColor: Colors.green,
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: Colors.green,
        selectionHandleColor: Colors.green,
      ),
      scaffoldBackgroundColor: Colors.white,
      textTheme: TextTheme(
        labelLarge: TextStyle(
          color: Colors.black,
          fontSize: screenWidth * 0.06, // 6% of screen width
          fontWeight: FontWeight.w700,
        ),
        labelMedium: TextStyle(
          color: Colors.black,
          fontSize: screenWidth * 0.03, // 3% of screen width
        ),
        labelSmall: TextStyle(
          color: Colors.black,
          fontSize: screenWidth * 0.025, // 2.5% of screen width
        ),
        headlineMedium: TextStyle(
          color: Colors.black,
          fontSize: screenWidth * 0.04, // 4% of screen width
        ),
        headlineSmall: TextStyle(
          color: Colors.black,
          fontSize: screenWidth * 0.025, // 2.5% of screen width
        ),
      ),
      appBarTheme: AppBarTheme(
        color: Colors.green,
        titleTextStyle: TextStyle(
          color: whiteTextColor,
          fontWeight: FontWeight.bold,
          fontSize: screenWidth * 0.04, // 4% of screen width
        ),

        actionsIconTheme: const IconThemeData(
          color: Colors.white,
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.green),
          foregroundColor: MaterialStateProperty.all(Colors.white),
          textStyle: MaterialStateProperty.all(TextStyle(
            fontSize: screenWidth * 0.04, // 4% of screen width
            fontWeight: FontWeight.bold,
          )),
          shape: MaterialStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(90),
            ),
          ),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: Colors.green,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: Colors.green,
      ),
      inputDecorationTheme: InputDecorationTheme(
        // Customize the appearance of the TextField
        filled: true,
        fillColor: Colors.grey[90],
        // Background color of TextField
        border: OutlineInputBorder(
          // Border style of TextField
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          // Border style when TextField is focused
          borderSide: const BorderSide(color: Colors.green),
          borderRadius: BorderRadius.circular(10),
        ),
        hintStyle: const TextStyle(
          color: Colors.green,
        ),
        labelStyle: const TextStyle(
          color: Colors.green,
        ),
        hoverColor: Colors.green,

        // Add more properties to customize TextField appearance
      ),
      cardTheme: CardTheme(
          color: Colors.grey[100],
        elevation: 4,

      ),
    );
  }

  static ThemeData darkTheme(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return ThemeData(
      primaryColor: Colors.grey,
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: Colors.green,
        selectionHandleColor: Colors.green,
      ),
      scaffoldBackgroundColor: darkColor,
      textTheme: TextTheme(
        labelLarge: TextStyle(
          color: Colors.white,
          fontSize: screenWidth * 0.06, // 6% of screen width
          fontWeight: FontWeight.w700,
        ),
        labelMedium: TextStyle(
          color: Colors.white,
          fontSize: screenWidth * 0.03,
        ),
        labelSmall: TextStyle(
          color: Colors.white,
          fontSize: screenWidth * 0.025,
        ),
        headlineMedium: TextStyle(
          color: Colors.white,
          fontSize: screenWidth * 0.04,
        ),
        headlineSmall: TextStyle(
          color: Colors.white,
          fontSize: screenWidth * 0.025,
        ),
        titleSmall: TextStyle(
          color: Colors.white,
          fontSize: screenWidth * 0.025,
        ),
        titleMedium:  TextStyle(
          color: Colors.white,
          fontSize: screenWidth * 0.025,
        ),
        titleLarge:  TextStyle(
          color: Colors.white,
          fontSize: screenWidth * 0.025,
        ),
        headlineLarge:  TextStyle(
          color: Colors.white,
          fontSize: screenWidth * 0.025,
        ),
        displaySmall:  TextStyle(
          color: Colors.white,
          fontSize: screenWidth * 0.025,
        ),
        displayMedium:  TextStyle(
          color: Colors.white,
          fontSize: screenWidth * 0.025,
        ),
        displayLarge:  TextStyle(
          color: Colors.white,
          fontSize: screenWidth * 0.025,
        ),
        bodySmall:  TextStyle(
          color: Colors.white,
          fontSize: screenWidth * 0.025,
        ),
        bodyLarge:  TextStyle(
          color: Colors.white,
          fontSize: screenWidth * 0.025,
        ),
      ),
      appBarTheme: AppBarTheme(
        color: darkColor,
        titleTextStyle: TextStyle(
          color: whiteTextColor,
          fontWeight: FontWeight.bold,
          fontSize: screenWidth * 0.04,
        ),
        actionsIconTheme: const IconThemeData(
          color: Colors.white,
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.green),
          foregroundColor: MaterialStateProperty.all(Colors.white),
          textStyle: MaterialStateProperty.all(TextStyle(
            fontSize: screenWidth * 0.04,
            fontWeight: FontWeight.bold,
          )),
          shape: MaterialStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(90),
            ),
          ),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: Colors.green,
        backgroundColor: darkColor,
        elevation: 20.0,
        unselectedItemColor: Colors.white,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.bold
        )
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: Colors.green,
      ),
      inputDecorationTheme: InputDecorationTheme(
        // Customize the appearance of the TextField
        filled: true,
        fillColor: Colors.grey[90],
        // Background color of TextField
        border: OutlineInputBorder(
          // Border style of TextField
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          // Border style when TextField is focused
          borderSide: const BorderSide(color: Colors.green),
          borderRadius: BorderRadius.circular(10),
        ),
        hintStyle: const TextStyle(
          color: Colors.green,
        ),
        labelStyle: const TextStyle(
          color: Colors.green,
        ),
        hoverColor: Colors.green,

        // Add more properties to customize TextField appearance
      ),
      cardTheme: const CardTheme(
        color: Colors.grey
      ),
    );
  }
}