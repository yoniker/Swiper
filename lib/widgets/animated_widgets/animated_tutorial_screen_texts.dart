import 'dart:async';

import 'package:betabeta/constants/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TimedAnimatedText {
  double beginTime;
  double endTime;
  String text;
  TextStyle? style;
  TimedAnimatedText(
      {required this.beginTime,
      required this.endTime,
      required this.text,
      this.style = LargeTitleStyleWhite}) {}
}

class AnimatedTutorialScreenTexts extends StatefulWidget {
  final double totalScriptedTime;
  final List<TimedAnimatedText> timedAnimatedTexts;

  const AnimatedTutorialScreenTexts(
      {Key? key,
      required this.totalScriptedTime,
      required this.timedAnimatedTexts})
      : super(key: key);

  @override
  State<AnimatedTutorialScreenTexts> createState() =>
      _AnimatedTutorialScreenTextsState();
}

class _AnimatedTutorialScreenTextsState
    extends State<AnimatedTutorialScreenTexts> {
  late Timer? timer;
  double time = 0;

  @override
  void initState() {
    timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      if (timer.isActive) {
        setState(() {
          time = time + 100;
        });
      }
      if (time > widget.totalScriptedTime) {
        timer.cancel();
        time = 0;
        Get.back();
      }
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    if (timer != null && timer!.isActive) {
      timer!.cancel();
    }
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black87,
        body: Center(
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: widget.timedAnimatedTexts
                .map(
                  (timedText) => AnimatedOpacity(
                    duration: Duration(milliseconds: 300),
                    opacity:
                        time > timedText.beginTime && time < timedText.endTime
                            ? 1
                            : 0,
                    child: Text(
                      timedText.text,
                      style: timedText.style,
                      maxLines: 6,
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
                .toList(),
          ),
        ));
  }
}
