import 'package:betabeta/constants/beta_icon_paths.dart';
import 'package:betabeta/constants/color_constants.dart';
import 'package:betabeta/screens/current_user_profile_view_screen.dart';
import 'package:betabeta/services/aws_networking.dart';
import 'package:betabeta/services/new_networking.dart';
import 'package:betabeta/services/settings_model.dart';
import 'package:betabeta/screens/account_settings.dart';
import 'package:betabeta/screens/notification_screen.dart';
import 'package:betabeta/screens/profile_edit_screen.dart';
import 'package:betabeta/utils/mixins.dart';
import 'package:betabeta/widgets/clickable.dart';
import 'package:betabeta/widgets/custom_app_bar.dart';
import 'package:betabeta/widgets/listener_widget.dart';
import 'package:betabeta/widgets/pre_cached_image.dart';
import 'package:betabeta/widgets/thumb_button.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key? key}) : super(key: key);
  static const String routeName = '/profile_screen';

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with AutomaticKeepAliveClientMixin, MountedStateMixin<ProfileScreen> {
  // create a SettingsData & a NetworkHelper instance.

  @override
  void initState() {
    super.initState();
    // this makes sure that if the state is not yet mounted, we don't end up calling setState
    // but instead push the function forward to the addPostFrameCallback function.
    mountedLoader(_syncFromServer);
  }

  void _syncFromServer() async {
    await AWSServer.instance.syncCurrentProfileImagesUrls();
  }

  // builds the profile picture display.
  Widget _profilePicDisplay(String? imageUrl) {
    //
    ImageProvider _image = imageUrl == null
        ? PrecachedImage.asset(
            imageURI: BetaIconPaths.defaultProfileImagePath01,
          ).image
        : ExtendedNetworkImageProvider(
            AWSServer.getProfileImageUrl(imageUrl),
            cache: true);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.0),
      child: Clickable(
        onTap: () {
          Get.toNamed(CurrentUserProfileViewScreen.routeName);
          // Get.toNamed(
          //   CurrentUserProfileViewScreen.routeName,
          // );

          // this is because the imageUrls might have been edited.
          // we want this page to stay updated so we use it this way.
          //
          // To avoid this we should consider using a StateManagement Library such as Provider or Bloc.
          _syncFromServer();
        },
        child: Material(
          color: Colors.white,
          elevation: 5.2,
          shape: CircleBorder(),
          child: Padding(
            padding: const EdgeInsets.all(2.1),
            child: CircleAvatar(
              minRadius: 35.0,
              maxRadius: 75.0,
              backgroundImage: _image,
              backgroundColor: lightCardColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    SettingsData.instance.name,
                    style: titleStyleWhite,
                  ),
                  SizedBox(
                    height: 10,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// builds the various achievement display such as the like display and the stars display.
  Widget _achievementLabel({
    required String label,
    required String iconURI,
    required String value,
    required Color color,
    Color? imageColor,
  }) {
    return Column(
      children: [
        PrecachedImage.asset(
          imageURI: iconURI,
          color: imageColor,
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

    return ListenerWidget(
      notifier: SettingsData.instance,
      builder: (context) {
        String? _profileImageToShow;
        List<String> _profileImagesUrls =
            SettingsData.instance.profileImagesUrls;

        if (_profileImagesUrls.isNotEmpty) {
          _profileImageToShow = _profileImagesUrls.first;
        }

        return Scaffold(
          backgroundColor: backgroundThemeColorALT,
          body: SingleChildScrollView(
            child: Column(
              children: [
                _profilePicDisplay(_profileImageToShow),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.location_on_rounded,
                      color: colorBlend01,
                    ),
                    SizedBox(width: 4.0),
                    Text(
                      SettingsData.instance.locationDescription,
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
                      imageColor: colorBlend01,
                      color: Colors.black,
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
                              Get.toNamed(AccountSettingsScreen.routeName);
                            },
                            child: Positioned(
                              top: 12.0,
                              child: Icon(
                                Icons.settings,
                                color: Colors.blueGrey,
                                size: 25,
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
                            onTap: () async {
                              // move to the profile screen.
                              await Get.toNamed(
                                ProfileEditScreen.routeName,
                              );
                            },
                            child: Positioned(
                              top: 12.0,
                              child: PrecachedImage.asset(
                                imageURI: BetaIconPaths.editIconFilled01,
                                color: yellowishOrange,
                              ),
                            ),
                          ),
                          SizedBox(height: 2.0),
                          Text(
                            'Edit Profile',
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
                              Get.toNamed(NotificationScreen.routeName);
                            },
                            child: Positioned(
                              top: 12.0,
                              child: PrecachedImage.asset(
                                imageURI:
                                    BetaIconPaths.notificationIconFilled01,
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
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
