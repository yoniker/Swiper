import 'dart:io';

import 'package:betabeta/constants/beta_icon_paths.dart';
import 'package:betabeta/constants/color_constants.dart';
import 'package:betabeta/models/settings_model.dart';
import 'package:betabeta/services/networking.dart';
import 'package:betabeta/utils/mixins.dart';
import 'package:betabeta/widgets/custom_app_bar.dart';
import 'package:betabeta/widgets/global_widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reorderables/reorderables.dart';

///
class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with MountedStateMixin<ProfileScreen> {
  // --> All this information should be added to the data model.
  // this will be pre-filled with data from the server.
  bool _showPhoto = false;

  String _aboutMe;

  String _jobTitle;

  String _company;

  NetworkHelper networkHelper;

  List<String> _profileImagesUrls = [];

  @override
  initState() {
    super.initState();

    // initialize the NetworkHelper instance.
    //
    // TODO(Yonikeren): You do know that whenever you work with [NetworkHelper()..do something] you are creating a
    // new instance of the class and of-course whatever field or variable present in the class as well.
    // that's why is always a good idea to instantiate a data-class via this form of declaration.
    // so we don't end up with uneccessary duplicates whenever we create a new instance.
    //
    // also there are some FUnctions I will suggest you make static since they don't alter or make changes to
    // any instance variable.
    networkHelper = NetworkHelper();

    // this makes sure that if the state is not yet mounted, we don't end up calling setState
    // but instead push the function forward to the addPostFrameCallback function.
    mountedLoader(() => _syncFromServer());
  }

