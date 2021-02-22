import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fluttery_dart2/layout.dart';
import 'package:betabeta/profiles.dart';
import 'package:provider/provider.dart';
import './photos.dart';
import './matches.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


class CardStack extends StatefulWidget {
  final MatchEngine matchEngine;

  CardStack({this.matchEngine});

  @override
  _CardStackState createState() => _CardStackState();
}

class _CardStackState extends State<CardStack> {
  Key _frontCard;
  Match _currentMatch;
  double _nextCardScale = 0.0;

  @override
  void initState() {
    super.initState();
    addCards();
    widget.matchEngine.addListener(_onMatchEngineChange);
    if(Provider.of<MatchEngine>(context, listen: false).length()>0) {
      _currentMatch = Provider.of<MatchEngine>(context, listen: false).currentMatch();
      _currentMatch.addListener(_onMatchChange);
      _frontCard = Key(_currentMatch.profile.username);
    }

  }

  void addCards() async

  {
    await Provider.of<MatchEngine>(context, listen: false).getMoreMatchesFromServer();
    setState(() {

    });

  }

  @override
  void didUpdateWidget(CardStack oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.matchEngine != oldWidget.matchEngine) {
      oldWidget.matchEngine.removeListener(_onMatchEngineChange);
      widget.matchEngine.addListener(_onMatchEngineChange);

      if (_currentMatch != null) {
        _currentMatch.removeListener(_onMatchChange);
      }

      _currentMatch = widget.matchEngine.currentMatch();
      if (_currentMatch != null) {
        _currentMatch.addListener(_onMatchChange);
      }
    }
  }

  @override
  void dispose() {
    if (_currentMatch != null) {
      _currentMatch.removeListener(_onMatchChange);
    }

    Provider.of<MatchEngine>(context, listen: false).removeListener(_onMatchEngineChange);
    super.dispose();
  }

  _onMatchEngineChange() {
    print('onMatchEngineCalled!');
    setState(() {
      if (_currentMatch != null) {
        _currentMatch.removeListener(_onMatchChange);
      }

      _currentMatch = Provider.of<MatchEngine>(context, listen: false).currentMatch();
      if (_currentMatch != null) {
        _currentMatch.addListener(_onMatchChange);
        _frontCard = Key(_currentMatch.profile.username);
      }


    });
  }

  _onMatchChange() {
    setState(() {});
  }

  Widget _buildBackCard() {
    if (Provider.of<MatchEngine>(context, listen: false).nextMatch()!=null){
    Widget card= Transform(
      transform: Matrix4.identity()..scale(_nextCardScale, _nextCardScale),
      alignment: Alignment.center,
      child: ProfileCard(
        profile: Provider.of<MatchEngine>(context, listen: false).nextMatch().profile,
        clickable: false,
      ),
    );
    return DraggableCard(
      screenHeight: MediaQuery.of(context).size.height,
      screenWidth: MediaQuery.of(context).size.width,
      isDraggable: false,
      card: card,
    );

    }

    return SpinKitDoubleBounce(size:200,color:Colors.blueAccent);
  }

  Widget _buildFrontCard() {
    if(Provider.of<MatchEngine>(context, listen: false).currentMatch()!=null) {

      Widget card =  ProfileCard(
        key: _frontCard,
        profile: Provider.of<MatchEngine>(context, listen: false).currentMatch().profile,
        clickable: true,
      );

      return DraggableCard(
        screenHeight: MediaQuery.of(context).size.height,
        screenWidth: MediaQuery.of(context).size.width,
        card: card,
        slideTo: _desiredSlideOutDirection(),
        onSlideUpdate: _onSlideUpdate,
        onSlideComplete: _onSlideComplete,
      );

    }
  return SpinKitDoubleBounce(size:200,color:Colors.blueAccent);
  }

  SlideDirection _desiredSlideOutDirection() {
    switch (Provider.of<MatchEngine>(context, listen: false).currentMatch().decision) {
      case Decision.nope:
        return SlideDirection.left;
        break;
      case Decision.like:
        return SlideDirection.right;
        break;
      case Decision.superLike:
        return SlideDirection.up;
        break;
      default:
        return null;
    }
  }

  void _onSlideUpdate(double distance) {
    setState(() {
      _nextCardScale = 0.9 + (0.1 * (distance / 100.0)).clamp(0.0, 0.1);
    });
  }

  void _onSlideComplete(SlideDirection direction) {

    Decision decision = Decision.indecided;

    switch (direction) {
      case SlideDirection.left:
        decision = Decision.nope;
        break;
      case SlideDirection.right:
        decision = Decision.like;
        break;
      case SlideDirection.up:
        decision = Decision.superLike;
        break;
    }

    Provider.of<MatchEngine>(context, listen: false).currentMatchDecision(decision);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        _buildBackCard(),
        _buildFrontCard()
      ],
    );
  }
}

