import 'package:flutter/material.dart';
import 'FacebookProfile.dart';
import 'matching_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as JSON;
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';

void main()  {
  runApp(MyApp());}


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
  String name;
  String facebookId;
  String facebookProfileImageUrl;
  bool _errorTryingToLogin;
  String _errorMessage;


  @override
  void initState(){
    super.initState();
    _errorTryingToLogin=false;
    _getDataFromPrefs();
  }
  
  _getDataFromPrefs() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    name = prefs.getString('name');

    if(name!=null){
      facebookId=prefs.getString('facebook_id');
      facebookProfileImageUrl=prefs.getString('facebook_profile_image_url');
      FacebookProfile currentUserFacebookProfile = FacebookProfile(name:name,facebookId: facebookId,facebookProfileImageUrl: facebookProfileImageUrl);
      Navigator.push(context, MaterialPageRoute(builder: (context) => MatchingScreen(title: 'Flutter Demo Home Page',userProfile:currentUserFacebookProfile)));


    }
    
  }
  
  _getFBLoginInfo() async{
    final result = await facebookLogin.logIn(['public_profile']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final token = result.accessToken.token;
        final graphResponse = await http.get('https://graph.facebook.com/v2.12/me?fields=name,picture,email&access_token=$token');
        final profile = JSON.jsonDecode(graphResponse.body);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        //Save name, id and picture url to persistent storage, and move on to the next screen
        await prefs.setString('name', profile['name']);
        await prefs.setString('facebook_id', profile['id']);
        await prefs.setString('facebook_profile_image_url', profile['picture']['data']['url']);
        _getDataFromPrefs();
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
          Image.asset(
            'assets/bigD.png',
            fit: BoxFit.contain,
            height: 32,
          ),
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
                      FlatButton(
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

              Text("Don't worry, it's just your public profile.",
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