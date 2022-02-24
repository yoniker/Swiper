import 'package:betabeta/models/profile.dart';
import 'package:betabeta/widgets/custom_app_bar.dart';
import 'package:betabeta/widgets/match_card.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CurrentUserProfileViewScreen extends StatefulWidget {
  static const String routeName = '/user_profile_viewer';
  const CurrentUserProfileViewScreen({Key? key}) : super(key: key);

  @override
  _CurrentUserProfileViewScreenState createState() =>
      _CurrentUserProfileViewScreenState();
}

class _CurrentUserProfileViewScreenState
    extends State<CurrentUserProfileViewScreen> {
  final dummyProfile = Profile(
      username: "Nitzan",
      headline: 'The Lamer',
      description:
          'I am here to rule the world with my big lamer ambitions! muhahahahaha',
      imageUrls: [
        'd2qp0siotla746.cloudfront.net/img/use-cases/profile-picture/template_1.jpg',
        'd2qp0siotla746.cloudfront.net/img/use-cases/profile-picture/template_2.jpg',
        'd2qp0siotla746.cloudfront.net/img/use-cases/profile-picture/template_3.jpg'
      ],
      location: 'Toronto, Canada',
      height: "5'7 (170cm)",
      jobTitle: 'The Rim Guy Owner',
      compatibilityScore: 0.5,
      hotnessScore: 0.5);

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.bottomRight, children: [
      Container(
        // appBar: CustomAppBar(),
        child: MatchCard(
          clickable: false,
          showCarousel: false,
          profile: dummyProfile,
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(30.0),
        child: FloatingActionButton(
            backgroundColor: Colors.blueGrey,
            child: Icon(
              FontAwesomeIcons.chevronLeft,
              size: 40,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
      )
    ]);
  }
}
