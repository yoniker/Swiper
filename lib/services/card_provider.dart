import 'dart:math';

import 'package:betabeta/services/match_engine.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

enum CardStatus { like, dislike }

class CardProvider extends ChangeNotifier {
  List<Match> _matches = [];
  bool isDragging = false;
  double angle = 0;
  Offset position = Offset.zero;
  Size _screenSize = Size.zero;
  List<Match> get matches => _matches;

  CardProvider() {
    MatchEngine.instance.addListener(() { resetUsers(); notifyListeners();});
    resetUsers();
  }

  void setScreenSize(Size screenSize) => _screenSize = screenSize;

  void startPosition(DragStartDetails details) {
    isDragging = true;
    notifyListeners();
  }

  void resetUsers() {
    _matches = List<Match>.from(MatchEngine.instance.topMatches.reversed);// TODO why does using a sublist here creates a nasty bug?
    notifyListeners();
  }

  void updatePosition(DragUpdateDetails details) {
    position += details.delta;

    final x = position.dx;
    angle = 45 * x / _screenSize.width;

    notifyListeners();
  }

  void endPosition() async {
    isDragging = false;
    notifyListeners();

    final status = getStatus(force: true);

    if (status != null) {
      Fluttertoast.cancel();
      Fluttertoast.showToast(
          msg: status.toString().split('.').last.toUpperCase(), fontSize: 36);
    }

    switch (status) {
      case CardStatus.like:
        like();
        break;
      case CardStatus.dislike:
        dislike();
        break;
      default:
        resetPosition();
    }
  }

  void resetPosition() {
    isDragging = false;
    position = Offset.zero;
    angle = 0;

    notifyListeners();
  }

  double getStatusOpacity() {
    final delta = 100;
    final pos = max(position.dx.abs(), position.dy.abs());
    final opacity = pos / delta;

    return min(opacity, 1);
  }

  double getStatusScale() {
    final delta = 30;
    final pos = max(position.dx.abs(), position.dy.abs());
    final scale = delta / pos;

    return min(scale, 1);
  }

  CardStatus? getStatus({bool force = false}) {
    final x = position.dx;
    final y = position.dy;

    if (force) {
      final delta = 100;

      if (x >= delta) {
        return CardStatus.like;
      } else if (x <= -delta) {
        return CardStatus.dislike;
      }
    } else {
      final delta = 0;

      if (x >= delta) {
        return CardStatus.like;
      } else if (x <= -delta) {
        return CardStatus.dislike;
      }
    }
  }

  void like() {
    angle = 20;
    position += Offset(2 * _screenSize.width / 2, 0);
    _nextCard(decision: Decision.like);

    notifyListeners();
  }

  void dislike() {
    angle = -20;
    position -= Offset(2 * _screenSize.width, 0);
    _nextCard(decision: Decision.nope);
    notifyListeners();
  }

  Future _nextCard({required Decision decision}) async {
    if (_matches.isEmpty) return;

    await Future.delayed(Duration(milliseconds: 200));
    print(MatchEngine.instance.currentMatch()!.profile!.username);
    MatchEngine.instance.currentMatchDecision(decision);
    resetPosition();
    resetUsers();
  }
}
