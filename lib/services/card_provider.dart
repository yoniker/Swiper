import 'dart:math';

import 'package:betabeta/services/match_engine.dart';
import 'package:betabeta/services/new_networking.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

enum CardStatus { like, dislike }

class CardProvider extends ChangeNotifier {
  List<String> _urlImages = [];
  bool isDragging = false;
  double angle = 0;
  Offset position = Offset.zero;
  Size _screenSize = Size.zero;

  List<String> get urlImages => _urlImages;

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
    _urlImages = MatchEngine.instance.matches.reversed.map((match) =>
    NewNetworkService.getProfileImageUrl(match.profile!.imageUrls![0])).toList();
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
    _nextCard();

    notifyListeners();
  }

  void dislike() {
    angle = -20;
    position -= Offset(2 * _screenSize.width, 0);
    _nextCard();
    notifyListeners();
  }

  void skip() {
    angle = 0;
    position -= Offset(0, _screenSize.height);
    _nextCard();
    notifyListeners();
  }

  Future _nextCard() async {
    if (_urlImages.isEmpty) return;

    await Future.delayed(Duration(milliseconds: 200));
    MatchEngine.instance.currentMatchDecision(Decision.nope);
    resetPosition();
    resetUsers();
  }
}
