import 'dart:math';
import 'package:betabeta/services/card_provider.dart';
import 'package:betabeta/services/match_engine.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'match_card.dart';

class VoilaCardWidget extends StatefulWidget {
  final Match match;
  final bool isFront;
  const VoilaCardWidget(
      {Key? key, required this.match, required this.isFront})
      : super(key: key);

  @override
  State<VoilaCardWidget> createState() => _VoilaCardWidgetState();
}

class _VoilaCardWidgetState extends State<VoilaCardWidget> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final size = MediaQuery.of(context).size;

      final provider = Provider.of<CardProvider>(context, listen: false);
      provider.setScreenSize(size);
    });
  }

  Widget build(BuildContext context) {
    return SizedBox(
      child: widget.isFront
          ? SizedBox.expand(child: buildFrontCard())
          : SizedBox.expand(child: buildBackCard()),
    );
  }

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
              child: Stack(
                children: [
                  buildCard(),
                  buildStamps(),
                ],
              ),
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

  Widget buildBackCard() {
    final provider = Provider.of<CardProvider>(context, listen: false);
    final scale = provider.getStatusScale();
    final milliseconds = provider.isDragging ? 0 : 400;

    return AnimatedContainer(
      curve: Curves.easeInOut,
      padding:
          EdgeInsets.symmetric(vertical: scale * 30, horizontal: scale * 15),
      duration: Duration(milliseconds: milliseconds),
      child: buildCard(),
    );
  }

  Widget buildCard() {
    return MatchCard(
      scrollController: null,
      key: Key(widget.match.profile!.uid),
      profile: widget.match.profile!,
      showCarousel: true,
      clickable: widget.isFront,
    );
  }

  Widget buildStamps() {
    final provider = Provider.of<CardProvider>(context);
    final status = provider.getStatus();
    final opacity = provider.getStatusOpacity();

    switch (status) {
      case CardStatus.like:
        final child = buildStamp(
            color: Colors.green, text: 'Voilà', angle: -0.5, opacity: opacity);

        return Positioned(
          child: child,
          top: 64,
          left: 50,
        );

      case CardStatus.dislike:
        final child = buildStamp(
            color: Colors.red, text: 'Dislike', angle: 0.5, opacity: opacity);

        return Positioned(
          child: child,
          top: 64,
          right: 50,
        );

      default:
        return Container();
    }
  }

  Widget buildStamp(
      {double angle = 0,
      required Color color,
      required String text,
      required double opacity}) {
    return Opacity(
      opacity: opacity,
      child: Transform.rotate(
        angle: angle,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8),
          // margin: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: color, width: 4)),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: color, fontSize: 48, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
