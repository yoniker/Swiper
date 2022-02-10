import 'dart:async';

import 'package:betabeta/models/settings_model.dart';
import 'package:betabeta/screens/onboarding/verification_code_screen.dart';
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


  Future<void> _getCredentialPhone({required String verificationId})async{
  dynamic userInput = await Get.toNamed(VerificationCodeScreen.routeName);
  String? codeFromUser = userInput is String?userInput:null;
  if(codeFromUser==null || codeFromUser.length!=VerificationCodeScreen.verificationCodeLength){
  //TODO verification code from user can't be legal so show that to the user. for now I will just present a snackbar
  Get.snackbar('Verification code not complete', 'Verification code not complete',duration: Duration(seconds: 10));
  _phoneCredential = null;
  _phoneLoginState = LoginState.WrongPassword;
  return;
  }

  // Create a PhoneAuthCredential with the code
  PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: codeFromUser);
  _phoneCredential = credential;
  _phoneLoginState = LoginState.Success; //Remember that we still didn't verify the code the user entered was correct

  }


   Future<LoginState> tryLoginPhone({String phoneNumber='+972556671457'})async{
    //This is a partial process eg in the best case scenario we will have a cre
    LoginState loginState = LoginState.InProcess;
    Completer completer = Completer<bool>();
    await FirebaseAuth.instance.verifyPhoneNumber(
      //Nitzan +1 416 8766549
      phoneNumber: phoneNumber, //TODO get number from user (go to appropriate screen etc)

      verificationCompleted: (PhoneAuthCredential credential) {
        Get.snackbar('Success', 'Success').show();
        _phoneCredential = credential;
        loginState = LoginState.Success;
        completer.complete(true);
      },


      verificationFailed: (FirebaseAuthException e) {
        Get.snackbar('Login failed', e.toString(),duration: Duration(seconds: 15)).show(); //TODO show the user the error in a different way
        _phoneCredential = null;
        completer.complete(true);
      },
      codeSent: (String verificationId, int? resendToken) async {
        await _getCredentialPhone(verificationId:verificationId);
        completer.complete(true);
      },

      codeAutoRetrievalTimeout: (String verificationId) async {
        //TODO this method is called after timeout where a phone couldn't find the sms sent to it. Should show the user something?
        if(!completer.isCompleted){
          await _getCredentialPhone(verificationId:verificationId);
        completer.complete(true);
        }


      },
    );

    await completer.future; //For the motivation to use it, See https://github.com/FirebaseExtended/flutterfire/issues/3239
    return loginState;

  }
  
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

    SettingsData.instance.name = userData['name'];
    SettingsData.instance.facebookId = userData['id'];
    //TODO the following code does nothing as the actual birthday isn't provided yet (facebook wants to see how this integrated into the app, so do this after onboarding is complete)
    var facebookDateFormat = DateFormat('MM/dd/yyyy');
    String birthday = facebookDateFormat.parse(userData['birthday']??'01/01/1995').toString();
    SettingsData.instance.facebookBirthday = birthday;
    SettingsData.instance.facebookProfileImageUrl =
    userData['picture']['data']['url'];

    DefaultCacheManager().emptyCache();
    DefaultCacheManager()
        .getSingleFile(SettingsData.instance.facebookProfileImageUrl);
  }
  
  static Future<UserCredential?> signInUser({required AuthCredential credential,void Function(Object)? onError})async{

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