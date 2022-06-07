import 'dart:math';

import 'package:betabeta/services/card_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'match_card.dart';

class VoilaCardWidget extends StatefulWidget {
  final MatchCard matchCard;
  const VoilaCardWidget({Key? key, required this.matchCard}) : super(key: key);

  @override
  State<VoilaCardWidget> createState() => _VoilaCardWidgetState();
}

class _VoilaCardWidgetState extends State<VoilaCardWidget> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final size = MediaQuery.of(context).size;

      final provider = Provider.of<CardProvider>(context, listen: true);
      provider.setScreenSize(size);
    });
  }

  Widget build(BuildContext context) => SizedBox.expand(
        child: buildFrontCard(),
      );

  Widget buildFrontCard() => GestureDetector(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final provider = Provider.of<CardProvider>(context, listen: true);
            final position = provider.position;
            final milliseconds = provider.isDragging ? 0 : 400;

            final center = constraints.smallest.center(Offset.zero);
            final angle = provider.angle * pi / 180;
            final rotatedMatrix = Matrix4.identity()
              ..translate(center.dx, center.dy)
              ..rotateZ(angle)
              ..translate(-center.dx, -center.dy);

            return AnimatedContainer(
              curve: Curves.easeInOut,
              duration: Duration(milliseconds: milliseconds),
              transform: rotatedMatrix..translate(position.dx, position.dy),
              child: buildCard(),
            );
          },
        ),
        onPanStart: (details) {
          final provider = Provider.of<CardProvider>(context, listen: false);

          provider.startPosition(details);
        },
        onPanUpdate: (details) {
          final provider = Provider.of<CardProvider>(context, listen: false);

          provider.updatePosition(details);
        },
        onPanEnd: (details) {
          final provider = Provider.of<CardProvider>(context, listen: false);

          provider.endPosition();
        },
      );

  Widget buildCard() =>
      Padding(padding: EdgeInsets.all(8), child: widget.matchCard);
}
