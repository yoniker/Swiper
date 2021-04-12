import 'package:betabeta/constants/color_constants.dart';
import 'package:flutter/material.dart';


/// A collection of Global Widgets to be used in various parts of the App.
class GlobalWidgets {
  /// A global widget that is uded to render respective asset images
  /// as icons.
  static Widget imageToIcon(String imagePath, {double scale}) {
    // check if scale is null and assign it a default value of 4.0
    scale ??= 4.0;

    return Padding(
      padding: EdgeInsets.all(7.5),
      child: Image.asset(
        imagePath,
        scale: scale,
      ),
    );
  }

  /// A Widget to build the block UI for each settings option.
  static Widget buildSettingsBlock({
    /// The description of the settings Tile.
    String description,

    /// The child Widget to build as the body of the Settings block.
    @required Widget child,

    /// The catch phrase for the Settings Panel or block
    String catchPhrase,

    /// An optional parameter to build the Title Widget.
    Widget title,

    ///
    EdgeInsetsGeometry outterPadding =
    const EdgeInsets.symmetric(horizontal: 2.0, vertical: 16.0),

    //
    EdgeInsetsGeometry tittlePadding = const EdgeInsets.all(8.0),

    //
    EdgeInsetsGeometry widgetPadding =
    const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
  }) {
    // assertion layer
    assert(
    title != null || description != null,
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
      margin: outterPadding,
      decoration: BoxDecoration(
        border: Border.all(
          color: darkCardColor,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(12.0),
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: tittlePadding,
            decoration: BoxDecoration(
              color: darkCardColor,
            ),
            child: (title != null)
                ? title
                : Text.rich(
              TextSpan(
                children: <InlineSpan>[
                  if (catchPhrase != null)
                    TextSpan(
                      // Add a quote and a string to the catchPhrases [TextSpan] `text`.
                      text: '$catchPhrase' + ' ',
                      style: _textStyle.copyWith(
                          fontWeight: FontWeight.w700),
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                RichText(
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
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 8.0,
                  ),
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
              ],
            ),
          ),
        );
      },
    );

    return status;
  }
}