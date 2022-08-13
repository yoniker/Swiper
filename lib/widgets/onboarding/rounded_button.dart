import 'package:betabeta/constants/onboarding_consts.dart';
import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  RoundedButton({
    this.elevation = 5,
    required this.name,
    this.color = Colors.white,
    required this.onTap,
    this.icon,
    this.minWidth = 400,
    this.withPadding = true,
    this.showBorder = true,
    this.textStyle = kButtonText,
    this.decoration,
    this.iconColor,
  });

  final double elevation;
  final double minWidth;
  final bool? showBorder;
  final bool? withPadding;
  final TextStyle? textStyle;
  final BoxDecoration? decoration;
  final Color? iconColor;
  final String? name;
  final Color? color;
  final IconData? icon;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    return Material(
      borderRadius: BorderRadius.all(
        Radius.circular(30),
      ),
      color: Colors.transparent,
      elevation: onTap != null ? elevation : 0,
      child: MaterialButton(
        disabledColor: Colors.grey.withOpacity(0.2),
        disabledTextColor: Colors.white,
        textColor: color == Colors.white && onTap != null
            ? Colors.black
            : Colors.white,
        padding: withPadding != false
            ? EdgeInsets.symmetric(horizontal: 20, vertical: 12)
            : null,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
          side: onTap == null || showBorder == false
              ? BorderSide(width: 0, color: Colors.transparent)
              : BorderSide(
                  width: 2,
                  color: color == Colors.white ? Colors.black : Colors.white),
        ),
        color: color,
        onPressed: onTap,
        minWidth: minWidth,
        height: screenHeight * 0.07,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: icon == null
              ? MainAxisAlignment.center
              : MainAxisAlignment.spaceEvenly,
          children: [
            Flexible(
              child: Text(
                name!,
                style: color == Colors.blueGrey ||
                        color == Color(0xFF0060DB) ||
                        color == Colors.transparent ||
                        onTap == null ||
                        color == Colors.red[800] ||
                        color == Colors.black87
                    ? kButtonTextWhite
                    : textStyle,
                overflow: TextOverflow.fade,
                maxLines: 1,
              ),
            ),
            (icon != null
                ? Icon(
                    icon,
                    size: 25,
                    color: iconColor == null
                        ? (color == Colors.white ? Colors.black : Colors.white)
                        : iconColor,
                  )
                : SizedBox()),
          ],
        ),
      ),
    );
  }
}
