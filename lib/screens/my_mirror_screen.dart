import 'package:betabeta/constants/app_functionality_consts.dart';
import 'package:betabeta/constants/beta_icon_paths.dart';
import 'package:betabeta/constants/color_constants.dart';
import 'package:betabeta/services/aws_networking.dart';
import 'package:betabeta/services/settings_model.dart';
import 'package:betabeta/widgets/custom_app_bar.dart';
import 'package:betabeta/widgets/listener_widget.dart';
import 'package:betabeta/widgets/rive_animations/avatar_rive.dart';
import 'package:betabeta/widgets/voila_logo_widget.dart';
import 'package:flutter/material.dart';

import 'dart:math' as math;

import 'package:get/get.dart';

import '../constants/assets_paths.dart';

class MyMirrorScreen extends StatefulWidget {
  const MyMirrorScreen({Key? key}) : super(key: key);

  @override
  State<MyMirrorScreen> createState() => _MyMirrorScreenState();
  static const String routeName = '/my_mirror';
}

class _MyMirrorScreenState extends State<MyMirrorScreen> {
  String selectedImage = '';
  ServerResponse currentState = ServerResponse.InProgress;
  List<String> facesUrls = [];
  Map traits = {};
  bool profileIsFacesBeingProcessed = false;
  bool traitsBeingFetched = false;

  Future<void> updateTraits(String link) async {
    if (mounted)
      setState(() {
        traitsBeingFetched = true;
      });
    traits = await AWSServer.instance.getTraitsByImageUrl(link);
    if (mounted)
      setState(() {
        traitsBeingFetched = false;
      });
  }

  Future<void> updateProfileFacesUrls() async {
    var response = await AWSServer.instance.getProfileFacesAnalysis();
    ServerResponse serverResponse = response.item2;
    List<String>? data = response.item1;
    while (serverResponse == ServerResponse.InProgress) {
      if (mounted)
        setState(() {
          profileIsFacesBeingProcessed = true;
        });
      //TODO Nitzan update UI to show this is being processed at the server
      await Future.delayed(Duration(
          seconds:
              1)); //TODO in the future,might replace polling with a websocket/FCM push
      response = await AWSServer.instance.getProfileFacesAnalysis();
      serverResponse = response.item2;
      data = response.item1;
    }

    setState(() {
      profileIsFacesBeingProcessed = false;
    });

    if (serverResponse == ServerResponse.Success && data != null) {
      setState(() {
        facesUrls = data!;
      });
    } //TODO what if not successful?
  }

  @override
  void initState() {
    updateProfileFacesUrls();
    super.initState();
  }

  int age = 0;
  String BMI = '';
  String firstEyeColor = '';
  String secondEyeColor = '';
  String firstHairColor = '';
  String secondHairColor = '';
  String gender = '';
  String ethnicity = '';
  String dominatedEyeColor = '';
  String dominatedHairColor = '';
  String education = '';

  int test = 1;

  String maxKey(
      {required Map<String, double> map, double minPossibleValue = -1.0}) {
    double thevalue =
        minPossibleValue; //assumption: the values are non negative
    String thekey = '';
    map.forEach((k, v) {
      if (v > thevalue) {
        thevalue = v;
        thekey = k;
      }
    });
    return thekey;
  }

  String minKey(
      {required Map<String, double> map, double maxPossibleValue = 101.0}) {
    double thevalue =
        maxPossibleValue; //assumption: the values are non negative
    String thekey = '';
    map.forEach((k, v) {
      if (v < thevalue) {
        thevalue = v;
        thekey = k;
      }
    });
    return thekey;
  }

  double getRelativeTextSize(num baseValue) {
    // get the aspect Ratio of the Device i.e. the length dived by the breadth (something of that sort)
    double multiplicativeRatio = MediaQuery.of(context).size.height / 2;

    // clamp the value to a range between "0.0" and the supplied baseValue
    double clampedValue = (multiplicativeRatio).clamp(
          0.0,
          1.0,
        ) *
        baseValue.toDouble();

    return clampedValue;
  }

  String getEyeColor() {
    switch (dominatedEyeColor) {
      case 'Hazel':
        return kAvatarHazelEyes;
      case 'Brown':
        return '';
      case 'Green':
        return kAvatarGreenEyes;
      case 'Blue':
        return kAvatarBlueEyes;
      case 'Gray':
        return kAvatarGreyEyes;
    }
    return '';
  }

  String maleHairEmoji = '👨‍🦱';
  String femaleHairEmoji = '👩‍🦱';

