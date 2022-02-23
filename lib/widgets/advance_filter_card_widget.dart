import 'package:betabeta/constants/color_constants.dart';
import 'package:betabeta/widgets/onboarding/input_field.dart';
import 'package:betabeta/widgets/onboarding/rounded_button.dart';
import 'package:flutter/material.dart';

import '../constants/onboarding_consts.dart';

class AdvanceFilterCard extends StatelessWidget {
  AssetImage image;
  Widget title;
  Widget? button;
  String info;
  Function()? onTap;
  AdvanceFilterCard(
      {required this.image,
      required this.title,
      required this.info,
      this.button,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 250,
        decoration: BoxDecoration(
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
                SizedBox(),
                title,
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
                            overflow: TextOverflow.visible,
                          ),
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
