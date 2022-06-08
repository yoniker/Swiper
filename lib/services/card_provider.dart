import 'package:betabeta/services/match_engine.dart';
import 'package:flutter/material.dart';

enum CardStatus { like, dislike, skip }

class CardProvider extends ChangeNotifier {
  List<Match?> matchCards = [];
  bool isDragging = false;
  double angle = 0;
  Offset position = Offset.zero;
  Size _screenSize = Size.zero;

  CardProvider() {
    resetUsers();
  }

  void resetUsers() {
    matchCards = [
      if (MatchEngine.instance.currentMatch() != null)
        MatchEngine.instance.currentMatch(),
      if (MatchEngine.instance.nextMatch() != null)
        MatchEngine.instance.nextMatch()
    ].reversed.toList();
  }

  void setScreenSize(Size screenSize) => _screenSize = screenSize;

  void startPosition(DragStartDetails details) {
    isDragging = true;

    notifyListeners();
  }

  void updatePosition(DragUpdateDetails details) {
    position += details.delta;

    final x = position.dx;
    angle = 45 * x / _screenSize.width;

    notifyListeners();
  }

  void endPosition() {
    isDragging = false;
    notifyListeners();

    final status = getStatus();

    switch (status) {
      case CardStatus.like:
        like();
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

  CardStatus? getStatus() {
    final x = position.dx;

    final delta = 100;

    if (x >= delta) {
      return CardStatus.like;
    }
    return null;
  }

  void like() {
    angle = 20;
    position += Offset(2 * _screenSize.width / 2, 0);
    _nextCard();

    notifyListeners();
  }

  Future _nextCard() async {
    if (matchCards.isEmpty) return;

    await Future.delayed(Duration(milliseconds: 200));
    matchCards.removeLast();
    resetPosition();
  }
}
