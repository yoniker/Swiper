import 'package:betabeta/constants/color_constants.dart';
import 'package:flutter/material.dart';

/// A collection of Global Widgets to be used in various parts of the App.
class GlobalWidgets {
  /// A global widget that is used to render respective asset images
  /// as icons.
  static Widget imageToIcon(
    String imagePath, {
    double scale = 4.0,

    /// The Padding to be applied to the outter bounds of `this`
    /// [ImageToIcon] Widget.
    EdgeInsets iconPad = const EdgeInsets.all(7.5),

    /// A callback that fires when this widget is tapped.
    void Function() onTap,
  }) {
    // ASSERTION LAYER.
    assert(
      iconPad != null,
      'The parameter "iconPad" cannot be null, please provide an acceptable value for the "iconPad" parameter',
    );

    // check if scale is null and assign it a default value of 4.0
    scale ??= 4.0;

    var child = Padding(
      padding: iconPad,
      child: Image.asset(
        imagePath,
        scale: scale,
      ),
    );

    // checks if the onTap parameter is null, this widget is returned as it is
    // else it is wrapped in a [GestureDetector] Widget to detect taps.
    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: child,
      );
    } else {
      return child;
    }
  }

  /// A Widget to build the block UI for each settings option.
  static Widget buildSettingsBlock(
      {

      /// The description of the settings Tile.
      String description,

      /// The child Widget to build as the body of the Settings block.
      @required Widget child,

      /// The title for the Settings Panel or block
      String title,

      /// An optional parameter to build the Title Widget.
      Widget leading,

      ///
      EdgeInsetsGeometry outerPadding =
          const EdgeInsets.symmetric(horizontal: 2.0, vertical: 16.0),

      //
      EdgeInsetsGeometry titlePadding = const EdgeInsets.all(8.0),

      //
      EdgeInsetsGeometry widgetPadding =
          const EdgeInsets.fromLTRB(0.0, 0.0, 8.0, 0.0)
      //const EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
      }) {
    // assertion layer
    assert(
      leading != null || description != null,
      '''One of `description` or `titleBuilder` must be specified. 
      When the two are specified, the title Widget is given Priority.''',
    );

    var _textStyle = TextStyle(
      color: darkTextColor,
      fontFamily: 'Nunito',
      fontSize: 15,
      fontWeight: FontWeight.w500,
    );

    return Container(
      margin: outerPadding,
      decoration: BoxDecoration(
        border: Border.all(
          color: darkCardColor,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(12.0),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: titlePadding,
            decoration: BoxDecoration(
              color: darkCardColor,
            ),
            child: (leading != null)
                ? leading
                : Text.rich(
                    TextSpan(
                      children: <InlineSpan>[
                        if (title != null)
                          TextSpan(
                            text: '$title' + ' ',
                            style: _textStyle.copyWith(
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.2),
                          ),
                        TextSpan(
                          text: description,
                        ),
                      ],
                    ),
                    style: _textStyle,
                  ),
          ),
          Container(
            padding: widgetPadding,
            decoration: BoxDecoration(
              color: whiteCardColor,
            ),
            child: child,
          ),
        ],
      ),
    );
  }

  /// A widget to show a simple Alert Dialogue.
  static void showAlertDialogue(
    BuildContext context, {
    @required String message,
    String title,
    void onTap,
  }) async {
    //
    var _defaultTextStyle = TextStyle(
      color: Colors.black,
      fontFamily: 'Nunito',
      fontSize: 15,
      fontWeight: FontWeight.w500,
    );

    var _varryingTextStyle = TextStyle(
      color: Colors.black,
      fontFamily: 'Nunito',
      fontSize: 16,
      fontWeight: FontWeight.w700,
    );

    String _resolveAlertTitle() {
      if (title != null && title != '') {
        return title;
      } else {
        return 'Alert!';
      }
    }

    var status = await showDialog<void>(
      useSafeArea: true,
      context: context,
      builder: (context) {
        return Container(
          margin: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height * 0.375,
            horizontal: MediaQuery.of(context).size.width * 0.1,
          ),
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height * 0.375,
            maxHeight: MediaQuery.of(context).size.height * 0.55,
            minWidth: MediaQuery.of(context).size.width * 0.75,
            maxWidth: MediaQuery.of(context).size.width * 0.95,
          ),
          child: Material(
            borderRadius: BorderRadius.circular(15),
            elevation: 1.0,
            color: darkCardColor,
            child: Stack(
              fit: StackFit.expand,
              // mainAxisAlignment: MainAxisAlignment.spaceAround,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FractionallySizedBox(
                  heightFactor: 0.7,
                  widthFactor: 1.0,
                  alignment: Alignment.topCenter,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: _defaultTextStyle,
                          children: <InlineSpan>[
                            TextSpan(
                              text: ' "${_resolveAlertTitle()}"\n ',
                              style: _varryingTextStyle,
                            ),
                            TextSpan(
                              text: ' $message ',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                FractionallySizedBox(
                  heightFactor: 0.3,
                  widthFactor: 1.0,
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateColor.resolveWith(
                            (states) => Colors.white),
                      ),
                      onPressed: () {
                        // user has canceled the delete action.
                        Navigator.of(context).pop<void>();
                        // return false;
                      },
                      child: Text(
                        'Ok',
                        style: _varryingTextStyle.copyWith(color: colorBlend02),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    return status;
  }
}
