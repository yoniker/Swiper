import 'package:betabeta/constants/beta_icon_paths.dart';
import 'package:betabeta/constants/color_constants.dart';
import 'package:betabeta/constants/onboarding_consts.dart';
import 'package:betabeta/screens/current_user_profile_view_screen.dart';
import 'package:betabeta/screens/main_navigation_screen.dart';
import 'package:betabeta/screens/pending_approvment_screen.dart';
import 'package:betabeta/screens/profile_edit_screen.dart';
import 'package:betabeta/services/app_tutorial_brain.dart';
import 'package:betabeta/services/new_networking.dart';
import 'package:betabeta/services/settings_model.dart';
import 'package:betabeta/utils/mixins.dart';
import 'package:betabeta/widgets/animated_widgets/animated_percentage_circle_profile_widget.dart';
import 'package:betabeta/widgets/circle_button.dart';
import 'package:betabeta/widgets/clickable.dart';
import 'package:betabeta/widgets/custom_scrollview_take_all_available_space.dart';
import 'package:betabeta/widgets/listener_widget.dart';
import 'package:betabeta/widgets/pre_cached_image.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/onboarding/rounded_button.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key? key}) : super(key: key);
  static const String routeName = '/profile_screen';

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with AutomaticKeepAliveClientMixin, MountedStateMixin<ProfileScreen> {
  final AppTutorialBrain appTutorial = AppTutorialBrain();

  // create a SettingsData & a NetworkHelper instance.

  @override
  void initState() {
    super.initState();
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
          setState(() {});
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
    final double adaptiveFontForMiddleTextButtons =
        MediaQuery.of(context).size.width * 0.05;
    final double adaptiveScaleOfMiddleIconButtons =
        MediaQuery.of(context).size.width * 0.055;
    final double predefinedIconScale =
        MediaQuery.of(context).size.width * 0.0095;
    final Color circleButtonColor = Color(0xFFF5F5F5);

    // Implementation for [AutomaticKeepAliveClientMixin].
    super.build(context);

    return ListenerWidget(
      notifier: SettingsData.instance,
      builder: (context) {
        print('Building profile page');
        String? _profileImageToShow;
        List<String> _profileImagesUrls =
            SettingsData.instance.profileImagesUrls;

        if (_profileImagesUrls.isNotEmpty) {
          _profileImageToShow = _profileImagesUrls.first;
        }

        return Scaffold(
          backgroundColor: backgroundThemeColor,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Container(
                    width: double.infinity,
                    child: CustomPaint(
                      painter: ArcPainter(),
                      child: Column(
                        children: [
                          AnimatedPercentageCircleProfileWidget(
                            // Ugly but force the widget to rebuild
                            key: GlobalKey(),
                            firstColor: Colors.red,
                            secondColor: Colors.white,
                            buttonBackgroundColor: Colors.black,
                            center: _profilePicDisplay(_profileImageToShow),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              CustomScrollViewTakesAllAvailableSpace(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleButton(
                        onPressed: () {},
                        color: circleButtonColor,
                        padding: EdgeInsets.all(12),
                        elevation: 5,
                        label: 'Look-a-like',
                        child: Image.asset(
                          BetaIconPaths.voilaCelebrityIconPath,
                          scale: predefinedIconScale,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: CircleButton(
                          onPressed: () async {
                            await Get.toNamed(ProfileEditScreen.routeName);
                            setState(() {});
                          },
                          color: circleButtonColor,
                          padding: EdgeInsets.all(14),
                          elevation: 5,
                          label: 'Edit profile',
                          child: Image.asset(
                            BetaIconPaths.editProfileIconPath,
                            scale: 7,
                          ),
                        ),
                      ),
                      CircleButton(
                        onPressed: () {},
                        color: circleButtonColor,
                        padding: EdgeInsets.all(12),
                        label: 'My mirror',
                        elevation: 5,
                        child: Image.asset(
                          BetaIconPaths.mirrorMalePath,
                          scale: predefinedIconScale,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: HingeStyleButtonTesting(
                      text: 'How does it work?',
                      onTap: () async {
                        changeColor();
                        await MainNavigationScreen.pageController.animateToPage(
                            MainNavigationScreen.MATCHING_PAGE_INDEX,
                            duration: Duration(milliseconds: 300),
                            curve: Curves.fastOutSlowIn);
                        appTutorial.showTutorial(context);
                      },
                      textStyle: kButtonText.copyWith(
                          fontSize: adaptiveFontForMiddleTextButtons),
                      icon: FontAwesomeIcons.question,
                      iconSize: adaptiveScaleOfMiddleIconButtons,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: HingeStyleButtonTesting(
                      onTap: () async {
                        final url = 'https://www.voiladating.com';
                        if (await canLaunch(url)) {
                          await launch(url);
                        }
                      },
                      text: 'Learn more about Voila',
                      textStyle: kButtonText.copyWith(
                          fontSize: adaptiveFontForMiddleTextButtons),
                      iconSize: adaptiveScaleOfMiddleIconButtons,
                      icon: FontAwesomeIcons.book,
                    ),
                  )
                  //   RoundedPictureButton(
                  //       height: smartButtonsHeight,
                  //       image: AssetImage(AssetsPaths.editProfilePicture),
                  //       child: Text(
                  //         'Edit profile',
                  //         maxLines: 1,
                  //         style: LargeTitleStyleWhite,
                  //       ),
                  //       onTap: () {
                  //         Get.toNamed(AccountSettingsScreen.routeName);
                  //       }),
                  //   RoundedPictureButton(
                  //     image: AssetImage(AssetsPaths.starPictureCeleb),
                  //     borderRadius: BorderRadius.all(
                  //       Radius.circular(30),
                  //     ),
                  //     height: smartButtonsHeight,
                  //     child: Text(
                  //       'My Look-A-Like',
                  //       style: LargeTitleStyleWhite,
                  //       textAlign: TextAlign.center,
                  //     ),
                  //     onTap: () {
                  //       Get.toNamed(MyLookALikeScreen.routeName);
                  //     },
                  //   ),
                  //   RoundedPictureButton(
                  //     height: smartButtonsHeight,
                  //     image: AssetImage(AssetsPaths.mirrorOnTheWall1),
                  //     borderRadius: BorderRadius.all(
                  //       Radius.circular(30),
                  //     ),
                  //     child: Text(
                  //       'Mirror on the Wall',
                  //       style: LargeTitleStyleWhite,
                  //       textAlign: TextAlign.center,
                  //     ),
                  //     onTap: () {},
                  //   ),
                  //   Divider(
                  //     thickness: 1,
                  //   ),
                ],
                padding: EdgeInsets.all(10),
              ),

              // SizedBox(
              //   height: 10,
              // ),
              SafeArea(
                child: Container(
                  margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.blueGrey.withOpacity(0.25),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Invite Others',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Send an invitation to your single friends and help them find a date with Voilà.',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      RoundedButton(
                        showBorder: false,
                        minWidth: double.minPositive,
                        color: Colors.white,
                        onTap: () {
                          Get.toNamed(PendingApprovementScreen.routeName);
                        },
                        name: 'Invite a friend',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class ArcPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 10
      ..style = PaintingStyle.fill;
    var paint2 = Paint()..style = PaintingStyle.fill;
    final arc1 = Path();
    final rect = Rect.fromPoints(Offset(size.width * 0.0, size.height * 0),
        Offset(size.width, size.height * 0.801));
    arc1.moveTo(size.width * 0.0, size.height * 0.8);
    arc1.arcToPoint(Offset(size.width, size.height * 0.8),
        radius: Radius.circular(650), clockwise: false);
    canvas.drawPath(arc1, paint);
    canvas.drawRect(rect, paint2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class HingeStyleButtonTesting extends StatelessWidget {
  final String text;
  final IconData? icon;
  final TextStyle? textStyle;
  final double? iconSize;
  final void Function()? onTap;
  const HingeStyleButtonTesting(
      {Key? key,
      this.text = '',
      this.onTap,
      this.icon,
      this.textStyle = kButtonText,
      this.iconSize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Color(0xFFBDBDBD),
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: textStyle,
            ),
            Icon(
              icon,
              size: iconSize,
            )
          ],
        ),
      ),
    );
  }
}
