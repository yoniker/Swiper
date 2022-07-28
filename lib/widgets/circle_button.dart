import 'package:betabeta/constants/color_constants.dart';
import 'package:flutter/material.dart';

class CircleButton extends StatefulWidget {
  final void Function()? onPressed;
  final Widget? child;
  final Color color;
  const CircleButton(
      {Key? key, this.onPressed, this.child, this.color = backgroundThemeColor})
      : super(key: key);

  @override
  State<CircleButton> createState() => _CircleButtonState();
}

class _CircleButtonState extends State<CircleButton> {
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      elevation: 0,
      padding: EdgeInsets.all(10),
      onPressed: widget.onPressed,
      shape: CircleBorder(),
      child: widget.child,
      color: widget.color,
    );
  }
}
