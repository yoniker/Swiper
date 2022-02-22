import 'package:betabeta/constants/color_constants.dart';
import 'package:flutter/material.dart';

import '../constants/onboarding_consts.dart';

class AdvanceFilterCard extends StatelessWidget {
  AssetImage image;
  String title;
  String info;
  Function()? onTap;
  AdvanceFilterCard(
      {required this.image,
      required this.title,
      required this.info,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 250,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
          image: DecorationImage(image: image, fit: BoxFit.cover, opacity: 0.8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(''),
              Text(
                title,
                style: titleStyleWhite,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    info,
                    style: kSmallInfoStyleWhite,
                  ),
                  Text(
                    'Discover',
                    style: TextStyle(color: Colors.white70),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
