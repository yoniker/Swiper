import 'package:betabeta/services/settings_model.dart';
import 'package:flutter/material.dart';

class TextSearchViewWidget extends StatefulWidget {
  const TextSearchViewWidget({Key? key}) : super(key: key);

  @override
  State<TextSearchViewWidget> createState() => _TextSearchViewWidgetState();
}

class _TextSearchViewWidgetState extends State<TextSearchViewWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _searchAnimation;

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
    _searchAnimation =
        Tween<double>(begin: 1, end: 110).animate(CurvedAnimation(
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
        width: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: Colors.black.withOpacity(0.9),
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
                child: FittedBox(
                  child: Icon(
                    Icons.search,
                    color: Colors.white.withOpacity(0.65),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
