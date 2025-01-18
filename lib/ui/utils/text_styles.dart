import 'dart:ui';

import 'package:canarslan_website/services/orientation_service.dart';
import 'package:canarslan_website/ui/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

abstract class AppTextStyles {
  static final title = GoogleFonts.inter(
    fontSize: 13.sp,
    color: AppColors.white,
    fontWeight: FontWeight.bold,
  );
  static final codingTitle = GoogleFonts.firaCode(
    fontSize: 13.sp,
    color: AppColors.white,
  );

  static final subtitle = GoogleFonts.inter(
    fontSize: 12.sp,
    fontWeight: FontWeight.bold,
  );

  static final regular = GoogleFonts.inter();

  static final body = GoogleFonts.inter(
    color: AppColors.white,
    fontSize: OrientationService.contentPackagesTitle,
  );
  static final codingBody =
      GoogleFonts.firaCode(fontSize: 13.sp, color: Colors.white);
  static final bodyBold = GoogleFonts.inter(
      color: AppColors.white, fontSize: 12.sp, fontWeight: FontWeight.bold);

  static final caption = GoogleFonts.inter(
    fontSize: 9.sp,
  );
  static final navBar = GoogleFonts.inter(
      fontSize: OrientationService.isPortrait ? 13.6.sp : 10.5.sp,
      color: AppColors.white,
      fontWeight: FontWeight.w500);
}
