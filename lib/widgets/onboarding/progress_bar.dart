import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class ProgressBar extends StatelessWidget {
  ProgressBar({this.page = 0, required this.totalProgressBarPages});
  final double page;
  final int totalProgressBarPages;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: LinearPercentIndicator(
        lineHeight: 3,
        percent: page / totalProgressBarPages,
        backgroundColor: Colors.grey[400],
        progressColor: Colors.black,
        animation: true,
        animateFromLastPercent: true,
        animationDuration: 200,
        fillColor: Colors.black.withOpacity(0.05),
      ),
    );
  }
}
