import 'package:betabeta/constants/onboarding_consts.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class ProgressBar extends StatelessWidget {
  ProgressBar({this.page = 0});
  final double page;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: LinearPercentIndicator(
        lineHeight: 2,
        percent: page / kTotalProgressBarPages,
        backgroundColor: Colors.grey[400],
        progressColor: Colors.blueAccent,
        fillColor: Colors.black26,
      ),
    );
  }
}
