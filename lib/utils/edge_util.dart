import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

final edgeUtil = _EdgeUtil();

/// EdgeUtil需要等待ScreenUtilInit
class _EdgeUtil {
  late double screenHorizontal;

  late EdgeInsets screenHorizontalPadding;

  init() {
    screenHorizontal = 32.r;

    screenHorizontalPadding =
        EdgeInsets.symmetric(horizontal: screenHorizontal);
  }
}
