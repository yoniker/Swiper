import 'package:betabeta/constants/color_constants.dart';
import 'package:betabeta/widgets/global_widgets.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    Key key,
    @required this.title,
    @required this.icon,
    this.hasBackButton = true,
  })  : color = Colors.black,
        super(key: key);

  /// The `title` for this tile.
  final String title;

  /// This is the asset image path of the icons used.
  final Widget icon;

  /// Determine wheter to include a back-button at
  /// start of the tile (same as trailing icon in the original Appbar class).
  final bool hasBackButton;

  /// The Color of the title text. Defaults to `Colors.black`
  final Color color;

  @override
  Widget build(BuildContext context) {
      return SafeArea(
        child: Align(
              alignment: Alignment.topCenter,
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
                icon,
              ],
            ),
          ),
        ),
      );





  }

  @override
  Size get preferredSize {
    return  Size.fromHeight(kToolbarHeight);
  }
  }
