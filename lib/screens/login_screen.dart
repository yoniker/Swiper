import 'dart:io';

import 'package:auth_buttons/auth_buttons.dart';
import 'package:betabeta/constants/color_constants.dart';
import 'package:betabeta/models/chatData.dart';
import 'package:betabeta/models/settings_model.dart';
import 'package:betabeta/services/chat_networking.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';


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
    _getSettings();
  }

  _getSettings() async {
    SettingsData settings = SettingsData();
    await settings.readSettingsFromShared();
    if (settings.readFromShared! && settings.facebookId != '') {
      ChatData().syncWithServer();
      Get.offAllNamed(
        MainNavigationScreen.routeName,
      ); //TODO make sure this makes sense given splash screen
    }
  }

  _tryLoginFacebook() async {
    setState(() {
      currentlyTryingToLogin = true;
    });
    final loginResult = await FacebookAuth.instance
        .login(permissions: ['email', 'public_profile', 'user_birthday']);
    switch (loginResult.status) {
      case LoginStatus.success:
        final AccessToken? accessToken = loginResult.accessToken;
        final OAuthCredential facebookAuthCredential =
            FacebookAuthProvider.credential(loginResult.accessToken!.token);
        UserCredential firebaseCredentials = await FirebaseAuth.instance
            .signInWithCredential(facebookAuthCredential);
        var idToken = await FirebaseAuth.instance.currentUser?.getIdToken();
        String uid = FirebaseAuth.instance.currentUser!.uid;
        String serverUid = await ChatNetworkHelper.registerUid(firebaseIdToken: idToken!);
        if(uid!=serverUid){
          print('The uid in server is different from client, something weird is going on!');
        }
        SettingsData().uid = uid;
        //TODO support existing accounts : check with the server if the uid already existed,and if so load the user's details from the server
        final userData = await FacebookAuth.instance.getUserData(
          fields: "name,email,picture.width(200),birthday",
        );

        SettingsData().name = userData['name'];
        SettingsData().facebookId = userData['id'];
        var facebookDateFormat = DateFormat('MM/dd/yyyy');
        String birthday = facebookDateFormat.parse(userData['birthday']??'01/01/1995').toString();
        SettingsData().facebookBirthday = birthday;
        SettingsData().facebookProfileImageUrl =
            userData['picture']['data']['url'];

        DefaultCacheManager().emptyCache();
        DefaultCacheManager()
            .getSingleFile(SettingsData().facebookProfileImageUrl);
        _getSettings();
        break;

      case LoginStatus.cancelled:
        setState(() {
          _errorTryingToLogin = true;
          _errorMessage = 'User cancelled Login';
        });
        break;
      case LoginStatus.operationInProgress:
      case LoginStatus.failed:
        setState(() {
          _errorTryingToLogin = true;
          _errorMessage = loginResult.message ?? 'Error trying to login';
        });
        break;
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
