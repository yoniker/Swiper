import 'package:betabeta/constants/beta_icon_paths.dart';
import 'package:betabeta/constants/color_constants.dart';
import 'package:betabeta/screens/general_settings.dart';
import 'package:betabeta/screens/notification_screen.dart';
import 'package:betabeta/screens/profile_screen.dart';
import 'package:betabeta/widgets/clickable.dart';
import 'package:betabeta/widgets/custom_app_bar.dart';
import 'package:betabeta/widgets/pre_cached_image.dart';
import 'package:betabeta/widgets/thumb_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileTabRedo extends StatefulWidget {
  ProfileTabRedo({Key key}) : super(key: key);

  @override
  _ProfileTabRedoState createState() => _ProfileTabRedoState();
}

class _ProfileTabRedoState extends State<ProfileTabRedo>
    with AutomaticKeepAliveClientMixin {
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
      child: Clickable(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProfileSettingsScreen(),
            ),
          );
        },
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
    // Implementation for [AutomaticKeepAliveClientMixin].
    super.build(context);

    return Scaffold(
      backgroundColor: darkCardColor,
      appBar: CustomAppBar(
        trailing: PrecachedImage.asset(imageURI: BetaIconPaths.profileIcon),
        hasTopPadding: true,
        hasBackButton: false,
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
                // _achievementLabel(
                //   label: 'Likes',
                //   iconURI: BetaIconPaths.likeIconFilled01,
                //   value: '500+',
                //   color: blue,
                // ),
                _achievementLabel(
                  label: 'Loves',
                  iconURI: BetaIconPaths.heartIconFilled01,
                  value: '800+',
                  color: colorBlend02,
                ),
                // _achievementLabel(
                //   label: 'Stars',
                //   iconURI: BetaIconPaths.starIconFilled01,
                //   value: '50+',
                //   color: yellowishOrange,
                // ),
              ],
            ),
            SizedBox(height: 12.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: 100,
                    minWidth: 85,
                  ),
                  child: Column(
                    children: [
                      ThumbButton(
                        thumbColor: whiteCardColor,
                        onTap: () {
                          // move to general settings screen.
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GeneralSettingsScreen(),
                            ),
                          );
                        },
                        child: Positioned(
                          top: 12.0,
                          child: PrecachedImage.asset(
                            imageURI: BetaIconPaths.settingsIconFilled01,
                          ),
                        ),
                      ),
                      SizedBox(height: 2.0),
                      Text(
                        'Settings',
                        style: smallBoldedCharStyle,
                      ),
                    ],
                  ),
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: 100,
                    minWidth: 85,
                  ),
                  child: Column(
                    children: [
                      ThumbButton(
                        thumbColor: whiteCardColor,
                        onTap: () {
                          // move to the profile screen.
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ProfileSettingsScreen(),
                            ),
                          );
                        },
                        child: Positioned(
                          top: 12.0,
                          child: PrecachedImage.asset(
                            imageURI: BetaIconPaths.profileIconFilled01,
                          ),
                        ),
                      ),
                      SizedBox(height: 2.0),
                      Text(
                        'Profile',
                        style: smallBoldedCharStyle,
                      ),
                    ],
                  ),
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: 100,
                    minWidth: 85,
                  ),
                  child: Column(
                    children: [
                      ThumbButton(
                        thumbColor: whiteCardColor,
                        onTap: () {
                          // move to the notification screen.
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => NotificationScreen(),
                            ),
                          );
                        },
                        child: Positioned(
                          top: 12.0,
                          child: PrecachedImage.asset(
                            imageURI: BetaIconPaths.notificationIconFilled01,
                          ),
                        ),
                      ),
                      SizedBox(height: 2.0),
                      Text(
                        'Notifications',
                        style: smallBoldedCharStyle,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
