import 'package:betabeta/constants/onboarding_consts.dart';
import 'package:betabeta/screens/main_navigation_screen.dart';
import 'package:betabeta/screens/onboarding/onboarding_flow_controller.dart';
import 'package:betabeta/widgets/onboarding/rounded_button.dart';
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller =
        VideoPlayerController.asset('assets/onboarding/videos/endingvideo.mp4')
          ..initialize().then((_) {
            _controller.play();
            _controller.setLooping(true);
            setState(() {});
          });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        SizedBox.expand(
          child: FittedBox(
            fit: BoxFit.fill,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: VideoPlayer(_controller),
            ),
          ),
        ),
        Container(
          color: Colors.black26,
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      'assets/onboarding/images/Voila-logo.png',
                      height: 200,
                    ),
                    const Text(
                      "You're ready to find someone special!",
                      style: kTitleStyleWhite,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'When you match with someone, both parties need to have a meaningful connection',
                      style: kSmallTitleStyle,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'One message is not enough! have a conversation to keep your match!',
                      style: kSmallTitleStyle,
                    )
                  ],
                ),
                RoundedButton(
                  name: 'Got it',
                  onTap: () {
                    Get.offAllNamed(OnboardingFlowController.instance.nextRoute(FinishOnboardingScreen.routeName));
                  },
                  color: Colors.white,
                )
              ],
            ),
          ),
        ),
      ]),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
