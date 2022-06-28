import 'package:betabeta/constants/beta_icon_paths.dart';
import 'package:betabeta/constants/color_constants.dart';
import 'package:betabeta/widgets/gradient_text_widget.dart';
import 'package:flutter/material.dart';

class VoilaLogoWidget extends StatefulWidget {
  const VoilaLogoWidget({Key? key, this.freeText = 'Voilà-dating'})
      : super(key: key);
  final String freeText;
  @override
  State<VoilaLogoWidget> createState() => _VoilaLogoWidgetState();
}

class _VoilaLogoWidgetState extends State<VoilaLogoWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _animation;

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 800))
          ..forward()
          ..addListener(() {
            setState(() {});
          });
    _animation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
        parent: _animationController, curve: Curves.fastOutSlowIn));
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Opacity(
          opacity: _animation.value,
          child: Image.asset(
            BetaIconPaths.voilaLogoBlackALT,
            scale: 9,
          ),
        ),
      ),
    );
  }
}
