import 'dart:math';

import 'package:flutter/material.dart';

/// https://codewithandrea.com/articles/shake-text-effect-flutter/
typedef ShackBuilder = void Function(void Function() shakeMethod);

class ShakeWidget extends StatefulWidget {
  const ShakeWidget({
    super.key,
    required this.builder,
    required this.child,
    this.shakeCount = 3,
    this.shakeOffset = 10,
    this.shakeDuration = const Duration(milliseconds: 400),
  });

  final ShackBuilder builder;
  final Widget child;
  final int shakeCount;
  final double shakeOffset;
  final Duration shakeDuration;

  @override
  State<ShakeWidget> createState() => _ShakeWidgetState();
}

class _ShakeWidgetState extends State<ShakeWidget>
    with SingleTickerProviderStateMixin {
  _ShakeWidgetState() : super();

  late final AnimationController animationController;

  @override
  void initState() {
    super.initState();

    animationController =
        AnimationController(vsync: this, duration: widget.shakeDuration);
    animationController.addStatusListener(_updateStatus);
  }

  @override
  void dispose() {
    animationController.removeStatusListener(_updateStatus);
    animationController.dispose();
    super.dispose();
  }

  void _updateStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      animationController.reset();
    }
  }

  void shake() {
    animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    widget.builder.call(shake);

    return AnimatedBuilder(
      /// pass our custom animation as an argument
      animation: animationController,

      /// optimization: pass the given child as an argument
      child: widget.child,
      builder: (context, child) {
        final sineValue =
            sin(widget.shakeCount * 2 * pi * animationController.value);
        return Transform.translate(
          /// apply a translation as a function of the animation value
          offset: Offset(sineValue * widget.shakeOffset, 0),
          child: child,
        );
      },
    );
  }
}
