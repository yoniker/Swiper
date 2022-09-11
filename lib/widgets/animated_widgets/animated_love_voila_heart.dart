import 'package:betabeta/constants/beta_icon_paths.dart';
import 'package:flutter/material.dart';

class AnimatedLoveVoilaHeart extends StatefulWidget {
  const AnimatedLoveVoilaHeart({Key? key}) : super(key: key);

  @override
  State<AnimatedLoveVoilaHeart> createState() => _AnimatedLoveVoilaHeartState();
}

class _AnimatedLoveVoilaHeartState extends State<AnimatedLoveVoilaHeart>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation _animation;
  late Animation _opacityAnimation;

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 1000))
          ..addListener(() {
            setState(() {});
            if (_controller.isCompleted) {
              _controller.repeat(reverse: true);
            }
          })
          ..forward();
    _animation = Tween<double>(begin: 17, end: 23).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.fastOutSlowIn,
        reverseCurve: Curves.easeIn));
    _opacityAnimation = Tween<double>(begin: 0.3, end: 0.7).animate(
        CurvedAnimation(parent: _controller, curve: Curves.decelerate));
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(_animation.value),
      child: ImageIcon(
        AssetImage(
          BetaIconPaths.voilaLogo,
        ),
        color: Colors.red.withOpacity(_opacityAnimation.value),
      ),
    );
  }
}
