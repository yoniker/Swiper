import 'package:flutter/material.dart';

// This is a list of colors and gradients.
// These final variables are used in making most of the
// UI for the Settings Screen.

const Color lightCardColor = Color(0xFFF5F5F5);
const Color backgroundThemeColor = Color(0xFFE8EBF1);
const Color darkTextColor = Color(0xFF747474);
const Color unselectedTabColor = Colors.white60;
const Color blackTextColor = Color(0xFF000000);
const Color whiteCardColor = Color(0xFFFFFFFF);
const Color whiteTextColor = Color(0xFFFFFFFF);
const defaultShadowColor = Color(0x99999999);
const Color linkColor = Color(0xFF389CEB);
const Color activeDot = Colors.white;
const Color inactiveDot = Color(0xFFBDBDBD);

//
const Color activeColor = Colors.blue;
const Color disabledColor = Colors.grey;
//
const Color colorBlend01 = Color(0xFFEA4336);
const Color mainAppColor02 = Colors.white;

const Color blue = Color(0xFF389CEB);
const Color yellowishOrange = Color(0xFFF99442);

const Color goldColorish = Color(0xFFC59533);
const Color appMainColor = Color(0xFFC62828);
const Color appSecondaryColor = Colors.black87;

// global textstyles
const TextStyle defaultTextStyle = TextStyle(
  color: Colors.black,
  fontFamily: 'Nunito',
  fontSize: 17,
  fontWeight: FontWeight.w500,
);

const TextStyle boldTextStyle = TextStyle(
  color: Colors.black,
  fontFamily: 'Nunito',
  fontSize: 18,
  fontWeight: FontWeight.w700,
);

const TextStyle kWhiteDescriptionShadowStyle = TextStyle(
  color: Colors.white70,
  overflow: TextOverflow.ellipsis,
  fontFamily: 'Nunito',
  fontSize: 18,
  fontWeight: FontWeight.w700,
  shadows: [
    Shadow(
      blurRadius: 17.0,
      color: Colors.black,
      offset: Offset(-2.0, 2.0),
    ),
  ],
);

const TextStyle titleStyle = TextStyle(
  color: Colors.black,
  fontFamily: 'Nunito',
  fontSize: 22,
  fontWeight: FontWeight.w700,
);

const TextStyle subTitleStyle = TextStyle(
  color: Colors.black87,
  fontFamily: 'Nunito',
  fontSize: 16,
  fontWeight: FontWeight.w600,
);

const TextStyle subHeaderStyle = TextStyle(
  color: Colors.black,
  fontFamily: 'Nunito',
  fontSize: 15,
  fontWeight: FontWeight.w600,
);

const TextStyle smallCharStyle = TextStyle(
  color: Colors.black,
  fontFamily: 'Nunito',
  fontSize: 13,
  fontWeight: FontWeight.w500,
);

const TextStyle smallBoldedCharStyle = TextStyle(
  color: darkTextColor,
  fontFamily: 'Nunito',
  fontSize: 13,
  fontWeight: FontWeight.w700,
);

const TextStyle smallBoldedTitleBlack = TextStyle(
    fontFamily: 'Nunito',
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.black);

const TextStyle smallTitleLighterBlack = TextStyle(
    fontFamily: 'Nunito',
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: Colors.black54);

const TextStyle mediumBoldedCharStyle = TextStyle(
  color: darkTextColor,
  fontFamily: 'Nunito',
  fontSize: 15,
  fontWeight: FontWeight.w700,
);

const TextStyle headerStyle = TextStyle(
  color: Colors.black,
  fontFamily: 'Nunito',
  fontSize: 24,
  fontWeight: FontWeight.w700,
);

const TextStyle boldTextStyleWhite = TextStyle(
  color: Colors.white,
  fontFamily: 'Nunito',
  fontSize: 18,
  fontWeight: FontWeight.w700,
);

const TextStyle titleStyleWhite = TextStyle(
    color: Colors.white,
    fontFamily: 'Nunito',
    fontSize: 22,
    fontWeight: FontWeight.w700,
    shadows: [
      Shadow(
        blurRadius: 15.0,
        color: Colors.black,
        offset: Offset(-2.0, 2.0),
      ),
    ]);

const TextStyle LargeTitleStyleWhite = TextStyle(
    color: Colors.white,
    fontFamily: 'Nunito',
    fontSize: 26,
    fontWeight: FontWeight.bold,
    shadows: [
      Shadow(
        blurRadius: 17.0,
        color: Colors.black,
        offset: Offset(-2.0, 2.0),
      ),
    ]);

const TextStyle LargeTitleStyle = TextStyle(
  color: Colors.black87,
  fontFamily: 'Nunito',
  fontSize: 26,
  fontWeight: FontWeight.bold,
);

//<@SUGN> This is an optional Gradient variable to be used in conjuction with
// the `GradientWidget` found in the {widgets} folder.
const LinearGradient mainColorGradient = const LinearGradient(
  colors: <Color>[
    colorBlend01,
    mainAppColor02,
  ],
);

const colorizeColors = [
  Color(0XFFFECA00),
  Color(0XFF824E02),
  Color(0XFFFECA00),
  Color(0XFFAC7A00),
  Color(0XFFDDA900)
];

const colorizeTextStyle =
    TextStyle(fontSize: 40.0, fontFamily: 'LuckiestGuy', shadows: [
  Shadow(
    blurRadius: 15.0,
    color: Colors.black,
    offset: Offset(-2.0, 2.0),
  ),
]);

const Decoration kSettingsBlockBoxDecor = BoxDecoration(
  color: Colors.white,
  boxShadow: [
    BoxShadow(
        offset: Offset(0.0, 2.0),
        blurRadius: 1.0,
        spreadRadius: -1.0,
        color: Color(0x33000000)),
    BoxShadow(
        offset: Offset(0.0, 1.0), blurRadius: 1.0, color: Color(0x24000000)),
    BoxShadow(
        offset: Offset(0.0, 1.0), blurRadius: 3.0, color: Color(0x1F000000)),
  ],
  borderRadius: BorderRadius.all(
    Radius.circular(5),
  ),
);
