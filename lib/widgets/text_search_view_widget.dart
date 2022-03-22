import 'package:betabeta/services/networking.dart';
import 'package:betabeta/services/settings_model.dart';
import 'package:betabeta/widgets/gradient_text_widget.dart';
import 'package:flutter/material.dart';

class TextSearchViewWidget extends StatelessWidget {
  const TextSearchViewWidget({Key? key, required this.animationController})
      : super(key: key);
  final Animation<double> animationController;

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
          alignment: Alignment.center,
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
