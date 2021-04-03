import 'package:betabeta/models/match_engine.dart';
import 'package:betabeta/models/settings_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:provider/provider.dart';
import 'screens/matching_screen.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as JSON;
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';

void main()  {
  runApp(
      ChangeNotifierProvider(
        create: (context) => MatchEngine(),
        child: MyApp(),
      )
  );

 }


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Swiper MVP',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColorBrightness: Brightness.light,
        primarySwatch: Colors.blue,
      ),
      home:
        LoginHome(),
      //MatchingScreen(title: 'Flutter Demo Home Page'),
    );
  }
}

class LoginHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginHomeState();
}}

class _LoginHomeState extends State<LoginHome>{ //See https://codesundar.com/flutter-facebook-login/
  final facebookLogin = FacebookLogin();
  bool _errorTryingToLogin;
  String _errorMessage;


  @override
  void initState(){
    super.initState();
    _errorTryingToLogin=false;
    _getSettings();
  }
  
  _getSettings() async {
    SettingsData settings = SettingsData();
    await settings.readSettingsFromShared();
    if(settings.readFromShared && settings.facebookId!=''){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MatchingScreen(title: 'Swiper MVP')));
    }
    
  }
  
  _getFBLoginInfo() async{
    final result = await facebookLogin.logIn(['public_profile']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final token = result.accessToken.token;
        final graphResponse = await http.get('https://graph.facebook.com/v2.12/me?fields=name,picture&access_token=$token');
        final profile = JSON.jsonDecode(graphResponse.body);
        //Save name, id and picture url to settings(persistent storage), and move on to the next screen
        SettingsData settings = SettingsData();
        settings.name = profile['name'];
        settings.facebookId = profile['id'];
        final pictureResponse = await http.get('https://graph.facebook.com/v2.12/${profile['id']}/picture?type=large&redirect=0'); //'https://graph.facebook.com/v2.12/10218504761950570/picture?type=large&redirect=0'
        String reasonablePictureUrl=JSON.jsonDecode(pictureResponse.body)['data']['url'];
        DefaultCacheManager().emptyCache();
        DefaultCacheManager().getSingleFile(reasonablePictureUrl);
        settings.facebookProfileImageUrl = reasonablePictureUrl;
        _getSettings();
        break;

      case FacebookLoginStatus.cancelledByUser:
        setState(() {_errorTryingToLogin = true;  _errorMessage='User cancelled Login';});
        break;
      case FacebookLoginStatus.error:
        setState(()  {_errorTryingToLogin = true; _errorMessage=result.errorMessage??'Error trying to login';} );
        break;
    }

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('D',style:TextStyle(fontSize: 55,fontFamily: 'RougeScript',fontWeight: FontWeight.bold)),
          Container(
              padding: const EdgeInsets.all(8.0), child: Text('MVPBeta Login'))
        ],

      )
      ),
        body:Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FacebookSignInButton(
                    onPressed: (){
                      _getFBLoginInfo();
                      //Navigator.push(context, MaterialPageRoute(builder: (context) => MatchingScreen(title: 'Flutter Demo Home Page')));
                    },
                  ),
                  _errorTryingToLogin?
                      TextButton(
                        child:Text('❗'),
                        onPressed: (){
                          showDialog(context: context,builder: (_) {
                            return AlertDialog(
                              title: Text("Error"),
                              content:Text(_errorMessage??"Error when trying to login"),

                            );
                          },
                          barrierDismissible: true);

                        }
                      )
                      :Container()
                ],
              ),

              Text("Don't worry, we only ask for your public profile.",
              style: TextStyle(color:Colors.grey,),textAlign: TextAlign.center,
              ),
              Text('We never post to Facebook.',style: TextStyle(color:Colors.grey,)),
              GestureDetector(
                child: Container(child: Text('What does public profile mean?',style:TextStyle(color:Colors.grey,fontWeight: FontWeight.bold,decoration: TextDecoration.underline)),
                ),
                onTap: (){showDialog(context: context,builder: (_) {
                  return AlertDialog(
                    title: Text("Public Profile Info"),
                    content:Text("Public Profile includes just your name and profile picture. This information is literally available to anyone in the world."),

                  );
                },
                    barrierDismissible: true);},
              )
            ],
          ),
        )

    );
  }


}