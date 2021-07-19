import 'package:betabeta/constants/beta_icon_paths.dart';
import 'package:betabeta/constants/color_constants.dart';
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
  NetworkTaskStatus _currentTaskStatus = NetworkTaskStatus.inProgress;
  String _taskId ='';
  String _netChildrenTargetLocation = '';
  bool _screenReady = false;

  // double _offset = 0;
  // double _page = 0;
  List<Image> _userFacesImages = [];
  List<Image> _matchFacesImages=[];
  List<Image> _generatedBabiesImages = [];

  void waitUntilTaskReady() async{
    while(_currentTaskStatus!=NetworkTaskStatus.completed){
      _currentTaskStatus = await NetworkHelper().checkTaskStatus(_taskId);
      print(_taskId);
    }
    List<String> listFacesMatch = await NetworkHelper().getFacesLinksMatch(widget.matchProfile);
    List<String> listFacesSelf = await NetworkHelper().getFacesLinkSelf();
    List <String> listChildrenImages = await NetworkHelper().getGeneratedBabiesLinks(_netChildrenTargetLocation);
    setStateIfMounted(() {
      _matchFacesImages = NetworkHelper.serverImagesUrlsToImages(listFacesMatch,context);
      _userFacesImages = NetworkHelper.serverImagesUrlsToImages(listFacesSelf,context);
      _generatedBabiesImages = NetworkHelper.serverImagesUrlsToImages(listChildrenImages, context);
      _screenReady = true;

    });


    
  }

  @override
  void initState() {
    super.initState();
    NetworkHelper().getChildrenPictures(widget.matchProfile).then((value) {
      _taskId = value['childrenTaskId'];
      _netChildrenTargetLocation = value['targetLocation'];
      waitUntilTaskReady();

    });

    _scrollController = ScrollController();
    _carouselController = CarouselController();
  }

  @override
  void dispose() {
    _scrollController.dispose();

    super.dispose();
  }

  Widget waitingAnimation(){
    return SpinKitPumpingHeart(color:colorBlend02,);
  }

  @override
  Widget build(BuildContext context) {
    // the device's screen specs.
    final Size _sizeConfig = MediaQuery.of(context).size;
    // the absolute size of the children image.
    final Size childrenCardSize = Size(256, 256);

    final double childrenVertCardPadding = 20.0;

    return Scaffold(
      backgroundColor: darkCardColor,
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
            SizedBox(
              height: _sizeConfig.height * 0.37,
              width: _sizeConfig.width,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment(0.0, 0.0),
                    child: FractionallySizedBox(
                      heightFactor: 0.6,
                      widthFactor: 0.6,
                      child: PrecachedImage.asset(
                        imageURI: BetaIconPaths.viewChildrenBackgroundImagePath,
                      ),
                    ),
                  ),
                  FractionallySizedBox(
                    heightFactor: 1.0,
                    widthFactor: 1.0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          flex: 1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    'You',
                                    style: smallBoldedCharStyle,
                                  ),
                                  SizedBox(height: 2.0),
                                  !_screenReady?
                                      waitingAnimation()
                                      :
                                  Clickable(
                                    onTap: () {
                                      // setStateIfMounted(() {
                                      //   final _newIndex = userProfileIndex + 1;
                                      //   if (_newIndex <
                                      //       userProfileImages.length) {
                                      //     // add to the index if the current index does not
                                      //     // exceed th imageUrls length.
                                      //     userProfileIndex = _newIndex;
                                      //   } else {
                                      //     // otherwise set the value to zero
                                      //     // therby resetting its position.
                                      //     userProfileIndex = 0;
                                      //   }
                                      // });
                                    },
                                    child: ProfileImageAvatar.mutable(
                                      actualImage: _userFacesImages.isEmpty
                                          ? null
                                          : _userFacesImages[0].image, //TODO change index here
                                      minRadius: 28.50,
                                      maxRadius: 35.5,
                                      placeholderImage: AssetImage(
                                        BetaIconPaths.defaultProfileImagePath01,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              PrecachedImage.asset(
                                imageURI: BetaIconPaths.heartsUnitedIconPath_01,
                              ),
                              Column(
                                children: [
                                  Text(
                                    'Abbie',
                                    style: smallBoldedCharStyle,
                                  ),
                                  SizedBox(height: 2.0),
                                  !_screenReady?waitingAnimation():
                                  Clickable(
                                    onTap: () {
                                      // setStateIfMounted(() {
                                      //   final _newIndex = matchProfileIndex + 1;
                                      //   if (_newIndex <
                                      //       matchProfileImages.length) {
                                      //     // add to the index if the current index does not
                                      //     // exceed th imageUrls length.
                                      //     matchProfileIndex = _newIndex;
                                      //   } else {
                                      //     // otherwise set the value to zero
                                      //     // therby resetting its position.
                                      //     matchProfileIndex = 0;
                                      //   }
                                      // });
                                    },
                                    child: ProfileImageAvatar.mutable(
                                      actualImage: _matchFacesImages.isEmpty
                                          ? null
                                          : _matchFacesImages[0].image,
                                      minRadius: 28.50,
                                      maxRadius: 35.5,
                                      placeholderImage: AssetImage(
                                        BetaIconPaths.defaultProfileImagePath01,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Flexible(
                          flex: 2,
                          child: Container(
                            child: !_screenReady?waitingAnimation():DecoratedBox(
                              decoration: kProfileImageAvatarDecoration,
                              child: ProfileImageAvatar.mutable(
                                actualImage:
                                  // Todo; Change to Image.network when linking with backend.
                                  _generatedBabiesImages[_childrenImageIndex].image, //TODO default silhouette image instead of red screen :D
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
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.0),
            SizedBox(
              height: childrenCardSize.height + childrenVertCardPadding,
              child: !_screenReady?SizedBox(): CarouselSlider.builder(
                carouselController: _carouselController,
                options: CarouselOptions(
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
                            image: _generatedBabiesImages[realIndex].image,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Center(
              child: TextButton.icon(
                style: TextButton.styleFrom(
                  textStyle: smallBoldedCharStyle.copyWith(
                    color: colorBlend02,
                    decorationColor: colorBlend02,
                    decoration: TextDecoration.underline,
                  ),
                  primary: colorBlend02,
                  backgroundColor: Colors.transparent,
                ),
                onPressed: () {/*Do something*/},
                label: Text(
                  'See more',
                  style: smallBoldedCharStyle.copyWith(
                    color: colorBlend02,
                    decorationColor: colorBlend02,
                    decoration: TextDecoration.underline,
                  ),
                ),
                icon: Icon(
                  Icons.add_rounded,
                  color: blue,
                  size: 18.0,
                ),
              ),
            ),
            SizedBox(height: 12.0),
            ActionBox(
              message: 'Mark as Like',
              messageStyle: smallBoldedCharStyle.copyWith(color: colorBlend02),
              margin: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
              trailing: PrecachedImage.asset(
                imageURI: BetaIconPaths.heartIconFilled01,
              ),
              onTap: () {
                // TODO: mark the current match as "Like" and close the ViewChildren screen.
              },
            ),
            ActionBox(
              message: 'Mark as Dislike',
              messageStyle: smallBoldedCharStyle.copyWith(color: blue),
              margin: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
              trailing: PrecachedImage.asset(
                imageURI: BetaIconPaths.dislikeMatchIcon,
                color: blue,
              ),
              onTap: () {
                // TODO: mark the current match as "Dislike" and close the ViewChildren screen.
              },
            ),
            SizedBox(height: 12.0),
            ActionBox(
              message: 'Say Hi',
              messageStyle:
                  smallBoldedCharStyle.copyWith(color: yellowishOrange),
              margin: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
              trailing: PrecachedImage.asset(
                imageURI: BetaIconPaths.messageIcon,
              ),
              onTap: () {
                // TODO: open junk-message folder and close the ViewChildren screen.
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
