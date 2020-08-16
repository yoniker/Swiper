import 'package:betabeta/search_preferences.dart';
import 'package:betabeta/user_profile.dart';
import 'package:betabeta/cards.dart';
import 'package:flutter/material.dart';
import 'package:betabeta/matches.dart';





class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColorBrightness: Brightness.light,
        primarySwatch: Colors.blue,
      ),
      home: MatchingScreen(title: 'Flutter Demo Home Page'),
    );
  }
}
enum BodyToShow {
  Settings,Swiping
}


class MatchingScreen extends StatefulWidget {
  MatchingScreen({Key key, this.title,this.userProfile}) :
        matchEngine = MatchEngine(userProfile: userProfile),
        super(key: key);
  final MatchEngine matchEngine;
  final String title;
  final FacebookProfile userProfile;
  @override
  _MatchingScreenState createState() => _MatchingScreenState();
}

class _MatchingScreenState extends State<MatchingScreen> {
  Match match =  Match();
  BodyToShow bodyToShow=BodyToShow.Swiping;
  @override
  void initState(){
    super.initState();

  }


  Widget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      centerTitle: true,
      leading:  IconButton(
        icon:  Icon(
          Icons.person,
          color: Colors.grey,
          size: 40.0,
        ),
        onPressed: () {
          setState(() {
            bodyToShow = BodyToShow.Settings;
          });

        },
      ),
      title:  FlatButton(onPressed:()=> setState(() {
        bodyToShow=BodyToShow.Swiping;

      }),
          child: Container(child:Image.asset('assets/bigD.png',width:50,height:50),color:Colors.transparent)),
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.chat_bubble,
            color: Colors.grey,
            size: 40.0,
          ),
          onPressed: () {
            // TODO
          },
        ),
      ],
    );
  }

  Widget _buildBottomBar() {
    return BottomAppBar(
        color: Colors.transparent,
        elevation: 0.0,
        child:  Padding(
          padding: const EdgeInsets.all(16.0),
          child:  Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              RoundIconButton.small(
                icon: Icons.refresh,
                iconColor: Colors.orange,
                onPressed: () {},
              ),
              RoundIconButton.large(
                icon: Icons.clear,
                iconColor: Colors.red,
                onPressed: () {
                  if (widget.matchEngine.currentMatch()!=null){
                    widget.matchEngine.currentMatchDecision(Decision.nope);
                    widget.matchEngine.goToNextMatch();
                  }},
              ),
              RoundIconButton.small(
                icon: Icons.star,
                iconColor: Colors.blue,
                onPressed: () {
                  if (widget.matchEngine.currentMatch()!=null) {
                    widget.matchEngine.currentMatchDecision(Decision.superLike);
                    widget.matchEngine
                        .goToNextMatch(); //TODO for some reason,it crushes unless I call this, figure out why
                  }},
              ),
              RoundIconButton.large(
                icon: Icons.favorite,
                iconColor: Colors.green,
                onPressed: () {
                  if (widget.matchEngine.currentMatch()!=null){
                    widget.matchEngine.currentMatchDecision(Decision.like);
                    widget.matchEngine.goToNextMatch();}
                },
              ),
              RoundIconButton.small(
                icon: Icons.lock,
                iconColor: Colors.purple,
                onPressed: () {},
              ),
            ],
          ),
        ));
  }

  Widget _build_body(){
    if(bodyToShow==BodyToShow.Swiping){
      return CardStack(matchEngine: widget.matchEngine,);
    }
    return SearchPreferences(matchEngine: widget.matchEngine);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body:  _build_body(),
      bottomNavigationBar: _buildBottomBar(),
    );
  }
}

class RoundIconButton extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final double size;
  final VoidCallback onPressed;

  RoundIconButton.large({
    this.icon,
    this.iconColor,
    this.onPressed,
  }) : size = 60.0;

  RoundIconButton.small({
    this.icon,
    this.iconColor,
    this.onPressed,
  }) : size = 50.0;

  RoundIconButton({
    this.icon,
    this.iconColor,
    this.size,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: const Color(0x11000000), blurRadius: 10.0),
          ]),
      child:  RawMaterialButton(
        shape:  CircleBorder(),
        elevation: 0.0,
        child:  Icon(
          icon,
          color: iconColor,
        ),
        onPressed: onPressed,
      ),
    );
  }
}
