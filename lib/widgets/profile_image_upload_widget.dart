import 'package:betabeta/constants/color_constants.dart';
import 'package:betabeta/widgets/global_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfileImageUploadWidget extends StatelessWidget {
  final String? imageUrl;

  bool loadingImage;

  /// This function is fired when an image is successfully taken from the Gallery or Camera.
  final void Function(PickedFile? imageFile)? onImagePicked;

  /// A function that fires when the cancel icon on the image-box is pressed.
  void Function()? onDelete;
  ProfileImageUploadWidget(
      {Key? key,
      this.imageUrl,
      this.onDelete,
      this.onImagePicked,
      required this.loadingImage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget _inBoxWidget = imageUrl != null
        ? Container(
            width: 200,
            child: Image.file(
              /// Changed this from networkImage to local path for now.
              File(imageUrl!),
              fit: BoxFit.cover,
            ),
          )
        : Center(
            child: loadingImage == false
                ? IconButton(
                    icon: Icon(Icons.add_rounded),
                    onPressed: () async {
                      await GlobalWidgets.showImagePickerDialogue(
                        context: context,
                        onImagePicked: onImagePicked,
                      );
                    },
                  )
                : SpinKitPumpingHeart(
                    color: mainAppColor02,
                  ));

    return Expanded(
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.25,
              child: Material(
                borderRadius: BorderRadius.circular(18.0),
                color: Colors.white,
                elevation: 2.0,
                shadowColor: Colors.grey[200],
                clipBehavior: Clip.antiAlias,
                child: _inBoxWidget,
              ),
            ),
          ),

          // This is the cancel button which will appear only when an image is present.
          if (imageUrl != null)
            Align(
              alignment: Alignment(0.80, -1.0),
              child: Material(
                clipBehavior: Clip.antiAlias,
                color: Colors.white,
                shape: CircleBorder(),
                elevation: 2.0,
                child: InkWell(
                  onTap: () {
                    onDelete!();
                  },
                  child: Padding(
                    padding: EdgeInsets.all(2.5),
                    child: Icon(
                      Icons.close,
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