  String getHairColor() {
    switch (dominatedHairColor) {
      case 'Brown':
        return '';
      case 'Bald':
        maleHairEmoji = '👨‍🦲';
        return kAvatarBaldHead;
      case 'Blond':
        maleHairEmoji = '👱‍♂️';
        femaleHairEmoji = '👱‍♀️';
        return kAvatarBlondHair;
      case 'Red':
        maleHairEmoji = '👨‍🦰';
        femaleHairEmoji = '👩‍🦰';
        return kAvatarRedHair;
      case 'Gray':
        maleHairEmoji = '👨‍🦳';
        femaleHairEmoji = '👩‍🦳';
        return kAvatarGreyHair;
    }
    return kAvatarBlackHair;
  }

  GlobalKey containerSizeKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    if (traits.isNotEmpty) {
      print(traits);
      Map<String, double> eyeColors =
          Map<String, double>.from(traits['eyes_color']);
      Map<String, double> genders = Map<String, double>.from(traits['gender']);
      Map<String, double> hairColors =
          Map<String, double>.from(traits['hair_color']);
      Map<String, double> ethnicities =
          Map<String, double>.from(traits['race']);
      Map<String, double> educations =
          Map<String, double>.from(traits['education']);

      age = traits['age'].round();
      BMI = traits['bmi_estimate'].toStringAsFixed(1);
      firstEyeColor = maxKey(map: eyeColors).toLowerCase();

      secondEyeColor = minKey(map: eyeColors).toLowerCase();

      firstHairColor = maxKey(map: hairColors).toLowerCase();
      secondHairColor = minKey(map: hairColors).toLowerCase();
      ethnicity = maxKey(map: ethnicities).toLowerCase();

      gender = maxKey(map: genders);
      if (gender == 'f') {
        gender = 'female';
      } else if (gender == 'm') {
        gender = 'male';
      } else
        gender = '';

      if (firstEyeColor == 'other') firstEyeColor = '';
      if (secondEyeColor == 'other') secondEyeColor = '';

      education = maxKey(map: educations);
      print(education);

      dominatedEyeColor = maxKey(map: eyeColors);
      dominatedHairColor = maxKey(map: hairColors);
    }

    ScrollController _scrollController = ScrollController();

