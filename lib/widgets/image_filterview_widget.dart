import 'package:betabeta/services/networking.dart';
import 'package:betabeta/services/settings_model.dart';
import 'package:flutter/material.dart';

class ImageFilterViewWidget extends StatefulWidget {
  @override
  State<ImageFilterViewWidget> createState() => _ImageFilterViewWidgetState();
}

class _ImageFilterViewWidgetState extends State<ImageFilterViewWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _searchAnimation;

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 3))
          ..forward()
          ..addListener(() {
            setState(() {});
            if (_animationController.isCompleted) {
              _animationController.repeat(reverse: true);
            }
          });
    _searchAnimation = Tween<double>(begin: 1, end: 60).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.fastOutSlowIn,
    ));
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
      child: Container(
        height: 44,
        width: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          image: SettingsData.instance.filterDisplayImageUrl != ''
              ? DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                    NetworkHelper.faceUrlToFullUrl(
                        SettingsData.instance.filterDisplayImageUrl),
                  ),
                )
              : DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage('assets/images/picture5.png'),
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
                size: 40,
              ),
            )
          ],
        ),
      ),
    );
  }
}
