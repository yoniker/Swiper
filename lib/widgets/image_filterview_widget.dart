import 'package:betabeta/constants/enums.dart';
import 'package:betabeta/services/aws_networking.dart';
import 'package:betabeta/services/settings_model.dart';
import 'package:flutter/material.dart';

class ImageFilterViewWidget extends StatefulWidget {
  @override
  State<ImageFilterViewWidget> createState() => _ImageFilterViewWidgetState();
}

class _ImageFilterViewWidgetState extends State<ImageFilterViewWidget>
    with TickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _searchAnimation;
  late AnimationController _firstAnimation;
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
    _expendLittleAnimation = Tween<double>(begin: 0.8, end: 1).animate(
        CurvedAnimation(parent: _firstAnimation, curve: Curves.fastOutSlowIn));
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 4))
          ..forward()
          ..addListener(() {
            setState(() {});
            if (_animationController.isCompleted) {
              _animationController.repeat(reverse: true);
            }
          });
    _searchAnimation =
        Tween<double>(begin: 1, end: 60).animate(_animationController);
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
        width: _expendLittleAnimation.value * 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          image: SettingsData.instance.filterDisplayImageUrl != ''
              ? DecorationImage(
                  opacity: _widgetAppearAnimation.value,
                  fit: BoxFit.cover,
                  image: NetworkImage(
                    SettingsData.instance.filterType == FilterType.CUSTOM_IMAGE?
                      AWSServer.instance.CustomFaceLinkToFullUrl(
                        SettingsData.instance.filterDisplayImageUrl):
                        AWSServer.instance.celebImageUrlToFullUrl(SettingsData.instance.filterDisplayImageUrl)
                    ,
                  ),
                )
              : DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage('assets/images/celeb3.jpg'),
                ),
        ),
        child: Stack(
          children: [
            Positioned(
              left: _searchAnimation.value,
              bottom: 2,
              child: Icon(
                Icons.search,
                color: Colors.white.withOpacity(0.65),
                size: _widgetAppearAnimation.value * 40,
              ),
            )
          ],
        ),
      ),
    );
  }
}
