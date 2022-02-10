

import 'package:flutter/material.dart';

enum ScreenSizeCategory { small, medium, large }

class ScreenSize {
  static ScreenSizeCategory getSize(BuildContext context) {
    Size phoneSize = MediaQuery.of(context).size;
    print(phoneSize.height);
    if (phoneSize.height < 600) {
      return ScreenSizeCategory.small;
    }
    if (phoneSize.height < 800) {
      return ScreenSizeCategory.medium;
    }
    return ScreenSizeCategory.large;
  }
}
