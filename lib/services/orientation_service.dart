import 'package:canarslan_website/pages/home_page/home_page.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class OrientationService {
  static bool get isPortrait {
    if (100.w > 100.h) {
      return false;
    } else {
      return true;
    }
  }

  static bool get isLandscape => !isPortrait;

  static double contentImageHeight = isPortrait ? 14.h : 25.h;
  static double contentTextSize = isPortrait ? 19.sp : 13.sp;
  static double contentSmallTextSize = isPortrait ? 16.sp : 12.sp;
  static double contentButtonTextSize = isPortrait ? 15.5.sp : 11.5.sp;
  static double contentPackagesTitle = isPortrait ? 19.sp : 13.7.sp;
  static double contentPackagesDescription = isPortrait ? 16.sp : 12.sp;
  static double contentPackagesImageSize = isPortrait ? 6.w : 1.7.w;
  static double contentDisposeAnimationTextTopPadding =
      isPortrait ? 10.h : 14.h;
  static double contentDisposeAnimationTextFontSize =
      isPortrait ? 22.sp : 18.sp;
  static double asciiArtTitleFontSize = isPortrait ? 13.sp : 9.6.sp;
  static int asciiButtonWidthCharacterCount = isPortrait ? 65 : 85;
  static int asciiButtonWidthAsciiCharacterCount = isPortrait ? 24 : 30;
  static double switchButtonWidth = isPortrait ? 30.w : 10.w;
  static double switchButtonFontSize = isPortrait ? 25.sp : 11.sp;
}
