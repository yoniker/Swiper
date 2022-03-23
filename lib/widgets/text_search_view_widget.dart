import 'package:betabeta/services/settings_model.dart';
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
              left: animationController.value * 110,
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
