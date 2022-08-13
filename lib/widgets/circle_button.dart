import 'package:betabeta/constants/color_constants.dart';
import 'package:flutter/material.dart';

class CircleButton extends StatefulWidget {
  final void Function()? onPressed;
  final Widget? child;
  final Color color;
  final double elevation;
  final EdgeInsets padding;
  final String? label;
  const CircleButton(
      {Key? key,
      this.onPressed,
      this.child,
      this.color = backgroundThemeColor,
      this.padding = const EdgeInsets.all(8.0),
      this.label,
      this.elevation = 0})
      : super(key: key);

  @override
  State<CircleButton> createState() => _CircleButtonState();
}

class _CircleButtonState extends State<CircleButton> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MaterialButton(
          splashColor: Colors.grey,
          elevation: widget.elevation,
          padding: widget.padding,
          onPressed: widget.onPressed,
          shape: CircleBorder(),
          child: widget.child,
          color: widget.color,
        ),
        if (widget.label != null)
          Text(
            widget.label!,
            style: titleStyle.copyWith(fontSize: 16),
            textAlign: TextAlign.center,
          )
      ],
    );
  }
}
