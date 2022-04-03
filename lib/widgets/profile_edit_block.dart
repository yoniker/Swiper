import 'package:betabeta/constants/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// Edit block that present the button in a different way

class ProfileEditBlock extends StatefulWidget {
  ProfileEditBlock({
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
  final void Function(String)? onType;
  final void Function()? onTap;

  @override
  _TextEditBlock2State createState() => _TextEditBlock2State();
}

class _TextEditBlock2State extends State<ProfileEditBlock> {
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
                Text(
                  ' ${widget.title}',
                  style: smallBoldedTitleBlack,
                  overflow: TextOverflow.fade,
                  maxLines: 1,
                ),
              ],
            ),
            Row(
              children: [
                widget.value == 0 || widget.value == '' || widget.value == null
                    ? Text(
                        'Add',
                        style: smallTitleLighterBlack,
                      )
                    : Container(
                        width: 150,
                        child: Text(
                          widget.value!,
                          textAlign: TextAlign.end,
                          style: smallBoldedTitleBlack,
                          maxLines: 1,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                        ),
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
