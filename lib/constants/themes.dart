import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Import this!

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.blueAccent,
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: Colors.white,
    inputDecorationTheme: InputDecorationTheme(border: OutlineInputBorder()),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),

    // ⬇️ Here's the magic
    textTheme: GoogleFonts.poppinsTextTheme(
      // <-- use Google Fonts here
      TextTheme(
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        headlineMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
        headlineSmall: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
        bodyLarge: TextStyle(fontSize: 16, color: Colors.black87),
        bodyMedium: TextStyle(fontSize: 14, color: Colors.black87),
        bodySmall: TextStyle(fontSize: 12, color: Colors.black54),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),
      ),
    ),

    cardTheme: CardThemeData(
      color: Colors.grey[100],
      shadowColor: Colors.grey.withOpacity(0.5),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),

    iconTheme: IconThemeData(color: Colors.blue, size: 24),

    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      elevation: 8,
    ),

    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
      elevation: 4,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.deepPurpleAccent,
    primarySwatch: Colors.deepPurple,
    scaffoldBackgroundColor: const Color(0xFF121212),
    inputDecorationTheme: InputDecorationTheme(border: OutlineInputBorder()),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.deepPurple,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    textTheme: GoogleFonts.poppinsTextTheme(
      TextTheme(
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        headlineMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        headlineSmall: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: Colors.white70,
        ),
        bodyLarge: TextStyle(fontSize: 16, color: Colors.white70),
        bodyMedium: TextStyle(fontSize: 14, color: Colors.white60),
        bodySmall: TextStyle(fontSize: 12, color: Colors.white54),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.deepPurpleAccent,
        ),
      ),
    ),
    cardTheme: CardThemeData(
      color: const Color(0xFF1E1E1E),
      shadowColor: Colors.black.withOpacity(0.5),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    iconTheme: IconThemeData(color: Colors.deepPurpleAccent, size: 24),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: const Color(0xFF1E1E1E),
      selectedItemColor: Colors.deepPurpleAccent,
      unselectedItemColor: Colors.white54,
      elevation: 8,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Colors.deepPurple,
      foregroundColor: Colors.white,
      elevation: 4,
    ),
  );
}
