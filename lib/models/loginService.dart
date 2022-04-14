import 'dart:async';

import 'package:betabeta/services/settings_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';


enum LoginState{
  LoggedOut,
  Success,
  WrongPassword,
  WrongToken,
  UserCancelled,
  InProcess,
  Error
}

class LoginsService{



  LoginsService._privateConstructor();

  static final LoginsService _instance = LoginsService._privateConstructor();

  static LoginsService get instance => _instance;


  LoginState _facebookLoginState = LoginState.LoggedOut;
  LoginState _phoneLoginState = LoginState.LoggedOut;
  PhoneAuthCredential? _phoneCredential;
  OAuthCredential? _facebookCredential;

  LoginState get facebookLoginState =>  _facebookLoginState;
  LoginState get phoneLoginState => _phoneLoginState;
  PhoneAuthCredential? get phoneCredential => _phoneCredential;
  OAuthCredential? get facebookCredential =>_facebookCredential;


   Future<void> saveInfoFacebookUser()async{
    //Save some info about the user in our app. Do it only while onboarding eg we don't have this info already
    if(_facebookLoginState!=LoginState.Success) {return;}
    final userData = await FacebookAuth.instance.getUserData(
      fields: "name,email,picture.width(200),birthday",
    );

    SettingsData.instance.name = userData['name'];
    SettingsData.instance.facebookId = userData['id'];
    //TODO the following code does nothing as the actual birthday isn't provided yet (facebook wants to see how this integrated into the app, so do this after onboarding is complete)
    var facebookDateFormat = DateFormat('MM/dd/yyyy');
    String birthday = facebookDateFormat.parse(userData['birthday']??'01/01/1995').toString();
    SettingsData.instance.facebookBirthday = birthday;
    SettingsData.instance.facebookProfileImageUrl =
    userData['picture']['data']['url'];
    DefaultCacheManager().getSingleFile(SettingsData.instance.facebookProfileImageUrl);
  }

  
  
   Future<LoginState> tryLoginFacebook()async{
    //Try to login with facebook, this is the complete process eg in the end we will know if the user is logged in or not
  final loginResult = await FacebookAuth.instance
      .login(permissions: ['email', 'public_profile', ]); //'user_birthday'
  switch (loginResult.status) {
  case LoginStatus.success:
    final OAuthCredential facebookAuthCredential =
    FacebookAuthProvider.credential(loginResult.accessToken!.token);
     _facebookCredential=  facebookAuthCredential;
    _facebookLoginState = LoginState.Success;
    break;

  case LoginStatus.cancelled:
    _facebookCredential = null;
    _facebookLoginState = LoginState.UserCancelled;
    break;
  case LoginStatus.operationInProgress:
  case LoginStatus.failed:
  //TODO loginResult.message has the official error message
  _facebookLoginState = LoginState.Error;
  _facebookCredential = null;
  break;
  }

  return _facebookLoginState;
  }

   Future<void>getFacebookUserData()async{
    if(_facebookLoginState!=LoginState.Success){return;}
    final userData = await FacebookAuth.instance.getUserData(
      fields: "name,email,picture.width(200),birthday",
    );


    if(SettingsData.instance.name.length==0){
    SettingsData.instance.name = ((userData['name'] as String?)??'').split(' ').first;}
    SettingsData.instance.facebookId = userData['id'];
    //TODO the following code does nothing as the actual birthday isn't provided yet (facebook wants to see how this integrated into the app, so do this after onboarding is complete)
    var facebookDateFormat = DateFormat('MM/dd/yyyy');
    String birthday = facebookDateFormat.parse(userData['birthday']??'01/01/1995').toString();
    SettingsData.instance.facebookBirthday = birthday;
    SettingsData.instance.facebookProfileImageUrl = userData['picture']['data']['url'];
    if((userData['email']??'').length>0){
      SettingsData.instance.email = userData['email'];
    }



    DefaultCacheManager().emptyCache();
    DefaultCacheManager()
        .getSingleFile(SettingsData.instance.facebookProfileImageUrl);
  }
  
   Future<UserCredential?> signInUser({required AuthCredential credential,void Function(Object)? onError})async{

    // Sign the user in (or link) with the credential
    try{
      var userCredentials = await FirebaseAuth.instance.signInWithCredential(credential);
      return userCredentials;
    }
    catch(e){
      //TODO something in this situation of bad credentials
      Get.snackbar('Exception-probably wrong verification code or password by the user', e.toString(),duration: Duration(seconds: 10));
      onError?.call(e);
      return null;
    }


  }

}