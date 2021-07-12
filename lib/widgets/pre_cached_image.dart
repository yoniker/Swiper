import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';

///
const kFadeInDuration = const Duration(milliseconds: 800);

/// An image Widget with caching capabilities making sure that the UI loads
/// faster.
class PrecachedImage extends StatelessWidget {
  const PrecachedImage({
    Key key,
    @required this.image,
    this.fadeIn = true,
    this.shouldPrecache = true,
    this.color,
    this.fit = BoxFit.cover,
    this.errorBuilder,
    this.height,
    this.width,
  }) : super(key: key);

  final ImageProvider image;
  final bool fadeIn;
  final bool shouldPrecache;
  final Color color;
  final BoxFit fit;
  final Widget Function(BuildContext) errorBuilder;
  final double height;
  final double width;

  PrecachedImage.asset({
    @required String imageURI,
    this.fadeIn = true,
    this.shouldPrecache = true,
    this.fit = BoxFit.cover,
    this.color,
    this.errorBuilder,
    this.width,
    this.height,
    double scale = 4.0,
  }) : this.image = Image.asset(
          imageURI,
          scale: scale,
        ).image;

  PrecachedImage.network({
    @required String imageURL,
    this.fadeIn = true,
    this.shouldPrecache = true,
    this.fit = BoxFit.cover,
    this.color,
    this.errorBuilder,
    this.width,
    this.height,
    double scale = 4.0,
  }) : this.image = Image.network(
          imageURL,
          scale: scale,
        ).image;

  PrecachedImage.uri({
    @required String imageURL,
    this.fadeIn = true,
    this.shouldPrecache = true,
    this.fit = BoxFit.cover,
    this.color,
    this.errorBuilder,
    this.width,
    this.height,
    double scale = 4.0,
  }) : this.image = Image.file(
          File(imageURL),
          scale: scale,
        ).image;

  PrecachedImage.rawFile(
    File file, {
    this.fadeIn = true,
    this.shouldPrecache = true,
    this.fit = BoxFit.cover,
    this.color,
    this.errorBuilder,
    this.width,
    this.height,
    double scale = 4.0,
  }) : this.image = Image.file(
          file,
          scale: scale,
        ).image;

  PrecachedImage.memory({
    @required Uint8List bytes,
    this.fadeIn = true,
    this.shouldPrecache = true,
    this.fit = BoxFit.cover,
    this.color,
    this.errorBuilder,
    this.width,
    this.height,
    double scale = 4.0,
  }) : this.image = Image.memory(
          bytes,
          scale: scale,
        ).image;

  @override
  Widget build(BuildContext context) {
    // pre-cache image when "shouldPrecache" is set to true.
    if (shouldPrecache) precacheImage(image, context);

    ImageFrameBuilder _frameBuilder;

    if (fadeIn) {
      _frameBuilder = (BuildContext context, Widget child, int frame,
          bool wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded) {
          return child;
        }
        return AnimatedOpacity(
          child: child,
          opacity: frame == null ? 0 : 1,
          duration: kFadeInDuration,
          curve: Curves.easeOut,
        );
      };
    }

    var current = Image(
      image: image,
      color: color,
      fit: fit,
      height: height,
      width: width,
      errorBuilder: (context, error, stackTrace) {
        // return the "errorWidget"
        return errorBuilder != null ? errorBuilder.call(context) : SizedBox.shrink();
      },
      frameBuilder: _frameBuilder,
    );

    return current;
  }
}
