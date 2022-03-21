import 'package:betabeta/constants/color_constants.dart';
import 'package:betabeta/constants/lists_consts.dart';
import 'package:flutter/material.dart';

class BubbleEditBlock extends StatefulWidget {
  BubbleEditBlock({this.title, this.bubbles, this.onTap, this.altEmptyBubbles});

  final String? title;
  final List<String>? bubbles;
  final Function()? onTap;
  final List<String>? altEmptyBubbles;

  @override
  State<BubbleEditBlock> createState() => _BubbleEditBlockState();
}

class _BubbleEditBlockState extends State<BubbleEditBlock> {
  List<String> emptyList = List.from(kEmptyBubbles);

  @override
  void initState() {
    if (widget.altEmptyBubbles != null)
      emptyList = List.from(widget.altEmptyBubbles!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            ' ${widget.title}',
            style: smallBoldedTitleBlack,
          ),
          SizedBox(
            height: 5,
          ),
          GestureDetector(
            onTap: widget.onTap,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Wrap(
                    children:
                        widget.bubbles == null || widget.bubbles!.length == 0
                            ? emptyList
                                .map((e) => Opacity(
                                      opacity: 0.3,
                                      child: Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 5, vertical: 5),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.grey, width: 1.5),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(
                                              30,
                                            ),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10.0, vertical: 4),
                                          child: Text(
                                            e,
                                            style: TextStyle(
                                                fontFamily: 'Nunito',
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey),
                                          ),
                                        ),
                                      ),
                                    ))
                                .toList()
                            : widget.bubbles!
                                .map((e) => Container(
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 5),
                                      decoration: BoxDecoration(
                                        color: Colors.blue[100],
                                        border: Border.all(
                                            color: Colors.blueAccent,
                                            width: 1.5),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(
                                            30,
                                          ),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10.0, vertical: 4),
                                        child: Text(
                                          e,
                                          style: smallBoldedTitleBlack.copyWith(
                                              color: Colors.blue),
                                        ),
                                      ),
                                    ))
                                .toList()),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
