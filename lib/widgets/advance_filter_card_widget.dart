import 'package:betabeta/constants/onboarding_consts.dart';
import 'package:betabeta/services/networking.dart';
import 'package:betabeta/services/settings_model.dart';
import 'package:flutter/material.dart';

class AdvanceFilterCard extends StatelessWidget {
  final AssetImage image;
  final Widget title;
  final bool? comingSoon;
  final bool? showAI;
  final bool? isActive;
  final Widget? button;
  final String info;
  final void Function()? onTap;
  final Widget? child;
  AdvanceFilterCard(
      {required this.image,
      required this.title,
      required this.info,
      this.child,
      this.comingSoon,
      this.showAI,
      this.isActive = false,
      this.button,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 250,
        decoration: BoxDecoration(
          border: isActive == true
              ? Border.all(color: Color(0xFFC62828), width: 4)
              : Border.all(
                  color: Colors.transparent,
                  width:
                      0), //TODO submit a bug at flutter github if doesn't animate with null
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
          image: isActive == true &&
                  SettingsData.instance.filterDisplayImageUrl != ''
              ? DecorationImage(
                  image: NetworkImage(NetworkHelper.faceUrlToFullUrl(
                      SettingsData.instance.filterDisplayImageUrl)),
                  fit: BoxFit.cover,
                )
              : DecorationImage(
                  image: image,
                  fit: BoxFit.cover,
                ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
            gradient: LinearGradient(colors: [
              Colors.black,
              Colors.transparent,
            ], begin: Alignment.bottomCenter, end: Alignment.center),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: title,
                ),
                if (child != null) Center(child: child!),
                SizedBox(),
                SizedBox(),
                comingSoon == true
                    ? Center(
                        child: Text(
                          'Coming Soon!',
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  blurRadius: 17.0,
                                  color: Colors.black,
                                  offset: Offset(-2.0, 2.0),
                                ),
                              ]),
                        ),
                      )
                    : SizedBox(),
                SizedBox(),
                SizedBox(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            info,
                            style: kSmallInfoStyleWhite,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                          if (showAI != false)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'A.I.',
                                  style: TextStyle(color: Colors.white70),
                                ),
                                Icon(
                                  Icons.psychology_outlined,
                                  color: Colors.white70,
                                  size: 20,
                                ),
                              ],
                            )
                        ],
                      ),
                    ),
                    if (button != null) button!,
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
