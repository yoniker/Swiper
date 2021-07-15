import 'package:betabeta/constants/beta_icon_paths.dart';
import 'package:betabeta/constants/color_constants.dart';
import 'package:betabeta/models/details_model.dart';
import 'package:betabeta/models/settings_model.dart';
import 'package:betabeta/services/networking.dart';
import 'package:betabeta/utils/mixins.dart';
import 'package:betabeta/widgets/custom_app_bar.dart';
import 'package:betabeta/widgets/global_widgets.dart';
import 'package:betabeta/widgets/pre_cached_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reorderables/reorderables.dart';

///
class ProfileSettingsScreen extends StatefulWidget {
  ProfileSettingsScreen({Key key, this.imageUrls}) : super(key: key);

  // Since we have loaded the image prior at the profile_tab
  // we can just pass it down to the profile_screen instead of having the
  // image display widgets wait for another fetch from the network.
  //
  // Note we still call the "getProfileImage" method but we get the Profile to load faster.
  //
  // Also, if non is provided it will just go on with its normal process of loading and waiting for the images
  // which means this route can be pushed to satck without worrying about the "imageUrls" parameter since its optional.
  final List<String> imageUrls;

  @override
  _ProfileSettingsScreenState createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen>
    with MountedStateMixin<ProfileSettingsScreen> {
  // --> All this information should be added to the data model.
  // this will be pre-filled with data from the server.
  bool _incognitoMode = false;

  String _aboutMe;

  String _jobTitle;

  String _company;

  NetworkHelper networkHelper;

  SettingsData settingsData;

  List<String> _profileImagesUrls =
      List.generate(6, (index) => null, growable: false);

  @override
  initState() {
    super.initState();

    if (widget.imageUrls != null && widget.imageUrls.isNotEmpty) {
      mountedLoader(() {
        _profileImagesUrls = List.from(widget.imageUrls, growable: false);
      });
    }

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
    settingsData = SettingsData();

    // this makes sure that if the state is not yet mounted, we don't end up calling setState
    // but instead push the function forward to the addPostFrameCallback function.
    mountedLoader(_syncFromServer);
    _aboutMe = DetailsData().aboutMe;
    _company = DetailsData().company;
    _jobTitle = DetailsData().job;
    print(DetailsData().aboutMe);
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
    String _imgUrl = settingsData.facebookProfileImageUrl;

    if (_profileImagesUrls != null && _profileImagesUrls.isNotEmpty) {
      _imgUrl = _profileImagesUrls.first;
    }

    final ImageProvider _img = _imgUrl == null
        ? PrecachedImage.asset(
            imageURI: BetaIconPaths.defaultProfileImagePath,
          ).image
        : CachedNetworkImageProvider(
            networkHelper.getProfileImageUrl(_imgUrl),
            // cacheKey: _profileImageUrl,
            imageRenderMethodForWeb: ImageRenderMethodForWeb.HtmlImage,
          );

    print("Here is the Profile");

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Profile',
        hasTopPadding: true,
        showAppLogo: false,
        trailing: Icon(
          Icons.edit_outlined,
          color: blackTextColor,
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
                  backgroundImage: _img,
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
                              GlobalWidgets.showLoadingIndicator(
                                context: context,
                              );

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
                  //I don't see a need to wait for the server;
                  setState(() {
                    // String temp = _profileImagesUrls[
                    //     oldIndex]; //Swap the elements (I wish there was a native way to do that!)
                    // _profileImagesUrls[oldIndex] = _profileImagesUrls[newIndex];
                    // _profileImagesUrls[newIndex] = temp;
                    final String newString = _profileImagesUrls[oldIndex];
                    final String oldString = _profileImagesUrls[newIndex];

                    _profileImagesUrls[oldIndex] = oldString;
                    _profileImagesUrls[newIndex] = newString;
                  });

                  await NetworkHelper().swapProfileImages(
                    oldIndex,
                    newIndex,
                  );
                },
                direction: Axis.horizontal,
                alignment: WrapAlignment.spaceAround,
                runAlignment: WrapAlignment.spaceAround,
                spacing: 12.0,
                runSpacing: 12.0,
                children: List<Widget>.generate(
                  _profileImagesUrls.length,
                  (index) {
                    // final url = index < _profileImagesUrls.length
                    //     ? networkHelper
                    //         .getProfileImageUrl(_profileImagesUrls[index])
                    //     : null;
                    final url = _profileImagesUrls[index] == null
                        ? null
                        : networkHelper
                            .getProfileImageUrl(_profileImagesUrls[index]);
                    return ReorderableWidget(
                      key: Key('#reorderable_profile$index'),
                      reorderable: index < _profileImagesUrls.length,
                      child: _pictureBox(
                        imageUrl: url,
                        onDelete: () async {
                          GlobalWidgets.showLoadingIndicator(context: context);

                          await networkHelper.deleteProfileImage(index);
                          // _syncFromServer();
                          updateListIndex(index);

                          GlobalWidgets.hideLoadingIndicator(context);
                        },
                        onImagePicked: (image) async {
                          GlobalWidgets.showLoadingIndicator(context: context);

                          await networkHelper.postProfileImage(image);
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
                  DetailsData().aboutMe = val;
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
                  DetailsData().job = val;
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
                  DetailsData().company = val;
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
    final _list = _resp;
    print(_list);

    if (_list?.isEmpty == true) {
      // setStateIfMounted(() {
      //   _profileImagesUrls.replaceRange(0, _profileImagesUrls.length, null);
      // });
      return;
    }

    for (int i = 0; i < _list.length; i++) {
      String value;

      // check if index exists in the profile images list.
      if (_list.length > i) {
        value = _list[i];
      }

      _profileImagesUrls[i] = value;
    }
    setStateIfMounted(() {/**/});
  }

  // update the list.
  void updateListIndex(int index) async {
    final _resp = await networkHelper.getProfileImages();
    String value;

    // check if index exists in the profile images list.
    if (_resp.length > index) {
      value = _resp[index];
    }

    setStateIfMounted(() {
      _profileImagesUrls[index] = value;
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
  TextEditingController _textEditingController;

  bool _isOpened;

  void toggle([bool force]) {
    setState(() {
      _isOpened = force ?? !_isOpened;
    });
  }

  @override
  void initState() {
    _textEditingController =
        widget.controller ?? TextEditingController(text: widget.text ?? '');

    _isOpened = (widget.text != null) && (widget.text != '');

    super.initState();
  }

  @override
  void dispose() {
    if (widget.controller == null) _textEditingController.dispose();

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
              if ((_textEditingController.text ?? '').length > 0) {
                print(_textEditingController.text ?? 'No text');
                return;
              }
              setState(() {
                _isOpened = !_isOpened;
              });

              // determine whether or not the [TextEditBlock] is expanded or not.
              if (_isOpened == true) {
                if (widget.onOpen != null) widget.onOpen();
              } else {
                if (widget.onCloseTile != null) widget.onCloseTile();
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
