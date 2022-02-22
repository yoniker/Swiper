import 'package:betabeta/constants/beta_icon_paths.dart';
import 'package:betabeta/constants/color_constants.dart';
import 'package:betabeta/services/networking.dart';
import 'package:betabeta/services/settings_model.dart';
import 'package:betabeta/utils/mixins.dart';
import 'package:betabeta/widgets/custom_app_bar.dart';
import 'package:betabeta/widgets/global_widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reorderables/reorderables.dart';

/// The Implemntation of the Profile-screen
class ProfileDetailsScreen extends StatefulWidget {
  static const String routeName = '/profile_details';

  // Since we have loaded the image prior at the profile_tab
  // we can just pass it down to the profile_screen instead of having the
  // image display widgets wait for another fetch from the network.
  //
  // Note we still call the "getProfileImage" method but we get the Profile to load faster.
  //
  // Also, if non is provided it will just go on with its normal process of loading and waiting for the images
  // which means this route can be pushed to satck without worrying about the "imageUrls" parameter since its optional.
  final List<String>? imageUrls;

  ProfileDetailsScreen({Key? key})
      : imageUrls = Get.arguments,
        super(key: key);

  @override
  _ProfileDetailsScreenState createState() => _ProfileDetailsScreenState();
}

class _ProfileDetailsScreenState extends State<ProfileDetailsScreen>
    with MountedStateMixin {
  // --> All this information should be added to the data model.
  // this will be pre-filled with data from the server.
  bool _incognitoMode = false;

  String? _aboutMe;

  String? _jobTitle;

  String? _company;

  bool _loadingImage =
      false; //Is image in the process of being uploaded? give user visual cue

  List<String>? _profileImagesUrls = [];

  @override
  initState() {
    super.initState();

    if (widget.imageUrls != null && widget.imageUrls!.isNotEmpty) {
      mountedLoader(() {
        _profileImagesUrls = widget.imageUrls;
      });
    }

    // this makes sure that if the state is not yet mounted, we don't end up calling setState
    // but instead push the function forward to the addPostFrameCallback function.
    _aboutMe = SettingsData.instance.userDescription;
    _company = SettingsData.instance.userDescription; //TODO change settings data appropriately,add properties as needed etc
    _jobTitle = SettingsData.instance.userDescription;

    _syncFromServer();
  }

  @override
  void dispose() {
    // make sure these are properly disposed after use.
    super.dispose();
  }

  /// builds the toggle tile.
  Widget _buildToggleTile({
    required String title,
    required bool value,
    void Function(bool)? onToggle,
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
    String? imageUrl,

    /// This function is fired when an image is successfully taken from the Gallery or Camera.
    void Function(PickedFile? imageFile)? onImagePicked,

    /// A function that fires when the cancel icon on the image-box is pressed.
    void Function()? onDelete,
  }) {
    Widget _inBoxWidget = imageUrl != null
        ? Image.network(
            imageUrl,
            fit: BoxFit.cover,
          )
        : Center(
            child: _loadingImage == false
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
                    onDelete!();
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
    String? _imgUrl;

    if (_profileImagesUrls != null && _profileImagesUrls!.isNotEmpty) {
      _imgUrl = _profileImagesUrls!.first;
    }

    final ImageProvider _profileImage = (_imgUrl == null
        ? AssetImage(
            BetaIconPaths.defaultProfileImagePath01,
          )
        : CachedNetworkImageProvider(
            NetworkHelper().getProfileImageUrl(_imgUrl),
          )) as ImageProvider<Object>;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Profile',
        hasTopPadding: true,
        showAppLogo: false,
        trailing: GlobalWidgets.assetImageToIcon(
          BetaIconPaths.inactiveVoilaTabIconPath,
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
                  backgroundImage: _profileImage,
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
                              onImagePicked: (image) {
                                // log
                                print(
                                    'The Path to the New Profile Image is: ${image!.path}');
                              });
                        },
                        child: Padding(
                          padding: EdgeInsets.all(2.5),
                          child: GlobalWidgets.assetImageToIcon(
                            BetaIconPaths.editProfileIconPath,
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
                  onReorder: (int oldIndex, int newIndex) {
                    if (newIndex >= _profileImagesUrls!.length) {
                      return;
                    }
                    NetworkHelper().swapProfileImages(oldIndex,
                        newIndex); //I don't see a need to wait for the server;
                    setState(() {
                      String temp = _profileImagesUrls![
                          oldIndex]; //Swap the elements (I wish there was a native way to do that!)
                      _profileImagesUrls![oldIndex] =
                          _profileImagesUrls![newIndex];
                      _profileImagesUrls![newIndex] = temp;
                    });
                  },
                  direction: Axis.horizontal,
                  alignment: WrapAlignment.spaceAround,
                  runAlignment: WrapAlignment.spaceAround,
                  spacing: 12.0,
                  runSpacing: 12.0,
                  children: List<Widget>.generate(
                      _profileImagesUrls!.length + 1,
                      (index) => ReorderableWidget(
                            key: Key('#profile_screen-reorderable_key'),
                            reorderable: index < _profileImagesUrls!.length,
                            child: _pictureBox(
                                imageUrl: index < _profileImagesUrls!.length
                                    ? NetworkHelper().getProfileImageUrl(
                                        _profileImagesUrls![index])
                                    : null,
                                onDelete: () {
                                  NetworkHelper()
                                      .deleteProfileImage(index)
                                      .then((_) {
                                    {
                                      _syncFromServer();
                                    }
                                  });
                                },
                                onImagePicked: (pickedImage) {
                                  setState(() {
                                    _loadingImage = true;
                                  });
                                  NetworkHelper()
                                      .postProfileImage(pickedImage!)
                                      .then((_) {
                                    setState(() {
                                      _loadingImage = false;
                                    });
                                    _syncFromServer();
                                  });
                                }),
                          ))),
              _buildToggleTile(
                title: 'Incognito Mode',
                value: _incognitoMode,
                onToggle: (val) {
                  setState(() {
                    _incognitoMode = val;
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
                  SettingsData.instance.userDescription = val;
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
                  SettingsData.instance.userDescription = val;
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
                  SettingsData.instance.userDescription = val;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _syncFromServer() {
    NetworkHelper().getProfileImages().then((profileImagesUrls) {
      setStateIfMounted(() {
        _profileImagesUrls = profileImagesUrls;
      });
    });
  }
}

/// The TextEditBlock used in the Profile Settings page.
class TextEditBlock extends StatefulWidget {
  TextEditBlock({
    Key? key,
    required this.title,
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
  final String? text;
  final String? placeholder;
  final int? maxLine;
  final void Function()? onOpen;
  final void Function()? onCloseTile;
  final TextEditingController? controller;

  /// This Function is fired when the block is opened or closed.
  ///
  /// A value of `true` is returned when the block is opened and a
  /// value of `false` if otherwise.
  final void Function(bool?)? onStatusChanged;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;

  @override
  _TextEditBlockState createState() => _TextEditBlockState();
}

class _TextEditBlockState extends State<TextEditBlock> {
  TextEditingController? _textEditingController;

  bool? _isOpened;

  void toggle([bool? force]) {
    setState(() {
      _isOpened = force ?? !_isOpened!;
    });
  }

  @override
  void initState() {
    _textEditingController = widget.controller ?? TextEditingController();

    if (widget.text != null) {
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
        _textEditingController!.text = widget.text!;
      });
    }

    _isOpened = (widget.text != null) && (widget.text != '');

    super.initState();
  }

  @override
  void dispose() {
    if (widget.controller == null) _textEditingController!.dispose();

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
              if ((_textEditingController!.text).length > 0) {
                print(_textEditingController!.text);
                return;
              }
              setState(() {
                _isOpened = !_isOpened!;
              });

              // determine whether or not the [TextEditBlock] is expanded or not.
              if (_isOpened == true) {
                if (widget.onOpen != null) widget.onOpen!();
              } else {
                if (widget.onCloseTile != null) widget.onCloseTile!();
              }

              if (widget.onStatusChanged != null)
                widget.onStatusChanged!(_isOpened);
            },
            child: GlobalWidgets.assetImageToIcon(
              BetaIconPaths.editIconPath02,
              iconPad: EdgeInsets.all(12.0),
            ),
          ),
        ],
      ),
      body: AnimatedContainer(
        duration: Duration(milliseconds: 1200),
        child: _isOpened!
            ? CupertinoTextField.borderless(
                controller: _textEditingController,
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
