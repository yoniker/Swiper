import 'package:betabeta/constants/color_constants.dart';
import 'package:betabeta/constants/onboarding_consts.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:get/get.dart';

class BubblesListWidget extends StatefulWidget {
  BubblesListWidget(
      {this.headline,
      required this.bubbles,
      this.maxChoices = 1,
      required this.initialValue,
      this.disableInteractiveOkButton = false,
      this.onValueChanged});

  final String? headline;
  final List<String> bubbles;
  final int maxChoices;
  final void Function(List<String>)? onValueChanged;
  final bool disableInteractiveOkButton;
  final List<String> initialValue;

  @override
  State<BubblesListWidget> createState() => _BubblesListWidgetState();
}

class _BubblesListWidgetState extends State<BubblesListWidget> {
  List<String> pickedBubbles = [];

  @override
  void initState() {
    pickedBubbles = List.from(widget.initialValue);
    super.initState();
  }

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
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
                child: Text(
                  '${widget.headline}',
                  style: kButtonText,
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
                              widget.onValueChanged?.call(pickedBubbles);
                            },
                            child: Container(
                              margin: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  color: pickedBubbles.contains(h)
                                      ? appMainColor.withOpacity(0.15)
                                      : null,
                                  border: Border.all(
                                      color: pickedBubbles.contains(h)
                                          ? appMainColor
                                          : Colors.black,
                                      width: 1.5),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30))),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 4),
                                child: Text(
                                  '$h',
                                  style: pickedBubbles.contains(h)
                                      ? smallBoldedTitleBlack.copyWith(
                                          color: appMainColor)
                                      : smallBoldedTitleBlack,
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
        if (pickedBubbles.equals(widget.initialValue) != true &&
            widget.disableInteractiveOkButton != true)
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: FloatingActionButton.extended(
              backgroundColor: Colors.red[900]!.withOpacity(0.8),
              onPressed: () {
                Get.back();
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
