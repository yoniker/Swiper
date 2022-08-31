import 'dart:async';

import 'package:flutter/material.dart';

class AnimatedLiveButtonWidget extends StatefulWidget {
  final Widget child;
  const AnimatedLiveButtonWidget({Key? key, required this.child})
      : super(key: key);

  @override
  State<AnimatedLiveButtonWidget> createState() =>
      _AnimatedLiveButtonWidgetState();
}

class _AnimatedLiveButtonWidgetState extends State<AnimatedLiveButtonWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation _animation;
  late Timer time;

  @override
  void initState() {
    time = Timer.periodic(Duration(milliseconds: 5000), (time) {
      _controller.forward(from: 0);
    });
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 1000))
          ..addListener(() {
            setState(() {});
            if (_controller.isCompleted) {
              _controller.reverse();
              time;
            }
          })
          ..forward();
    _animation = Tween<double>(begin: 50, end: 60)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.bounceIn));
    super.initState();
  }

  @override
  void dispose() {
    time.cancel();
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _animation.value,
      height: _animation.value,
      child: FittedBox(child: widget.child),
    );
  }
}
