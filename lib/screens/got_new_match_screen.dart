import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:betabeta/constants/color_constants.dart';
import 'package:betabeta/models/profile.dart';
import 'package:betabeta/screens/chat/chat_screen.dart';
import 'package:betabeta/widgets/match_card.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class GotNewMatchScreen extends StatefulWidget {
  const GotNewMatchScreen({Key? key}) : super(key: key);
  static const String routeName = '/gotNewMatch';

  @override
  _GotNewMatchScreenState createState() => _GotNewMatchScreenState();
}

class _GotNewMatchScreenState extends State<GotNewMatchScreen>
    with SingleTickerProviderStateMixin {
  late Profile theUser;
  late AnimationController _controller;
  late Animation animation;
  late Animation secondAnimation;
  late final ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {});
      });
    theUser = Get.arguments;
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    );
    animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.5, 1, curve: Curves.fastOutSlowIn),
      ),
    );
    secondAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.4, 1, curve: Curves.fastOutSlowIn),
      ),
    );
    _controller.forward();
    _controller.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.black, Colors.transparent],
                  begin: Alignment.topCenter,
                  end: Alignment.center),
            ),
          ),
          MatchCard(
            scrollController: _scrollController,
            profile: theUser,
            clickable: true,
            showCarousel: true,
            showActionButtons: false,
            showAI: false,
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 2.0, top: 2),
              child: FloatingActionButton(
                elevation: 20,
                backgroundColor: Colors.transparent,
                child: Icon(
                  FontAwesomeIcons.chevronLeft,
                  // shadows: [
                  //   Shadow(
                  //     blurRadius: 17.0,
                  //     color: Colors.black,
                  //     offset: Offset(-2.0, 2.0),
                  //   ),
                  // ],
                  size: 40,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
          SafeArea(
            child: AnimatedOpacity(
              opacity:
                  _scrollController.hasClients && _scrollController.offset > 200
                      ? 0
                      : 1,
              duration: Duration(seconds: 1),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Center(
                    child: Column(
                      children: [
                        SizedBox(
                          height: animation.value * 32,
                          child: FittedBox(
                            child: AnimatedTextKit(
                              isRepeatingAnimation: true,
                              repeatForever: true,
                              pause: Duration(milliseconds: 1),
                              animatedTexts: [
                                ColorizeAnimatedText(
                                  'You & ${theUser.username}',
                                  speed: Duration(seconds: 2),
                                  textStyle:
                                      colorizeTextStyle.copyWith(fontSize: 20),
                                  colors: colorizeColors,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: secondAnimation.value * 66,
                          child: FittedBox(
                            child: AnimatedTextKit(
                              pause: Duration(milliseconds: 1),
                              isRepeatingAnimation: true,
                              repeatForever: true,
                              animatedTexts: [
                                ColorizeAnimatedText(
                                  'MATCHED!',
                                  textStyle: colorizeTextStyle,
                                  speed: Duration(seconds: 2),
                                  colors: colorizeColors,
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.offAndToNamed(
                          ChatScreen.getRouteWithUserId(theUser.uid));

                      /// ToDo need to get to user match chat directly
                    },
                    child: AnimatedContainer(
                      margin: EdgeInsets.symmetric(horizontal: 30),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                flex: 3,
                                child: Text(
                                  'Introduce yourself ☺️',
                                  overflow: TextOverflow.fade,
                                  maxLines: 1,
                                  style: titleStyle.copyWith(
                                      color: Colors.black54),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                              Flexible(
                                flex: 1,
                                child: AnimatedContainer(
                                  duration: Duration(seconds: 1),
                                  height: secondAnimation.isCompleted ? 30 : 0,
                                  width: secondAnimation.isCompleted ? 30 : 0,
                                  child: SingleChildScrollView(
                                    child: Icon(
                                      FontAwesomeIcons.facebookMessenger,
                                      size: 28,
                                      color: Colors.black45,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      height: _controller.isCompleted ? 65 : 0,
                      width: _controller.isCompleted ? 600 : 0,
                      curve: Curves.easeIn,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.6),

                            blurRadius: 15,
                            offset:
                                Offset(-2.0, 2.0), // changes position of shadow
                          ),
                        ],
                        color: Colors.white70,
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      duration: Duration(milliseconds: 500),
                    ),
                  ),
                  SizedBox(
                    height: 120,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
