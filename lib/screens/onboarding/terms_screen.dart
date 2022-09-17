import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:betabeta/constants/assets_paths.dart';
import 'package:betabeta/constants/color_constants.dart';
import 'package:betabeta/constants/onboarding_consts.dart';
import 'package:betabeta/screens/onboarding/onboarding_pageview_screen.dart';
import 'package:betabeta/services/onboarding_flow_controller.dart';
import 'package:betabeta/services/screen_size.dart';
import 'package:betabeta/widgets/onboarding/conditional_parent_widget.dart';
import 'package:betabeta/widgets/onboarding/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class TermsScreen extends StatefulWidget {
  const TermsScreen({Key? key, this.onNext}) : super(key: key);

  @override
  _TermsScreenState createState() => _TermsScreenState();
  static const String routeName = '/Terms';
  final void Function()? onNext;
}

class _TermsScreenState extends State<TermsScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    _controller = VideoPlayerController.asset(AssetsPaths.backgroundVideoPath)
      ..initialize().then((_) {
        _controller.seekTo(Duration(seconds: 23));
        _controller.play();
        _controller.setLooping(true);
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScrollController scrollController = ScrollController();
    return GestureDetector(
      onTap: () {
        if (scrollController.position.maxScrollExtent.isFinite)
          scrollController.animateTo(scrollController.position.maxScrollExtent,
              duration: Duration(milliseconds: 300), curve: Curves.easeIn);
      },
      child: Scaffold(
        backgroundColor: Colors.black87,
        body: Stack(
          children: [
            SizedBox.expand(
              child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    height: _controller.value.size.height,
                    width: _controller.value.size.width,
                    child: VideoPlayer(_controller),
                  )),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 30.w),
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AnimatedTextKit(
                            animatedTexts: [
                              ColorizeAnimatedText('Welcome to Voilà!',
                                  colors: colorizeColors,
                                  textStyle: kTitleStyleBlack)
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Please follow these guidelines:',
                            style: kSmallInfoStyleWhite.copyWith(
                              fontSize: 16,
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 5, top: 20),
                            child: Row(
                              children: [
                                Text(
                                  '✔',
                                  style: kVstyle,
                                ),
                                Text(
                                  '  No Catfishing.',
                                  style: kWhiteDescriptionShadowStyle.copyWith(
                                      color: Colors.white, fontSize: 20),
                                  textAlign: TextAlign.start,
                                ),
                              ],
                            ),
                          ),
                          Text(
                            'Use your own bio, age and photos',
                            style: kSmallInfoStyleWhite.copyWith(
                              fontSize: 16,
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 5, top: 20),
                            child: Row(
                              children: [
                                Text(
                                  '✔',
                                  style: kVstyle,
                                ),
                                Text(
                                  '  Respect.',
                                  style: kWhiteDescriptionShadowStyle.copyWith(
                                      color: Colors.white, fontSize: 20),
                                  textAlign: TextAlign.start,
                                ),
                              ],
                            ),
                          ),
                          Text(
                            'Treat others the same way you would want to be treated.',
                            style: kSmallInfoStyleWhite.copyWith(
                              fontSize: 16,
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 5, top: 20),
                            child: Row(
                              children: [
                                Text(
                                  '✔',
                                  style: kVstyle,
                                ),
                                Text(
                                  '  Security.',
                                  style: kWhiteDescriptionShadowStyle.copyWith(
                                      color: Colors.white, fontSize: 20),
                                  textAlign: TextAlign.start,
                                ),
                              ],
                            ),
                          ),
                          Text(
                            'Don\'t give away your personal information too quickly!',
                            style: kSmallInfoStyleWhite.copyWith(
                              fontSize: 16,
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 20, top: 20),
                            child: Text(
                              'And remember that we are here for you!',
                              style: kSmallInfoStyleWhite.copyWith(
                                fontSize: 16,
                                color: Colors.white.withOpacity(0.8),
                              ),
                              textAlign: TextAlign.start,
                            ),
                          )
                        ],
                      ),
                    ),
                    RoundedButton(
                      elevation: 0,
                      name: 'I Agree',
                      onTap: () {
                        widget.onNext?.call();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
