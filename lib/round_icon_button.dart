import 'package:flutter/material.dart';

class RoundIconButton extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final double size;
  final VoidCallback onPressed;

  RoundIconButton.large({
    this.icon,
    this.iconColor,
    this.onPressed,
  }) : size = 60.0;

  RoundIconButton.small({
    this.icon,
    this.iconColor,
    this.onPressed,
  }) : size = 50.0;

   RoundIconButton({
    this.icon,
    this.iconColor,
    this.size,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: const Color(0x11000000), blurRadius: 10.0),
          ]),
      child:  RawMaterialButton(
        shape:  CircleBorder(),
        elevation: 0.0,
        child:  Icon(
          icon,
          color: iconColor,
        ),
        onPressed: onPressed,
      ),
    );
  }
}









class RoundButton extends StatelessWidget {
  final Widget child;
  final double size;
  final VoidCallback onPressed;

  RoundButton.large({
    this.child,
    this.onPressed,
  }) : size = 60.0;

  RoundButton.small({
    this.child,
    this.onPressed,
  }) : size = 50.0;

  RoundButton({
    this.child,
    this.size,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: const Color(0x11000000), blurRadius: 10.0),
          ]),
      child:  RawMaterialButton(
        shape:  CircleBorder(),
        elevation: 0.0,
        child:  child,
        onPressed: onPressed,
      ),
    );
  }
}