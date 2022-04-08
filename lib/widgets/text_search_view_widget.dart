import 'package:betabeta/services/settings_model.dart';
import 'package:flutter/material.dart';

class TextSearchViewWidget extends StatefulWidget {
  const TextSearchViewWidget({Key? key}) : super(key: key);

  @override
  State<TextSearchViewWidget> createState() => _TextSearchViewWidgetState();
}

class _TextSearchViewWidgetState extends State<TextSearchViewWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _firstAnimation;
  late Animation<double> _searchAnimation;
  late Animation<double> _expendLittleAnimation;
  late Animation<double> _widgetAppearAnimation;

  @override
  void initState() {
    _firstAnimation =
        AnimationController(vsync: this, duration: Duration(milliseconds: 400))
          ..forward()
          ..addListener(() {
            setState(() {});
          });
    _widgetAppearAnimation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _firstAnimation, curve: Curves.fastOutSlowIn));
    _expendLittleAnimation = Tween<double>(begin: 0.5, end: 1).animate(
        CurvedAnimation(parent: _firstAnimation, curve: Curves.fastOutSlowIn));
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 5))
          ..forward()
          ..addListener(() {
            setState(() {});
            if (_animationController.isCompleted) {
              _animationController.repeat(reverse: true);
            }
          });
    _searchAnimation =
        Tween<double>(begin: 1, end: 110).animate(_animationController);
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _firstAnimation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: _expendLittleAnimation.value * 44,
        width: _expendLittleAnimation.value * 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: Colors.black.withOpacity(_widgetAppearAnimation.value * 0.9),
        ),
        child: Stack(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  SettingsData.instance.textSearch,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      overflow: TextOverflow.ellipsis,
                      color: Colors.white.withOpacity(0.8)),
                ),
              ),
            ),
            Positioned(
              left: _searchAnimation.value,
              bottom: 5,
              child: Container(
                decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 5.0,
                  ),
                ]),
                height: 35,
                child: Icon(
                  Icons.search,
                  size: _widgetAppearAnimation.value * 30,
                  color: Colors.white.withOpacity(0.65),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
