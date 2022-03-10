import 'package:flutter/material.dart';

import '../constants/onboarding_consts.dart';

class AdvanceFilterCard extends StatelessWidget {
  AssetImage image;
  Widget title;
  bool? comingSoon;
  bool? showAI;
  bool? isActive;
  Widget? button;
  String info;
  Function()? onTap;
  AdvanceFilterCard(
      {required this.image,
      required this.title,
      required this.info,
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
              : null,
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
          image: DecorationImage(
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
