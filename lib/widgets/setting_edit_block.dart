import 'package:betabeta/constants/color_constants.dart';
import 'package:betabeta/widgets/onboarding/input_field.dart';
import 'package:flutter/material.dart';

/// Replacement for TextEditBlock for profile settings page.

class TextEditBlock extends StatefulWidget {
  TextEditBlock(
      {required this.title,
      this.initialValue,
      this.maxLines = 1,
      this.minLines = 1,
      this.maxCharacters = 50,
      this.onType,
      this.onTap,
      this.icon,
      this.keyboardType = TextInputType.text,
      this.readOnly = false,
      this.showCursor = false,
      this.hideTitle = false,
      this.controller,
      this.placeholder});
  final String title;
  final IconData? icon;
  final int maxLines;
  final int minLines;
  final int maxCharacters;
  final String? placeholder;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool readOnly;
  final bool showCursor;
  final bool hideTitle;
  final String? initialValue;
  final void Function(String)? onType;
  final void Function()? onTap;

  @override
  _TextEditBlockState createState() => _TextEditBlockState();
}

class _TextEditBlockState extends State<TextEditBlock> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.hideTitle != true)
            Text(' ${widget.title}', style: smallBoldedTitleBlack),
          SizedBox(
            height: 5,
          ),
          InputField(
            minLines: widget.minLines,
            keyboardType: widget.keyboardType,
            showCursor: widget.showCursor,
            icon: widget.icon,
            controller: widget.controller,
            onTap: widget.onTap,
            readonly: widget.readOnly,
            onType: widget.onType,
            initialvalue: widget.initialValue,
            maxCharacters: widget.maxCharacters,
            maxLines: widget.maxLines,
            hintText: widget.placeholder != null
                ? ' ${widget.placeholder}'
                : ' ${widget.title}',
          )
        ],
      ),
    );
  }
}
