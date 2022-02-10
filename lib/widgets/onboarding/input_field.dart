import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  InputField(
      {this.hintText,
      this.padding,
      this.onTap,
      this.onType,
      this.initialvalue,
      this.pressed = false,
      this.icon,
      this.iconHeight = 1,
      this.keyboardType,
      this.maxLines = 1,
      this.maxCharacters,
      this.style,
      this.onTapIcon});

  bool pressed;
  String? initialvalue;
  void Function()? onTap;
  final double iconHeight;
  TextStyle? style;
  String? hintText = "";
  int maxLines;
  void Function(String)? onType;
  void Function()? onTapIcon;
  final IconData? icon;
  TextInputType? keyboardType = TextInputType.text;
  int? maxCharacters = 20;
  EdgeInsets? padding = EdgeInsets.fromLTRB(20, 10.0, 20, 10.0);

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      elevation: pressed == true ? 1 : 5,
      color: Colors.transparent,
      child: TextFormField(
        initialValue: initialvalue,
        onTap: onTap,
        maxLines: maxLines,
        textCapitalization: TextCapitalization.sentences,
        onChanged: onType,
        keyboardType: keyboardType,
        style: style != null
            ? style
            : const TextStyle(fontSize: 20, color: Colors.black87),
        maxLength: maxCharacters,
        textAlign: TextAlign.start,
        decoration: InputDecoration(
          suffixIcon: Padding(
            padding: EdgeInsets.only(right: 15, top: iconHeight),
            child: GestureDetector(
              onTap: onTapIcon == null ? null : onTapIcon,
              child: Icon(
                icon,
                color: onTapIcon == null ? Colors.grey : Colors.black87,
              ),
            ),
          ),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black87, width: 2)),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blueGrey, width: 1.5),
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          filled: true,
          fillColor: Colors.white,
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.black12, fontSize: 18),
          counterText: "",
          contentPadding: padding,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
