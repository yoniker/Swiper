import 'package:betabeta/constants/color_constants.dart';
import 'package:betabeta/widgets/global_widgets.dart';
import 'package:betabeta/widgets/onboarding/conditional_parent_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

/// A customAppBar that can be used as a Widget outside the [Scaffold] and can also be used inside the
/// Material [Scaffold] as an [AppBar].
///
/// Note: You must either provide the "title" or the "customTitleBuilder" parameter and
/// the parameter "icon" cannot be null.
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    Key? key,
    this.title,
    this.trailing,
    this.titleTextColor = Colors.black,
    this.customTitle,
    this.backColor = Colors.black87,
    this.backgroundColor = backgroundThemeColor,
    this.elevation = 1,
    this.centerTitle = false,
    this.hasTopPadding = false,
    this.hasBackButton = true,
    this.hasVerticalPadding = true,
    this.trailingPad = 5.0,
    this.centerWidget,
  })  :
        // add necessary assertions.
        //assert(trailing != null, 'The parameter trailing cannot be null'),
        assert((title == null) != (customTitle == null),
            'One of "title" and "customTitleBuilder" must be null, You can only specify one of the two!'),
        super(key: key);

  CustomAppBar.subPage({
    required String subPageTitle,
    this.titleTextColor = Colors.blue,
    this.centerTitle = false,
    this.backgroundColor = Colors.white,
    this.hasBackButton = true,
    this.hasTopPadding = false,
    this.elevation = 1,
    this.backColor = Colors.black87,
    this.trailingPad = 5.0,
    this.hasVerticalPadding = true,
    this.centerWidget,
  })  : this.trailing = Padding(
          padding: EdgeInsets.only(left: 10.0),
          child: Text(
            subPageTitle,
            style: TextStyle(
              color: titleTextColor,
              fontSize: 22,
              fontFamily: 'Nunito',
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        this.title = '',
        this.customTitle = SizedBox.shrink();

  /// The `title` for this tile.
  final String? title;

  /// This denotes the icon widget that is placed in the Appbar .
  final Widget? trailing;

  /// Determine whether to include a back-button at
  /// start of the tile (same as trailing icon in the original Appbar class).
  final bool hasBackButton;

  /// The Color of the title text. Defaults to `Colors.black`
  final Color titleTextColor;

  final Color backColor;

  /// Determines whether to add a Padding to the Top of the AppBar in a case where it is used
  /// as the `appBar` parameter of the [Scaffold] widget.
  final bool hasTopPadding;

  /// Use this to build a custom title Widget for the [CustomAppbar].
  final Widget? customTitle;

  final Widget? centerWidget;

  final double elevation;

  /// If the Appbar should have a background color we can use this.
  final Color backgroundColor;

  /// This is an optional Callback called immediately the backbutton (if enabled) is clicked.
  ///
  /// You can pass in this parameter to override the default pop behavour of the backbutton
  /// when pressed.
  ///
  /// Note: You will have to call the pop function yourself if you intend to pop the Current Route when
  /// the back-Button is clicked.
  ///
  /// Note: if `hasBackButton` is false or null, this function won't fire as the backbutton will
  /// be hiddden.

  /// This determines how much padding (in pixels) to add to the back to the trialing widget.
  ///
  /// The defualt is 5(px).
  final double trailingPad;

  final bool centerTitle;

  final bool hasVerticalPadding;

  @override
  Widget build(BuildContext context) {
    // This holds the value for the topPadding of the AppBar.
    double topPadding = MediaQuery.of(context).viewPadding.top;

    return Material(
      color: backgroundColor,
      elevation: elevation,
      child: Container(
        margin: (hasTopPadding)
            ? EdgeInsets.only(top: topPadding)
            : EdgeInsets.zero,
        padding: hasVerticalPadding == true
            ? EdgeInsets.symmetric(horizontal: 4.0, vertical: 5.0)
            : null,
        child: Stack(children: [
          if (centerWidget != null) centerWidget!,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  if (hasBackButton)
                    InkWell(
                      splashColor: mainAppColor02.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8.0),
                      onTap: () {
                        Get.back();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Icon(
                          FontAwesomeIcons.chevronLeft,
                          color: backColor,
                          size: 22,
                        ),
                      ),
                    ),
                  customTitle ??
                      Padding(
                        padding: EdgeInsets.only(left: 10.0),
                        child: Text(
                          title!,
                          style: TextStyle(
                            color: titleTextColor,
                            fontSize: 18,
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(right: trailingPad),
                child: trailing,
              ),
              // show App Logo.
            ],
          ),
        ]),
      ),
    );
  }

  @override
  Size get preferredSize {
    return Size.fromHeight(kToolbarHeight);
  }
}
