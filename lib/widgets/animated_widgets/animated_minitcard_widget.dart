import 'package:betabeta/constants/assets_paths.dart';
import 'package:betabeta/constants/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AnimatedMiniTcardWidget extends StatefulWidget {
  AnimatedMiniTcardWidget(
      {Key? key, required this.maleOrFemaleImage, this.CustomButtonWidget})
      : super(key: key);

  final String maleOrFemaleImage;
  late final Widget? CustomButtonWidget;

  @override
  State<AnimatedMiniTcardWidget> createState() =>
      _AnimatedMiniTcardWidgetState();
}

class _AnimatedMiniTcardWidgetState extends State<AnimatedMiniTcardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation swipeAnimation;
  late Animation positionAnimation;
  late Animation expandAnimation;
  late Animation shrinkAnimation;

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 2))
          ..forward()
          ..addListener(() {
            setState(() {});
            if (_controller.isCompleted) {
              _controller.repeat(reverse: true);
            }
          });
    swipeAnimation = Tween<double>(begin: -0.2, end: 0.2).animate(
      CurvedAnimation(
          parent: _controller,
          curve: Curves.fastOutSlowIn,
          reverseCurve: Curves.fastOutSlowIn),
    );
    positionAnimation = Tween<double>(begin: 0, end: 20).animate(
        CurvedAnimation(
            parent: _controller,
            curve: Curves.fastOutSlowIn,
            reverseCurve: Curves.fastOutSlowIn));
    expandAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.fastOutSlowIn,
        reverseCurve: Curves.fastOutSlowIn));
    shrinkAnimation = Tween<double>(begin: 1, end: 0).animate(
        CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn));
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Container(
            margin: EdgeInsets.all(5),
            width: 80,
            height: 110,
            decoration: BoxDecoration(
                border: Border.all(width: 3, color: Colors.white),
                image: DecorationImage(
                    image: AssetImage(AssetsPaths.MiniTcardBackImage),
                    fit: BoxFit.cover),
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                )),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: positionAnimation.value),
          child: Transform.rotate(
            angle: swipeAnimation.value,
            child: Container(
              margin: EdgeInsets.all(5),
              width: 80,
              height: 105,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                border: Border.all(width: 2, color: Colors.white),
                image: DecorationImage(
                    image: AssetImage(widget.maleOrFemaleImage),
                    fit: BoxFit.cover),
              ),
              child: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Colors.black, Colors.transparent],
                        begin: Alignment.bottomCenter,
                        end: Alignment.center),
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(10),
                    )),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        widget.CustomButtonWidget != null
                            ? widget.CustomButtonWidget!
                            : Text(
                                'Swipe',
                                textAlign: TextAlign.center,
                                style: titleStyleWhite.copyWith(
                                    fontSize: 17, height: 0.8),
                              ),
                      ],
                    ),
                    Icon(
                      FontAwesomeIcons.solidThumbsUp,
                      color:
                          Colors.green.withOpacity(expandAnimation.value * 1),
                      size: expandAnimation.value * 35,
                    ),
                    Icon(
                      FontAwesomeIcons.solidThumbsDown,
                      color: Colors.red.withOpacity(shrinkAnimation.value * 1),
                      size: shrinkAnimation.value * 35,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
