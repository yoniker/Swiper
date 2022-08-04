import 'package:betabeta/constants/color_constants.dart';
import 'package:betabeta/constants/global_keys.dart';
import 'package:betabeta/screens/main_navigation_screen.dart';
import 'package:betabeta/screens/voila_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

late TutorialCoachMark VoilaTutorial;
List<TargetFocus> targets = <TargetFocus>[];
final int pageGeneralAnimationTimeInMillSec = 300;
late TutorialCoachMark VoilaTutorialStage2;

void changeColor() {
  MainNavigationScreen.appBarColorAnimationController.reverse();
}

class AppTutorialBrain {
  final Function()? moveToChatPage;
  final void Function()? moveBackToMatchPage;
  AppTutorialBrain(
      {required this.moveToChatPage, required this.moveBackToMatchPage});
  showTutorial(context) {
    initTargets();
    VoilaTutorial = TutorialCoachMark(
      context,
      hideSkip: true,
      alignSkip: Alignment.centerLeft,
      targets: targets,
      colorShadow: Colors.black.withOpacity(0.7),
      textSkip: "SKIP",
      paddingFocus: 10,
      opacityShadow: 0.8,
      onFinish: () async {
        await Get.toNamed(VoilaPage.routeName, arguments: true);
        await Future.delayed(
            Duration(milliseconds: 300), moveToChatPage?.call());
        showStage2Tutorial(context);
      },
    )..show();
  }

  void initTargets() {
    targets.clear();
    targets.add(
      TargetFocus(
        identify: "filterButtonAppBar",
        keyTarget: filterButton,
        alignSkip: Alignment.bottomCenter,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return GestureDetector(
                onTap: () {
                  print('clicked on overlay');
                },
                child: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Click here for basic filters",
                        style: LargeTitleStyleWhite,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      GestureDetector(
                        onTap: () {
                          VoilaTutorial.next();
                        },
                        child: Text(
                          'NEXT',
                          style: LargeTitleStyleWhite.copyWith(
                              decoration: TextDecoration.underline,
                              color: Colors.blueAccent),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
    targets.add(
      TargetFocus(
        identify: "SearchButtonAppBar",
        keyTarget: searchButton,
        alignSkip: Alignment.bottomCenter,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Click here for advanced search",
                      style: LargeTitleStyleWhite,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  showStage2Tutorial(context) {
    initStage2Targets();
    VoilaTutorialStage2 = TutorialCoachMark(
      context,
      hideSkip: true,
      alignSkip: Alignment.centerLeft,
      targets: targets,
      colorShadow: Colors.black.withOpacity(0.7),
      textSkip: "SKIP",
      paddingFocus: 10,
      opacityShadow: 0.8,
      onFinish: () {
        moveBackToMatchPage?.call();
      },
    )..show();
  }

  void initStage2Targets() {
    targets.clear();
    targets.add(
      TargetFocus(
        identify: "conversationsYouStarted",
        keyTarget: numberOfConversationsWidget,
        alignSkip: Alignment.bottomCenter,
        contents: [
          TargetContent(
            align: ContentAlign.left,
            builder: (context, controller) {
              return GestureDetector(
                onTap: () {
                  VoilaTutorialStage2.next();
                },
                child: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "For more meaningful connections, we limit each user number of conversation starts!",
                        style: LargeTitleStyleWhite.copyWith(
                            color: Colors.lightBlueAccent, fontSize: 22),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Click anywhere to start swiping!\n\nEnjoy ☺️',
                        style: LargeTitleStyleWhite,
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
