import 'package:flutter/material.dart';

// This is a list of colors and gradients.
// These final variables are used in making most of the
// UI for the Settings Screen.

final Color darkCardColor = Color(0xFFEFEFF1);
final Color darkTextColor = Color(0xFF747474);
final Color whiteCardColor = Color(0xFFFFFFFF);
final Color linkColor = Color(0xFF389CEB);
// 
final Color activeColor = Colors.blue;
final Color disabledColor = Colors.grey;
//
final Color colorBlend01 = Color(0xFFED3CB3);
final Color colorBlend02 = Color(0xFFD118E1);

// global textstyles
final TextStyle defaultTextStyle = TextStyle(
  color: Colors.black,
  fontFamily: 'Nunito',
  fontSize: 16,
  fontWeight: FontWeight.w500,
);

final TextStyle boldTextStyle = TextStyle(
  color: Colors.black,
  fontFamily: 'Nunito',
  fontSize: 18,
  fontWeight: FontWeight.w700,
);

//<@SUGN> This is an optional Gradient variable to be used in conjuction with
// the `GradientWidget` found in the {widgets} folder.
final LinearGradient mainColorGradientList = LinearGradient(
  colors: <Color>[
    colorBlend01,
    colorBlend02,
  ],
);