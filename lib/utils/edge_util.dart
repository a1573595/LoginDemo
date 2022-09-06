import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// EdgeUtil需要等待ScreenUtilInit
class EdgeUtil {
  static double screenHorizontal = 32;

  static EdgeInsets screenHorizontalPadding =
      EdgeInsets.symmetric(horizontal: screenHorizontal);

  static initAfterScreenUtil() {
    screenHorizontal = 32.r;

    screenHorizontalPadding =
        EdgeInsets.symmetric(horizontal: screenHorizontal);
  }
}
