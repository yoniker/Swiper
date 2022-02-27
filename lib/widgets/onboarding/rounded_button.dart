import 'package:betabeta/constants/onboarding_consts.dart';
import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  RoundedButton({
    this.elevation = 0.0,
    required this.name,
    this.color = Colors.white,
    required this.onTap,
    this.icon,
    this.showBorder,
    this.decoration,
    this.addControlerAnimation = 1,
    this.iconColor,
  });

  double elevation;
  bool? showBorder = true;
  BoxDecoration? decoration;
  final Color? iconColor;
  final String? name;
  final Color? color;
  final IconData? icon;
  void Function()? onTap;
  double addControlerAnimation = 1;

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    return Material(
      borderRadius: BorderRadius.all(
        Radius.circular(30),
      ),
      color: Colors.transparent,
      elevation: elevation,
      child: Container(
        decoration: onTap == null || showBorder == false
            ? null
            : (color == Colors.white ? kBlackBorder : kWhiteBorder),
        child: MaterialButton(
          disabledColor: Colors.grey.withOpacity(0.2),
          disabledTextColor: Colors.white,
          textColor: color == Colors.white && onTap != null
              ? Colors.black
              : Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          color: color,
          elevation: color == Colors.grey.withOpacity(0.6) ||
                  color == Colors.transparent
              ? 0.0
              : elevation,
          onPressed: onTap,
          minWidth: addControlerAnimation * 400,
          height: addControlerAnimation * screenHeight * 0.04,
          child: Row(
            mainAxisAlignment: icon == null
                ? MainAxisAlignment.center
                : MainAxisAlignment.spaceEvenly,
            children: [
              Text(name!,
                  style: color == Colors.blueGrey ||
                          color == Color(0xFF0060DB) ||
                          color == Colors.transparent ||
                          onTap == null
                      ? kButtonTextWhite
                      : kButtonText),
              (icon != null
                  ? Icon(
                      icon,
                      size: 25,
                      color: iconColor != null
                          ? (color == Colors.white
                              ? Colors.black
                              : Colors.white)
                          : iconColor,
                    )
                  : Text('')),
            ],
          ),
        ),
      ),
    );
  }
}
