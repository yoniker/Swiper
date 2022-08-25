import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class FemaleAvatarRive extends StatelessWidget {
  const FemaleAvatarRive({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RiveAnimation.asset(
      'assets/rive/star_test.riv',
      fit: BoxFit.contain,
    );
  }
}
