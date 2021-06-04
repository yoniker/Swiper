import 'package:betabeta/constants/color_constants.dart';
import 'package:betabeta/widgets/gradient_widget.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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

    Widget _child = Padding(
      padding: iconPad,
      child: Image.asset(
        imagePath,
        scale: scale,
      ),
    );

    // checks if the onTap parameter is null, this widget is returned as it is
    // else it is wrapped in a [GestureDetector] Widget to detect taps.
    if (onTap != null) {
      _child = GestureDetector(
        onTap: onTap,
        child: _child,
      );
    }

    return _child;
  }

  /// A Widget to build the block UI for each settings option.
  static Widget buildSettingsBlock(
      {

      /// The description of the settings Tile.
      String description,

      /// The child Widget to build as the body of the Settings block.
      Widget body,

      /// The title for the Settings Panel or block
      String title,

      /// An optional parameter to build the Title Widget.
      Widget top,

      ///
      EdgeInsetsGeometry outerPadding =
          const EdgeInsets.symmetric(horizontal: 2.0, vertical: 16.0),

      //
      EdgeInsetsGeometry titlePadding = const EdgeInsets.all(8.0),

      //
      EdgeInsetsGeometry bodyPadding =
          const EdgeInsets.fromLTRB(0.0, 0.0, 8.0, 0.0)
      //const EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
      }) {
    // assertion layer
    assert(
      top != null || description != null,
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
            constraints: BoxConstraints(
              minHeight: 50.0,
            ),
            decoration: BoxDecoration(
              color: darkCardColor,
            ),
            child: (top != null)
                ? top
                : Text.rich(
                    TextSpan(
                      children: <InlineSpan>[
                        if (title != null)
                          TextSpan(
                            text: '$title' + ' ',
                            style: _textStyle.copyWith(
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.2,
                            ),
                          ),
                        TextSpan(
                          text: description,
                        ),
                      ],
                    ),
                    style: _textStyle,
                  ),
          ),
          if (body != null)
            Container(
              padding: bodyPadding,
              decoration: BoxDecoration(
                color: whiteCardColor,
              ),
              child: body,
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

  static Future<void> showImagePickerDialogue({
    @required BuildContext context,
    String title = 'Select an Image source',

    /// This function is called immediately after the image is picked.
    /// Here you can make use of the [PickedFile] returned in whatever
    /// Network request or any other usage you may have in mind..
    Function(PickedFile) onImagePicked,
  }) async {
    PickedFile _imageFile;
    final ImagePicker _picker = ImagePicker();
    String _retrieveDataError;

    double _heightExtent = 0.355;

    // Called in-case the user interupts the file-picking process such as recieving a message and so o,
    // basically things that disturb the process in one way or the other.
    //
    Future<void> retrieveLostData() async {
      final LostData response = await _picker.getLostData();
      if (response.isEmpty) {
        return;
      }
      if (response.file != null) {
        if (response.type == RetrieveType.video) {
          return;
        } else if (response.type == RetrieveType.image) {
          if (_imageFile == null) {
            _imageFile = response.file;
          }
        }
      } else {
        _retrieveDataError = response.exception.code;

        print('Error retrieving lost Data! [ERROR-CODE]: $_retrieveDataError');
      }
    }

    void _onImageButtonPressed(ImageSource source) async {
      // Initiate the pick Image Function.
      try {
        final pickedFile = await _picker.getImage(source: source);
        if (pickedFile == null) {
          // Add the retrieve lost data function.
          retrieveLostData();
        }
        if (pickedFile != null) {
          _imageFile = pickedFile;
          if (onImagePicked != null) onImagePicked(_imageFile);

          return;
        }
      } catch (error) {
        // log
        print('Error picking Image! [ERROR]: $error');

        return;
      }
    }

    //
    // var _defaultTextStyle = TextStyle(
    //   color: Colors.black,
    //   fontFamily: 'Nunito',
    //   fontSize: 15,
    //   fontWeight: FontWeight.w500,
    // );

    // var _varryingTextStyle = TextStyle(
    //   color: Colors.black,
    //   fontFamily: 'Nunito',
    //   fontSize: 16,
    //   fontWeight: FontWeight.w700,
    // );

    String _resolveAlertTitle() {
      if (title != null && title != '') {
        return title;
      } else {
        return 'Image Selection';
      }
    }

    Widget imageSelectionItem({
      @required ImageSource source,
      String sourceName,
      @required Widget icon,
    }) {
      return InkWell(
        onTap: () {
          // Pop the dialogue and execute the image-picking Function.
          Navigator.of(context).pop();

          _onImageButtonPressed(source);
        },
        child: Container(
          margin: const EdgeInsets.all(8.0),
          padding: EdgeInsets.all(6.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(right: 12.0),
                child: GradientWidget(
                  gradient: mainColorGradientList,
                  child: icon,
                ),
              ),
              RichText(
                text: TextSpan(
                  style: defaultTextStyle,
                  children: [
                    TextSpan(
                      text: 'Pick from ',
                    ),
                    TextSpan(
                      text: '${sourceName ?? source.toString()}',
                      style: boldTextStyle,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    // show the image-picker dialogue
    await showDialog(
      useSafeArea: true,
      context: context,
      builder: (context) {
        return Container(
          margin: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height * _heightExtent,
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
                  heightFactor: 0.25,
                  widthFactor: 1.0,
                  alignment: Alignment.topCenter,
                  child: Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.all(4.5),
                    child: Text(
                      ' "${_resolveAlertTitle()}"\n ',
                      style: boldTextStyle,
                    ),
                  ),
                ),
                FractionallySizedBox(
                  heightFactor: 0.75,
                  widthFactor: 1.0,
                  alignment: Alignment.bottomCenter,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: [
                        imageSelectionItem(
                          source: ImageSource.camera,
                          sourceName: 'Camera',
                          icon: Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 24.0,
                          ),
                        ),
                        imageSelectionItem(
                          source: ImageSource.gallery,
                          sourceName: 'Gallery',
                          icon: Icon(
                            Icons.photo_library,
                            color: Colors.white,
                            size: 24.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    // return;
  }
}
