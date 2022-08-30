import 'package:betabeta/constants/color_constants.dart';
import 'package:flutter/material.dart';

class AnimatedColorTextWidget extends StatefulWidget {
  final String text;
  final Duration? duration;
  final Color startingColor;
  final Color endingColor;
  final TextStyle textStyle;
  const AnimatedColorTextWidget(
      {Key? key,
      required this.text,
      required this.duration,
      this.startingColor = Colors.lightGreen,
      this.endingColor = Colors.redAccent,
      required this.textStyle})
      : super(key: key);

  @override
  State<AnimatedColorTextWidget> createState() =>
      _AnimatedColorTextWidgetState();
}

class _AnimatedColorTextWidgetState extends State<AnimatedColorTextWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation _animation;

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..addListener(() {
        setState(() {});
        if (_controller.isCompleted) {
          _controller.repeat(reverse: true);
        }
      })
      ..forward();
    _animation = ColorTween(
            begin: widget.startingColor, end: widget.endingColor)
        .animate(
            CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn));
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      widget.text,
      style: widget.textStyle.copyWith(color: _animation.value),
    );
  }
}
