import 'package:betabeta/constants/beta_icon_paths.dart';
import 'package:betabeta/constants/color_constants.dart';
import 'package:betabeta/widgets/onboarding/conditional_parent_widget.dart';
import 'package:betabeta/widgets/pre_cached_image.dart';
import 'package:flutter/material.dart';

class BasicDetail extends StatelessWidget {
  final String? detailText;
  final Widget? detailIcon;
  final bool isBubble;

  const BasicDetail(
      {Key? key, this.detailText, this.detailIcon, this.isBubble = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (detailText == null) {
      return SizedBox.shrink();
    }

    return ConditionalParentWidget(
      conditionalBuilder: (Widget child) {
        return Container(
            child: child,
            padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 10),
            margin: EdgeInsets.symmetric(vertical: 4, horizontal: 2.5),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.05),
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            ));
      },
      condition: isBubble,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15.0, 0, 0, 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: isBubble != true ? MainAxisSize.max : MainAxisSize.min,
          children: [
            Container(
              width: isBubble != true ? 16 : 30,
              child: FittedBox(child: detailIcon),
            ),
            SizedBox(
              width: 15,
            ),
            Flexible(
              child: Text(
                detailText!,
                style: isBubble != true
                    ? boldTextStyle.copyWith(
                        color: Colors.black.withOpacity(0.6), fontSize: 15)
                    : smallBoldedTitleBlack.copyWith(
                        color: Colors.black.withOpacity(0.65), fontSize: 16),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
