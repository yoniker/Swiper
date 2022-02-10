import 'package:betabeta/constants/onboarding_consts.dart';
import 'package:flutter/material.dart';

class TextButtonOnly extends StatelessWidget {
  void Function()? onClick;
  String label = '';
  TextButtonOnly({Key? key, this.onClick, required this.label})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: kButtonText,
      ),
    );
  }
}
