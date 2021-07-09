import 'package:betabeta/constants/beta_icon_paths.dart';
import 'package:betabeta/constants/color_constants.dart';
import 'package:betabeta/widgets/custom_app_bar.dart';
import 'package:betabeta/widgets/global_widgets.dart';
import 'package:betabeta/widgets/pre_cached_image.dart';
import 'package:betabeta/widgets/thumb_button.dart';
import 'package:flutter/material.dart';

class ProfileTabRedo extends StatefulWidget {
  ProfileTabRedo({Key key}) : super(key: key);

  @override
  _ProfileTabRedoState createState() => _ProfileTabRedoState();
}

class _ProfileTabRedoState extends State<ProfileTabRedo> {
  // builds the profile picture display.
  Widget _profilePicDisplay(String imageUrl) {
    // when the time comes we use "PrecachedImage.network" instead since we
    // plan to fetch the image over the network.
    //
    final _image = PrecachedImage.asset(
      imageURI: 'assets/mock_images/scarlet.jpg',
    );

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.0),
      child: Material(
        color: Colors.white,
        elevation: 1.2,
        shape: CircleBorder(),
        child: Padding(
          padding: const EdgeInsets.all(2.1),
          child: CircleAvatar(
            minRadius: 35.0,
            maxRadius: 75.0,
            backgroundImage: _image.image,
            backgroundColor: colorBlend01,
            child: Align(
              alignment: Alignment(0.85, 0.9),
              child: Material(
                clipBehavior: Clip.antiAlias,
                color: Colors.white,
                shape: CircleBorder(),
                elevation: 2.0,
                child: InkWell(
                  onTap: () async {
                    await GlobalWidgets.showImagePickerDialogue(
                      context: context,
                      onImagePicked: (imageFile) {
                        print('THE PATH TO THE FILE PICKED: ${imageFile.path}');
                      },
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.all(4.0),
                    child: PrecachedImage.asset(
                      imageURI: BetaIconPaths.editProfieImageIconPath,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// builds the various achievement display such as the like display and the stars display.
  Widget _achievementLabel({
    @required String label,
    @required String iconURI,
    @required String value,
    @required Color color,
  }) {
    return Column(
      children: [
        PrecachedImage.asset(
          imageURI: iconURI,
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 6.0),
          child: Text(
            value,
            style: titleStyle.copyWith(color: color),
          ),
        ),
        Text(
          label,
          style: smallCharStyle.copyWith(
            color: darkTextColor,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkCardColor,
      appBar: CustomAppBar(
        trailing: PrecachedImage.asset(imageURI: BetaIconPaths.profileIcon),
        hasTopPadding: true,
        showAppLogo: false,
        title: 'Profile',
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _profilePicDisplay('TODO: Add a valid profile image!'),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
              child: Text(
                'JEREMY jr., 50',
                style: titleStyle,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PrecachedImage.asset(
                  imageURI: BetaIconPaths.locationIconFilled01,
                ),
                SizedBox(width: 4.0),
                Text(
                  'Alaska, U.S.A',
                  style: subTitleStyle.copyWith(color: darkTextColor),
                ),
              ],
            ),
            SizedBox(height: 12.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _achievementLabel(
                  label: 'Likes',
                  iconURI: BetaIconPaths.likeIconFilled01,
                  value: '500+',
                  color: blue,
                ),
                _achievementLabel(
                  label: 'Loves',
                  iconURI: BetaIconPaths.heartIconFilled01,
                  value: '800+',
                  color: colorBlend02,
                ),
                _achievementLabel(
                  label: 'Stars',
                  iconURI: BetaIconPaths.starIconFilled01,
                  value: '50+',
                  color: yellowishOrange,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ThumbButton(
                  thumbColor: whiteCardColor,
                  onTap: () {
                    print('Thumb CLicked');
                  },
                  child: PrecachedImage.asset(
                    imageURI: BetaIconPaths.settingsIconFilled01,
                  ),
                ),
                ThumbButton(
                  thumbColor: whiteCardColor,
                  onTap: () {
                    print('Thumb CLicked');
                  },
                  child: PrecachedImage.asset(
                    imageURI: BetaIconPaths.heartIconFilled01,
                    scale: 2.0,
                  ),
                ),
                ThumbButton(
                  thumbColor: whiteCardColor,
                  onTap: () {
                    print('Thumb CLicked');
                  },
                  child: PrecachedImage.asset(
                    imageURI: BetaIconPaths.notificationIconFilled01,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