    return ListenerWidget(
      notifier: SettingsData.instance,
      builder: (context) {
        TextStyle cardFontStyle = boldTextStyle.copyWith(
          color: Colors.white,
          fontSize: getRelativeTextSize(18),
          shadows: [
            Shadow(
              blurRadius: 22.0,
              color: Colors.black,
              offset: Offset(-2.0, 2.0),
            ),
          ],
        );
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: CustomAppBar(
            hasTopPadding: true,
            backColor: selectedImage == '' ? goldColorish : Colors.black87,
            customTitle: SizedBox(
              height: 80,
            ),
            centerWidget: VoilaLogoWidget(
              logoOnlyMode: true,
              goldLogo: selectedImage == '',
            ),
            backgroundColor: Colors.white,
            elevation: 0,
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              profileIsFacesBeingProcessed
                  ? Container(
                      height: MediaQuery.of(context).size.height * 0.5,
                      width: MediaQuery.of(context).size.width,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : //TODO Nitzan - change this text to a nice looking widget
                  traitsBeingFetched
                      ? Container(
                          height: MediaQuery.of(context).size.height * 0.5,
                          width: MediaQuery.of(context).size.width,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : //TODO Nitzan - change this text to a nice looking widget
                      selectedImage != ''
                          ? Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5.0),
                                child: Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    AspectRatio(
                                      aspectRatio: 1 / 1,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(selectedImage),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(10),
                                            ),
                                          ),
                                          child: AspectRatio(
                                            aspectRatio: 2 / 1,
                                            child: CustomPaint(
                                              painter: ProfilePainter(),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(7.0),
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      'Selected image estimate results:',
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          color: goldColorish,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                    Expanded(
                                                      child: Center(
                                                        child: AvatarRive(
                                                          artBoard: gender ==
                                                                  'male'
                                                              ? kAvatarMaleArtboard
                                                              : kAvatarFemaleArtboard,
                                                          eyesColor:
                                                              getEyeColor(),
                                                          hairColor:
                                                              getHairColor(),
                                                          darkSkin: ethnicity ==
                                                              'black',
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            child: LayoutBuilder(
                                              builder: (BuildContext context,
                                                  BoxConstraints constraints) {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: Stack(
                                                    alignment:
                                                        Alignment.bottomRight,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(5.0),
                                                        child: Image.asset(
                                                          BetaIconPaths
                                                              .aiLogoRobot,
                                                          scale: 2,
                                                        ),
                                                      ),
                                                      Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: [
                                                          Column(
                                                            children: [
                                                              Text(
                                                                '${age} years old $ethnicity $gender',
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style:
                                                                    kWhiteDescriptionShadowStyle
                                                                        .copyWith(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize:
                                                                      getRelativeTextSize(
                                                                          25),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        5.0),
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .stretch,
                                                              children: [
                                                                Text(
                                                                    '📊 $BMI BMI',
                                                                    style:
                                                                        cardFontStyle),
                                                                Text(
                                                                  '👀 ${firstEyeColor.capitalizeFirst} $secondEyeColor eyes',
                                                                  style:
                                                                      cardFontStyle,
                                                                ),
                                                                if (gender ==
                                                                    'male')
                                                                  Text(
                                                                    '$maleHairEmoji $dominatedHairColor $secondHairColor hair',
                                                                    style:
                                                                        cardFontStyle,
                                                                  ),
                                                                if (gender ==
                                                                    'female')
                                                                  Text(
                                                                    '$femaleHairEmoji $dominatedHairColor $secondHairColor hair',
                                                                    style:
                                                                        cardFontStyle,
                                                                  ),
                                                                Text(
                                                                  '🎓 $education education',
                                                                  style:
                                                                      cardFontStyle,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                ),
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : Flexible(
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.8,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    opacity: 1,
                                    fit: BoxFit.cover,
                                    image: AssetImage(
                                        AssetsPaths.mirrorOnTheWall1),
                                  ),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                        colors: [
                                          Colors.white,
                                          Colors.white.withOpacity(0),
                                          Colors.white.withOpacity(0),
                                          Colors.white
                                        ],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15.0),
                                    child: Text(
                                      'Choose a picture for \nVoilà to analyze',
                                      textAlign: TextAlign.center,
                                      style:
                                          kWhiteDescriptionShadowStyle.copyWith(
                                              fontSize: getRelativeTextSize(30),
                                              color: Colors.white),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ),
                            ),
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
                    minHeight: 40.5,
                    maxHeight: 110.5,
                    minWidth: 250.0,
                    maxWidth: MediaQuery.of(context).size.width,
                  ),
                  child: !(facesUrls.length > 0)
                      ? Center(
                          child: Text(
                            profileIsFacesBeingProcessed
                                ? 'Analyzing your profile'
                                : 'No faces found in profile images',
                            style: mediumBoldedCharStyle,
                          ),
                        )
                      : RawScrollbar(
                          scrollbarOrientation: ScrollbarOrientation.top,
                          controller: _scrollController,
                          thumbVisibility: true,
                          radius: Radius.circular(30),
                          thickness: 5,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 12.0),
                            child: ListView.separated(
                              controller: _scrollController,
                              scrollDirection: Axis.horizontal,
                              itemCount: facesUrls.length,
                              itemBuilder: (cntx, index) {
                                final String _url =
                                    AWSServer.profileFaceLinkToFullUrl(
                                        facesUrls[index]);
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedImage = _url;
                                    });
                                    updateTraits(facesUrls[index]);
                                  },
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                      minHeight: 40.5,
                                      maxHeight: 110.5,
                                      minWidth: 40.5,
                                      maxWidth: 110.5,
                                    ),
                                    // height: 80.5,
                                    // width: 100.0,
                                    child: AspectRatio(
                                      aspectRatio: 1 / 1,
                                      child: Container(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 3),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              border: selectedImage == _url
                                                  ? Border.all(
                                                      width: 3.0,
                                                      color: Colors.white)
                                                  : null,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black87,
                                                  blurRadius: 3,
                                                  offset: Offset(-2, 0),
                                                )
                                              ],
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                  image: NetworkImage(_url),
                                                  fit: BoxFit.cover)),
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
            ],
          ),
        );
      },
    );
  }
}

class ProfilePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final backgroundColor = Paint()
      ..shader = LinearGradient(colors: [
        Colors.black,
        Colors.black,
      ], begin: Alignment.topLeft, end: Alignment.bottomRight)
          .createShader(Rect.largest);
    canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromPoints(Offset(size.width * 0, size.height * 0.0),
              Offset(size.width * 1.0, size.height * 0.451)),
          Radius.circular(10),
        ),
        backgroundColor);
    canvas.drawRect(
        Rect.fromPoints(
          Offset(size.width * 0, size.height * 0.2),
          Offset(size.width * 1.0, size.height * 0.851),
        ),
        backgroundColor);
    final arc1 = Path();
    arc1.moveTo(size.width * 0.0, size.height * 0.85);
    arc1.arcToPoint(Offset(size.width, size.height * 0.85),
        radius: Radius.circular(550), clockwise: false);
    canvas.drawPath(arc1, backgroundColor);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
