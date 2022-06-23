import 'package:betabeta/constants/color_constants.dart';
import 'package:flutter/material.dart';

class VoilaSearchButtonWidget extends StatefulWidget {
  const VoilaSearchButtonWidget({Key? key}) : super(key: key);

  @override
  State<VoilaSearchButtonWidget> createState() =>
      _VoilaSearchButtonWidgetState();
}

class _VoilaSearchButtonWidgetState extends State<VoilaSearchButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Text(
          'Search',
          style: TextStyle(
              overflow: TextOverflow.fade,
              color: Colors.black54,
              fontSize: 25,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
