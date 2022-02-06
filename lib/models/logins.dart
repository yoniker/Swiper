import 'dart:async';

import 'package:betabeta/screens/onboarding/verification_code_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class LoginsService{

  static Future<PhoneAuthCredential?> _getCredential({required String verificationId})async{
  dynamic userInput = await Get.toNamed(VerificationCodeScreen.routeName);
  String? codeFromUser = userInput is String?userInput:null;
  if(codeFromUser==null || codeFromUser.length!=VerificationCodeScreen.verificationCodeLength){
  //TODO verification code from user can't be legal so show that to the user. for now I will just present a snackbar
  Get.snackbar('Verification code not complete', 'Verification code not complete',duration: Duration(seconds: 10));
  return null;
  }

  // Create a PhoneAuthCredential with the code
  PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: codeFromUser);
  print('going to return $credential');
  return credential;

  }


  static Future<PhoneAuthCredential?> tryLoginPhone()async{
    PhoneAuthCredential? phoneCredential;
    Completer completer = Completer<bool>();
    await FirebaseAuth.instance.verifyPhoneNumber(
      //Nitzan +1 416 8766549
      phoneNumber: '+972556671457', //TODO get number from user (go to appropriate screen etc)
      verificationCompleted: (PhoneAuthCredential credential) {
        Get.snackbar('Success', 'Success').show();
        phoneCredential = credential;
        completer.complete(true);
      },
      verificationFailed: (FirebaseAuthException e) {
        Get.snackbar('Login failed', e.toString(),duration: Duration(seconds: 15)).show(); //TODO show the user the error in a different way
        phoneCredential = null;
        completer.complete(true);
      },
      codeSent: (String verificationId, int? resendToken) async {
        phoneCredential =  await _getCredential(verificationId:verificationId);
        completer.complete(true);
      },
      codeAutoRetrievalTimeout: (String verificationId) async {
        //TODO this method is called after timeout where a phone couldn't find the sms sent to it. Should show the user something?
        phoneCredential =  await _getCredential(verificationId:verificationId);
        completer.complete(true);

      },
    );

    await completer.future; //For the motivation to use it, See https://github.com/FirebaseExtended/flutterfire/issues/3239
    return phoneCredential;

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