  /// builds the toggle tile.
  Widget _buildToggleTile({
    @required String title,
    @required bool value,
    void Function(bool) onToggle,
  }) {
    return GlobalWidgets.buildSettingsBlock(
      top: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: boldTextStyle,
          ),
          CupertinoSwitch(
            value: value,
            activeColor: colorBlend01,
            onChanged: onToggle,
          ),
        ],
      ),
    );
  }

  /// A Box that Displays the currently available user profile images.
  Widget _pictureBox({
    String imageUrl,

    /// This function is fired when an image is successfully taken from the Gallery or Camera.
    void Function(PickedFile imageFile) onImagePicked,

    /// A function that fires when the cancel icon on the image-box is pressed.
    void Function() onDelete,
  }) {
    Widget _child = imageUrl != null
        ? Image.network(
            imageUrl,
            fit: BoxFit.cover,
          )
        : Center(
            child: IconButton(
              icon: Icon(Icons.add_rounded),
              onPressed: () async {
                await GlobalWidgets.showImagePickerDialogue(
                  context: context,
                  onImagePicked: onImagePicked,
                );
              },
            ),
          );

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
              child: _child,
            ),
          ),

          // This is the cancel button which will appear only when an image is present.
          if (imageUrl != null)
            Align(
              alignment: Alignment(1.2, -1.2),
              child: Material(
                clipBehavior: Clip.antiAlias,
                color: Colors.white,
                shape: CircleBorder(),
                elevation: 2.0,
                child: InkWell(
                  onTap: () {
                    if (onDelete != null) onDelete();
                  },
                  child: Padding(
                    padding: EdgeInsets.all(2.5),
                    child: GlobalWidgets.assetImageToIcon(
                      BetaIconPaths.cancelIconPath,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Profile',
        hasTopPadding: true,
        showAppLogo: false,
        trailing: GlobalWidgets.assetImageToIcon(
          BetaIconPaths.inactiveProfileTabIconPath,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            children: [
              Center(
                child: CircleAvatar(
                  backgroundColor: Colors.grey[200],
                  backgroundImage: CachedNetworkImageProvider(
                      SettingsData().facebookProfileImageUrl),
                  radius: 50.5,
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Material(
                      clipBehavior: Clip.antiAlias,
                      color: Colors.white,
                      shape: CircleBorder(),
                      elevation: 2.0,
                      child: InkWell(
                        onTap: () async {
                          // show the imagePicker Dialogue.
                          await GlobalWidgets.showImagePickerDialogue(
                            context: context,
                            onImagePicked: (image) async {
                              GlobalWidgets.showLoadingIndicator(context: context);

                              // log
                              print(
                                  'The Path to the New Profile Image is: ${image.path}');

                              GlobalWidgets.hideLoadingIndicator(context);
                            },
                          );
                        },
                        child: Padding(
                          padding: EdgeInsets.all(2.5),
                          child: GlobalWidgets.assetImageToIcon(
                            BetaIconPaths.editProfieImageIconPath,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              ReorderableWrap(
                needsLongPressDraggable: false,
                onReorder: (int oldIndex, int newIndex) async {
                  if (newIndex >= _profileImagesUrls.length) {
                    return;
                  }
                  await NetworkHelper().swapProfileImages(
                    oldIndex,
                    newIndex,
                  ); //I don't see a need to wait for the server;
                  setState(() {
                    String temp = _profileImagesUrls[
                        oldIndex]; //Swap the elements (I wish there was a native way to do that!)
                    _profileImagesUrls[oldIndex] = _profileImagesUrls[newIndex];
                    _profileImagesUrls[newIndex] = temp;
                  });
                },
                direction: Axis.horizontal,
                alignment: WrapAlignment.spaceAround,
                runAlignment: WrapAlignment.spaceAround,
                spacing: 12.0,
                runSpacing: 12.0,
                children: List<Widget>.generate(
                  6,
                  (index) {
                    final url = index < _profileImagesUrls.length
                        ? networkHelper
                            .getProfileImageUrl(_profileImagesUrls[index])
                        : null;
                    return ReorderableWidget(
                      key: Key('#reorderable_profile$index'),
                      reorderable: index < _profileImagesUrls.length,
                      child: _pictureBox(
                        imageUrl: url,
                        onDelete: () async {
                          GlobalWidgets.showLoadingIndicator(context: context);

                          await networkHelper.deleteProfileImage(index);
                          _syncFromServer();

                          GlobalWidgets.hideLoadingIndicator(context);
                        },
                        onImagePicked: (image) async {
                          GlobalWidgets.showLoadingIndicator(context: context);

                          await networkHelper
                              .postProfileImage(File(image.path));
                          _syncFromServer();

                          GlobalWidgets.hideLoadingIndicator(context);
                        },
                      ),
                    );
                  },
                ),
                // children: List<Widget>.generate(
                //   _profileImagesUrls.length + 1,
                //   (index) {
                //     final url = index < _profileImagesUrls.length
                //         ? NetworkHelper()
                //             .getProfileImageUrl(_profileImagesUrls[index])
                //         : null;
                //     return ReorderableWidget(
                //       reorderable: index < _profileImagesUrls.length,
                //       child: _pictureBox(
                //           imageUrl: url,
                //           onDelete: () {
                //             NetworkHelper().deleteProfileImage(index).then((_) {
                //               _syncFromServer();
                //             });
                //           },
                //           onImagePicked: (image) {
                //             NetworkHelper()
                //                 .postProfileImage(File(image.path))
                //                 .then((_) {
                //               _syncFromServer();
                //             });
                //           }),
                //     );
                //   },
                // ),
              ),
              _buildToggleTile(
                title: 'Show photo',
                value: _showPhoto,
                onToggle: (val) {
                  setState(() {
                    _showPhoto = val;
                  });
                },
              ),
              TextEditBlock(
                title: 'About Me',
                placeholder: 'About Me',
                text: _aboutMe,
                onCloseTile: () {
                  // do something.
                },
                onChanged: (val) {
                  // do something.
                },
              ),
              TextEditBlock(
                title: 'Job Title',
                placeholder: 'Job Title',
                maxLine: 1,
                text: _jobTitle,
                onCloseTile: () {
                  // do something.
                },
                onChanged: (val) {
                  // do something.
                },
              ),
              TextEditBlock(
                title: 'Company',
                placeholder: 'Company',
                maxLine: 1,
                text: _company,
                onCloseTile: () {
                  // do something.
                },
                onChanged: (val) {
                  // do something.
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _syncFromServer() async {
    final _resp = await networkHelper.getProfileImages();

    setStateIfMounted(() {
      _profileImagesUrls = _resp;
    });
  }
}

/// The TextEditBlock used in the Profile Settings page.
class TextEditBlock extends StatefulWidget {
  TextEditBlock({
    Key key,
    @required this.title,
    this.text,
    this.placeholder,
    this.maxLine,
    this.onOpen,
    this.onCloseTile,
    this.onStatusChanged,
    this.onChanged,
    this.onSubmitted,
    this.controller,
  }) : super(key: key);

  final String title;
  final String text;
  final String placeholder;
  final int maxLine;
  final void Function() onOpen;
  final void Function() onCloseTile;
  final TextEditingController controller;

  /// This Function is fired when the block is opened or closed.
  ///
  /// A value of `true` is returned when the block is opened and a
  /// value of `false` if otherwise.
  final void Function(bool) onStatusChanged;
  final void Function(String) onChanged;
  final void Function(String) onSubmitted;

  @override
  _TextEditBlockState createState() => _TextEditBlockState();
}

class _TextEditBlockState extends State<TextEditBlock> {
  TextEditingController _resolvedTextEditingController;

  bool _isOpened;

  void toggle([bool force]) {
    setState(() {
      _isOpened = force ?? !_isOpened;
    });
  }

  @override
  void initState() {
    _resolvedTextEditingController =
        widget.controller ?? TextEditingController(text: widget.text ?? '');

    _isOpened = widget.text != null;

    super.initState();
  }

  @override
  void dispose() {
    if (widget.controller == null) _resolvedTextEditingController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GlobalWidgets.buildSettingsBlock(
      bodyPadding: EdgeInsets.zero,
      top: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.title,
            style: boldTextStyle,
          ),
          InkWell(
            customBorder: CircleBorder(),
            onTap: () {
              setState(() {
                _isOpened = !_isOpened;
              });

              // determine whether or not the [TextEditBlock] is expanded or not.
              if (_isOpened == true) {
                if (widget.onOpen != null) widget.onOpen.call();
              } else {
                if (widget.onCloseTile != null) widget.onCloseTile.call();
              }

              if (widget.onStatusChanged != null)
                widget.onStatusChanged(_isOpened);
            },
            child: GlobalWidgets.assetImageToIcon(
              BetaIconPaths.editImageIconPath02,
              iconPad: EdgeInsets.all(12.0),
            ),
          ),
        ],
      ),
      body: AnimatedContainer(
        duration: Duration(milliseconds: 1200),
        child: _isOpened
            ? CupertinoTextField.borderless(
                controller: _resolvedTextEditingController,
                placeholder: widget.placeholder,
                placeholderStyle:
                    boldTextStyle.copyWith(color: Colors.grey[300]),
                onChanged: widget.onChanged,
                onSubmitted: widget.onSubmitted,
                maxLines: widget.maxLine,
                style: defaultTextStyle,
              )
            : SizedBox.shrink(),
      ),
    );
  }
}
