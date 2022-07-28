import 'package:betabeta/constants/color_constants.dart';
import 'package:betabeta/services/settings_model.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class AnimatedPercentageCircleProfileWidget extends StatefulWidget {
  final Widget? center;
  final Color firstColor;
  // if a second color is provided create a tween animation between the two
  final Color? secondColor;
  final Color buttonBackgroundColor;
  final void Function()? onTap;
  const AnimatedPercentageCircleProfileWidget(
      {Key? key,
      this.center,
      this.firstColor = Colors.white,
      this.secondColor,
      this.onTap,
      this.buttonBackgroundColor = backgroundThemeColor})
      : super(key: key);

  @override
  State<AnimatedPercentageCircleProfileWidget> createState() =>
      _AnimatedPercentageCircleProfileWidgetState();
}

class _AnimatedPercentageCircleProfileWidgetState
    extends State<AnimatedPercentageCircleProfileWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation _animation;
  late Animation _colorTween;
  late double percentIndicator;

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
    percentIndicator = (count / totalItems) * 100;

    _controller.forward();
    print(count);
  }

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 2000))
          ..addListener(() {
            setState(() {});
          })
          ..forward();
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.decelerate),
    );
    _colorTween = ColorTween(
            begin: widget.firstColor,
            end: widget.secondColor != null
                ? widget.secondColor
                : widget.firstColor)
        .animate(
            CurvedAnimation(parent: _controller, curve: Curves.decelerate));
    _checkPercentage();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _checkPercentage();
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Column(
          children: [
            CircularPercentIndicator(
              addAutomaticKeepAlive: false,
              backgroundColor: Colors.black,
              curve: Curves.decelerate,
              center: widget.center,
              percent: percentIndicator / 100,
              restartAnimation: false,
              animation: true,
              animationDuration: 2000,
              radius: MediaQuery.of(context).size.width * 0.18,
              progressColor: _colorTween.value,
              startAngle: 180,
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
        GestureDetector(
          onTap: widget.onTap,
          child: Container(
            padding: EdgeInsets.only(top: 4, bottom: 20, left: 12, right: 12),
            decoration: BoxDecoration(
              color: widget.buttonBackgroundColor,
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            child: Text(
              '${(_animation.value * (percentIndicator)).toInt()}% done',
              maxLines: 1,
              style: kTypeTextStyle.copyWith(
                  color: _colorTween.value,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}
