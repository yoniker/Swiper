import 'package:flutter/material.dart';
import './cards.dart';
import './matches.dart';
import './profiles.dart';
import 'package:flutter_svg/flutter_svg.dart';
void main() => runApp(MyApp());

final MatchEngine matchEngine = new MatchEngine(
    matches: demoProfiles.map((Profile profile) {
  return Match(profile: profile);
}).toList());

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
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Match match =  Match();

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
          // TODO
        },
      ),
      title:  Container(child:Image.asset('assets/bigD.png',width:50,height:50),color:Colors.transparent),
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
                  matchEngine.currentMatch.nope();
                  matchEngine.cycleMatch();
                },
              ),
               RoundIconButton.small(
                icon: Icons.star,
                iconColor: Colors.blue,
                onPressed: () {
                  matchEngine.currentMatch.superLike();
                  matchEngine.cycleMatch(); //TODO for some reason,it crushes unless I call this, figure out why
                },
              ),
               RoundIconButton.large(
                icon: Icons.favorite,
                iconColor: Colors.green,
                onPressed: () {
                  matchEngine.currentMatch.like();
                  matchEngine.cycleMatch();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body:  CardStack(
        matchEngine: matchEngine,
      ),
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
