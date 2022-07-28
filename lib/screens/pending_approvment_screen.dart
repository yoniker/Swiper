import 'package:betabeta/constants/beta_icon_paths.dart';
import 'package:betabeta/constants/color_constants.dart';
import 'package:betabeta/constants/url-consts.dart';
import 'package:betabeta/screens/account_settings.dart';
import 'package:betabeta/screens/current_user_profile_view_screen.dart';
import 'package:betabeta/screens/profile_edit_screen.dart';
import 'package:share_plus/share_plus.dart';
import 'package:betabeta/services/new_networking.dart';
import 'package:betabeta/services/settings_model.dart';
import 'package:betabeta/utils/mixins.dart';
import 'package:betabeta/widgets/animated_widgets/animated_percentage_circle_profile_widget.dart';
import 'package:betabeta/widgets/circle_button.dart';
import 'package:betabeta/widgets/clickable.dart';
import 'package:betabeta/widgets/custom_scrollview_take_all_available_space.dart';
import 'package:betabeta/widgets/listener_widget.dart';
import 'package:betabeta/widgets/main_app_box.dart';
import 'package:betabeta/widgets/onboarding/rounded_button.dart';
import 'package:betabeta/widgets/pre_cached_image.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'my_look_a_like_screen.dart';

class PendingApprovementScreen extends StatefulWidget {
  const PendingApprovementScreen({Key? key}) : super(key: key);
  static const String routeName = '/pending_approvement_screen';

  @override
  State<PendingApprovementScreen> createState() =>
      _PendingApprovementScreenState();
}

class _PendingApprovementScreenState extends State<PendingApprovementScreen>
    with MountedStateMixin<PendingApprovementScreen> {
  @override
  void initState() {
    super.initState();
    mountedLoader(_syncFromServer);
  }

  void _syncFromServer() async {
    await NewNetworkService.instance.syncCurrentProfileImagesUrls();
  }

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
    final double adaptiveFontSize = MediaQuery.of(context).size.width * 0.05;
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
          backgroundColor: Colors.white,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                    child: SafeArea(
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CircleButton(
                                onPressed: () {
                                  Get.toNamed(MyLookALikeScreen.routeName);
                                },
                                color: Colors.white,
                                child: Image.asset(
                                  BetaIconPaths.voilaCelebrityIconPath,
                                  scale: 4,
                                ),
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  AnimatedPercentageCircleProfileWidget(
                                    center:
                                        _profilePicDisplay(_profileImageToShow),
                                    buttonBackgroundColor: Colors.black,
                                    key: GlobalKey(),
                                  ),
                                  RoundedButton(
                                    name: 'Edit Profile',
                                    onTap: () async {
                                      await Get.toNamed(
                                          ProfileEditScreen.routeName);
                                      _syncFromServer();
                                    },
                                    minWidth: 0,
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.03,
                                  )
                                ],
                              ),
                              CircleButton(
                                color: Colors.white,
                                onPressed: () {
                                  Get.toNamed(AccountSettingsScreen.routeName);
                                },
                                child: Image.asset(
                                  BetaIconPaths.voilaSwipeSettingsButtonPath,
                                  scale: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              CustomScrollViewTakesAllAvailableSpace(
                padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.07,
                    top: MediaQuery.of(context).size.height * 0.02,
                    right: MediaQuery.of(context).size.width * 0.07),
                children: [
                  Text(
                    'Thank you and welcome to Voilà! Your profile is now being reviewed',
                    style: titleStyle.copyWith(fontSize: adaptiveFontSize),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  Text(
                    'In the meantime, try the Celeb Look-A-Like & invite friends! (It will help you get approved!)\n\nWe will notify you as soon as your profile has been approved.',
                    style: titleStyle.copyWith(
                        fontSize: adaptiveFontSize,
                        fontWeight: FontWeight.normal),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  if (SettingsData.instance.email != '')
                    Text(
                      'We will send the updates to',
                      style: titleStyle.copyWith(
                          color: Colors.black54, fontSize: adaptiveFontSize),
                      textAlign: TextAlign.left,
                    ),
                  if (SettingsData.instance.email != '')
                    Center(
                      child: MainAppBox(
                        child: Text(
                          SettingsData.instance.email,
                          style: titleStyle.copyWith(
                              fontSize: adaptiveFontSize,
                              fontWeight: FontWeight.normal),
                        ),
                      ),
                    ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: RoundedButton(
                  name: 'Invite my friends',
                  color: Colors.black87,
                  onTap: () async {
                    await Share.share(SettingsData.instance.name +
                        ' has invited you to download Voilà! a personalized dating app where people actually care.\n' +
                        shareLink);
                  },
                  minWidth: 0,
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
