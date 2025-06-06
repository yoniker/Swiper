import 'dart:math';

import 'package:betabeta/constants/color_constants.dart';
import 'package:betabeta/data_models/celeb.dart';
import 'package:betabeta/models/celebs_info_model.dart';
import 'package:betabeta/services/aws_networking.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class CelebWidget extends StatefulWidget {
  final Celeb theCeleb;
  final CelebsInfo? celebsInfo;
  final void Function()? onTap;
  final void Function(String)? onTapCelebImage;
  final int? celebIndex;
  final bool enableCarousel;
  final String? headline;
  final double height;
  final double width;
  CelebWidget(
      {required this.theCeleb,
      this.celebsInfo,
      this.onTap,
      this.height = 300,
      this.width = 200,
      this.enableCarousel = false,
      this.celebIndex,
      this.headline,
      this.onTapCelebImage,
      Key? key})
      : super(key: key);
  @override
  _CelebWidgetState createState() => _CelebWidgetState();
}

class _CelebWidgetState extends State<CelebWidget> {
  int _imageIndex = 0;
  late List<DecorationImage> celebImages;

  @override
  void didChangeDependencies() {
    updateCelebImages();
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant CelebWidget oldWidget) {
    if (oldWidget.theCeleb != widget.theCeleb) {
      _imageIndex = 0;
    }
    updateCelebImages();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    _imageIndex = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool backImageButtonEnabled = false;
    bool nextImageButtonEnabled = false;
    if (widget.theCeleb.imagesUrls == null) {
      widget.celebsInfo!.getCelebImageLinks(widget.theCeleb);
    } else {
      //TODO handle empty celeb images from server

      if (_imageIndex > celebImages.length - 1) {
        _imageIndex = 0;
      }

      backImageButtonEnabled = (_imageIndex > 0);
      nextImageButtonEnabled = (_imageIndex < ((celebImages.length) - 1));
    }

    double iconSize = 45;
    double celebNameFontSize = 28;

    Color themeColor = Colors.white;
    Color disabledColor = Colors.white38;
    List<Shadow>? themeShadows = const [
      Shadow(
        blurRadius: 17.0,
        color: Colors.black,
        offset: Offset(-2.0, 2.0),
      ),
    ];

    Widget Carousel(bool highlighted) {
      return Expanded(
        child: Container(
          margin: EdgeInsets.all(1),
          height: 3,
          decoration: BoxDecoration(
            color: highlighted ? Colors.white : Colors.black12,
            borderRadius: BorderRadius.all(
              Radius.circular(30),
            ),
          ),
        ),
      );
    }

    print('going to show image number $_imageIndex');

    return GestureDetector(
      onTap: () {
        print('tapped ${widget.theCeleb.celebName}');
        widget.onTap?.call();
        if (widget.theCeleb.imagesUrls?.elementAt(_imageIndex) != null) {
          widget.onTapCelebImage
              ?.call((widget.theCeleb.imagesUrls?.elementAt(_imageIndex))!);
        }
      },
      child: Container(
        height: widget.height,
        width: widget.width,
        padding: EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.0),
          image: celebImages.length > 0 ? celebImages[_imageIndex] : null,
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: lightCardColor,
              blurRadius: 12.5,
              spreadRadius: 2.5,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                if (widget.theCeleb.imagesUrls != null && widget.enableCarousel)
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Opacity(
                      opacity: widget.theCeleb.imagesUrls!.length > 1 ? 1 : 0,
                      child: Row(
                        children: widget.theCeleb.imagesUrls!.map(
                          (image_url) {
                            return Carousel(
                                widget.theCeleb.imagesUrls![_imageIndex] ==
                                    image_url);
                          },
                        ).toList(),
                      ),
                    ),
                  ),
                if (widget.headline != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5.0),
                    child: Text(
                      widget.headline!,
                      style: LargeTitleStyle.copyWith(
                          color: themeColor,
                          shadows: themeShadows,
                          fontSize: 17,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.celebIndex != null)
                        Text(
                          (widget.celebIndex! + 1).toString() + '. ',
                          style: LargeTitleStyle.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: celebNameFontSize,
                              color: themeColor),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      Text(
                        widget.theCeleb.celebName,
                        style: LargeTitleStyle.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: celebNameFontSize,
                            color: themeColor,
                            shadows: themeShadows),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (backImageButtonEnabled)
                  IconButton(
                      padding: EdgeInsets.fromLTRB(18, 8, 8, 8),
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: themeColor,
                        shadows: themeShadows,
                      ),
                      onPressed: backImageButtonEnabled
                          ? () {
                              setState(() {
                                _imageIndex -= 1;
                                _imageIndex = max(_imageIndex, 0);
                              });
                            }
                          : () {},
                      iconSize: iconSize),
                SizedBox(
                  width: 100,
                ),
                if (nextImageButtonEnabled)
                  IconButton(
                    icon: Icon(Icons.arrow_forward_ios,
                        color: themeColor, shadows: themeShadows),
                    onPressed: nextImageButtonEnabled
                        ? () {
                            setState(
                              () {
                                _imageIndex++;
                                _imageIndex = max(
                                  0,
                                  min(
                                    _imageIndex,
                                    widget.theCeleb.imagesUrls?.length ?? 0 - 1,
                                  ),
                                );
                              },
                            );
                          }
                        : () {},
                    iconSize: iconSize,
                  )
              ],
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  widget.theCeleb.description ?? '',
                  style: LargeTitleStyle.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                      color: themeColor,
                      shadows: themeShadows),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void updateCelebImages() async {
    print('update celeb image was called');
    celebImages = [];
    if (widget.theCeleb.imagesUrls != null) {
      print(
          'Going to precaches ${widget.theCeleb.imagesUrls?.length ?? 0} images of the celeb ${widget.theCeleb.celebName}');
      List<Future<void>> precacheImagesFutures = [];
      for (int imageIndex = 0;
          imageIndex < (widget.theCeleb.imagesUrls?.length ?? 0);
          imageIndex++) {
        String url = AWSServer.instance
            .celebImageUrlToFullUrl(widget.theCeleb.imagesUrls![imageIndex]);
        DecorationImage img = DecorationImage(
          fit: BoxFit.cover,
          image: ExtendedNetworkImageProvider(url),
        );

        precacheImagesFutures.add(precacheImage(img.image, context));
        celebImages.add(img);
      }
      await Future.wait(precacheImagesFutures);
      print('finished precaching images of ${widget.theCeleb.celebName}');
    }
  }
}
