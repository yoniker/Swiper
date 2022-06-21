import 'dart:math';

import 'package:betabeta/services/match_engine.dart';
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
    resetUsers();
  }

  void setScreenSize(Size screenSize) => _screenSize = screenSize;

  void startPosition(DragStartDetails details) {
    isDragging = true;
    notifyListeners();
  }

  void resetUsers() {
    _urlImages = <String>[
      'https://unsplash.com/photos/PaCzyxEcqiw/download?ixid=MnwxMjA3fDB8MXxhbGx8fHx8fHx8fHwxNjU0ODI4MjM5&force=true&w=640',
      'https://unsplash.com/photos/n1B6ftPB5Eg/download?ixid=MnwxMjA3fDB8MXxhbGx8fHx8fHx8fHwxNjU0ODM2NzQ3&force=true&w=640',
      'https://unsplash.com/photos/RBerxXPnZPE/download?ixid=MnwxMjA3fDB8MXxhbGx8fHx8fHx8fHwxNjU0ODM2Mjgy&force=true&w=640',
      'https://unsplash.com/photos/Zz5LQe-VSMY/download?ixid=MnwxMjA3fDB8MXxzZWFyY2h8NXx8d29tYW58ZW58MHx8fHwxNjU0NzY4NDY3&force=true&w=640',
      'https://unsplash.com/photos/aoQ4DYZLE_E/download?ixid=MnwxMjA3fDB8MXxhbGx8fHx8fHx8fHwxNjU0ODM2ODE4&force=true&w=640',
      'https://unsplash.com/photos/JoKS3XweV50/download?ixid=MnwxMjA3fDB8MXxhbGx8fHx8fHx8fHwxNjU0ODM2ODM3&force=true&w=640',
      'https://unsplash.com/photos/AoL-mVxprmk/download?ixid=MnwxMjA3fDB8MXxhbGx8fHx8fHx8fHwxNjU0ODMzNDgy&force=true&w=640',
      'https://unsplash.com/photos/0oRefidSNKc/download?force=true&w=640',
      'https://unsplash.com/photos/FcLyt7lW5wg/download?ixid=MnwxMjA3fDB8MXxzZWFyY2h8NTV8fHdvbWFufGVufDB8fHx8MTY1NDc2NzM1Mg&force=true&w=640'
    ].reversed.toList();
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
    _urlImages.removeLast();
    resetPosition();
  }
}
