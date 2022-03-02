import 'package:betabeta/services/new_networking.dart';
import 'package:betabeta/services/settings_model.dart';
import 'package:betabeta/widgets/global_widgets.dart';
import 'package:betabeta/widgets/listener_widget.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reorderables/reorderables.dart';

class ImagesUploadwidget extends StatefulWidget {
  const ImagesUploadwidget({Key? key}) : super(key: key);

  @override
  _ImagesUploadwidgetState createState() => _ImagesUploadwidgetState();
}

class _ImagesUploadwidgetState extends State<ImagesUploadwidget> {
  Widget _pictureBox({
    String? imageUrl,

    /// This function is fired when an image is successfully taken from the Gallery or Camera.
    void Function(PickedFile? imageFile)? onImagePicked,

    /// A function that fires when the cancel icon on the image-box is pressed.
    void Function()? onDelete,
  }) {
    Widget _inBoxWidget = imageUrl != null
        ? GestureDetector(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (_) => Dialog(
                        alignment: Alignment.bottomCenter,
                        backgroundColor: Colors.transparent,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.8),
                              borderRadius: BorderRadius.all(
                                Radius.circular(30),
                              )),
                          height: 120,
                          child: Column(
                            children: [
                              TextButton(
                                  onPressed: () {
                                    Get.back();
                                    onDelete!();
                                  },
                                  child: Text(
                                    'Delete Picture',
                                    style: TextStyle(
                                        color: Colors.red, fontSize: 18),
                                  )),
                              Divider(),
                              TextButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  child: const Text(
                                    'Cancel',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 18),
                                  )),
                            ],
                          ),
                        ),
                      ));
            },
            child: ExtendedImage.network(
              imageUrl,
              fit: BoxFit.cover,
              cache: true,
            ),
          )
        : Center(
            child: _uploadingImage == false
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
                    color: Colors.red,
                  ));

    return Container(
      height: 125,
      width: 85,
      child: Stack(
        children: [
          Container(
            height: 125,
            width: 85,
            child: Material(
              borderRadius: BorderRadius.circular(18.0),
              color: Colors.white,
              elevation: 2.0,
              shadowColor: Colors.grey[200],
              clipBehavior: Clip.antiAlias,
              child: _inBoxWidget,
            ),
          ),

          // This is the cancel button which will appear only when an image is present.
        ],
      ),
    );
  }

  List<String> _profileImagesUrls = SettingsData.instance.profileImagesUrls;
  bool _uploadingImage = false;
  @override
  Widget build(BuildContext context) {
    return ListenerWidget(
        notifier: SettingsData.instance,
        builder: (context) {
          _profileImagesUrls = SettingsData.instance.profileImagesUrls;
          return ReorderableWrap(
              needsLongPressDraggable: false,
              onReorder: (int oldIndex, int newIndex) {
                if (newIndex >= _profileImagesUrls.length) {
                  return;
                }
                NewNetworkService.instance.swapProfileImages(
                    _profileImagesUrls[oldIndex],
                    _profileImagesUrls[
                        newIndex]); //I don't see a need to wait for the server;
                String temp = _profileImagesUrls[
                    oldIndex]; //Swap the elements (I wish there was a native way to do that!)
                _profileImagesUrls[oldIndex] = _profileImagesUrls[newIndex];
                _profileImagesUrls[newIndex] = temp;

                setState(() {
                  SettingsData.instance.profileImagesUrls = _profileImagesUrls;
                });
              },
              direction: Axis.horizontal,
              alignment: WrapAlignment.spaceAround,
              runAlignment: WrapAlignment.spaceAround,
              spacing: 12.0,
              runSpacing: 12.0,
              children: List<Widget>.generate(
                  _profileImagesUrls.length + 1,
                  (index) => ReorderableWidget(
                        key: Key('#reorderable'),
                        reorderable: index < _profileImagesUrls.length,
                        child: _pictureBox(
                            imageUrl: index < _profileImagesUrls.length
                                ? NewNetworkService.getProfileImageUrl(
                                    _profileImagesUrls[index])
                                : null,
                            onDelete: () async {
                              if (_profileImagesUrls.length < index + 1) {
                                return;
                              }
                              await NewNetworkService.instance
                                  .deleteProfileImage(
                                      _profileImagesUrls[index]);
                              await _syncProfileImagesFromServer();
                            },
                            onImagePicked: (pickedImage) async {
                              setState(() {
                                _uploadingImage = true;
                              });
                              await NewNetworkService.instance
                                  .postProfileImage(pickedImage!);
                              setState(() {
                                _uploadingImage = false;
                              });
                              await _syncProfileImagesFromServer();
                            }),
                      )));
        });
  }

  Future<void> _syncProfileImagesFromServer() async {
    var profileImagesUrls =
        await NewNetworkService.instance.getCurrentProfileImagesUrls();
    if (profileImagesUrls != null) {
      SettingsData.instance.profileImagesUrls = profileImagesUrls;
    }
  }
}
