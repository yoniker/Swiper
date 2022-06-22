import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:app_settings/app_settings.dart';
import 'package:betabeta/constants/api_consts.dart';
import 'package:betabeta/constants/assets_paths.dart';
import 'package:betabeta/constants/color_constants.dart';
import 'package:betabeta/constants/enums.dart';
import 'package:betabeta/constants/onboarding_consts.dart';
import 'package:betabeta/models/profile.dart';
import 'package:betabeta/screens/profile_edit_screen.dart';
import 'package:betabeta/services/card_provider.dart';
import 'package:betabeta/services/location_service.dart';
import 'package:betabeta/services/match_engine.dart';
import 'package:betabeta/services/settings_model.dart';
import 'package:betabeta/utils/utils_methods.dart';
import 'package:betabeta/widgets/animated_widgets/animated_minitcard_widget.dart';
import 'package:betabeta/widgets/animated_widgets/no_matches_display_widget.dart';
import 'package:betabeta/widgets/listener_widget.dart';
import 'package:betabeta/widgets/match_card.dart';
import 'package:betabeta/widgets/onboarding/rounded_button.dart';
import 'package:betabeta/widgets/voila_card_widget.dart';
import 'package:betabeta/widgets/voila_logo_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:tcard/tcard.dart';

class MatchScreen extends StatefulWidget {
  static const String routeName = '/match_screen';
  MatchScreen({Key? key}) : super(key: key);

  @override
  _MatchScreenState createState() => _MatchScreenState();
}

