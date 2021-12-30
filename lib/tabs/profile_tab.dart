import 'package:betabeta/constants/beta_icon_paths.dart';
import 'package:betabeta/constants/color_constants.dart';
import 'package:betabeta/models/settings_model.dart';
import 'package:betabeta/screens/account_settings.dart';
import 'package:betabeta/screens/notification_screen.dart';
import 'package:betabeta/screens/profile_details_screen.dart';
import 'package:betabeta/services/networking.dart';
import 'package:betabeta/utils/mixins.dart';
import 'package:betabeta/widgets/clickable.dart';
import 'package:betabeta/widgets/custom_app_bar.dart';
import 'package:betabeta/widgets/pre_cached_image.dart';
import 'package:betabeta/widgets/thumb_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileTabRedo extends StatefulWidget {
  ProfileTabRedo({Key? key}) : super(key: key);

  @override
  _ProfileTabRedoState createState() => _ProfileTabRedoState();
}

class _ProfileTabRedoState extends State<ProfileTabRedo>
    with AutomaticKeepAliveClientMixin, MountedStateMixin<ProfileTabRedo> {
  List<String>? _profileImagesUrls = [];

  // create a SettingsData & a NetworkHelper instance.

  @override
  void initState() {
    super.initState();
    // this makes sure that if the state is not yet mounted, we don't end up calling setState
    // but instead push the function forward to the addPostFrameCallback function.
    mountedLoader(_syncFromServer);
  }

  @override
  void dispose() {
    // dispose off the instance.
    //
    // It is essential that this is called so that we don't keep unneccessary resources in memory
    // which can potentially cause memory overloading.
    //
    // TODO(Yoni): We need to make sure every screen that make use of this resources are duly
    // reviewed and restructured such that each screen has only an instance of these classes and that they
    // are all properly disposed.
    SettingsData().dispose();

    super.dispose();
  }

  void _syncFromServer([bool? reset]) async {
    // if (reset == true) {
    //   _profileImagesUrls = List.generate(6, (index) => null, growable: false);
    // }

    final _resp = await NetworkHelper().getProfileImages();
    final _list = _resp;
    _profileImagesUrls = _list;
    print(_profileImagesUrls);

    setStateIfMounted(() {/**/});
  }

  // builds the profile picture display.
  Widget _profilePicDisplay(String? imageUrl) {
    //
    ImageProvider _image = imageUrl == null
        ? PrecachedImage.asset(
            imageURI: BetaIconPaths.defaultProfileImagePath01,
          ).image
        : CachedNetworkImageProvider(
            NetworkHelper().getProfileImageUrl(imageUrl),
          );

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.0),
      child: Clickable(
        onTap: () async {
          await Get.toNamed(
              ProfileDetailsScreen.routeName,arguments: _profileImagesUrls,
              );

          // this is because the imageUrls might have been edited.
          // we want this page to stay updated so we use it this way.
          //
          // To avoid this we should consider using a StateManagement Library such as Provider or Bloc.
          _syncFromServer();
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
              backgroundImage: _image,
              backgroundColor: lightCardColor,
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

    String? _imgUrl;


    if (_profileImagesUrls != null && _profileImagesUrls!.isNotEmpty) {
      _imgUrl = _profileImagesUrls!.first;
    }

    return Scaffold(
      backgroundColor: lightCardColor,
      appBar: CustomAppBar(
        trailing: PrecachedImage.asset(imageURI: BetaIconPaths.editIcon03),
        hasTopPadding: true,
        hasBackButton: false,
        showAppLogo: false,
        title: 'Profile',
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _profilePicDisplay(_imgUrl),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
              child: Text(
                SettingsData().name,
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
                  'Your city, U.S.A',
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
                          Get.toNamed(
                              AccountSettingsScreen.routeName);
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
                        onTap: () async {
                          // move to the profile screen.
                          await Get.toNamed(ProfileDetailsScreen.routeName,
                              arguments: _profileImagesUrls,
                              );

                          // this is because the imageUrls might have been edited.
                          // we want this page to stay updated so we use it this way.
                          //
                          // To avoid this we should consider using a StateManagement Library such as Provider or Bloc.
                          _syncFromServer(true);
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
                          Get.toNamed(NotificationScreen.routeName

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

  // TODO(John & Yoni): Should we make use of KeepAlive at this page or not?
  // Also, should we add a pull to refresh Functionality?
  @override
  bool get wantKeepAlive => true;
}
