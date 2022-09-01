import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

final edgeUtil = _EdgeUtil();

/// EdgeUtil需要等待ScreenUtilInit
class _EdgeUtil {
  late double screenHorizontal;
  late double screenVertical;

  late EdgeInsets screenPadding;
  late EdgeInsets screenHorizontalPadding;

  late EdgeInsets listviewVerticalPadding;

  late EdgeInsets cardPadding;

  init() {
    screenHorizontal = 24.r;
    screenVertical = 16.r;

    screenPadding = EdgeInsets.symmetric(
        horizontal: screenHorizontal, vertical: screenVertical);

    screenHorizontalPadding =
        EdgeInsets.symmetric(horizontal: screenHorizontal);

    listviewVerticalPadding = EdgeInsets.symmetric(vertical: screenVertical);

    cardPadding = EdgeInsets.all(8.r);
  }
}
