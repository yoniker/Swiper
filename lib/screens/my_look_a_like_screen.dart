import 'package:betabeta/constants/color_constants.dart';
import 'package:betabeta/data_models/celeb.dart';
import 'package:betabeta/models/celebs_info_model.dart';
import 'package:betabeta/services/aws_networking.dart';
import 'package:betabeta/services/settings_model.dart';
import 'package:betabeta/widgets/celeb_widget.dart';
import 'package:betabeta/widgets/custom_app_bar.dart';
import 'package:betabeta/widgets/listener_widget.dart';
import 'package:betabeta/widgets/pre_cached_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

import '../constants/assets_paths.dart';

class MyLookALikeScreen extends StatefulWidget {
  const MyLookALikeScreen({Key? key}) : super(key: key);

  @override
  State<MyLookALikeScreen> createState() => _MyLookALikeScreenState();
  static const String routeName = '/my_celeb_look_a_like';
}

class CelebDetails {
  Celeb celeb;
  double faceRecognitionDistance;
  CelebDetails({required this.celeb, required this.faceRecognitionDistance});
}

class _MyLookALikeScreenState extends State<MyLookALikeScreen> {
  String selectedImage = '';
  ServerResponse currentState = ServerResponse.InProgress;
  List<String> facesUrls = [];
  List<CelebSimilarityDetails> celebsSimilarities = [];
  bool profileIsBeingProcessed = false;
  bool celebsBeingProcessed = false;

  Future<void> updateCelebs(String link) async {
    setState(() {
      celebsBeingProcessed = true;
    });
    celebsSimilarities =
        await AWSServer.instance.getSimilarCelebsByImageUrl(link);
    setState(() {
      celebsBeingProcessed = false;
    });
  }

  Future<void> updateProfileFacesUrls() async {
    var response = await AWSServer.instance.getProfileFacesAnalysis();
    ServerResponse serverResponse = response.item2;
    List<String>? data = response.item1;
    while (serverResponse == ServerResponse.InProgress) {
      if (mounted)
        setState(() {
          profileIsBeingProcessed = true;
        });
      //TODO Nitzan update UI to show this is being processed at the server
      await Future.delayed(Duration(
          seconds:
              1)); //TODO in the future,might replace polling with a websocket/FCM push
      response = await AWSServer.instance.getProfileFacesAnalysis();
      serverResponse = response.item2;
      data = response.item1;
    }
    if (mounted)
      setState(() {
        profileIsBeingProcessed = false;
      });

    if (serverResponse == ServerResponse.Success && data != null) {
      setState(() {
        facesUrls = data!;
      });
    } //TODO what if not successful?
  }

  String ConvertDistanceToString(double distance) {
    if (distance < 1.1) return 'You look almost identical to';
    if (distance < 1.15) return 'You look extremely similar to';
    if (distance < 1.2) return 'You look very similar to';
    if (distance < 1.3)
      return 'You look somewhat like';
    else
      return 'You look a bit like';
  }

  ScrollController? scrollController = ScrollController();

  @override
  void initState() {
    updateProfileFacesUrls();
    super.initState();
  }

