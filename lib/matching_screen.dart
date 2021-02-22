import 'package:betabeta/round_icon_button.dart';
import 'package:betabeta/tabs/settings_tab.dart';
import 'package:betabeta/user_profile.dart';
import 'package:betabeta/cards.dart';
import 'package:flutter/material.dart';
import 'package:betabeta/matches.dart';
import 'package:provider/provider.dart';

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
enum MatchTab {
  Settings,Swiping
}


class MatchingScreen extends StatefulWidget {
  MatchingScreen({Key key, this.title,this.userProfile}) :
        //matchEngine = MatchEngine(userProfile: userProfile),
        super(key: key);
  //final MatchEngine matchEngine;
  final String title;
  final FacebookProfile userProfile;
  @override
  _MatchingScreenState createState() => _MatchingScreenState();
}

class _MatchingScreenState extends State<MatchingScreen> {
  Match match =  Match();
  MatchTab currentTab=MatchTab.Swiping;
  @override
  void initState(){
    super.initState();

  }
  currentMatchDecision(Decision decision){
    if (Provider.of<MatchEngine>(context, listen: false).currentMatch()!=null){
      Provider.of<MatchEngine>(context, listen: false).currentMatchDecision(decision);
      Provider.of<MatchEngine>(context, listen: false).goToNextMatch();}
  }

  Widget _buildAppBar() {
    Color profileColor= currentTab==MatchTab.Settings?Colors.redAccent:Colors.grey;
    Color bigDColor=currentTab==MatchTab.Swiping?Colors.redAccent:Colors.grey;

    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      centerTitle: true,
      leading:  IconButton(
        icon:  Icon(
          Icons.person,
          color: profileColor,
          size: 40.0,
        ),
        onPressed: () {
          setState(() {
            currentTab = MatchTab.Settings;
          });

        },
      ),
      title:  FlatButton(onPressed:()=> setState(() {
        currentTab=MatchTab.Swiping;

      }),
          child: Container(child:Text('D',style:TextStyle(color:bigDColor,fontSize: 55,fontFamily: 'RougeScript',fontWeight: FontWeight.bold)))),
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
                onPressed: () {
                  Provider.of<MatchEngine>(context, listen: false).goBack();
                },
              ),
              RoundIconButton.large(
                icon: Icons.clear,
                iconColor: Colors.red,
                onPressed: () {
                  currentMatchDecision(Decision.nope);},
              ),
              RoundIconButton.small(
                icon: Icons.star,
                iconColor: Colors.blue,
                onPressed: () {
                  currentMatchDecision(Decision.superLike);},
              ),
              RoundIconButton.large(
                icon: Icons.favorite,
                iconColor: Colors.green,
                onPressed: () {
                  currentMatchDecision(Decision.like);
                },
              ),
              RoundButton.small(
                child:Text('?',style: TextStyle(color:Colors.grey,fontSize: 30,fontWeight: FontWeight.bold),),
                onPressed: () {
                  currentMatchDecision(Decision.dontKnow);
                },
              ),
            ],
          ),
        ));
  }

  Widget _buildBody(){
    if(currentTab==MatchTab.Swiping){
      return CardStack();
    }
    return SettingsTab(
      wrapUp: (bool preferencesChanged){
        if(preferencesChanged){
          Provider.of<MatchEngine>(context, listen: false).clear();
        }

      }
      ,
    );//SearchPreferencesScreen(matchEngine: widget.matchEngine);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body:  _buildBody(),
      bottomNavigationBar: currentTab==MatchTab.Swiping?_buildBottomBar():null,
    );
  }
}


