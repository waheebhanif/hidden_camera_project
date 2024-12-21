import 'package:flutter/material.dart';
import 'package:hidden_camera_detector/app/ui/theme/colors.dart';

class AppTextTheme {
  AppTextTheme._();

  static TextTheme lightTextTheme = const TextTheme(
    displayLarge: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      color: Colors.black,
      fontFamily: 'Work Sans',
    ),
    displayMedium: TextStyle(
      fontSize: 23,
      fontWeight: FontWeight.w400,
      fontFamily: 'Work Sans',
      color: kPrimaryTextColor,
    ),
    displaySmall: TextStyle(
      fontSize: 14,
      fontFamily: 'Work Sans',
      fontWeight: FontWeight.w400,
      color: kPrimaryTextColor,
    ),
    headlineLarge: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w700,
      color: kPrimaryTextColor,
    ),
    headlineMedium: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    ),
    headlineSmall: TextStyle(
      fontSize: 10,
      fontFamily: 'Work Sans',
      fontWeight: FontWeight.w600,
      color: kPrimaryTextColor,
      height: 1.1,
    ),
    // titleLarge: TextStyle(
    //   fontSize: 18, // Typically used for large titles
    //   fontWeight: FontWeight.w800,
    //   color: ksecondaryText,
    // ),
    titleMedium: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      fontFamily: 'Work Sans',
      color: Color(0xFF333333),
    ),
    titleSmall: TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w400,
      fontFamily: 'Work Sans',
      color: kPrimaryTextColor,
    ),
    // bodyLarge: TextStyle(
    //   fontSize: 19, // Typically used for large body text
    //   fontWeight: FontWeight.w600,
    //   color: ksecondaryBackground,
    // ),
    bodyMedium: TextStyle(
      fontSize: 16, // Typically used for medium body text
      fontWeight: FontWeight.w500,
      fontFamily: 'Work Sans',
      color: kPrimaryTextColor,
    ),
    // bodySmall: TextStyle(
    //   fontSize: 12, // Typically used for small body text
    //   fontWeight: FontWeight.w400,
    //   color: klightText,
    // ),
    // labelLarge: TextStyle(
    //   fontSize: 14,
    //   fontWeight: FontWeight.w400,
    //   color: klableColor,
    // ),
    // labelMedium: TextStyle(
    //   fontSize: 14,
    //   fontWeight: FontWeight.w700,
    //   color: kblack,
    // ),
    // labelSmall: TextStyle(
    //   fontSize: 10,
    //   fontWeight: FontWeight.w400,
    //   color: Color(0xFF7B6F72),
    // ),
  );
}
