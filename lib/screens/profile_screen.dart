import 'package:betabeta/constants/beta_icon_paths.dart';
import 'package:betabeta/constants/color_constants.dart';
import 'package:betabeta/models/settings_model.dart';
import 'package:betabeta/widgets/custom_app_bar.dart';
import 'package:betabeta/widgets/global_widgets.dart';
import 'package:betabeta/widgets/pre_cached_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

///
class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _settingsData = SettingsData();

  bool _showPhoto = false;

  // TODO: Fill the list with actual data from the server.
  List<String> imageList = List.filled(6, null);

  @override
  void initState() {
    super.initState();

    // set the value of the first element in the imageList to
    // the value we have in the [SettingsData].
    imageList[0] = _settingsData.facebookProfileImageUrl;
  }

  ///
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

  ///
  Widget _buildEditTile({
    @required String title,
    String text,
    String placeholder,
    bool isOpened = false,
    TextEditingController textEditingController,

    /// This Function is fired when the block is opened or closed.
    ///
    /// A value of `true` is returned when the block is opened and a
    /// value of `false` if otherwise.
    void Function(bool) onStatusChanged,
    void Function(String) onChanged,
    void Function(String) onSubmitted,
  }) {
    if (textEditingController != null && text != null)
      textEditingController.text = text;

    return StatefulBuilder(builder: (context, setter) {
      return GlobalWidgets.buildSettingsBlock(
        bodyPadding: EdgeInsets.zero,
        top: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: boldTextStyle,
            ),
            InkWell(
              customBorder: CircleBorder(),
              onTap: () {
                setter(() {
                  isOpened = !isOpened;
                });
                if (onStatusChanged != null) onStatusChanged(isOpened);
              },
              child: GlobalWidgets.imageToIcon(
                BetaIconPaths.editImageIconPath02,
                iconPad: EdgeInsets.all(12.0),
              ),
            ),
          ],
        ),
        body: AnimatedContainer(
          duration: Duration(milliseconds: 1200),
          child: isOpened
              ? CupertinoTextField.borderless(
                  controller: textEditingController,
                  placeholder: placeholder,
                  placeholderStyle:
                      boldTextStyle.copyWith(color: Colors.grey[300]),
                  onChanged: onChanged,
                  onSubmitted: onSubmitted,
                  maxLines: null,
                  style: defaultTextStyle,
                )
              : SizedBox.shrink(),
        ),
      );
    });
  }

  /// A Box that Displays the currently available user profile images.
  Widget _pictureBox({
    String imageUrl,

    /// This function is fired when an image is succesfully taken from the Gallery or Camera.
    void Function(PickedFile) onImagePicked,

    /// A function that fires when the cancel icon on the image-box is pressed.
    void Function() onDelete,
  }) {
    Widget _child = imageUrl != null
        ? PrecachedImage.network(
            imageURL: imageUrl,
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

    return SizedBox(
      height: 125,
      width: 85,
      child: Stack(
        children: [
          SizedBox(
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
                  onTap: onDelete,
                  child: Padding(
                    padding: EdgeInsets.all(2.5),
                    child: GlobalWidgets.imageToIcon(
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
        trailing: GlobalWidgets.imageToIcon(
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
                      _settingsData.facebookProfileImageUrl),
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
                                    'The Path to the New Profile Image is: ${image.path}');
                              });
                        },
                        child: Padding(
                          padding: EdgeInsets.all(2.5),
                          child: GlobalWidgets.imageToIcon(
                            BetaIconPaths.editProfieImageIconPath,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Wrap(
                direction: Axis.horizontal,
                alignment: WrapAlignment.spaceAround,
                runAlignment: WrapAlignment.spaceAround,
                spacing: 12.0,
                runSpacing: 12.0,
                children: [
                  _pictureBox(
                    imageUrl: imageList[0],
                    onDelete: () {
                      // remove the image.
                    },
                    onImagePicked: (image) {
                      // TODO: do something about the "image" here
                      // like upload to the storage.
                    },
                  ),
                  _pictureBox(
                    imageUrl: imageList[1],
                    onDelete: () {
                      // remove the image.
                    },
                    onImagePicked: (image) {
                      // TODO: do something about the "image" here
                      // like upload to the storage.
                    },
                  ),
                  _pictureBox(
                    imageUrl: imageList[2],
                    onDelete: () {
                      // remove the image.
                    },
                    onImagePicked: (image) {
                      // TODO: do something about the "image" here
                      // like upload to the storage.
                    },
                  ),
                  _pictureBox(
                    imageUrl: imageList[3],
                    onDelete: () {
                      // remove the image.
                    },
                    onImagePicked: (image) {
                      // TODO: do something about the "image" here
                      // like upload to the storage.
                    },
                  ),
                  _pictureBox(
                    imageUrl: imageList[4],
                    onDelete: () {
                      // remove the image.
                    },
                    onImagePicked: (image) {
                      // TODO: do something about the "image" here
                      // like upload to the storage.
                    },
                  ),
                  _pictureBox(
                    imageUrl: imageList[5],
                    onDelete: () {
                      // remove the image.
                    },
                    onImagePicked: (image) {
                      // TODO: do something about the "image" here
                      // like upload to the storage.
                    },
                  ),
                ],
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
              _buildEditTile(
                title: 'About Me',
              ),
              _buildEditTile(
                title: 'Job Title',
              ),
              _buildEditTile(
                title: 'Company',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
