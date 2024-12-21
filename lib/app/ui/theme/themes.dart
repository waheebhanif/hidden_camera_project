import 'package:flutter/material.dart';
import 'package:hidden_camera_detector/app/ui/theme/text_theme.dart';

class Themes {
  final lightTheme = ThemeData.light().copyWith(
    primaryColor: Colors.red,
    cardColor: Colors.grey[100],
    scaffoldBackgroundColor: Colors.white,
    shadowColor: Colors.grey,
    textTheme: AppTextTheme.lightTextTheme,
  );
  final darkTheme = ThemeData.dark().copyWith(
    primaryColor: Colors.grey[900],
    cardColor: Colors.grey[900],
    scaffoldBackgroundColor: Colors.grey[800],
    shadowColor: Colors.grey,
  );
}
