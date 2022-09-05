import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

class ShakeWidget extends StatefulWidget {
  const ShakeWidget({
    Key? key,
    required this.provider,
    required this.child,
    this.shakeCount = 3,
    this.shakeOffset = 10,
    this.shakeDuration = const Duration(milliseconds: 400),
  }) : super(key: key);
  final ProviderListenable<bool> provider;
  final Widget child;
  final int shakeCount;
  final double shakeOffset;
  final Duration shakeDuration;

  @override
  State<ShakeWidget> createState() => ShakeWidgetState(shakeDuration);
}

class ShakeWidgetState extends AnimationControllerState<ShakeWidget> {
  ShakeWidgetState(Duration duration) : super(duration);

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
    return Consumer(builder: (context, ref, child) {
      ref.listen(widget.provider, (previous, next) {
        if (next == true) {
          shake();
        }
      });

      // 1. return an AnimatedBuilder
      return AnimatedBuilder(
        // 2. pass our custom animation as an argument
        animation: animationController,
        // 3. optimization: pass the given child as an argument
        child: widget.child,
        builder: (context, child) {
          final sineValue =
              sin(widget.shakeCount * 2 * pi * animationController.value);
          return Transform.translate(
            // 4. apply a translation as a function of the animation value
            offset: Offset(sineValue * widget.shakeOffset, 0),
            // 5. use the child widget
            child: child,
          );
        },
      );
    });
  }
}
