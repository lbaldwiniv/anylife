import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white, // Main background for light mode
    colorScheme: const ColorScheme.light(
      primary: Colors.black, // Monochromatic primary
      surface: Colors.white, // Main background color
      onSurface: Colors.black, // Main text color
      surfaceContainerHighest: Color(0xFFEEEEEE), // A smidge darker for contrast
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontSize: 57.0, fontWeight: FontWeight.bold),
      headlineLarge: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold),
      headlineMedium: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
      titleLarge: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
      bodyLarge: TextStyle(fontSize: 16.0),
      bodyMedium: TextStyle(fontSize: 14.0),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
    ),
    // Add other theme properties here
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor:
        const Color(0xFF0E1415), // Custom dark background
    colorScheme: const ColorScheme.dark(
      primary: Colors.white, // Monochromatic primary
      surface: Color(0xFF0E1415), // Match custom background
      onSurface: Colors.white, // Main text color
      surfaceContainerHighest:
          Color(0xFF1A2022), // Lighter shade for dark theme contrast
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontSize: 57.0, fontWeight: FontWeight.bold, color: Colors.white),
      headlineLarge: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold, color: Colors.white),
      headlineMedium: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold, fontFamily: 'Poppins', color: Colors.white),
      titleLarge: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold, color: Colors.white),
      bodyLarge: TextStyle(fontSize: 16.0, color: Colors.white),
      bodyMedium: TextStyle(fontSize: 14.0, color: Colors.white),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
    ),
    // Add other theme properties here
  );
}