class _MatchScreenState extends State<MatchScreen>
    with AutomaticKeepAliveClientMixin {
  // Todo: Add the implementation for detecting the changeCount.
  // holds a boolean value whether or not a user can undo his/her previous Match Decision.
  bool canUndo = false;

  /// Make the MatchCard Invisible by setting the variable "_matchCardIsVisible"
  /// to false.
  ///
  /// Note: This should be called whenever you are planning to Navigate from this Screen to a new
  /// one.

  // initState Declaration.

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundThemeColor,
      child: Padding(
        padding: MediaQuery.of(context).padding,
        child: Container(
          color: Colors.white70,
          child: Column(
            children: [
              // create the card stack.
              // Wrap in expanded to allow the card to take up the maximum
              // possible space.
              Expanded(
                child: MatchCardBuilder(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

/// The card Widget used to display match Information.
class MatchCardBuilder extends StatefulWidget {
  MatchCardBuilder({Key? key}) : super(key: key);

  final maxThumbOpacity =
      0.7; // Max opacity of the thumbs feedback (when swiping left/right)
  late final ScrollController _scrollController;

  @override
  _MatchCardBuilderState createState() => _MatchCardBuilderState();
}

//
class _MatchCardBuilderState extends State<MatchCardBuilder>
    with SingleTickerProviderStateMixin {
  double bottomCardScale = 0.95;
  Offset bottomCardOffset = Offset(0.0, 1.7);
  SwipeDirection? currentJudgment;
  late double currentInterpolation;
  late final ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void enableLocation() async {
    if (LocationService.instance.needChangeAppSettings()) {
      await AppSettings.openLocationSettings();
    }
    var status = await LocationService.instance.requestLocationCapability();
    if (status == LocationServiceStatus.enabled) {
      LocationService.instance.onInit();
    }
  }

  Widget _widgetWhenNoCardsExist() {
    if (MatchEngine.instance.locationCountData.status ==
        LocationCountStatus.not_enough_users) {
      String maleOrFemaleImage =
          SettingsData.instance.preferredGender == PreferredGender.Women.name
              ? AssetsPaths.Woman1Swipe
              : AssetsPaths.Man1Swipe;
      int? requiredNumUsers, currentNumUsers;
      requiredNumUsers =
          MatchEngine.instance.locationCountData.requiredNumUsers;
      currentNumUsers = MatchEngine.instance.locationCountData.currentNumUsers;
      double percents =
          (currentNumUsers ?? 0) / (requiredNumUsers ?? 250) * 100;
      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 40,
              ),
              AnimatedMiniTcardWidget(
                maleOrFemaleImage: maleOrFemaleImage,
                CustomButtomWidget: Text(
                  'Registration\nOpen ❤️',
                  textAlign: TextAlign.center,
                  style: titleStyleWhite.copyWith(fontSize: 12),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Welcome to',
                    style: titleStyle.copyWith(
                        color: Colors.black.withOpacity(0.7), fontSize: 25),
                  ),
                  VoilaLogoWidget(
                    freeText: 'Voilà!',
                  )
                ],
              ),
              Text(
                'Registration is now open in your area! \nNew users will appear here. \n\nCheck this page often to see new matches. \n\nIn the meantime, complete your profile to attract potential matches! 😊',
                style: titleStyle.copyWith(
                    color: Colors.black.withOpacity(0.6), fontSize: 18),
                textAlign: TextAlign.center,
              ),
              if (percents > 50)
                Text(
                  '${percents.round()}% of users already joined!',
                  style: titleStyle.copyWith(color: Colors.blueGrey),
                ),
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: RoundedButton(
                  color: Colors.black87,
                  name: 'Complete my profile',
                  onTap: () {
                    Get.toNamed(ProfileEditScreen.routeName);
                  },
                ),
              )
            ],
          ),
        ),
      );
    }

    if (MatchEngine.instance.locationCountData.status ==
            LocationCountStatus.unknown_location &&
        (LocationService.instance.serviceStatus ==
                LocationServiceStatus.userTemporaryNotGrantedPermission ||
            LocationService.instance.serviceStatus ==
                LocationServiceStatus.userPermanentlyNotGrantedPermission)) {
      return NoMatchesDisplayWidget(
        centerWidget: SizedBox(
          child: Text(
            'Oops! looks like you forgot to unable location services! \n\nWe need to know where you are swiping from in order to show you potential matches. \n\nPlease return here once your location services have been activated 😊 ',
            style: kSmallInfoStyle.copyWith(color: Colors.black54),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        customButtonWidget: RoundedButton(
          color: Colors.blueGrey,
          name: LocationService.instance.needChangeAppSettings()
              ? 'Location Settings'
              : 'Enable location   ',
          onTap: () {
            enableLocation();
          },
          icon: FontAwesomeIcons.locationPinLock,
          iconColor: Colors.white,
        ),
      );
    }
    if (MatchEngine.instance.locationCountData.status ==
        LocationCountStatus.initial_state) {
      return NoMatchesDisplayWidget(
        centerWidget: DefaultTextStyle(
          maxLines: 1,
          style: LargeTitleStyle.copyWith(color: Colors.black54),
          child: AnimatedTextKit(
            pause: Duration(seconds: 2),
            repeatForever: true,
            animatedTexts: [
              TyperAnimatedText(
                'Searching users...',
                speed: Duration(milliseconds: 100),
              ),
              TyperAnimatedText(
                'Connecting to server...',
                speed: Duration(milliseconds: 100),
              ),
              TyperAnimatedText(
                'Waiting for response...',
                speed: Duration(milliseconds: 100),
              ),
              TyperAnimatedText(
                'Connecting...',
                speed: Duration(milliseconds: 100),
              ),
            ],
          ),
        ),
        customButtonWidget: SizedBox(),
      );
    }

    if (MatchEngine.instance.getServerSearchStatus ==
        MatchSearchStatus.not_found) {
      return NoMatchesDisplayWidget(
        centerWidget: Text(
          'No new matches found with your current preferences. Check again soon to see new people.',
          style: kSmallInfoStyle.copyWith(color: Colors.black45),
          textAlign: TextAlign.center,
        ),
      );
    }

    return SpinKitChasingDots(
      size: 20.0,
      color: Colors.blue,
    );
  }

  @override
  Widget build(BuildContext context) {
    // return a stack of cards well positioned.

    return ChangeNotifierProvider(
        create: (context) => CardProvider(),
    child:ListenerWidget(
      notifier: MatchEngine.instance,
      builder: (context) {

        Widget buildCards() {
          final provider = Provider.of<CardProvider>(context, listen: true);
          final matches = provider.matches;

          return matches.isEmpty
              ? Center(
                  child: ElevatedButton(
                    onPressed: () {
                      final provider =
                          Provider.of<CardProvider>(context, listen: false);

                      provider.resetUsers();
                    },
                    child: Text('Restart'),
                  ),
                )
              : Stack(
                  children: matches
                      .map(
                        (match) => VoilaCardWidget(
                          key:Key(match.profile!.uid),
                            match: match,
                            isFront: matches.last == match),
                      )
                      .toList(),
                );
        }

        return MatchEngine.instance.topMatches.isEmpty
            ? _widgetWhenNoCardsExist()
            : Stack(
                fit: StackFit.expand,
                children: [
                  buildCards(),
                ],
              );
      },
    ));
  }
}
