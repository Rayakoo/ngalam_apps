import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'color.dart';
import 'typography.dart';

class AppThemes {
  static ThemeData getTheme() => light;

  static final ThemeData light = ThemeData(
    useMaterial3: true,
    primaryColor: AppColors.c2a6892,
    primarySwatch: AppColors.primarySwatch,
    brightness: Brightness.light,
    cardColor: AppColors.cce1f0,
    dividerColor: AppColors.a4cbe5,
    scaffoldBackgroundColor: AppColors.white,
    textTheme: const TextTheme(
      headlineLarge: AppTextStyles.heading_1_bold,
      headlineMedium: AppTextStyles.heading_2_medium,
      headlineSmall: AppTextStyles.heading_3_regular,
      titleLarge: AppTextStyles.heading_4_medium,
      bodyLarge: AppTextStyles.paragraph_18_regular,
    ),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      color: AppColors.white,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      titleTextStyle: AppTextStyles.heading_3_bold,
      iconTheme: IconThemeData(color: AppColors.c2a6892),
    ),
    iconTheme: const IconThemeData(color: AppColors.c2a6892),
  );
}
