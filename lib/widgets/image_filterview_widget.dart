import 'package:betabeta/services/networking.dart';
import 'package:betabeta/services/settings_model.dart';
import 'package:flutter/material.dart';

class ImageFilterViewWidget extends StatelessWidget {
  ImageFilterViewWidget({required this.animationController});

  final Animation<double> animationController;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 44,
        width: 100,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(
                  NetworkHelper.faceUrlToFullUrl(
                      SettingsData.instance.filterDisplayImageUrl),
                ))),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Opacity(
                  opacity: 0.8,
                  child: AnimatedIcon(
                      icon: AnimatedIcons.search_ellipsis,
                      color: Colors.white,
                      size: 30,
                      progress: animationController),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
