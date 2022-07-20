import 'package:betabeta/constants/assets_paths.dart';
import 'package:betabeta/constants/beta_icon_paths.dart';
import 'package:betabeta/constants/color_constants.dart';
import 'package:betabeta/constants/global_keys.dart';
import 'package:betabeta/screens/current_user_profile_view_screen.dart';
import 'package:betabeta/services/new_networking.dart';
import 'package:betabeta/services/settings_model.dart';
import 'package:betabeta/screens/account_settings.dart';
import 'package:betabeta/screens/profile_edit_screen.dart';
import 'package:betabeta/utils/mixins.dart';
import 'package:betabeta/widgets/clickable.dart';
import 'package:betabeta/widgets/listener_widget.dart';
import 'package:betabeta/widgets/pre_cached_image.dart';
import 'package:betabeta/widgets/rounded_picture_button.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/percent_indicator.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key? key}) : super(key: key);
  static const String routeName = '/profile_screen';

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with
        AutomaticKeepAliveClientMixin,
        MountedStateMixin<ProfileScreen>,
        SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation _animation;
  late Animation _colorTween;
  double height = 300;
  double percentage = 0;

  // create a SettingsData & a NetworkHelper instance.

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2000),
    )
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        print(status);
      })
      ..forward();
    _animation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _controller, curve: Curves.decelerate));
    _colorTween = ColorTween(begin: Colors.yellowAccent, end: appMainColor)
        .animate(
            CurvedAnimation(parent: _controller, curve: Curves.decelerate));
    super.initState();

    // this makes sure that if the state is not yet mounted, we don't end up calling setState
    // but instead push the function forward to the addPostFrameCallback function.
    mountedLoader(_syncFromServer);
  }

  void restartPercentageAnimation() {
    _controller.value = 0;
  }

  void _checkPercentage() {
    double count = 0;
    double totalItems = 13;
    if (SettingsData.instance.profileImagesUrls.length > 1) {
      count++;
    }
    if (SettingsData.instance.heightInCm != 0) {
      count++;
    }
    if (SettingsData.instance.religion != '') {
      count++;
    }
    if (SettingsData.instance.jobTitle != '') {
      count++;
    }
    if (SettingsData.instance.school != '') {
      count++;
    }
    if (SettingsData.instance.education != '') {
      count++;
    }
    if (SettingsData.instance.fitness != '') {
      count++;
    }
    if (SettingsData.instance.smoking != '') {
      count++;
    }
    if (SettingsData.instance.drinking != '') {
      count++;
    }
    if (SettingsData.instance.children != '') {
      count++;
    }
    if (SettingsData.instance.covid_vaccine != '') {
      count++;
    }
    if (SettingsData.instance.hobbies.length != 0) {
      count++;
    }
    if (SettingsData.instance.pets.length != 0) {
      count++;
    }
    percentage = (count / totalItems) * 100;

    _controller.forward();
    print(count);
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
          restartPercentageAnimation();
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
    _checkPercentage();
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
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              Column(
                                children: [
                                  CircularPercentIndicator(
                                    key: _controller.value != 0
                                        ? percentageWidgetCircle
                                        : GlobalKey(),
                                    addAutomaticKeepAlive: false,
                                    curve: Curves.decelerate,
                                    center:
                                        _profilePicDisplay(_profileImageToShow),
                                    percent: percentage / 100,
                                    restartAnimation: false,
                                    animation: true,
                                    animationDuration: 2000,
                                    radius: MediaQuery.of(context).size.width *
                                        0.18,
                                    progressColor: _colorTween.value,
                                    startAngle: 180,
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                              GestureDetector(
                                onTap: () async {
                                  await Get.toNamed(
                                      ProfileEditScreen.routeName);
                                  restartPercentageAnimation();
                                },
                                child: Container(
                                  padding: EdgeInsets.only(
                                      top: 4, bottom: 20, left: 12, right: 12),
                                  decoration: BoxDecoration(
                                    color: backgroundThemeColor,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(20),
                                    ),
                                  ),
                                  child: Text(
                                    '${(_animation.value * (percentage)).toInt()}% done',
                                    maxLines: 1,
                                    style: kTypeTextStyle.copyWith(
                                        color: _colorTween.value,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          RoundedPictureButton(
                            height: MediaQuery.of(context).size.height * 0.11,
                            image: AssetImage('assets/images/quill2.jpg'),
                            child: Text(
                              'Edit Profile',
                              maxLines: 1,
                              style: LargeTitleStyleWhite,
                            ),
                            onTap: () async {
                              await Get.toNamed(ProfileEditScreen.routeName);
                              restartPercentageAnimation();
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          RoundedPictureButton(
                              height: MediaQuery.of(context).size.height * 0.11,
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
                                onTap: () {},
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
                                  style: LargeTitleStyleWhite.copyWith(
                                      fontSize: 17),
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
                                  onPressed: () {},
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
                  ),
                  Container(
                    height: 20,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [
                            backgroundThemeColor,
                            Colors.white.withOpacity(0)
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