  @override
  void dispose() {
    if (scrollController != null) scrollController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenerWidget(
      notifier: SettingsData.instance,
      builder: (context) {
        return Scaffold(
          backgroundColor: backgroundThemeColor,
          appBar: CustomAppBar(
            elevation: 0,
            hasTopPadding: true,
            title: 'Which Celeb Looks-Like-Me?',
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(
                    top: 8.0,
                    bottom: 12.0,
                    left: 5.0,
                    right: 5.0,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: 30.5,
                      maxHeight: 100.5,
                      minWidth: 250.0,
                      maxWidth: MediaQuery.of(context).size.width,
                    ),
                    child: !(facesUrls.length > 0)
                        ? Center(
                            child: Text(
                              profileIsBeingProcessed?'Analyzing your profile':'No faces found in profile images',
                              style: mediumBoldedCharStyle,
                            ),
                          )
                        : RawScrollbar(
                            scrollbarOrientation: ScrollbarOrientation.top,
                            controller: scrollController,
                            thumbVisibility: true,
                            radius: Radius.circular(30),
                            thickness: 5,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 12.0),
                              child: ListView.separated(
                                controller: scrollController,
                                scrollDirection: Axis.horizontal,
                                itemCount: facesUrls.length,
                                itemBuilder: (cntx, index) {
                                  final String _url =
                                      AWSServer.profileFaceLinkToFullUrl(
                                          facesUrls[index]);
                                  return GestureDetector(
                                    onTap: () {
                                      if (selectedImage != _url)
                                        setState(() {
                                          selectedImage = _url;
                                        });
                                      else
                                        setState(() {
                                          selectedImage = '';
                                        });
                                      updateCelebs(facesUrls[index]);
                                    },
                                    child: ConstrainedBox(
                                      constraints: BoxConstraints(
                                        minHeight: 30.5,
                                        maxHeight: 100.5,
                                        minWidth: 30.5,
                                        maxWidth: 100.5,
                                      ),
                                      // height: 80.5,
                                      // width: 100.0,
                                      child: AspectRatio(
                                        aspectRatio: 1 / 1,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.grey,
                                                  offset: Offset(-2, 0),
                                                  blurRadius: 2),
                                            ],
                                            border: selectedImage == _url
                                                ? Border.all(
                                                    width: 3,
                                                    color: Colors.white)
                                                : null,
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                                image: NetworkImage(_url),
                                                fit: BoxFit.cover),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                separatorBuilder: (cntx, index) {
                                  return SizedBox(width: 16.0);
                                },
                              ),
                            ),
                          ),
                  ),
                ),
                profileIsBeingProcessed
                    ? Container(
                        height: MediaQuery.of(context).size.height * 0.5,
                        width: MediaQuery.of(context).size.width,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : celebsBeingProcessed
                        ? Container(
                            height: MediaQuery.of(context).size.height * 0.5,
                            width: MediaQuery.of(context).size.width,
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : selectedImage != ''
                            ? Wrap(
                                direction: Axis.vertical,
                                children: celebsSimilarities.map((celeb) {
                                  Celeb currentCeleb = celeb.celeb;
                                  double currentDistance =
                                      celeb.faceRecognitionDistance;
                                  return Container(
                                      margin: EdgeInsets.only(
                                        top: 10,
                                      ),
                                      height: 300,
                                      width: MediaQuery.of(context).size.width *
                                          0.9,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(30),
                                          bottom: Radius.circular(10),
                                        ),
                                      ),
                                      child: CelebWidget(
                                        enableCarousel: true,
                                        key: ValueKey(currentCeleb.celebName),
                                        backgroundImageMode: true,
                                        headline: ConvertDistanceToString(
                                            currentDistance),
                                        theCeleb: currentCeleb,
                                        celebsInfo: CelebsInfo.instance,
                                        onTap: () {
                                          print(
                                              'pressed ${currentCeleb.celebName} which has distance $currentDistance');
                                        },
                                      ));
                                }).toList(),
                              )
                            : Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.6,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: AssetImage(
                                        AssetsPaths.starPictureCeleb),
                                  ),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                          colors: [
                                        backgroundThemeColor,
                                        Colors.white.withOpacity(0.85),
                                        Colors.white.withOpacity(0.85),
                                        backgroundThemeColor
                                      ],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter)),
                                  child: Center(
                                    child: Text(
                                      'Pick a face to find out who you look like!',
                                      textAlign: TextAlign.center,
                                      style:
                                          kWhiteDescriptionShadowStyle.copyWith(
                                              fontSize: 30,
                                              color: Colors.white),
                                      overflow: TextOverflow.fade,
                                    ),
                                  ),
                                ),
                              ),
                SizedBox(
                  height: 20,
                )
                // Container(
                //   width: MediaQuery.of(context).size.width * 0.95,
                //   height: MediaQuery.of(context).size.width * 0.85,
                //   decoration: kSettingsBlockBoxDecor,
                //   child: profileIsBeingProcessed
                //       ? Center(
                //           child: CircularProgressIndicator(),
                //         )
                //       : celebsBeingProcessed
                //           ? Center(
                //               child: CircularProgressIndicator(),
                //             )
                //           : ListView.separated(
                //               physics: BouncingScrollPhysics(),
                //               //controller: _listController,
                //               separatorBuilder:
                //                   (BuildContext context, int index) {
                //                 return SizedBox(height: 15.0);
                //               },
                //               itemCount: celebsSimilarities.length,
                //               itemBuilder: (BuildContext context, int index) {
                //                 Celeb currentCeleb =
                //                     celebsSimilarities[index].celeb;
                //                 double currentDistance =
                //                     celebsSimilarities[index]
                //                         .faceRecognitionDistance;
                //                 return CelebWidget(
                //                   backgroundImageMode: true,
                //                   key: ValueKey(currentCeleb.celebName),
                //                   theCeleb: currentCeleb,
                //                   celebsInfo: CelebsInfo.instance,
                //                   celebIndex: index,
                //                   onTap: () {
                //                     print(
                //                         'pressed ${currentCeleb.celebName} which has distance $currentDistance');
                //                   },
                //                 );
                //               },
                //             ),
                // )
              ],
            ),
          ),
        );
      },
    );
  }
}
