import 'package:flutter/material.dart';

class SmallIconButton extends StatelessWidget {
  SmallIconButton({required this.onTap, this.icon, this.color, this.iconColor});
  final IconData? icon;
  void Function()? onTap;
  Color? color = Colors.white;
  Color? iconColor = Colors.black45;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      fillColor: color,
      shape: const CircleBorder(),
      elevation: 0.0,
      child: Icon(
        icon,
        color: iconColor,
      ),
      onPressed: onTap,
    );
  }
}
