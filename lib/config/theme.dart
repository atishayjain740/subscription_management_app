import 'package:flutter/material.dart';
import 'package:subsciption_management_app/config/constants.dart';

class AppThemes {
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.white,
    primaryColor: AppColors.primaryColor,
    fontFamily: appFontFamily,
    textTheme: const TextTheme(
      displayLarge: TextStyle(
          color: AppColors.black, fontSize: 26, fontWeight: FontWeight.bold),
      bodyLarge: TextStyle(color: AppColors.black, fontSize: 18),
      bodyMedium: TextStyle(color: AppColors.black, fontSize: 12),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.backgroundBlack,
    primaryColor: AppColors.primaryColor,
    fontFamily: appFontFamily,
    textTheme: const TextTheme(
      displayLarge: TextStyle(
          color: AppColors.white, fontSize: 26, fontWeight: FontWeight.bold),
      bodyLarge: TextStyle(color: AppColors.grey, fontSize: 18),
      bodyMedium: TextStyle(color: AppColors.grey, fontSize: 12),
    ),
  );
}
