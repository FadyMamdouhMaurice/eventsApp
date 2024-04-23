import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyThemeData {
  //static Color primaryColor = Colors.green;
  static Color greyTextColor = Colors.grey;
  static Color whiteTextColor = Colors.white;
  static Color darkColor = Colors.grey[900]!;

  // double screenHeight=MediaQuery.of(context).size.height;
  static ThemeData lightTheme(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return ThemeData(
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: Colors.green,
        selectionHandleColor: Colors.green,
      ),
      scaffoldBackgroundColor: Colors.white,
      textTheme: TextTheme(
        labelLarge: TextStyle(
          color: Colors.white,
          fontSize: screenWidth * 0.06, // 6% of screen width
          fontWeight: FontWeight.w700,
        ),
        labelMedium: TextStyle(
          color: Colors.white,
          fontSize: screenWidth * 0.03, // 3% of screen width
        ),
        labelSmall: TextStyle(
          color: Colors.white,
          fontSize: screenWidth * 0.025, // 2.5% of screen width
        ),
        headlineMedium: TextStyle(
          color: Colors.white,
          fontSize: screenWidth * 0.04, // 4% of screen width
        ),
        headlineSmall: TextStyle(
          color: Colors.white,
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

        actionsIconTheme: IconThemeData(
          color: Colors.white,
        ),
        iconTheme: IconThemeData(
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
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: Colors.green,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
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
          borderSide: BorderSide(color: Colors.green),
          borderRadius: BorderRadius.circular(10),
        ),
        hintStyle: TextStyle(
          color: Colors.green,
        ),
        labelStyle: TextStyle(
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
    double screenHeight = MediaQuery.of(context).size.height;

    return ThemeData(
      textSelectionTheme: TextSelectionThemeData(
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
          fontSize: screenWidth * 0.03, // 3% of screen width
        ),
        labelSmall: TextStyle(
          color: Colors.white,
          fontSize: screenWidth * 0.025, // 2.5% of screen width
        ),
        headlineMedium: TextStyle(
          color: Colors.white,
          fontSize: screenWidth * 0.04, // 4% of screen width
        ),
        headlineSmall: TextStyle(
          color: Colors.white,
          fontSize: screenWidth * 0.025, // 2.5% of screen width
        ),
      ),
      appBarTheme: AppBarTheme(
        color: darkColor,
        titleTextStyle: TextStyle(
          color: whiteTextColor,
          fontWeight: FontWeight.bold,
          fontSize: screenWidth * 0.04, // 4% of screen width
        ),
        actionsIconTheme: IconThemeData(
          color: Colors.white,
        ),
        iconTheme: IconThemeData(
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
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: Colors.green,
        backgroundColor: darkColor,
        elevation: 20.0,
        unselectedItemColor: Colors.white,
        selectedLabelStyle: TextStyle(
          fontWeight: FontWeight.bold
        )
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
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
          borderSide: BorderSide(color: Colors.green),
          borderRadius: BorderRadius.circular(10),
        ),
        hintStyle: TextStyle(
          color: Colors.green,
        ),
        labelStyle: TextStyle(
          color: Colors.green,
        ),
        hoverColor: Colors.green,

        // Add more properties to customize TextField appearance
      ),
      cardTheme: CardTheme(
        color: Colors.grey
      ),
    );
  }

  /*
  static ThemeData darkTheme = ThemeData(
    primarySwatch: Colors.green,
    scaffoldBackgroundColor: darkColor,
    appBarTheme: AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: darkColor, statusBarBrightness: Brightness.light),
      color: darkColor,
      // Set app bar color
      elevation: 0.0,
      // Set app bar elevation (shadow)
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(color: Colors.white), // Set icon color
    ),
    textTheme: const TextTheme(
      labelLarge: TextStyle(
          color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
      labelMedium: TextStyle(color: Colors.white, fontSize: 25),
      labelSmall: TextStyle(color: Colors.white, fontSize: 20),
      headlineMedium: TextStyle(
        color: Colors.white,
        fontSize: 28,
      ),
      headlineSmall: TextStyle(
        color: Colors.white,
        fontSize: 18,
      ),
      bodyLarge: TextStyle(
        color: Colors.white,
        fontSize: 18,
      ),
      bodyMedium: TextStyle(
        color: Colors.white,
        fontSize: 18,
      ),
      bodySmall: TextStyle(
        color: Colors.white,
        fontSize: 18,
      ),
      displayLarge: TextStyle(
        color: Colors.white,
        fontSize: 18,
      ),
      displayMedium: TextStyle(
        color: Colors.white,
        fontSize: 18,
      ),
      displaySmall: TextStyle(
        color: Colors.white,
        fontSize: 18,
      ),
      headlineLarge: TextStyle(
        color: Colors.white,
        fontSize: 18,
      ),
      titleLarge: TextStyle(
        color: Colors.white,
        fontSize: 18,
      ),
      titleMedium: TextStyle(
        color: Colors.white,
        fontSize: 18,
      ),
      titleSmall: TextStyle(
        color: Colors.white,
        fontSize: 18,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      // Customize the appearance of the TextField
      filled: true,
      fillColor: darkColor,
      // Background color of TextField
      border: OutlineInputBorder(
        // Border style of TextField
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(10),
      ),
      focusedBorder: OutlineInputBorder(
        // Border style when TextField is focused
        borderSide: BorderSide(color: Colors.green),
        borderRadius: BorderRadius.circular(10),
      ),
      hintStyle: TextStyle(
        color: Colors.white,
      ),
      labelStyle: TextStyle(
        color: Colors.white,
      ),
      hoverColor: Colors.white,
      // Add more properties to customize TextField appearance
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: Colors.red, // Set button background color
      textTheme: ButtonTextTheme.primary, // Set text theme
    ),
    // Add more properties as needed
  );
*/
}