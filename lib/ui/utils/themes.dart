import 'package:canarslan_website/ui/utils/colors.dart';
import 'package:flutter/material.dart';

abstract class AppThemes {
  static ThemeData mainTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
    useMaterial3: true,
  );
}
