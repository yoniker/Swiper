import 'package:betabeta/constants/onboarding_consts.dart';
import 'package:flutter/material.dart';

class OnboardingColumn extends StatelessWidget {
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final List<Widget> children;
  final image;
  OnboardingColumn(
      {required this.children,
      this.mainAxisAlignment = MainAxisAlignment.center,
      this.image,
      this.crossAxisAlignment = CrossAxisAlignment.center});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: kThemeColor,
      child: Stack(children: [
        Center(
          child: SizedBox(
            height: 180,
            child: image != null ? image : null,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: crossAxisAlignment,
            mainAxisAlignment: mainAxisAlignment,
            children: children,
          ),
        ),
      ]),
    );
  }
}
