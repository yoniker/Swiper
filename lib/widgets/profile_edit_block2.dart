import 'package:betabeta/constants/color_constants.dart';
import 'package:betabeta/widgets/onboarding/input_field.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// Edit block that present the button in a different way

class ProfileEditBlock2 extends StatefulWidget {
  ProfileEditBlock2({
    required this.title,
    this.value,
    this.onType,
    this.showArrow = true,
    this.iconColor = Colors.black,
    this.onTap,
    this.icon,
  });
  final String title;
  final IconData? icon;
  final Color iconColor;
  final String? value;
  final bool showArrow;
  void Function(String)? onType;
  void Function()? onTap;

  @override
  _TextEditBlockState createState() => _TextEditBlockState();
}

class _TextEditBlockState extends State<ProfileEditBlock2> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Icon(
                    widget.icon,
                    color: widget.iconColor,
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Text(' ${widget.title}', style: smallBoldedTitleBlack),
              ],
            ),
            Row(
              children: [
                widget.value == null
                    ? Text(
                        'Add',
                        style: smallTitleLighterBlack,
                      )
                    : Text(
                        widget.value!,
                        style: smallBoldedTitleBlack,
                        maxLines: 1,
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                      ),
                SizedBox(
                  width: 5,
                ),
                if (widget.showArrow)
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Icon(
                      FontAwesomeIcons.chevronRight,
                      color: Colors.black54,
                    ),
                  )
              ],
            )
          ],
        ),
      ),
    );
  }
}
