import 'dart:io';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:betabeta/constants/color_constants.dart';
import 'package:betabeta/constants/enums.dart';
import 'package:betabeta/data_models/celeb.dart';
import 'package:betabeta/services/settings_model.dart';
import 'package:betabeta/screens/celebrity_selection_screen.dart';
import 'package:betabeta/screens/face_selection_screen.dart';
import 'package:betabeta/services/networking.dart';
import 'package:betabeta/widgets/advance_filter_card_widget.dart';
import 'package:betabeta/widgets/animated_widgets/animated_pop_up_dialog.dart';
import 'package:betabeta/widgets/custom_app_bar.dart';
import 'package:betabeta/widgets/global_widgets.dart';
import 'package:betabeta/widgets/listener_widget.dart';
import 'package:betabeta/widgets/onboarding/input_field.dart';
import 'package:betabeta/widgets/onboarding/rounded_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:tuple/tuple.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class VoilaPage extends StatefulWidget {
  static const String routeName = '/voila_page';
  final bool startTutorial = Get.arguments ?? false;

  @override
  State<VoilaPage> createState() => _VoilaPageState();
}

class _VoilaPageState extends State<VoilaPage>
    with AutomaticKeepAliveClientMixin {
  bool isLoading = false;
  bool isPressed = false;
  String textSearchTyped = SettingsData.instance.textSearch;

  ScrollController _scrollController = ScrollController();

  late TutorialCoachMark VoilaTutorial;
  List<TargetFocus> targets = <TargetFocus>[];

  final GlobalKey<FormState> textSearchWidget = GlobalKey<FormState>();
  final GlobalKey<FormState> imageSearchWidget = GlobalKey<FormState>();
  final GlobalKey<FormState> celebSearchWidget = GlobalKey<FormState>();
  final GlobalKey<FormState> yourTasteWidget = GlobalKey<FormState>();
  final GlobalKey<FormState> theirTasteWidget = GlobalKey<FormState>();

  void ScrollPageDown() {
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 500), curve: Curves.easeIn);
  }

  void showTutorial() {
    initTargets();
    VoilaTutorial = TutorialCoachMark(
      context,
      hideSkip: true,
      alignSkip: Alignment.centerLeft,
      targets: targets,
      colorShadow: Colors.black.withOpacity(0.7),
      textSkip: "SKIP",
      paddingFocus: 10,
      opacityShadow: 0.8,
      onFinish: () {
        Get.back();
        showDialog(
          barrierColor: Colors.black.withOpacity(0.8),
          context: context,
          builder: (_) => AnimatedPopUpDialog(),
        );
      },
      onClickTarget: (target) {
        if (target.keyTarget == targets[2].keyTarget)
          Future.delayed(Duration(milliseconds: 100), ScrollPageDown);
      },
      onClickTargetWithTapPosition: (target, tapDetails) {
        print("target: $target");
        print(
            "clicked at position local: ${tapDetails.localPosition} - global: ${tapDetails.globalPosition}");
      },
      onClickOverlay: (target) {
        print('onClickOverlay: $target');
      },
      onSkip: () {
        print("skip");
      },
    )..show();
  }

  void initTargets() {
    targets.clear();
    targets.add(
      TargetFocus(
        identify: "textSearchWidget",
        keyTarget: textSearchWidget,
        alignSkip: Alignment.bottomCenter,
        shape: ShapeLightFocus.RRect,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Click here for free text search",
                      style: LargeTitleStyleWhite,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'You can find other New York Yankees for example!',
                      style: LargeTitleStyleWhite.copyWith(
                          color: Colors.redAccent, fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        VoilaTutorial.next();
                      },
                      child: Text(
                        'NEXT',
                        style: LargeTitleStyleWhite.copyWith(
                            decoration: TextDecoration.underline,
                            color: Colors.blueAccent),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );

    targets.add(
      TargetFocus(
        identify: 'yourTasteWidget',
        keyTarget: yourTasteWidget,
        alignSkip: Alignment.bottomCenter,
        shape: ShapeLightFocus.RRect,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return Container(
                child: Column(
                  children: [
                    Text(
                      "Voilà has a personal assistant, which learns your taste intimately",
                      style: LargeTitleStyleWhite,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'You can actually ask voilà to show you people that you like!',
                      style: LargeTitleStyleWhite.copyWith(
                          fontSize: 20, color: Colors.redAccent),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        VoilaTutorial.next();
                      },
                      child: Text(
                        'NEXT',
                        style: LargeTitleStyleWhite.copyWith(
                            decoration: TextDecoration.underline,
                            color: Colors.blueAccent),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
    targets.add(
      TargetFocus(
        identify: 'theirTasteWidget',
        keyTarget: theirTasteWidget,
        alignSkip: Alignment.bottomCenter,
        shape: ShapeLightFocus.RRect,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return Container(
                child: Column(
                  children: [
                    Text(
                      "Since voilà learns everyone's taste, you can even ask voila to show people that will like you!",
                      style: LargeTitleStyleWhite.copyWith(
                          fontSize: 20, color: Colors.redAccent),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'See members that you are their taste!',
                      style: LargeTitleStyleWhite,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        ScrollPageDown();
                        VoilaTutorial.next();
                      },
                      child: Text(
                        'NEXT',
                        style: LargeTitleStyleWhite.copyWith(
                            decoration: TextDecoration.underline,
                            color: Colors.blueAccent),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
    targets.add(
      TargetFocus(
        identify: 'celebSearchWidget',
        keyTarget: celebSearchWidget,
        alignSkip: Alignment.bottomCenter,
        shape: ShapeLightFocus.RRect,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return Container(
                child: Column(
                  children: [
                    Text(
                      'You can look for celeb look-a-likes. So if you like britney spears, you can date her look-a-likes ☺️',
                      style: LargeTitleStyleWhite.copyWith(
                          fontSize: 20, color: Colors.redAccent),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Click here to search for Celeb look-a-like members!',
                      style: LargeTitleStyleWhite,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        VoilaTutorial.next();
                      },
                      child: Text(
                        'NEXT',
                        style: LargeTitleStyleWhite.copyWith(
                            decoration: TextDecoration.underline,
                            color: Colors.blueAccent),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
    targets.add(
      TargetFocus(
        identify: "imageSearchWidget",
        keyTarget: imageSearchWidget,
        alignSkip: Alignment.bottomCenter,
        shape: ShapeLightFocus.RRect,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return Container(
                child: Column(
                  children: <Widget>[
                    Text(
                      'You can even use your own picture!',
                      style: LargeTitleStyleWhite.copyWith(
                          fontSize: 20, color: Colors.redAccent),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Click here to search for picture look-a-like members",
                      style: LargeTitleStyleWhite,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        VoilaTutorial.next();
                      },
                      child: Text(
                        'NEXT',
                        style: LargeTitleStyleWhite.copyWith(
                            decoration: TextDecoration.underline,
                            color: Colors.blueAccent),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  /// Here is where the custom-picked image is being Posted and sent over Network.
  Future<void> postCustomImageToNetwork(XFile chosenImage) async {
    // block the UI
    setState(() {
      isLoading = true;
    });

    try {
      Tuple2<img.Image, String> imageFileDetails =
          await NetworkHelper().preparedFaceSearchImageFileDetails(chosenImage);

      //
      await NetworkHelper().postFaceSearchImage(imageFileDetails);

      //

      await Get.toNamed(
        FaceSelectionScreen.routeName,
        arguments: FaceSelectionScreenArguments(
          imageFile: File(chosenImage.path),
          imageFileName: imageFileDetails.item2,
        ),
      );
      print(SettingsData.instance.filterType);
      print(SettingsData.instance.filterDisplayImageUrl);
      print('dor');
    } catch (exception) {
      print(exception);

      // show an alert dialogue saying that an error occurred.
      GlobalWidgets.showAlertDialogue(
        context,
        message: 'An error occurred, please try again later!',
      );
    }

    // un-block the UI.
    setState(() {
      isLoading = false;
    });
  }

  void inDevelopmentPopUp() {
    showDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
              title: Text(
                "Coming Soon!",
              ),
              content: Text('Coming in 2022. Stay Toned!'),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Close',
                      style: TextStyle(color: Colors.red),
                    ))
              ],
            ));
  }

  @override
  void initState() {
    print(SettingsData.instance.uid);
    if (widget.startTutorial)
      Future.delayed(Duration(milliseconds: 100), showTutorial);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Advanced Search',
        hasTopPadding: true,
        hasBackButton: true,
      ),
      backgroundColor: Colors.white,
      body: ListenerWidget(
          notifier: SettingsData.instance,
          builder: (BuildContext context) {
            bool customImageExists =
                SettingsData.instance.filterDisplayImageUrl.length > 0;
            Celeb _selectedCeleb = Celeb(
                celebName: SettingsData.instance.celebId,
                imagesUrls: [SettingsData.instance.filterDisplayImageUrl]);
            return GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Container(
                child: Column(
                  children: [
                    Container(
                      child: Expanded(
                        child: SingleChildScrollView(
                          controller: _scrollController,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Flexible(
                                      child: AnimatedContainer(
                                        margin:
                                            SettingsData.instance.filterType !=
                                                    FilterType.NONE
                                                ? EdgeInsets.only(bottom: 10)
                                                : EdgeInsets.zero,
                                        height:
                                            SettingsData.instance.filterType !=
                                                    FilterType.NONE
                                                ? 40
                                                : 0,
                                        width:
                                            SettingsData.instance.filterType !=
                                                    FilterType.NONE
                                                ? 1000
                                                : 0,
                                        duration: Duration(milliseconds: 500),
                                        child: SizedBox(
                                          width: 100,
                                          child: RoundedButton(
                                            elevation: 4,
                                            name: 'Deactivate filters',
                                            onTap: () {
                                              SettingsData.instance.filterType =
                                                  FilterType.NONE;
                                              SettingsData.instance
                                                  .filterDisplayImageUrl = '';
                                            },
                                            withPadding: false,
                                            color: Colors.red[800],
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                Container(
                                  key: textSearchWidget,
                                  child: AdvanceFilterCard(
                                      onTap: () {
                                        setState(
                                          () {
                                            SettingsData.instance.filterType =
                                                FilterType.TEXT_SEARCH;
                                            SettingsData.instance
                                                .filterDisplayImageUrl = '';
                                          },
                                        );
                                        FocusScope.of(context).unfocus();
                                      },
                                      child: AnimatedContainer(
                                        width: 400,
                                        height:
                                            SettingsData.instance.filterType !=
                                                    FilterType.TEXT_SEARCH
                                                ? 0
                                                : 54,
                                        duration:
                                            const Duration(milliseconds: 300),
                                        child: SingleChildScrollView(
                                          child: InputField(
                                            borderColor: appMainColor,
                                            onFocusChange: (hasFocus) {
                                              if (!hasFocus) {
                                                SettingsData
                                                        .instance.textSearch =
                                                    textSearchTyped;
                                                print(SettingsData
                                                        .instance.textSearch +
                                                    ' testing if changed');
                                                for (int i = 0; i < 4; ++i)
                                                  print(
                                                      'finished typing $textSearchTyped');
                                                if (SettingsData.instance
                                                        .textSearch.length !=
                                                    0) Get.back();
                                                if (SettingsData.instance
                                                        .textSearch.length ==
                                                    0)
                                                  SettingsData
                                                          .instance.filterType =
                                                      FilterType.NONE;
                                                SettingsData.instance
                                                    .filterDisplayImageUrl = '';
                                              }
                                            },
                                            onType: (value) {
                                              setState(() {
                                                textSearchTyped = value;
                                              });
                                            },
                                            onTapIcon:
                                                textSearchTyped.length > 0
                                                    ? () {
                                                        print(
                                                            'move to match screen?');
                                                        FocusScope.of(context)
                                                            .unfocus();
                                                      }
                                                    : null,
                                            hintText: ' Search...',
                                            maxLines: 1,
                                            maxCharacters: 20,
                                            icon: Icons.search,
                                            iconSize: 30,
                                            initialvalue: textSearchTyped,
                                          ),
                                        ),
                                      ),
                                      isActive:
                                          SettingsData.instance.filterType ==
                                              FilterType.TEXT_SEARCH,
                                      image: AssetImage(
                                          'assets/images/textsearch2.jpg'),
                                      showAI: false,
                                      title: Row(
                                        children: [
                                          Text(
                                            'Text Search',
                                            style: LargeTitleStyleWhite,
                                          ),
                                          DefaultTextStyle(
                                            style: LargeTitleStyleWhite,
                                            child: AnimatedTextKit(
                                              pause: Duration(seconds: 2),
                                              repeatForever: true,
                                              animatedTexts: [
                                                TyperAnimatedText(
                                                  '   Dog lover?...',
                                                  speed: Duration(
                                                      milliseconds: 100),
                                                ),
                                                TyperAnimatedText(
                                                  '   Vegan?...',
                                                  speed: Duration(
                                                      milliseconds: 100),
                                                ),
                                                TyperAnimatedText(
                                                  '   Outdoors?...',
                                                  speed: Duration(
                                                      milliseconds: 100),
                                                ),
                                                TyperAnimatedText(
                                                  '   Sushi?...',
                                                  speed: Duration(
                                                      milliseconds: 100),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      info: 'Search by a simple word or text'),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      key: yourTasteWidget,
                                      child: AdvanceFilterCard(
                                          onTap: () {
                                            inDevelopmentPopUp();
                                          },
                                          centerNotice: 'Not enough data',
                                          image: AssetImage(
                                              'assets/images/taste5.jpg'),
                                          title: Text(
                                            'Your Taste',
                                            style: titleStyleWhite,
                                          ),
                                          info:
                                              'Show me people \nwho are my taste'),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      key: theirTasteWidget,
                                      child: AdvanceFilterCard(
                                          onTap: () {
                                            SettingsData.instance.filterType =
                                                FilterType.THEIR_TASTE;
                                            FocusScope.of(context).unfocus();
                                            Get.back();
                                          },
                                          isActive: SettingsData
                                                  .instance.filterType ==
                                              FilterType.THEIR_TASTE,
                                          image: AssetImage(
                                              'assets/images/taste2.jpg'),
                                          title: Text(
                                            'Their Taste',
                                            style: titleStyleWhite,
                                          ),
                                          info:
                                              'Show me people who are likely to like me'),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      key: imageSearchWidget,
                                      child: AdvanceFilterCard(
                                          isActive: SettingsData
                                                  .instance.filterType ==
                                              FilterType.CUSTOM_IMAGE,
                                          image: AssetImage(
                                              'assets/images/picture5.jpg'),
                                          title: Text(
                                            FilterType.CUSTOM_IMAGE.description,
                                            style: titleStyleWhite,
                                          ),
                                          onTap: () async {
                                            SettingsData.instance
                                                .filterDisplayImageUrl = '';
                                            bool imagePicked = false;
                                            await GlobalWidgets
                                                .showImagePickerDialogue(
                                              context: context,
                                              onImagePicked: (imageFile) async {
                                                imagePicked = true;
                                                if (imageFile != null) {
                                                  await postCustomImageToNetwork(
                                                      imageFile);
                                                  SettingsData
                                                          .instance.filterType =
                                                      FilterType.CUSTOM_IMAGE;
                                                  Get.back();
                                                } else {
                                                  SettingsData
                                                          .instance.filterType =
                                                      FilterType.NONE;
                                                }
                                              },
                                            );
                                            if (!imagePicked) {
                                              SettingsData.instance.filterType =
                                                  FilterType.NONE;
                                            }
                                          },
                                          info:
                                              'Discover picture \nlook-a-likes.'),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      key: celebSearchWidget,
                                      child: AdvanceFilterCard(
                                          image: AssetImage(
                                              'assets/images/celeb3.jpg'),
                                          isActive: SettingsData
                                                  .instance.filterType ==
                                              FilterType.CELEB_IMAGE,
                                          onTap: () async {
                                            var selectedCeleb =
                                                await Get.toNamed(
                                                    ScreenCelebritySelection
                                                        .routeName);
                                            SettingsData.instance.filterType =
                                                FilterType.CELEB_IMAGE;
                                            // Set the `_selectedCeleb` variable to the newly selected
                                            // celebrity from the [CelebritySelectionScreen] page given that it is not null.
                                            if (selectedCeleb != null) {
                                              _selectedCeleb =
                                                  selectedCeleb as Celeb;
                                              SettingsData.instance.celebId =
                                                  _selectedCeleb.celebName;
                                              SettingsData.instance.filterType =
                                                  FilterType.CELEB_IMAGE;
                                              if (_selectedCeleb.imagesUrls !=
                                                      null &&
                                                  _selectedCeleb
                                                          .imagesUrls!.length >
                                                      0) {
                                                SettingsData.instance
                                                        .filterDisplayImageUrl =
                                                    _selectedCeleb
                                                        .imagesUrls![0];
                                                Get.back();
                                              } else {
                                                SettingsData.instance
                                                    .filterDisplayImageUrl = '';
                                              }
                                            } else {
                                              SettingsData.instance
                                                  .filterDisplayImageUrl = '';
                                              SettingsData.instance.celebId =
                                                  '';
                                              SettingsData.instance.filterType =
                                                  FilterType.NONE;
                                              //No celebrity selected
                                            }
                                          },
                                          title: Text(
                                            FilterType.CELEB_IMAGE.description,
                                            style: titleStyleWhite,
                                          ),
                                          info:
                                              'Discover celebrity \nlook-a-likes.'),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                AdvanceFilterCard(
                                    image: AssetImage('assets/images/bar3.jpg'),
                                    title: Text(
                                      'Local Bar.',
                                      style: LargeTitleStyleWhite,
                                    ),
                                    onTap: () {
                                      inDevelopmentPopUp();
                                    },
                                    centerNotice: 'Coming Soon!',
                                    info:
                                        'Join the local bar and meet people around you!')
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
