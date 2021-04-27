import 'dart:async';
import 'package:betabeta/main.dart';
import 'package:betabeta/models/settings_model.dart';
import 'package:betabeta/popups/genderselector.dart';
import 'package:betabeta/popups/popup.dart';
import 'package:betabeta/screens/settings_screen.dart';
import 'package:betabeta/widgets/round_icon_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:page_indicator/page_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileTab extends StatefulWidget {
  ProfileTab();
  @override
  _ProfileTabState createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab>
    with AutomaticKeepAliveClientMixin<ProfileTab> {
  int currentPage = 0;
  int currentColor = 0;
  bool reverse = false;
  PageController _controller = new PageController();
  Timer _pageChangeTimer;
  Timer colorTimer;
  String name=SettingsData().name;
  String profileImageUrl= SettingsData().facebookProfileImageUrl;






  @override
  void initState() {
    super.initState();
    _pageChanger();
  }

  @override
  void dispose() {
    _pageChangeTimer.cancel();
    _controller.dispose();
    super.dispose();
  }

  _logout()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Save name, id and picture url to persistent storage, and move on to the next screen
    await prefs.remove('name');
    await prefs.remove('facebook_id');
    await prefs.remove('facebook_profile_image_url');
    await prefs.remove('preferredGender');
    SettingsData().facebookId='';
    SettingsData().name= '';
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
        LoginHome()), (Route<dynamic> route) => false);}


    void _pageChanger() {
    _pageChangeTimer = Timer.periodic(Duration(seconds: 2), (_) {
      if (reverse == false && currentPage < bigDList.length - 1) {
        _controller.nextPage(
            duration: Duration(milliseconds: 5), curve: Curves.easeIn);
      } else if (reverse == true && currentPage <= bigDList.length - 1) {
        _controller.previousPage(
            duration: Duration(milliseconds: 5), curve: Curves.easeOut);
      }
    });
  }

  void _onPageChanged(int value) {
    //print("$value $reverse");
    setState(() {
      currentPage = value;
    });

    if (currentPage == bigDList.length - 1) {
      setState(() {
        reverse = true;
      });
      return;
    }

    if (currentPage == 0) {
      setState(() {
        reverse = false;
      });
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return new Scaffold(
      body: SafeArea(
        child: new Stack(
          children: <Widget>[_buildProfileInfo(), _buildSettingsBottom()],
        ),
      ),
    );
  }

  Widget _buildProfileInfo() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      padding: const EdgeInsets.only(
          right: 15.0, left: 15.0, top: 20.0, bottom: 50.0),
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            new BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 1.0,
                blurRadius: 1.0)
          ],
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.elliptical(250, 100),
            bottomRight: Radius.elliptical(250, 100),
          )),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        //mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          new Container(
            height: 110.0,
            width: 110.0,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: CachedNetworkImageProvider(
                        profileImageUrl
                    ),
                    fit: BoxFit.cover,
                    alignment: Alignment.center),
                shape: BoxShape.circle,
                color: Colors.grey.withOpacity(0.2)),
          ),
          new SizedBox(
            height: 10.0,
          ),
          new Text(
            name,
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
          new SizedBox(
            height: 10.0,
          ),
          const Text(
            "Some info about you will be entered here",
            style: TextStyle(
              fontSize: 12.0,
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
           FacebookSignInButton(text:'Facebook logout',onPressed: (){_logout();},),
          const SizedBox(
            height: 20.0,
          ),
          _buildSettingsButtons()
        ],
      ),
    );
  }

  Widget _buildSettingsBottom() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          new Flexible(child: _buildBigDUI()),
          new Padding(
            padding:
            const EdgeInsets.only(left: 50.0, right: 50.0, bottom: 25.0),
            child: new RaisedButton(
              color: Colors.white,
              padding: const EdgeInsets.all(16.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0)),
              onPressed: () {},
              child: Center(
                child: new Text(
                  "MY BigD PLUS",
                  style: TextStyle(color: Colors.pink, fontSize: 16.0),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildBigDUI() {
    return Container(
      height: 150.0,
      child: PageIndicatorContainer(
          indicatorSpace: 5.0,
          indicatorSelectorColor: Colors.blue,
          indicatorColor: Colors.grey.withOpacity(0.5),
          align: IndicatorAlign.bottom,
          child: new PageView.builder(
              controller: _controller,
              onPageChanged: _onPageChanged,
              itemCount: bigDList.length,
              itemBuilder: (c, index) {
                return new Container(
                  padding: EdgeInsets.all(15.0),
                  margin: EdgeInsets.only(top: 20.0),
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        bigDList[index].title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.0,
                            fontWeight: FontWeight.w900),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        bigDList[index].subTitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14.0, color: Colors.black),
                      ),
                    ],
                  ),
                  width: MediaQuery.of(context).size.width,
                );
              }),
          length: bigDList.length),
    );
  }

  showPopup(BuildContext context, String title,
      {BuildContext popupContext})async {
    return await Navigator.push(
      context,
      PopupLayout(
        top: 30,
        left: 30,
        right: 30,
        bottom: 50,
        child: GenderSelector(selectedGender:SettingsData().preferredGender),
      ),
    );
  }



  Widget _buildSettingsButtons() {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        new Column(
          children: <Widget>[
             RoundIconButton.large(
              icon: Icons.settings,
              iconColor: Colors.red,
              onPressed: 
                  /*() async {
                var genderPreferred=await showPopup(context, 'Show me:');
                if(userPreferences!=null){
                  userPreferences.genderPreferred=genderPreferred;
                }
              }*/(){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>SettingsScreen()));
              },
            ),
            new SizedBox(
              height: 10.0,
            ),
            const Text(
              "SETTINGS",
              style: TextStyle(color: Colors.grey, fontSize: 12.0),
            )
          ],
        ),
        new Column(
          children: <Widget>[
             RoundIconButton.small(
              icon: Icons.camera_alt,
              iconColor: Colors.blue,
              onPressed: () {
                //TODO
              },
            ),
            new SizedBox(
              height: 10.0,
            ),
            const Text(
              "ADD MEDIA",
              style: TextStyle(color: Colors.grey, fontSize: 12.0),
            )
          ],
        ),
        new Column(
          children: <Widget>[
            new RoundIconButton.large(
              icon: Icons.edit,
              iconColor: Colors.green,
              onPressed: () {
                //TODO
              },
            ),
            const SizedBox(
              height: 10.0,
            ),
            const Text(
              "EDIT INFO",
              style: TextStyle(color: Colors.grey, fontSize: 12.0),
            )
          ],
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class BigDPlusMessage {
  final String title;
  final String subTitle;
  BigDPlusMessage({this.title, this.subTitle});
}

final List<BigDPlusMessage> bigDList = [
  /*
  new BigDPlusMessage(
      title: "Get BigD Plus", subTitle: "See your future family!"),
  new BigDPlusMessage(title: "Get Matches Faster", subTitle: "You are shown to people who will be interested in you, thanks to our advanced AI"),
  new BigDPlusMessage(
      title: "Choose only hot people",
      subTitle: "Our AI learns your taste,fast!"),
  new BigDPlusMessage(
      title: "Personalize your experience",
      subTitle: "Our AI enables you to see only people that you will like,people who will be interested in you, or both"),
  new BigDPlusMessage(
      title: "Help you to choose photos",
      subTitle: "Our AI will scan your photos, and recommend recent photos which other users will like!"),
  new BigDPlusMessage(title: "Take a glimpse into the future",
subTitle: "See your potential children with your match! See your future family photo!"),*/
  new BigDPlusMessage(
      title: "Meet Dor, king of the multiverse",
      subTitle: "Learn how to humble yourself!"),
  new BigDPlusMessage(
      title: "Smoke Dorgila",
      subTitle: "Get unlimited Dorgila with BigD Plus!"),
];