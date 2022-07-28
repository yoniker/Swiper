import 'package:flutter/material.dart';

class AnimatedAppearWidget extends StatefulWidget {
  final void Function()? onTap;
  final Widget child;
  const AnimatedAppearWidget({Key? key, this.onTap, required this.child})
      : super(key: key);

  @override
  State<AnimatedAppearWidget> createState() => _AnimatedAppearWidgetState();
}

class _AnimatedAppearWidgetState extends State<AnimatedAppearWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation _animation;

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300))
          ..addListener(() {
            setState(() {});
          })
          ..forward();
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: _animation.value,
      child: GestureDetector(onTap: widget.onTap, child: widget.child),
    );
  }
}
