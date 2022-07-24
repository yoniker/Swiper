import 'package:betabeta/services/aws_networking.dart';
import 'package:betabeta/services/settings_model.dart';
import 'package:betabeta/widgets/listener_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AnimatedTheirTasteWidget extends StatefulWidget {
  const AnimatedTheirTasteWidget({Key? key}) : super(key: key);

  @override
  State<AnimatedTheirTasteWidget> createState() =>
      _AnimatedTheirTasteWidgetState();
}

class _AnimatedTheirTasteWidgetState extends State<AnimatedTheirTasteWidget>
    with TickerProviderStateMixin {
  late final AnimationController _animationController;
  late AnimationController _firstAnimation;
  late Animation<double> _expendLittleAnimation;
  late Animation<double> _widgetAppearAnimation;
  late Animation<double> _pulseAnimation;
  late Animation _colorAnimation;

  @override
  void initState() {
    _firstAnimation =
        AnimationController(vsync: this, duration: Duration(milliseconds: 400))
          ..forward()
          ..addListener(() {
            setState(() {});
          });
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 1500))
          ..forward()
          ..addListener(() {
            setState(() {});
            if (_animationController.isCompleted) {
              _animationController.repeat(reverse: true);
            }
          });
    _colorAnimation = ColorTween(
            begin: Colors.deepPurpleAccent.withOpacity(0.0),
            end: Colors.redAccent.withOpacity(0.7))
        .animate(
            CurvedAnimation(parent: _animationController, curve: Curves.ease));
    _widgetAppearAnimation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _firstAnimation, curve: Curves.fastOutSlowIn));
    _expendLittleAnimation = Tween<double>(begin: 0.8, end: 1).animate(
        CurvedAnimation(parent: _firstAnimation, curve: Curves.fastOutSlowIn));
    _pulseAnimation = Tween<double>(begin: 33, end: 28).animate(CurvedAnimation(
        parent: _animationController, curve: Curves.easeInOutBack));
  }

  @override
  void dispose() {
    _animationController.dispose();
    _firstAnimation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenerWidget(
      notifier: SettingsData.instance,
      builder: (context) {
        String? _profileImageToShow;
        List<String> _profileImagesUrls =
            SettingsData.instance.profileImagesUrls;
        if (_profileImagesUrls.isNotEmpty) {
          _profileImageToShow = _profileImagesUrls.first;
        }

        return Center(
          child: Opacity(
            opacity: _widgetAppearAnimation.value,
            child: Container(
              height: _expendLittleAnimation.value * 45,
              width: _expendLittleAnimation.value * 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(30)),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(AWSServer.getProfileImageUrl(
                      _profileImageToShow!)),
                ),
              ),
              child: Center(
                child: Icon(
                  FontAwesomeIcons.solidHeart,
                  size: _pulseAnimation.value,
                  color: _colorAnimation.value,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
