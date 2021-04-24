import 'package:betabeta/constants/beta_icon_paths.dart';
import 'package:betabeta/constants/color_constants.dart';
import 'package:betabeta/widgets/global_widgets.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    Key key,
    @required this.title,
    @required this.icon,
    this.hasTopPadding = false,
    this.showAppLogo = true,
    this.hasBackButton = true,
  })  : color = Colors.black,
        super(key: key);

  /// The `title` for this tile.
  final String title;

  /// This denotes the icon widget that is placed in the Appbar .
  final Widget icon;

  /// Determine whether to include a back-button at
  /// start of the tile (same as trailing icon in the original Appbar class).
  final bool hasBackButton;

  /// The Color of the title text. Defaults to `Colors.black`
  final Color color;

  /// Determines whether to add a Padding to the Top of the AppBar in a case where it is used
  /// as the `appBar` parameter of the [Scaffold] widget.
  final bool hasTopPadding;

  /// Whether to show the App's Logo at the center of the App Bar.
  /// Must not be null.
  final bool showAppLogo;

  @override
  Widget build(BuildContext context) {
    // This holds the value for the topPadding of the AppBar.
    double topPadding = MediaQuery.of(context).viewPadding.top;

    return Padding(
      padding: (hasTopPadding) ? EdgeInsets.only(top: topPadding) : EdgeInsets.zero,
      child: Container(
        margin: EdgeInsets.only(top: 5.0),
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
            // show App Logo.
            if (showAppLogo)
              GlobalWidgets.imageToIcon(BetaIconPaths.appLogoIcon),
            icon,
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize {
    return Size.fromHeight(kToolbarHeight);
  }
}
