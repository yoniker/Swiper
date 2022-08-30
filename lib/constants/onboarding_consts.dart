import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const TextStyle kHintStyle = TextStyle(fontSize: 20, color: Colors.grey);
const TextStyle kTitleStyle =
    TextStyle(fontSize: 30, fontWeight: FontWeight.w500, color: Colors.black87);
const TextStyle kTitleStyleWhite =
    TextStyle(fontSize: 30, fontWeight: FontWeight.w500, color: Colors.white);
const TextStyle kTitleStyleBlack =
    TextStyle(fontSize: 35, fontWeight: FontWeight.bold);
const TextStyle kInputTextStyle = TextStyle(fontSize: 20, height: 0.8);
const TextStyle kSmallTitleBlack =
    TextStyle(fontSize: 20, fontWeight: FontWeight.w500);
const TextStyle kSmallInfoStyle = TextStyle(
  color: Colors.black54,
  fontWeight: FontWeight.w500,
  fontSize: 15,
);
const TextStyle kSmallInfoStyleAlert =
    TextStyle(color: Colors.red, fontWeight: FontWeight.w600, fontSize: 16);
const TextStyle kSmallInfoStyleWhite = TextStyle(
    fontFamily: 'Nunito',
    color: Colors.white,
    fontWeight: FontWeight.w500,
    fontSize: 15,
    shadows: [
      Shadow(
        blurRadius: 17.0,
        color: Colors.black,
        offset: Offset(-2.0, 2.0),
      ),
    ]);
const TextStyle kSmallInfoStyleUnderline = TextStyle(
    color: Colors.black54,
    fontWeight: FontWeight.w500,
    fontSize: 15,
    decoration: TextDecoration.underline);
const TextStyle kSmallInfoStyleUnderlineWhite = TextStyle(
    shadows: [
      Shadow(
        blurRadius: 17.0,
        color: Colors.black,
        offset: Offset(-2.0, 2.0),
      ),
    ],
    color: Colors.white70,
    fontWeight: FontWeight.w500,
    decoration: TextDecoration.underline);
const TextStyle kButtonText =
    TextStyle(fontSize: 20, color: Colors.black87, fontWeight: FontWeight.w500);
const TextStyle kButtonTextWhite = TextStyle(fontSize: 20, color: Colors.white);
const TextStyle kSmallTitleStyle = TextStyle(color: Colors.white, fontSize: 20);
const TextStyle kBlueButtonStyle =
    TextStyle(color: Colors.blueAccent, fontSize: 20);
const Color kIconColor = Colors.blueAccent;
const TextStyle kVstyle = TextStyle(fontSize: 20, color: Colors.blueAccent);
const int kTotalProgressBarPages = 9;

Color kBackroundThemeColor = Color(0xFFE8EBF1);

Color lamer = Colors.black.withOpacity(0.95);
const BoxDecoration kThemeColor = BoxDecoration(
  color: Color(0xFFE8EBF1),
);

final BoxDecoration kBlackBorder = BoxDecoration(
    border: Border.all(color: Colors.black, width: 2),
    borderRadius: const BorderRadius.all(Radius.circular(25)));

final BoxDecoration kWhiteBorder = BoxDecoration(
    border: Border.all(color: Colors.white, width: 2),
    borderRadius: const BorderRadius.all(Radius.circular(25)));

const BoxDecoration kDarkToTransTheme = BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.center,
    colors: [Colors.black, Colors.black45, Colors.transparent],
  ),
);

class PhoneFormatter extends TextInputFormatter {
  final String sample;
  final String seperator;

  PhoneFormatter({required this.seperator, required this.sample}) {
    assert(sample != null);
    assert(seperator != null);
  }
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.length > 0) {
      if (newValue.text.length > oldValue.text.length) {
        if (newValue.text.length > sample.length) return oldValue;
        if (newValue.text.length < sample.length &&
            sample[newValue.text.length - 1] == seperator) {
          return TextEditingValue(
            text:
                '${oldValue.text}$seperator${newValue.text.substring(newValue.text.length - 1)}',
            selection: TextSelection.collapsed(
              offset: newValue.selection.end + 1,
            ),
          );
        }
      }
    }
    return newValue;
  }
}
