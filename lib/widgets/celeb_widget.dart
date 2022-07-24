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
  CelebWidget({required this.theCeleb, this.celebsInfo, this.onTap,this.celebIndex,Key? key}):super(key: key);
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
          (_imageIndex < ((widget.theCeleb.imagesUrls?.length)??0 - 1));
    }

    return GestureDetector(
      onTap: () {
        print('tapped ${widget.theCeleb.celebName}');
        widget.onTap!();
      },
      child: Container(
          height: 200.0,
          width: 200.0,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.0),
            border: Border.all(
              width: 1.2,
              color: lightCardColor,
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: lightCardColor,
                blurRadius: 12.5,
                spreadRadius: 2.5,
              ),
            ]
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
              (widget.celebIndex!+1).toString()+'.'+ widget.theCeleb.celebName,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: backImageButtonEnabled
                          ? Colors.black
                          : theme.disabledColor,
                    ),
                    onPressed: backImageButtonEnabled
                        ? () {
                            setState(() {
                              _imageIndex -= 1;
                              _imageIndex = max(_imageIndex, 0);
                            });
                          }
                        : () {},
                    iconSize: 25.0),
                imageWidget,
                IconButton(
                  icon: Icon(
                    Icons.arrow_forward_ios,
                    color: nextImageButtonEnabled
                        ? Colors.black
                        : theme.disabledColor,
                  ),
                  onPressed: nextImageButtonEnabled
                      ? () {
                          setState(
                            () {
                              _imageIndex++;
                              _imageIndex = max(
                                0,
                                min(
                                  _imageIndex,
                                  widget.theCeleb.imagesUrls?.length??0 - 1,
                                ),
                              );
                            },
                          );
                        }
                      : () {},
                  iconSize: 25.0,
                )
              ]),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      widget.theCeleb.description??'',
                      style: TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 14.0),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              )
            ],
          )),
    );
  }

  void updateCelebImages() {
    if (widget.theCeleb.imagesUrls != null) {
      celebImages = [];
      for (int imageIndex = 0; imageIndex < (widget.theCeleb.imagesUrls?.length??0); imageIndex++) {
        String url =AWSServer.instance.celebImageUrlToFullUrl(widget.theCeleb.imagesUrls![imageIndex]);
        ExtendedImage img = ExtendedImage.network(url,height: 150.0,width: 150.0,fit:BoxFit.cover,retries: 3,);
        precacheImage(img.image, context);
        celebImages.add(img);
      }
    }
  }
}
