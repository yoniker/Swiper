import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';

/// An image Widget with caching capabilities making sure that the UI loads
/// faster.
class PrecachedImage extends StatelessWidget {
  const PrecachedImage({
    Key key,
    @required this.image,
    this.color,
    this.fit = BoxFit.cover,
    this.errorWidget,
    this.height,
    this.width,
  }) : super(key: key);

  final ImageProvider image;
  final Color color;
  final BoxFit fit;
  final Widget errorWidget;
  final double height;
  final double width;

  PrecachedImage.asset({
    @required String imageURI,
    this.fit = BoxFit.cover,
    this.color,
    this.errorWidget,
    this.width,
    this.height,
    double scale = 4.0,
  }) : this.image = Image.asset(
          imageURI,
          scale: scale,
        ).image;

  PrecachedImage.network({
    @required String imageURL,
    this.fit = BoxFit.cover,
    this.color,
    this.errorWidget,
    this.width,
    this.height,
    double scale = 4.0,
  }) : this.image = Image.network(
          imageURL,
          scale: scale,
        ).image;

  PrecachedImage.file({
    @required String imageURL,
    this.fit = BoxFit.cover,
    this.color,
    this.errorWidget,
    this.width,
    this.height,
    double scale = 4.0,
  }) : this.image = Image.file(
          File(imageURL),
          scale: scale,
        ).image;

  PrecachedImage.memory({
    @required Uint8List bytes,
    this.fit = BoxFit.cover,
    this.color,
    this.errorWidget,
    this.width,
    this.height,
    double scale = 4.0,
  }) : this.image = Image.memory(
          bytes,
          scale: scale,
        ).image;

  @override
  Widget build(BuildContext context) {
    // pre-cache image.
    precacheImage(image, context);

    return Image(
      image: image,
      color: color,
      fit: fit,
      height: height,
      width: width,
      errorBuilder: (context, error, stackTrace) {
        // return the "errorWidget"
        return errorWidget ?? SizedBox.shrink();
      },
    );
  }
}
