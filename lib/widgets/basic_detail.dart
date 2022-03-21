import 'package:betabeta/constants/beta_icon_paths.dart';
import 'package:betabeta/constants/color_constants.dart';
import 'package:betabeta/models/profile.dart';
import 'package:betabeta/widgets/pre_cached_image.dart';
import 'package:flutter/material.dart';

class BasicDetail extends StatelessWidget {
  final String? detailText;
  final Widget? detailIcon;

  const BasicDetail({Key? key, this.detailText, this.detailIcon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (detailText == null) {
      return SizedBox.shrink();
    }

    return Container(
      alignment: Alignment.centerRight,
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
              margin: EdgeInsets.only(left: 5), width: 50, child: detailIcon),
          SizedBox(width: 5.6),
          Expanded(
            child: Text(
              detailText!,
              style: defaultTextStyle,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
