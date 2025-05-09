import 'package:flutter/material.dart';

class AppColor {
  static late bool isDarkMode;

  /// Helper method to choose color based on dark mode
  static Color _themeColor({required Color dark, required Color light}) {
    return AppColor.isDarkMode ? dark : light;
  }

  // Primary
  static Color get primary =>
      _themeColor(dark: const Color(0xFF171212), light: Color(0xFFFFFFFF));

  static Color grey100 = Color(0xffedefef);

  static Color get translucentBG =>
      _themeColor(dark: Color(0x11ffffff), light: Color(0x11555555));

  static Color get translucentDark =>
      _themeColor(dark: Color(0x16ffffff), light: Color(0x22555555));
}
