import 'package:betabeta/constants/beta_icon_paths.dart';
import 'package:betabeta/constants/color_constants.dart';
import 'package:betabeta/screens/profile_screen.dart';
import 'package:betabeta/screens/settings_screen.dart';
import 'package:betabeta/widgets/clickable.dart';
import 'package:betabeta/widgets/custom_app_bar.dart';
import 'package:betabeta/widgets/global_widgets.dart';
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
            CupertinoPageRoute(
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
                ThumbButton(
                  thumbColor: whiteCardColor,
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => SwipeSettingsScreen(),
                      ),
                    );
                  },
                  child: PrecachedImage.asset(
                    imageURI: BetaIconPaths.settingsIconFilled01,
                  ),
                ),
                ThumbButton(
                  thumbColor: whiteCardColor,
                  onTap: () {
                    // move to profile screen.
                    Navigator.of(context).push(
                      CupertinoPageRoute(
                        builder: (context) => ProfileSettingsScreen(),
                      ),
                    );
                  },
                  child: PrecachedImage.asset(
                    imageURI: BetaIconPaths.profileIconFilled01,
                  ),
                ),
                ThumbButton(
                  thumbColor: whiteCardColor,
                  onTap: () {
                    print('TODO: Move to notifications screen!');
                  },
                  child: PrecachedImage.asset(
                    imageURI: BetaIconPaths.notificationIconFilled01,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.0),
            ActionBox(
              message: 'Swiping Preference',
              messageStyle: smallBoldedCharStyle.copyWith(color: colorBlend02),
              margin: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
              trailing: Icon(
                Icons.settings,
                color: colorBlend02,
              ),
              onTap: () {},
            ),
            ActionBox(
              message: 'Facebook Logout',
              messageStyle: smallBoldedCharStyle.copyWith(color: blue),
              margin: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
              trailing: PrecachedImage.asset(
                imageURI: BetaIconPaths.facebookLogo,
              ),
              onTap: () {},
            ),
            SizedBox(height: 12.0),
            // Card(
            //   margin: EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
            //   elevation: 2.0,
            //   shadowColor: darkCardColor,
            //   shape: RoundedRectangleBorder(
            //     borderRadius: BorderRadius.circular(13.0),
            //   ),
            //   clipBehavior: Clip.hardEdge,
            //   child: Column(
            //     children: [
            //       Padding(
            //         padding: EdgeInsets.symmetric(vertical: 12.0),
            //         child: Text(
            //           'Notifications',
            //           style: subTitleStyle,
            //         ),
            //       ),
            //       SizedBox(
            //         height: MediaQuery.of(context).size.height * 0.3,
            //         child: ListView.builder(
            //           itemCount: 5,
            //           physics: BouncingScrollPhysics(),
            //           itemBuilder: (context, index) {
            //             return NotificationBox(
            //               message: 'This is the number $index notification!',
            //               onTap: () {
            //                 // TODO: Open notification.
            //               },
            //             );
            //           },
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
