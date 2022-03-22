import 'package:betabeta/constants/color_constants.dart';
import 'package:betabeta/widgets/gradient_text_widget.dart';
import 'package:flutter/material.dart';

class VoilaLogoWidget extends StatelessWidget {
  const VoilaLogoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GradientText(
          'Voilà-dating',
          style: TextStyle(
              overflow: TextOverflow.fade,
              color: goldColorish,
              fontSize: 25,
              fontWeight: FontWeight.bold),
          gradient: LinearGradient(colors: [
            Color(0XFFC3932F),
            Color(0XFFD2AB54),
            Color(0XFFC3932F),
          ]),
        ),
      ),
    );
  }
}
