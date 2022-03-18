import 'package:betabeta/constants/color_constants.dart';
import 'package:flutter/material.dart';

class BubblesListWidget extends StatefulWidget {
  BubblesListWidget(
      {this.headline, required this.bubbles, this.maxChoices = 1});

  final String? headline;
  final List<String> bubbles;
  final int maxChoices;

  @override
  State<BubblesListWidget> createState() => _BubblesListWidgetState();
}

class _BubblesListWidgetState extends State<BubblesListWidget> {
  List<String> pickedBubbles = [];

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.headline != null)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                child: Text(
                  '${widget.headline}',
                  style: smallTitleLighterBlack,
                ),
              ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(10),
                child: Wrap(
                  direction: Axis.horizontal,
                  children: widget.bubbles
                      .map((h) => GestureDetector(
                            onTap: () {
                              setState(() {
                                if (pickedBubbles.length <
                                    (widget.maxChoices.toInt() + 1)) ;
                                {
                                  if (pickedBubbles.contains(h) != true) {
                                    pickedBubbles.add(h);
                                  } else {
                                    pickedBubbles.remove(h);
                                  }
                                }
                                if (pickedBubbles.length ==
                                    (widget.maxChoices.toInt() + 1))
                                  pickedBubbles.remove(h);
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  color: pickedBubbles.contains(h)
                                      ? Colors.blue[200]
                                      : null,
                                  border: Border.all(
                                      color: Colors.black, width: 1.5),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30))),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 4),
                                child: Text(
                                  '$h',
                                  style: smallBoldedTitleBlack,
                                ),
                              ),
                            ),
                          ))
                      .toList(),
                ),
              ),
            ),
          ],
        ),
        if (pickedBubbles.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: FloatingActionButton.extended(
              backgroundColor: Colors.blue[800]!.withOpacity(0.8),
              onPressed: () {
                Navigator.pop(context);
              },
              label: Text(
                'OK (${pickedBubbles.length}/${widget.maxChoices})',
                style: boldTextStyleWhite,
              ),
            ),
          ),
      ],
    );
  }
}
