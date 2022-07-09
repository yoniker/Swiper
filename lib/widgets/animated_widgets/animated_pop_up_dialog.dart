import 'package:betabeta/constants/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AnimatedPopUpDialog extends StatefulWidget {
  const AnimatedPopUpDialog({Key? key}) : super(key: key);

  @override
  State<AnimatedPopUpDialog> createState() => _AnimatedPopUpDialogState();
}

class _AnimatedPopUpDialogState extends State<AnimatedPopUpDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation _animation;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )
      ..forward()
      ..addListener(() {
        setState(() {});
      });
    _animation = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.back();
      },
      child: Opacity(
        opacity: _animation.value,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "To make sure that your connections here will be meaningful, we limit each user number of conversation starts!",
                  style: LargeTitleStyleWhite.copyWith(
                      color: Colors.redAccent, fontSize: 25),
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
        ),
      ),
    );
  }
}
