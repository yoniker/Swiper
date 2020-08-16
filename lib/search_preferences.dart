
import 'package:betabeta/matches.dart';
import 'package:flutter/material.dart';
import 'package:gender_picker/gender_picker.dart';
import 'package:gender_picker/source/enums.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:shared_preferences/shared_preferences.dart';




class SearchPreferences extends StatefulWidget {
  SearchPreferences({Key key,MatchEngine matchEngine}) :matchEngine=matchEngine,super(key: key);
  final MatchEngine matchEngine;

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".


  @override
  _SearchPreferencesState createState() => _SearchPreferencesState();
}

class _SearchPreferencesState extends State<SearchPreferences> {

  bool _changedPreferredGender=false;
  String preferredGender;
  getPreferencesFromSharedPreferences()async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String preferredGenderSaved = prefs.getString('preferredGender');
    if(preferredGenderSaved!=preferredGender && _changedPreferredGender==false){
      setState(() {
        preferredGender = preferredGenderSaved;

      });
    }
    //Save name, id and picture url to persistent storage, and move on to the next screen
    //await prefs.setString('name', profile['name']);}
  }


  savePreferences()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('preferredGender', preferredGender);
    widget.matchEngine.clear();
  }


  Gender getGenderFromString(String s){
    if(s=='Male') {return Gender.Male;}
    if(s=='Female') {return Gender.Female;}
    return Gender.Others;
  }

  String getStringFromGender(Gender g){
    if(g==Gender.Male){return 'Male';}
    if(g==Gender.Female){return 'Female';}
    return 'Everyone';
  }

  @override
  void initState() {
    super.initState();
    getPreferencesFromSharedPreferences();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
          title: Text('Search Preferences')),
      body: Column(

        children: [
          Text("Show me:",style: TextStyle(fontSize: 20,color:Colors.purple),),
          GenderPickerWithImage(
            otherGenderText:"Everyone",
            showOtherGender: true,
            verticalAlignedText: false,
            selectedGender: getGenderFromString(preferredGender),
            selectedGenderTextStyle: TextStyle(
                color: Color(0xFF8b32a8), fontWeight: FontWeight.bold),
            unSelectedGenderTextStyle: TextStyle(
                color: Colors.white, fontWeight: FontWeight.normal),
            onChanged: (Gender gender) {
              setState(() {
                _changedPreferredGender = true;
                preferredGender = getStringFromGender(gender);
                savePreferences();
              });



            },
            equallyAligned: true,
            animationDuration: Duration(milliseconds: 300),
            isCircular: true,
            // default : true,
            opacityOfGradient: 0.4,
            padding: const EdgeInsets.all(3),
            size: 50, //default : 40
          ),
          FacebookSignInButton(text:'Facebook logout',onPressed: (){},), //TODO logout
        ],

      )

      , // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
