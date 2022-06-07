import 'package:flutter/material.dart';

class CardProvider extends ChangeNotifier {
  bool isDragging = false;
  double angle = 0;
  Offset position = Offset.zero;
  Size _screenSize = Size.zero;

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
    resetPosition();
  }

  void resetPosition() {
    isDragging = false;
    position = Offset.zero;
    angle = 0;

    notifyListeners();
  }
}
