import 'package:betabeta/constants/color_constants.dart';
import 'package:betabeta/constants/lists_consts.dart';
import 'package:betabeta/constants/onboarding_consts.dart';
import 'package:betabeta/screens/complete_profile_pageview_screen.dart';
import 'package:betabeta/services/onboarding_flow_controller.dart';
import 'package:betabeta/services/settings_model.dart';
import 'package:betabeta/widgets/onboarding/rounded_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class FinishOnboardingScreen extends StatefulWidget {
  static const String routeName = '/finishOnboardingScreen';

  const FinishOnboardingScreen({Key? key}) : super(key: key);

  @override
  _FinishOnboardingScreenState createState() => _FinishOnboardingScreenState();
}

class _FinishOnboardingScreenState extends State<FinishOnboardingScreen> {
  late VideoPlayerController _controller;

  String lookingFor() {
    switch (SettingsData.instance.relationshipType) {
      case 'Marriage':
        return 'Looks like you are here to get married!';
      case 'Relationship':
        return 'Looks like you are here for a relationship!';
    }
    return 'Congratulations on creating a profile!';
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller =
        VideoPlayerController.asset('assets/onboarding/videos/startvideo.mp4')
          ..initialize().then((_) {
            _controller.seekTo(Duration(seconds: 36));
            _controller.play();
            _controller.setLooping(true);
            setState(() {});
          });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _controller.value.size.width,
                height: _controller.value.size.height,
                child: VideoPlayer(_controller),
              ),
            ),
          ),
          RawScrollbar(
            isAlwaysShown: true,
            thumbColor: Colors.white24,
            thickness: 5,
            child: CustomScrollView(
              scrollDirection: Axis.vertical,
              reverse: true,
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Container(
                    color: Colors.black26,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Image.asset(
                                  'assets/onboarding/images/Voila-logo.png',
                                  height: 200,
                                ),
                              ),
                              Text(
                                lookingFor(),
                                style: kWhiteDescriptionShadowStyle.copyWith(
                                    color: Colors.white,
                                    fontSize: 20,
                                    overflow: TextOverflow.visible),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Text(
                                'When you start a conversation, there is 48 hours for both parties to keep the match.',
                                style: kWhiteDescriptionShadowStyle.copyWith(
                                    color: Colors.white,
                                    fontSize: 20,
                                    overflow: TextOverflow.visible),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Text(
                                'One message is not enough!',
                                style: kWhiteDescriptionShadowStyle.copyWith(
                                    color: Colors.white,
                                    fontSize: 20,
                                    overflow: TextOverflow.visible),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Text(
                                'People love to see a detailed profile. \nYou can add more information about yourself below.',
                                style: kWhiteDescriptionShadowStyle.copyWith(
                                    color: Colors.white,
                                    fontSize: 20,
                                    overflow: TextOverflow.visible),
                              )
                            ],
                          ),
                          Column(
                            children: [
                              TextButton(
                                onPressed: () {
                                  Get.offAllNamed(OnboardingFlowController
                                      .instance
                                      .nextRoute(
                                          FinishOnboardingScreen.routeName));
                                },
                                child: Text(
                                  'Skip for now',
                                  style: kButtonTextWhite.copyWith(
                                      decoration: TextDecoration.underline),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              RoundedButton(
                                name: 'Complete profile now',
                                onTap: () {
                                  Get.toNamed(
                                      CompleteProfilePageViewScreen.routeName);
                                },
                                color: Colors.white,
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