enum SlideDirection {
  left,
  right,
  up,
}

class DraggableCard extends StatefulWidget {
  final Widget card;
  final bool isDraggable;
  final SlideDirection slideTo;
  final Function(double distance) onSlideUpdate;
  final Function(SlideDirection direction) onSlideComplete;
  final double screenWidth;
  final double screenHeight;

  DraggableCard({
    Key key,
    this.card,
    this.isDraggable = true,
    this.slideTo,
    this.onSlideUpdate,
    this.onSlideComplete,
    this.screenWidth,
    this.screenHeight,
  });

  @override
  _DraggableCardState createState() => _DraggableCardState();
}

class _DraggableCardState extends State<DraggableCard>
    with TickerProviderStateMixin {
  Decision decision;
  GlobalKey profileCardKey = GlobalKey(debugLabel: 'profile_card_key');
  Offset cardOffset = const Offset(0.0, 0.0);
  Offset dragStart;
  Offset dragPosition;
  List<Offset> gestureOffsets; //Track if all offsets happened at the same direction
  List<Duration> gestureTimeStamps; //Track all of the time stamps to test if it happened "fast enough"
  Offset slideBackStart;
  SlideDirection slideOutDirection;
  AnimationController slideBackAnimation;
  Tween<Offset> slideOutTween;
  AnimationController slideOutAnimation;

  @override
  void initState() {
    super.initState();
    slideBackAnimation = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )
      ..addListener(() => setState(() {
            cardOffset = Offset.lerp(slideBackStart, const Offset(0.0, 0.0),
                Curves.elasticOut.transform(slideBackAnimation.value));

            if (null != widget.onSlideUpdate) {
              widget.onSlideUpdate(cardOffset.distance);
            }
          }))
      ..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            dragStart = null;
            slideBackStart = null;
            dragPosition = null;
            gestureOffsets = null;
            gestureTimeStamps = null;
          });
        }
      });

    slideOutAnimation = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    )
      ..addListener(() => setState(() {
            cardOffset = slideOutTween.evaluate(slideOutAnimation);
            if (null != widget.onSlideUpdate) {
              widget.onSlideUpdate(cardOffset.distance);
            }
          }))
      ..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            dragStart = null;
            dragPosition = null;
            slideOutTween = null;

            if (widget.onSlideComplete != null) {
              widget.onSlideComplete(slideOutDirection);
            }
          });
        }
      });
  }

  @override
  void didUpdateWidget(DraggableCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.card.key != oldWidget.card.key) {
      cardOffset = const Offset(0.0, 0.0);
    }

    if (oldWidget.slideTo == null && widget.slideTo != null) {
      switch (widget.slideTo) {
        case SlideDirection.left:
          _slideLeft();
          break;
        case SlideDirection.right:
          _slideRight();
          break;
        case SlideDirection.up:
          _slideUp();
          break;
      }
    }
  }

  @override
  void dispose() {
    slideBackAnimation.dispose();
    slideOutAnimation.dispose();
    super.dispose();
  }

  void _slideLeft() {
    // final screenWidth = context.size.width;
    dragStart = _chooseRandomDragStart();
    slideOutTween = Tween(
      begin: const Offset(0.0, 0.0),
      end: Offset(-2 * widget.screenWidth, 0.0),
    );

    slideOutAnimation.forward(from: 0.0);
  }



  Offset _chooseRandomDragStart() {
    final cardContex = profileCardKey.currentContext;
    final cardTopLeft = (cardContex.findRenderObject() as RenderBox)
        .localToGlobal(const Offset(0.0, 0.0));
    final dragStartY =
        widget.screenHeight * (new Random().nextDouble() < 0.5 ? 0.25 : 0.75) +
            cardTopLeft.dy;

    return Offset(widget.screenWidth / 2 + cardTopLeft.dx, dragStartY);
  }

  void _slideRight() {
    dragStart = _chooseRandomDragStart();
    slideOutTween = Tween(
      begin: const Offset(0.0, 0.0),
      end: Offset(2 * widget.screenWidth, 0.0),
    );

    slideOutAnimation.forward(from: 0.0);
  }

  void _slideUp() {
    // final screenHeight = context.size.height;
    dragStart = _chooseRandomDragStart();
    slideOutTween = Tween(
      begin: const Offset(0.0, 0.0),
      end: Offset(0.0, -2 * widget.screenHeight),
    );

    slideOutAnimation.forward(from: 0.0);
  }

  void _onPanStart(DragStartDetails details) {
    dragStart = details.globalPosition;
    gestureOffsets = List<Offset>();
    gestureTimeStamps = List<Duration>();

    if (slideBackAnimation.isAnimating) {
      slideBackAnimation.stop(canceled: true);
    }
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      dragPosition = details.globalPosition;
      cardOffset = dragPosition - dragStart;
      gestureOffsets.add(cardOffset);
      gestureTimeStamps.add(details.sourceTimeStamp);

      if (null != widget.onSlideUpdate) {
        widget.onSlideUpdate(cardOffset.distance);
      }
    });
  }

  FastSwipe detectFastSwipe(){
    const int MINIMUM_GESTURE_LENGTH=40;
    const double MINIMUM_DURATION_TIME = 1; //TODO convert it into Duration since it's more like dart than this
    const double MAXIMUM_DURATION_TIME = 1000;

    if(gestureTimeStamps.length<2){return FastSwipe.notFastSwipe;}
    final int gestureTime = (gestureTimeStamps[gestureTimeStamps.length-1]-gestureTimeStamps[0]).inMilliseconds;
    if(gestureTime<MINIMUM_DURATION_TIME){return FastSwipe.notFastSwipe;}
    if(gestureTime>MAXIMUM_DURATION_TIME){return FastSwipe.notFastSwipe;} //TODO again,it's important to cut the lists but for now
    double overAllGestureSize = gestureOffsets[gestureOffsets.length-1].dx-gestureOffsets[0].dx;
    if(overAllGestureSize.abs()<MINIMUM_GESTURE_LENGTH){return FastSwipe.notFastSwipe;}
    //TODO cut both lists such that we will observe only the very last motions eg 1/2 miliseconds
    bool monotonic=true;
    for(int i=1; i<gestureOffsets.length; ++i){
      if(gestureOffsets[i].dx.abs()<gestureOffsets[i-1].dx.abs()){
        monotonic = false;
        break;
      }
    }
    if(!monotonic){return FastSwipe.notFastSwipe;}

    if(gestureOffsets[0].dx>gestureOffsets[1].dx){
      return FastSwipe.Left;
    }

    return FastSwipe.Right;


  }

  void _onPanEnd(DragEndDetails details) {


    final dragVector = cardOffset / cardOffset.distance;
    bool isInLeftRegion = (cardOffset.dx / context.size.width) < -0.35;
    bool isInRightRegion = (cardOffset.dx / context.size.width) > 0.35;
    final isInTopRegion = (cardOffset.dy / context.size.height) < -0.30;
    final FastSwipe fastSwipeStatus = detectFastSwipe();

    isInLeftRegion|=fastSwipeStatus==FastSwipe.Left;
    isInRightRegion|=fastSwipeStatus==FastSwipe.Right;

    setState(() {
      if (isInLeftRegion || isInRightRegion) {
        slideOutTween =  Tween(
            begin: cardOffset, end: dragVector * (2 * context.size.width));

        slideOutAnimation.forward(from: 0.0);

        slideOutDirection =
            isInLeftRegion ? SlideDirection.left : SlideDirection.right;
      } else if (isInTopRegion) {
        slideOutTween =  Tween(
            begin: cardOffset, end: dragVector * (2 * context.size.height));
        slideOutAnimation.forward(from: 0.0);

        slideOutDirection = SlideDirection.up;
      } else {
        slideBackStart = cardOffset;
        slideBackAnimation.forward(from: 0.0);
      }
    });
  }

  double _rotation(Rect dragBounds) {
    if (dragStart != null) {
      final rotationCornerMultiplier =
          dragStart.dy >= dragBounds.top + (dragBounds.height / 2) ? -1 : 1;
      return (pi / 8) *
          (cardOffset.dx / dragBounds.width) *
          rotationCornerMultiplier;
    } else {
      return 0.0;
    }
  }

  Offset _rotationOrigin(Rect dragBounds) {
    if (dragStart != null) {
      return dragStart - dragBounds.topLeft;
    } else {
      return const Offset(0.0, 0.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return  AnchoredOverlay(
      showOverlay: true,
      child:  Center(),
      overlayBuilder: (BuildContext context, Rect anchorBounds, Offset anchor) {
        return CenterAbout(
          position: anchor,
          child:  Transform(
            transform:
                 Matrix4.translationValues(cardOffset.dx, cardOffset.dy, 0.0)
                  ..rotateZ(_rotation(anchorBounds)),
            origin: _rotationOrigin(anchorBounds),
            child:  Container(
              key: profileCardKey,
              width: anchorBounds.width,
              height: anchorBounds.height,
              padding: const EdgeInsets.all(16.0),
              child:  GestureDetector(
                onPanStart: widget.isDraggable?_onPanStart:null,
                onPanUpdate: widget.isDraggable?_onPanUpdate:null,
                onPanEnd: widget.isDraggable?_onPanEnd:null,
                child: widget.card,
              ),
            ),
          ),
        );
      },
    );
  }
}

class ProfileCard extends StatefulWidget {
  final Profile profile;
  final bool clickable;

  ProfileCard({Key key, this.profile,this.clickable}) : super(key: key);

  @override
  _ProfileCardState createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  Widget _buildBackground() {
    return PhotoBrowser(
      photoAssetPaths: widget.profile.imageUrls,
      visiblePhotoIndex: 0,
      clickable:widget.clickable
    );
  }

  Widget _buildProfileSynopsis() {
    return  Positioned(
      left: 0.0,
      right: 0.0,
      bottom: 0.0,
      child:  Container(
        decoration:  BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
              Colors.transparent,
              Colors.black.withOpacity(0.8),
            ])),
        padding: const EdgeInsets.all(24.0),
        child:  Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
             Expanded(
              child:  Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  widget.profile.username!=null? Text(widget.profile.username,
                      style:
                           TextStyle(color: Colors.white, fontSize: 24.0)) : Text(''),
                  widget.profile.headline!=null?Text(widget.profile.headline,
                      style:  TextStyle(color: Colors.white, fontSize: 18.0)):Text('')
                ],
              ),
            ),
             IconButton(
               color: Colors.transparent,
               onPressed: (){print('Implement images slider for current profile');},
               icon: Icon(
                Icons.info,
                color: Colors.white,
            ),
             )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:  BoxDecoration(
          borderRadius:  BorderRadius.circular(10.0),
          boxShadow: [
             BoxShadow(
              color: const Color(0x11000000),
              blurRadius: 5.0,
              spreadRadius: 2.0,
            )
          ]),
      child: ClipRRect(
        borderRadius:  BorderRadius.circular(10.0),
        child:  Material(
          child:  Stack(
            fit: StackFit.expand,
            children: <Widget>[
              _buildBackground(),
              _buildProfileSynopsis(),
            ],
          ),
        ),
      ),
    );
  }
}

enum FastSwipe {
  notFastSwipe,
  Right,
  Left
}
