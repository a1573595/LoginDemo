import 'dart:math';

import 'package:flutter/material.dart';

/// https://codewithandrea.com/articles/shake-text-effect-flutter/
abstract class AnimationControllerState<T extends StatefulWidget>
    extends State<T> with SingleTickerProviderStateMixin {
  AnimationControllerState(this.animationDuration);

  final Duration animationDuration;
  late final animationController =
      AnimationController(vsync: this, duration: animationDuration);

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}

typedef ShackBuilder = void Function(void Function() shakeMethod);

class ShakeWidget extends StatefulWidget {
  const ShakeWidget({
    Key? key,
    required this.builder,
    required this.child,
    this.shakeCount = 3,
    this.shakeOffset = 10,
    this.shakeDuration = const Duration(milliseconds: 400),
  }) : super(key: key);

  final ShackBuilder builder;
  final Widget child;
  final int shakeCount;
  final double shakeOffset;
  final Duration shakeDuration;

  @override
  State<ShakeWidget> createState() => _ShakeWidgetState(shakeDuration);
}

class _ShakeWidgetState extends AnimationControllerState<ShakeWidget> {
  _ShakeWidgetState(Duration duration) : super(duration);

  @override
  void initState() {
    super.initState();
    animationController.addStatusListener(_updateStatus);
  }

  @override
  void dispose() {
    animationController.removeStatusListener(_updateStatus);
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
