import 'package:betabeta/constants/beta_icon_paths.dart';
import 'package:betabeta/constants/color_constants.dart';
import 'package:betabeta/models/match_engine.dart';
import 'package:betabeta/models/profile.dart';
import 'package:betabeta/services/networking.dart';
import 'package:betabeta/utils/mixins.dart';
import 'package:betabeta/widgets/clickable.dart';
import 'package:betabeta/widgets/custom_app_bar.dart';
import 'package:betabeta/widgets/global_widgets.dart';
import 'package:betabeta/widgets/pre_cached_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

/// The implementation for the Notification screen.
class ViewChildrenScreen extends StatefulWidget {
  static const String routeName = '/view_children';

  ViewChildrenScreen({Key key, @required this.matchProfile}) : super(key: key);

  final Profile matchProfile;

  @override
  _ViewChildrenScreenState createState() => _ViewChildrenScreenState();
}

class _ViewChildrenScreenState extends State<ViewChildrenScreen>
    with MountedStateMixin {
  final GlobalKey _scrollKey = GlobalKey();

  CarouselController _carouselController;

  ScrollController _scrollController;

  int _userImageIndex = 0;
  int _matchImageIndex = 0;
  int _childrenImageIndex = 0;
  String _netChildrenTargetLocation = '';
  bool _childrenReady = false;
  bool _userFacesReady = false;
  bool _matchFacesReady = false;

  // double _offset = 0;
  // double _page = 0;
  List<Image> _userFacesImages = [];
  List<Image> _matchFacesImages = [];
  List<Image> _generatedBabiesImages = [];

  Future<void> waitUntilTaskReady(taskId) async {
    NetworkTaskStatus currentTaskStatus = NetworkTaskStatus.inProgress;
    while (currentTaskStatus != NetworkTaskStatus.completed) {
      currentTaskStatus = await NetworkHelper().checkTaskStatus(taskId);
    }
    return;
  }

  //Get the user's faces,the match's faces and then the children faces
  void getTasksFromServer() async {
    Map<String, String> tasksInfo =
        await NetworkHelper().startChildrenTasks(widget.matchProfile);
    _netChildrenTargetLocation = tasksInfo['targetLocation'];
    String taskChildren = tasksInfo['childrenTaskId'];
    String taskMatchFaces = tasksInfo['matchFacesTaskId'];
    String taskUserFaces = tasksInfo['user_faces_task'];
    //Actually perform tasks and update the UI accordingly
    //1.User Images
    await waitUntilTaskReady(taskUserFaces);
    List<String> listFacesSelf = await NetworkHelper().getFacesLinkSelf();
    setStateIfMounted(() {
      _userFacesImages =
          NetworkHelper.serverImagesUrlsToImages(listFacesSelf, context);
      _userFacesReady = true;
    });

    //2. Match Images
    await waitUntilTaskReady(taskMatchFaces);
    List<String> listFacesMatch =
        await NetworkHelper().getFacesLinksMatch(widget.matchProfile);
    setStateIfMounted(() {
      _matchFacesImages =
          NetworkHelper.serverImagesUrlsToImages(listFacesMatch, context);
      _matchFacesReady = true;
    });

    //3.Children Images
    await waitUntilTaskReady(taskChildren);
    List<String> listChildrenImages = await NetworkHelper()
        .getGeneratedBabiesLinks(_netChildrenTargetLocation);
    setStateIfMounted(() {
      _generatedBabiesImages =
          NetworkHelper.serverImagesUrlsToImages(listChildrenImages, context);
      _childrenImageIndex = (_generatedBabiesImages.length / 2 - 1).toInt();
      _childrenReady = true;
    });

    return;
  }

  @override
  void initState() {
    super.initState();
    getTasksFromServer();

    _scrollController = ScrollController();
    _carouselController = CarouselController();
  }

  @override
  void dispose() {
    _scrollController.dispose();

    super.dispose();
  }

  Widget waitingAnimation() {
    return SpinKitPumpingHeart(
      color: colorBlend02,
    );
  }

  /// A function to select the match Decision made on the the current match.
  currentMatchDecision(Decision decision) {
    if (Provider.of<MatchEngine>(context, listen: false).currentMatch() !=
        null) {
      Provider.of<MatchEngine>(context, listen: false)
          .currentMatchDecision(decision);
      Provider.of<MatchEngine>(context, listen: false).goToNextMatch();
    }
    // close the view-children-page.
    Navigator.of(context).maybePop();
  }

  @override
  Widget build(BuildContext context) {
    // the device's screen specs.
    final Size _sizeConfig = MediaQuery.of(context).size;
    // the absolute size of the children image.
    final Size childrenCardSize = Size(256, 256);

    final double childrenVertCardPadding = 20.0;

    return Scaffold(
      backgroundColor: lightCardColor,
      appBar: CustomAppBar.subPage(
        subPageTitle: 'View Children',
        hasTopPadding: true,
        showAppLogo: false,
      ),
      body: SingleChildScrollView(
        key: _scrollKey,
        controller: _scrollController,
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            SizedBox(height: 20.0),
            ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: 150,
                maxHeight: 300,
                minWidth: 200,
                maxWidth: _sizeConfig.width,
              ),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment(0.0, -0.17),
                    child: FractionallySizedBox(
                      heightFactor: 0.60,
                      widthFactor: 0.60,
                      child: PrecachedImage.asset(
                        imageURI: BetaIconPaths.viewChildrenBackgroundImagePath,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        flex: 1,
                        child: Stack(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Flexible(
                                  flex: 1,
                                  fit: FlexFit.tight,
                                  child: Column(
                                    children: [
                                      Text(
                                        'You',
                                        style: smallBoldedCharStyle,
                                      ),
                                      SizedBox(height: 2.0),
                                      !_userFacesReady
                                          ? waitingAnimation()
                                          : Clickable(
                                              onTap: () {
                                                //TODO overlay of FacesWidget
                                              },
                                              child: ProfileImageAvatar.mutable(
                                                actualImage: _userFacesImages
                                                        .isEmpty
                                                    ? AssetImage(BetaIconPaths
                                                        .silhouetteProfileImage)
                                                    : _userFacesImages[0]
                                                        .image, //TODO change index here
                                                minRadius: 28.50,
                                                maxRadius: 35.5,
                                                placeholderImage: AssetImage(
                                                  BetaIconPaths
                                                      .defaultProfileImagePath01,
                                                ),
                                              ),
                                            ),
                                    ],
                                  ),
                                ),
                                Flexible(
                                  flex: 1,
                                  fit: FlexFit.tight,
                                  child: Column(
                                    children: [
                                      Text(
                                        widget.matchProfile.username,
                                        style: smallBoldedCharStyle,
                                      ),
                                      SizedBox(height: 2.0),
                                      !_matchFacesReady
                                          ? waitingAnimation()
                                          : Clickable(
                                              onTap: () {
                                                ////TODO overlay of FacesWidget
                                              },
                                              child: ProfileImageAvatar.mutable(
                                                actualImage: _matchFacesImages
                                                        .isEmpty
                                                    ? AssetImage(BetaIconPaths
                                                        .silhouetteProfileImage)
                                                    : _matchFacesImages[0]
                                                        .image,
                                                minRadius: 28.50,
                                                maxRadius: 35.5,
                                                placeholderImage: AssetImage(
                                                  BetaIconPaths
                                                      .defaultProfileImagePath01,
                                                ),
                                              ),
                                            ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Center(
                              child: PrecachedImage.asset(
                                imageURI: BetaIconPaths.heartsUnitedIconPath_01,
                                scale: 3.75,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Flexible(
                        flex: 2,
                        child: Container(
                          child: !_childrenReady
                              ? waitingAnimation()
                              : DecoratedBox(
                                  decoration: kProfileImageAvatarDecoration,
                                  child: ProfileImageAvatar.mutable(
                                    actualImage: _generatedBabiesImages.isEmpty
                                        ? AssetImage(BetaIconPaths
                                            .silhouetteProfileImage)
                                        : _generatedBabiesImages[
                                                _childrenImageIndex]
                                            .image, //TODO default silhouette image instead of red screen :D
                                    minRadius: 65.0,
                                    maxRadius: 85.5,
                                    placeholderImage: AssetImage(
                                      BetaIconPaths.defaultProfileImagePath01,
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.0),
            SizedBox(
              height: childrenCardSize.height + childrenVertCardPadding,
              child: !_childrenReady
                  ? Center(
                    child: SpinKitFadingFour(
                        color: colorBlend02,
                      ),
                  )
                  : _generatedBabiesImages.isEmpty
                      ? Text(
                          'No face found so cannot generate children',
                          style: defaultTextStyle.copyWith(color: Colors.red),
                        )
                      : CarouselSlider.builder(
                          carouselController: _carouselController,
                          options: CarouselOptions(
                            initialPage: _childrenImageIndex,
                            autoPlay: false,
                            enableInfiniteScroll: false,
                            height: childrenCardSize.height,
                            enlargeCenterPage: true,
                            viewportFraction: 0.6,
                            enlargeStrategy: CenterPageEnlargeStrategy.scale,
                            onPageChanged: (index, changeReason) {
                              setStateIfMounted(() {
                                _childrenImageIndex = index;
                              });
                            },
                          ),
                          itemCount: _generatedBabiesImages.length,
                          itemBuilder: (context, _index, realIndex) {
                            return GestureDetector(
                              onTap: () {
                                _carouselController.animateToPage(
                                  realIndex,
                                  duration: Duration(milliseconds: 800),
                                  curve: Curves.decelerate,
                                );

                                setStateIfMounted(() {
                                  _childrenImageIndex = realIndex;
                                });
                              },
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  minHeight: childrenCardSize.height,
                                  maxHeight: childrenCardSize.height,
                                  minWidth: childrenCardSize.width,
                                  maxWidth: childrenCardSize.width,
                                ),
                                child: Container(
                                  width: childrenCardSize.width,
                                  height: childrenCardSize.height,
                                  margin: EdgeInsets.all(6.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(18),
                                    boxShadow: kElevationToShadow[2],
                                    image: DecorationImage(
                                      image: _generatedBabiesImages[realIndex]
                                          .image,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
            ),
            SizedBox(height: 12.0),
            ActionBox(
              message: 'Like',
              messageStyle: smallBoldedCharStyle.copyWith(color: colorBlend02),
              margin: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
              trailing: PrecachedImage.asset(
                imageURI: BetaIconPaths.likeMatchIcon,
              ),
              onTap: () {
                // Decision.like
                currentMatchDecision(Decision.like);
              },
            ),
            ActionBox(
              message: 'Dislike',
              messageStyle: smallBoldedCharStyle.copyWith(color: Colors.red),
              margin: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
              trailing: PrecachedImage.asset(
                imageURI: BetaIconPaths.dislikeMatchIcon,
              ),
              onTap: () {
                // Decision.nope
                currentMatchDecision(Decision.nope);
              },
            ),
            SizedBox(height: 12.0),
            ActionBox(
              message: 'Say Hi',
              messageStyle:
                  smallBoldedCharStyle.copyWith(color: yellowishOrange),
              margin: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
              trailing: PrecachedImage.asset(
                imageURI: BetaIconPaths.draftMesssageIcon,
              ),
              onTap: () {
                // TODO: open the junk-message page and close the ViewChildren screen.
                print('MAKE A DRAFT!');
              },
            ),
            SizedBox(height: 12.0),
            Center(
              child: Material(
                clipBehavior: Clip.antiAlias,
                color: Colors.white,
                shape: CircleBorder(),
                elevation: 2.0,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).maybePop();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: GlobalWidgets.assetImageToIcon(
                      BetaIconPaths.cancelIconPath,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }
}
