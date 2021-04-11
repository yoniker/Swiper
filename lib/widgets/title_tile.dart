import 'package:betabeta/constants/color_constants.dart';
import 'package:betabeta/widgets/global_widgets.dart';
import 'package:flutter/material.dart';

class TitleTile extends StatelessWidget {
  const TitleTile({
    Key key,
    @required this.title,
    @required this.iconURI,
    this.isReversed = false,
    this.hasBackButton = true,
  })  : color = Colors.black,
        super(key: key);

  /// The `title` for this tile.
  final String title;

  /// This is the asset image path of the icons used.
  final String iconURI;

  /// Determine wheter to include a back-button at
  /// start of the tile (same as trailing icon in the original Appbar class).
  final bool hasBackButton;

  /// Determine whether the title of the `TitleTile` should
  /// be placed aligned to the Left or Right.
  final bool isReversed;

  /// The Color of the title text. Defaults to `Colors.black`
  final Color color;

  @override
  Widget build(BuildContext context) {
    //
    Widget _reversed() {
      return Container(
        margin: EdgeInsets.symmetric(vertical: 12.0),
        padding: EdgeInsets.symmetric(horizontal: 5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (hasBackButton)
              InkWell(
                borderRadius: BorderRadius.circular(8.0),
                onTap: () {
                  // Pop the current page.
                  Navigator.of(context).pop();
                },
                child: GlobalWidgets.imageToIcon(
                  'assets/images/back_arrow.png',
                ),
              ),
            Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Text(
                title,
                style: TextStyle(
                  color: color,
                  fontSize: 22,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      );
    }

    //
    Widget _buildStandardTile() {
      return Container(
        margin: EdgeInsets.symmetric(vertical: 12.0),
        padding: EdgeInsets.symmetric(horizontal: 5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (hasBackButton)
                  InkWell(
                    splashColor: colorBlend02.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8.0),
                    onTap: () {
                      // Pop the current context.
                      Navigator.of(context).pop();
                    },
                    child: GlobalWidgets.imageToIcon(
                      'assets/images/back_arrow.png',
                    ),
                  ),
                Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Text(
                    title,
                    style: TextStyle(
                      color: color,
                      fontSize: 22,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            GlobalWidgets.imageToIcon(iconURI),
          ],
        ),
      );
    }

    if (isReversed) {
      return _reversed();
    } else {
      return _buildStandardTile();
    }
  }
}