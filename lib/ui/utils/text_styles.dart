import 'dart:ui';

import 'package:canarslan_website/ui/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class AppTextStyles {
  static final title = GoogleFonts.inter(
    fontSize: 24,
    color: AppColors.white,
    fontWeight: FontWeight.bold,
  );
  static final codingTitle = GoogleFonts.firaCode(
    fontSize: 24,
    color: AppColors.white,
  );

  static final subtitle = GoogleFonts.inter(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

  static final body = GoogleFonts.inter(
    fontSize: 16,
  );

  static final caption = GoogleFonts.inter(
    fontSize: 12,
  );
}
