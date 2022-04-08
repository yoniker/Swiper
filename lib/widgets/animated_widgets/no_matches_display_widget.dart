import 'package:betabeta/constants/enums.dart';
import 'package:betabeta/screens/swipe_settings_screen.dart';
import 'package:betabeta/services/settings_model.dart';
import 'package:betabeta/widgets/onboarding/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NoMatchesDisplayWidget extends StatefulWidget {
  const NoMatchesDisplayWidget(
      {Key? key, this.centerWidget, this.customButtonWidget})
      : super(key: key);

  final Widget? centerWidget;
  final Widget? customButtonWidget;

  @override
  State<NoMatchesDisplayWidget> createState() => _NoMatchesDisplayWidgetState();
}

class _NoMatchesDisplayWidgetState extends State<NoMatchesDisplayWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animation;
  late Animation<double> _animationCurve;

  @override
  void initState() {
    _animation =
        AnimationController(vsync: this, duration: Duration(seconds: 10));
    _animation.addListener(() {
      setState(() {});
    });
    _animation.repeat(reverse: true);
    _animationCurve = Tween<double>(begin: 1, end: 10)
        .animate(CurvedAnimation(parent: _animation, curve: Curves.elasticIn));
    super.initState();
  }

  @override
  void dispose() {
    _animation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: double.infinity,
      width: double.infinity,
      child: Center(
          child: Padding(
        padding: const EdgeInsets.all(60.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Transform.rotate(
              angle: _animationCurve.value * 10,
              child: Icon(
                Icons.radar_outlined,
                size: 100,
                color: Colors.black12,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            if (widget.centerWidget != null) widget.centerWidget!,
            SizedBox(
              height: 20,
            ),
            widget.customButtonWidget != null
                ? widget.customButtonWidget!
                : SettingsData.instance.filterType != FilterType.NONE
                    ? RoundedButton(
                        name: 'Deactivate filters',
                        elevation: 4,
                        onTap: () {
                          SettingsData.instance.filterType = FilterType.NONE;
                          SettingsData.instance.filterDisplayImageUrl = '';
                        },
                      )
                    : RoundedButton(
                        elevation: 4,
                        onTap: () {
                          Get.toNamed(SwipeSettingsScreen.routeName);
                        },
                        name: 'Expand search',
                      )
          ],
        ),
      )),
    );
  }
}
