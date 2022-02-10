import 'package:auth_buttons/auth_buttons.dart';
import 'package:betabeta/constants/color_constants.dart';
import 'package:betabeta/models/chatData.dart';
import 'package:betabeta/models/loginService.dart';
import 'package:betabeta/models/settings_model.dart';
import 'package:betabeta/services/chat_networking.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';



import 'main_navigation_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/login';
  @override
  State<StatefulWidget> createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen> {
  //See https://codesundar.com/flutter-facebook-login/

  bool _errorTryingToLogin = false;
  bool currentlyTryingToLogin = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _continueIfLoggedIn();
  }

  _tryLoginPhone()async{

    setState(() {
      currentlyTryingToLogin = true;
    });
    await LoginsService.instance.tryLoginPhone();
    if(LoginsService.instance.phoneLoginState!=LoginState.Success || LoginsService.instance.phoneCredential==null){return;}
    //TODO play here..

    print('dor king');
    print('dor is the king');
    if(FirebaseAuth.instance.currentUser!=null && LoginsService.instance.phoneCredential!=null){
      try{
    await FirebaseAuth.instance.currentUser!.linkWithCredential(LoginsService.instance.phoneCredential!);}
    on FirebaseAuthException catch (e){

      if (e.code == 'invalid-verification-code') {//TODO something else while verifying code
        Get.snackbar('Error verifying phone', 'Wrong verification code',duration: Duration(seconds:10)).show();
      }

      if(e.code == 'credential-already-in-use'){
        Get.snackbar('Error', 'Credential in use',duration: Duration(seconds:10)).show();
      }
    }



    }
    else{//Phone is the main provider
      UserCredential? userCredential = await LoginsService.signInUser(credential: LoginsService.instance.phoneCredential!);
      if(userCredential!=null){
        await _saveUid();
        _continueIfLoggedIn();
      }
    }
    await _saveUid();


    setState(() {
      currentlyTryingToLogin = false;
    });

      _continueIfLoggedIn();

  }

  _continueIfLoggedIn() async {
    //Continue to the next screen if the user is already logged in.
    SettingsData settings = SettingsData.instance;
    await settings.readSettingsFromShared();
    if (settings.readFromShared! && settings.uid.length>0) {
      print('continue because uid is ${settings.uid}');
      ChatData().syncWithServer();
      Get.offAllNamed(
        MainNavigationScreen.routeName,
      ); //TODO make sure this makes sense given splash screen
    }
  }



  Future<void> _saveUid()async{
    var idToken = await FirebaseAuth.instance.currentUser?.getIdToken();
    String uid = FirebaseAuth.instance.currentUser!.uid;
    print('Registering uid...');
    String serverUid = await ChatNetworkHelper.registerUid(firebaseIdToken: idToken!);
    //TODO support existing accounts : check with the server if the uid already existed,and if so load the user's details from the server
    if(uid!=serverUid){
      print('The uid in server is different from client, something weird is going on!');
      //TODO something about it?
    }
    SettingsData.instance.uid = uid;
    print('Registered the uid $uid');
  }

  _tryLoginFacebook() async {
    setState(() {
      currentlyTryingToLogin = true;
    });
    await LoginsService.instance.tryLoginFacebook();
    if(LoginsService.instance.facebookLoginState==LoginState.Success){
      await LoginsService.instance.getFacebookUserData();
      await LoginsService.signInUser(credential: LoginsService.instance.facebookCredential!);
      await _saveUid();
      await _continueIfLoggedIn();
    }
    setState(() {
      currentlyTryingToLogin = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: currentlyTryingToLogin
            ? loggingInAnimation()
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    HuaweiAuthButton(onPressed: _tryLoginPhone,),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FacebookAuthButton(
                          onPressed: () {
                            _tryLoginFacebook();
                          },
                        ),
                        _errorTryingToLogin
                            ? TextButton(
                                child: Text('❗'),
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (_) {
                                        return AlertDialog(
                                          title: Text("Error"),
                                          content: Text(_errorMessage ??
                                              "Error when trying to login"),
                                        );
                                      },
                                      barrierDismissible: true);
                                })
                            : Container()
                      ],
                    ),
                    Text(
                      "Don't worry, we only ask for your public profile.",
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text('We never post to Facebook.',
                        style: TextStyle(
                          color: Colors.grey,
                        )),
                    GestureDetector(
                      child: Container(
                        child: Text('What does public profile mean?',
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline)),
                      ),
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (_) {
                              return AlertDialog(
                                title: Text("Public Profile Info"),
                                content: Text(
                                    "Public Profile includes just your name and profile picture. This information is literally available to anyone in the world."),
                              );
                            },
                            barrierDismissible: true);
                      },
                    ),
                  ],
                ),
              ));
  }

  Widget loggingInAnimation() {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SpinKitPumpingHeart(
          color: colorBlend02,
        ),
        Text(
          'Logging in...',
          style: titleStyle,
        ),
      ],
    ));
  }
}
