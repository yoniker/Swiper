import 'package:betabeta/constants/onboarding_consts.dart';
import 'package:betabeta/screens/onboarding/onboarding_flow_controller.dart';
import 'package:betabeta/widgets/onboarding/onboarding_column.dart';
import 'package:betabeta/widgets/onboarding/profile_image_widget.dart';
import 'package:betabeta/widgets/onboarding/progress_bar.dart';
import 'package:betabeta/widgets/onboarding/rounded_button.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reorderables/reorderables.dart';

import '../../constants/beta_icon_paths.dart';
import '../../services/new_networking.dart';
import '../../services/settings_model.dart';
import '../../widgets/global_widgets.dart';
import '../../widgets/listener_widget.dart';

class UploadImagesOnboardingScreen extends StatefulWidget {
  static const String routeName = '/uploadPicturesScreen';

  const UploadImagesOnboardingScreen({Key? key}) : super(key: key);

  @override
  _UploadImagesOnboardingScreenState createState() =>
      _UploadImagesOnboardingScreenState();
}

class _UploadImagesOnboardingScreenState
    extends State<UploadImagesOnboardingScreen> {
  String imageUrl = '';
  String imageUrl2 = '';

  bool _uploadingImage = false;

  void getFilePath(PickedFile? imagePicked) {
    if (imagePicked == null) {
      return;
    }
    if (imageUrl.isEmpty) {
      imageUrl = imagePicked.path;
    } else {
      imageUrl2 = imagePicked.path;
    }
    setState(() {});
  }

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
                                    Navigator.pop(context);
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
                                    Navigator.pop(context);
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

  @override
  Widget build(BuildContext context) {
    return ListenerWidget(
      notifier: SettingsData.instance,
      builder: (context) {
        String? _mainProfileImage;
        List<String> _profileImagesUrls =
            SettingsData.instance.profileImagesUrls;

        if (_profileImagesUrls.isNotEmpty) {
          _mainProfileImage = _profileImagesUrls.first;
        }

        final ImageProvider _profileImage = (_mainProfileImage == null
            ? AssetImage(
                BetaIconPaths.defaultProfileImagePath01,
              )
            : ExtendedNetworkImageProvider(
                NewNetworkService.getProfileImageUrl(_mainProfileImage),
                cache: true,
              )) as ImageProvider<Object>;
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: OnboardingColumn(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    ProgressBar(
                      page: 8,
                    ),
                    const Text(
                      'Add two photos of yourself',
                      style: kTitleStyle,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                        'Let\'s start with your first photos. You can change and add more later.',
                        style: kSmallInfoStyle),
                    const SizedBox(
                      height: 30,
                    ),
                    Center(
                      child: ReorderableWrap(
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
                            _profileImagesUrls[oldIndex] =
                                _profileImagesUrls[newIndex];
                            _profileImagesUrls[newIndex] = temp;

                            setState(() {
                              SettingsData.instance.profileImagesUrls =
                                  _profileImagesUrls;
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
                                    reorderable:
                                        index < _profileImagesUrls.length,
                                    child: _pictureBox(
                                        imageUrl: index <
                                                _profileImagesUrls.length
                                            ? NewNetworkService
                                                .getProfileImageUrl(
                                                    _profileImagesUrls[index])
                                            : null,
                                        onDelete: () async {
                                          if (_profileImagesUrls.length <
                                              index + 1) {
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
                                  ))),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    RoundedButton(
                        name: 'Add from Facebook',
                        icon: Icons.facebook,
                        color: const Color(0xFF0060DB),
                        onTap: () {})
                  ],
                ),
                RoundedButton(
                  name: 'NEXT',
                  onTap: () {
                    Get.offAllNamed(OnboardingFlowController.nextRoute(
                        UploadImagesOnboardingScreen.routeName));
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _syncProfileImagesFromServer() async {
    var profileImagesUrls =
        await NewNetworkService.instance.getCurrentProfileImagesUrls();
    if (profileImagesUrls != null) {
      SettingsData.instance.profileImagesUrls = profileImagesUrls;
    }
  }
}
