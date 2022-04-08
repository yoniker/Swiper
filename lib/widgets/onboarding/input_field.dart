import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputField extends StatelessWidget {
  InputField(
      {this.hintText = '',
      this.controller,
      this.formatters,
      this.padding,
      this.onTap,
      this.onType,
      this.onFocusChange,
      this.initialvalue,
      this.pressed = false,
      this.readonly = false,
      this.showCursor = true,
      this.icon,
      this.iconHeight = 1,
      this.iconSize,
      this.keyboardType = TextInputType.text,
      this.maxLines = 1,
      this.minLines = 1,
      this.maxCharacters = 20,
      this.style,
      this.borderColor = Colors.black87,
      this.onTapIconDisable,
      this.onTapIcon});

  final bool pressed;
  final bool readonly;
  final bool showCursor;
  final String? initialvalue;
  final void Function()? onTap;
  final double iconHeight;
  final TextEditingController? controller;
  final List<TextInputFormatter>? formatters;
  final TextStyle? style;
  final String? hintText;
  final int maxLines;
  final int minLines;
  final double? iconSize;
  final void Function(String)? onType;
  final void Function()? onTapIcon;
  final void Function()? onTapIconDisable;
  final void Function(bool)? onFocusChange;
  final IconData? icon;
  final TextInputType? keyboardType;
  final int? maxCharacters;
  final EdgeInsets? padding;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      elevation: pressed == true ? 1 : 0,
      color: Colors.transparent,
      child: Theme(
        data: ThemeData(
          textSelectionHandleColor: Colors.blue,
          textSelectionTheme: TextSelectionThemeData(
              selectionColor: Colors.blue[100],
              cursorColor: Colors.blue,
              selectionHandleColor: Colors.blue),
        ),
        child: Focus(
          onFocusChange: onFocusChange,
          child: TextFormField(
            showCursor: showCursor,
            inputFormatters: formatters,
            controller: controller,
            readOnly: readonly,
            cursorColor: Colors.blue,
            initialValue: initialvalue,
            onTap: onTap,
            maxLines: maxLines,
            minLines: minLines,
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
                  onTap: onTapIcon,
                  child: GestureDetector(
                    onTap: onTapIconDisable,
                    child: Icon(
                      icon,
                      size: iconSize,
                      color: onTapIcon == null ? Colors.grey : Colors.black87,
                    ),
                  ),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: borderColor, width: 2)),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 1.5),
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              filled: true,
              fillColor: Colors.white,
              hintText: hintText,
              hintStyle: const TextStyle(color: Colors.black12, fontSize: 18),
              counterText: "",
              contentPadding: padding != null
                  ? padding
                  : EdgeInsets.fromLTRB(20, 15.0, 20, 15.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
