import 'package:betabeta/constants/assets_paths.dart';
import 'package:betabeta/constants/beta_icon_paths.dart';
import 'package:betabeta/constants/color_constants.dart';
import 'package:betabeta/constants/global_keys.dart';
import 'package:betabeta/screens/current_user_profile_view_screen.dart';
import 'package:betabeta/screens/my_look_a_like_screen.dart';
import 'package:betabeta/screens/pending_approvment_screen.dart';
import 'package:betabeta/services/new_networking.dart';
import 'package:betabeta/services/settings_model.dart';
import 'package:betabeta/screens/account_settings.dart';
import 'package:betabeta/screens/profile_edit_screen.dart';
import 'package:betabeta/utils/mixins.dart';
import 'package:betabeta/widgets/animated_widgets/animated_percentage_circle_profile_widget.dart';
import 'package:betabeta/widgets/clickable.dart';
import 'package:betabeta/widgets/listener_widget.dart';
import 'package:betabeta/widgets/pre_cached_image.dart';
import 'package:betabeta/widgets/rounded_picture_button.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/onboarding/rounded_button.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key? key}) : super(key: key);
  static const String routeName = '/profile_screen';

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with AutomaticKeepAliveClientMixin, MountedStateMixin<ProfileScreen> {
  double height = 300;
  double percentage = 0;
  int count = 0;

  // create a SettingsData & a NetworkHelper instance.

  @override
  void initState() {
    super.initState();

    // this makes sure that if the state is not yet mounted, we don't end up calling setState
    // but instead push the function forward to the addPostFrameCallback function.
    mountedLoader(_syncFromServer);
  }

  void _syncFromServer() async {
    await NewNetworkService.instance.syncCurrentProfileImagesUrls();
  }

  // builds the profile picture display.
  Widget _profilePicDisplay(String? imageUrl) {
    //
    ImageProvider _image = imageUrl == null
        ? PrecachedImage.asset(
            imageURI: BetaIconPaths.defaultProfileImagePath01,
          ).image
        : ExtendedNetworkImageProvider(
            NewNetworkService.getProfileImageUrl(imageUrl),
            cache: true);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.0),
      child: Clickable(
        onTap: () async {
          await Get.toNamed(CurrentUserProfileViewScreen.routeName);
          // restartPercentageAnimation();
          _syncFromServer();
        },
        child: Material(
          color: Colors.transparent,
          elevation: 0,
          shape: CircleBorder(),
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: CircleAvatar(
              minRadius: 35.0,
              maxRadius: 75.0,
              backgroundImage: _image,
              foregroundColor: Colors.transparent,
              child: Container(
                height: double.infinity,
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      SettingsData.instance.name,
                      style: titleStyleWhite.copyWith(fontSize: 17),
                    ),
                    SizedBox(
                      height: 20,
                    )
                  ],
                ),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                      colors: [Colors.black87, Colors.transparent],
                      begin: Alignment.bottomCenter,
                      end: Alignment.center),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double smartButtonsHeight = MediaQuery.of(context).size.height * 0.09;
    double smartButtonsWidth = MediaQuery.of(context).size.width * 0.35;
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
          backgroundColor: backgroundThemeColor,
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  width: double.infinity,
                  child: Column(
                    children: [
                      AnimatedPercentageCircleProfileWidget(
                        // Ugly but force the widget to rebuild
                        key: GlobalKey(),
                        buttonBackgroundColor: Colors.black,
                        center: _profilePicDisplay(_profileImageToShow),
                      ),
                      RoundedButton(
                        name: 'Edit Profile',
                        onTap: () async {
                          await Get.toNamed(ProfileEditScreen.routeName);
                          _syncFromServer();
                        },
                        minWidth: 0,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
                RoundedPictureButton(
                    height: smartButtonsHeight,
                    image: AssetImage(AssetsPaths.appSettingsPic),
                    child: Text(
                      'App Settings',
                      maxLines: 1,
                      style: LargeTitleStyleWhite,
                    ),
                    onTap: () {
                      Get.toNamed(AccountSettingsScreen.routeName);
                    }),
                Divider(
                  thickness: 1,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RoundedPictureButton(
                      image: AssetImage(AssetsPaths.editPicture1),
                      borderRadius: BorderRadius.all(
                        Radius.circular(30),
                      ),
                      width: smartButtonsWidth,
                      height: smartButtonsHeight,
                      child: Text(
                        'Who do I \nLook-A-Like',
                        style: LargeTitleStyleWhite.copyWith(
                          fontSize: 17,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      onTap: () {
                        Get.toNamed(MyLookALikeScreen.routeName);
                      },
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    RoundedPictureButton(
                      width: smartButtonsWidth,
                      height: smartButtonsHeight,
                      image: AssetImage(AssetsPaths.mirrorOnTheWall1),
                      borderRadius: BorderRadius.all(
                        Radius.circular(30),
                      ),
                      child: Text(
                        'Mirror on the Wall',
                        style: LargeTitleStyleWhite.copyWith(fontSize: 17),
                        textAlign: TextAlign.center,
                      ),
                      onTap: () {},
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.lightBlueAccent.shade100,
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Invite Others',
                        style: kTypeTextStyle.copyWith(
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Send an invitation to your single friends and help them find a date with Voilà.',
                        style: kTypeTextStyle,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      FloatingActionButton.extended(
                        backgroundColor: Colors.white,
                        onPressed: () {
                          print(SettingsData.instance.uid);
                          Get.toNamed(PendingApprovementScreen.routeName);
                        },
                        label: Text(
                          'INVITE A FRIEND',
                          style: kTypeTextStyle.copyWith(
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                )
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
