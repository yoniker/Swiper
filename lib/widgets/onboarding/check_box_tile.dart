import 'package:betabeta/constants/onboarding_consts.dart';
import 'package:flutter/material.dart';

class CheckBoxTile extends StatelessWidget {
  bool? value;
  void Function(bool?)? onChanged;
  String text;
  CheckBoxTile(
      {Key? key,
      required this.onChanged,
      required this.value,
      required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(unselectedWidgetColor: Colors.black87),
      child: CheckboxListTile(
        title: Text(
          text,
          style: kSmallInfoStyle,
        ),
        controlAffinity: ListTileControlAffinity.leading,
        contentPadding: EdgeInsets.zero,
        checkColor: Colors.white,
        activeColor: Colors.black87,
        tristate: false,
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}
