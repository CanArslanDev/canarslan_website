import 'package:canarslan_website/ui/utils/colors.dart';
import 'package:canarslan_website/ui/utils/text_styles.dart';
import 'package:flutter/material.dart';

abstract class AppThemes {
  static ThemeData mainTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
    useMaterial3: true,
    textTheme: TextTheme(
      displayLarge: AppTextStyles.regular,
      displayMedium: AppTextStyles.regular,
      displaySmall: AppTextStyles.regular,
      bodyLarge: AppTextStyles.regular,
      bodyMedium: AppTextStyles.regular,
      bodySmall: AppTextStyles.regular,
    ).apply(
      bodyColor: AppColors.white,
      displayColor: AppColors.white,
    ),
  );
}
