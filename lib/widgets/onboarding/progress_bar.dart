import 'package:flutter/material.dart';

class ProgressBar extends StatefulWidget {
  ProgressBar({this.page = 0});
  int page;

  @override
  State<ProgressBar> createState() => _ProgressBarState();
}

class _ProgressBarState extends State<ProgressBar> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20),
      child: Container(
        height: 2,
        width: MediaQuery.of(context).size.width,
        color: Colors.grey[300],
        child: Row(
          children: [
            for (int x = 0; x < 8; x++)
              Expanded(
                child: Container(
                  color: widget.page > x ? Colors.blueAccent : null,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
