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
  final int? celebIndex;
  final bool backgroundImageMode;
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
      this.backgroundImageMode = false,
      this.enableCarousel = false,
      this.celebIndex,
      this.headline,
      Key? key})
      : super(key: key);
  @override
  _CelebWidgetState createState() => _CelebWidgetState();
}

class _CelebWidgetState extends State<CelebWidget> {
  int _imageIndex = 0;
  late List<ExtendedImage> celebImages;

  @override
  void didChangeDependencies() {
    celebImages = [];
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
    Widget imageWidget;
    final ThemeData theme = Theme.of(context);
    bool backImageButtonEnabled = false;
    bool nextImageButtonEnabled = false;
    if (widget.theCeleb.imagesUrls == null) {
      widget.celebsInfo!.getCelebImageLinks(widget.theCeleb);
      imageWidget = Text('Loading...');
    } else {
      //TODO handle empty celeb images from server

      if (_imageIndex > widget.theCeleb.imagesUrls!.length - 1) {
        _imageIndex = 0;
      }
      imageWidget = ClipOval(
        child: celebImages[_imageIndex],
      );

      backImageButtonEnabled = (_imageIndex > 0);
      nextImageButtonEnabled =
          (_imageIndex < ((widget.theCeleb.imagesUrls?.length) ?? 0 - 1));
    }

    double iconSize = 45;
    double celebNameFontSize = widget.backgroundImageMode ? 28 : 20;

    Color themeColor = widget.backgroundImageMode ? Colors.white : Colors.black;
    Color disabledColor =
        widget.backgroundImageMode ? Colors.white38 : theme.disabledColor;
    List<Shadow>? themeShadows = widget.backgroundImageMode
        ? const [
            Shadow(
              blurRadius: 17.0,
              color: Colors.black,
              offset: Offset(-2.0, 2.0),
            ),
          ]
        : null;

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

    return GestureDetector(
      onTap: () {
        print('tapped ${widget.theCeleb.celebName}');
        widget.onTap!();
      },
      child: Container(
        height: widget.height,
        width: widget.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.0),
          image: widget.backgroundImageMode
              ? DecorationImage(
                  fit: BoxFit.cover,
                  image: ExtendedNetworkImageProvider(AWSServer.instance
                      .celebImageUrlToFullUrl(
                          widget.theCeleb.imagesUrls![_imageIndex])))
              : null,
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: lightCardColor,
              blurRadius: 12.5,
              spreadRadius: 2.5,
            ),
          ],
        ),
        child: Stack(children: [
          if (widget.theCeleb.imagesUrls != null && widget.enableCarousel)
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: widget.theCeleb.imagesUrls!.map(
                  (image) {
                    return Carousel(
                        widget.theCeleb.imagesUrls![_imageIndex] == image);
                  },
                ).toList(),
              ),
            ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
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
                  IconButton(
                      padding: EdgeInsets.fromLTRB(18, 8, 8, 8),
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color:
                            backImageButtonEnabled ? themeColor : disabledColor,
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
                  widget.backgroundImageMode == false
                      ? imageWidget
                      : SizedBox(
                          width: 100,
                        ),
                  IconButton(
                    icon: Icon(Icons.arrow_forward_ios,
                        color:
                            nextImageButtonEnabled ? themeColor : disabledColor,
                        shadows: themeShadows),
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
        ]),
      ),
    );
  }

  void updateCelebImages() async {
    if (widget.theCeleb.imagesUrls != null) {
      celebImages = [];
      List<Future<void>> precacheImagesFutures = [];
      for (int imageIndex = 0;
          imageIndex < (widget.theCeleb.imagesUrls?.length ?? 0);
          imageIndex++) {
        String url = AWSServer.instance
            .celebImageUrlToFullUrl(widget.theCeleb.imagesUrls![imageIndex]);
        ExtendedImage img = ExtendedImage.network(url,
            height: 150.0, width: 150.0, fit: BoxFit.cover);
        precacheImagesFutures.add(precacheImage(img.image, context));
        celebImages.add(img);
      }
      await Future.wait(precacheImagesFutures);
    }
  }
}
