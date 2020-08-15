import 'package:flutter/material.dart';
import 'matching_screen.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as JSON;

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
  bool _isLoggedIn=false;
  Map userProfile;
  _loginWithFB() async{


    final result = await facebookLogin.logIn(['public_profile']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final token = result.accessToken.token;
        final graphResponse = await http.get('https://graph.facebook.com/v2.12/me?fields=name,picture,email&access_token=$token');
        final profile = JSON.jsonDecode(graphResponse.body);
        print(profile);
        setState(() {
          userProfile = profile;
          _isLoggedIn = true;
        });
        break;

      case FacebookLoginStatus.cancelledByUser:
        setState(() => _isLoggedIn = false );
        break;
      case FacebookLoginStatus.error:
        setState(() => _isLoggedIn = false );
        break;
    }

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlineButton(
                child:Text('FaceBook Login'),
                onPressed: (){
                  _loginWithFB();
                  //Navigator.push(context, MaterialPageRoute(builder: (context) => MatchingScreen(title: 'Flutter Demo Home Page')));
                },
              )
            ],
          ),
        )

    );
  }


}