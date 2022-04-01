import 'dart:async';

import 'package:betabeta/constants/onboarding_consts.dart';
import 'package:betabeta/services/loginService.dart';
import 'package:betabeta/widgets/onboarding/onboarding_column.dart';
import 'package:betabeta/widgets/onboarding/phone_number_collector.dart';
import 'package:country_code_picker/country_code.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_verification_code/flutter_verification_code.dart';
import 'package:get/get.dart';

class PhoneScreen extends StatefulWidget {
  static const String routeName = '/phoneScreen';

  const PhoneScreen({Key? key}) : super(key: key);
  @override
  _PhoneScreenState createState() => _PhoneScreenState();
}

class _PhoneScreenState extends State<PhoneScreen> {
  int dropDownValue = 1;
  bool _onEditing = true;
  String? phoneNumberEntered;
  CountryCode? countryCode;
  String? _smsCode;
  PhoneAuthCredential? _phoneCredential;
  bool showVerificationWidget = false;
  static const int verificationCodeLength = 6;
  String? _verificationId;
  


  void tryLoginPhone({String phoneNumber='+972556671457'}){
    //This is a partial process eg in the best case scenario we will have a cre
     FirebaseAuth.instance.verifyPhoneNumber(
      //Nitzan +1 416 8766549
      phoneNumber: phoneNumber,

      verificationCompleted: (PhoneAuthCredential credential) {
        Get.snackbar('Success', 'Success').show();
        _phoneCredential = credential;
        
      },


      verificationFailed: (FirebaseAuthException e) {
        Get.snackbar('Login failed', e.toString(),duration: Duration(seconds: 15)).show(); //TODO show the user the error in the UI
        _phoneCredential = null;
      },
      codeSent: (String verificationId, int? resendToken) async { //When Firebase sends an SMS code to the device,
        //await _getCredentialPhone(verificationId:verificationId);
        _verificationId = verificationId;
        setState(() {
          showVerificationWidget = true;
        });
      },

      codeAutoRetrievalTimeout: (String verificationId) async {// After timeout where a phone couldn't find the sms sent to it.
        _verificationId = verificationId;
        setState(() {
          showVerificationWidget = true;
        });


      },
    );

    

  }


  void tryVerificationCode(){
    if(_verificationId==null){
      Get.snackbar('empty verification id', 'empty verification id',duration: Duration(seconds: 10));//Without a bug, should never be here
      return;
    }
    
    if(_smsCode==null ||_smsCode!.length!=verificationCodeLength){
      Get.snackbar('Bad length verification', 'Bad length verificatione',duration: Duration(seconds: 10)); //TODO show this in UI
      return;
    }


    
     _phoneCredential = PhoneAuthProvider.credential(verificationId: _verificationId!, smsCode: _smsCode!);
    Get.snackbar('Credential exists', 'credential exists',duration: Duration(seconds: 10)); //TODO show this in UI
  setState(() {

  });
  }




  Widget _buildVerificationWidget(){
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Center(
            child: Text(
              'Enter your code',
              style: TextStyle(fontSize: 20.0),
            ),
          ),
        ),
        VerificationCode(
          textStyle: TextStyle(fontSize: 20.0, color: Colors.red[900]),
          keyboardType: TextInputType.number,
          underlineColor: Colors.amber, // If this is null it will use primaryColor: Colors.red from Theme
          length: verificationCodeLength,
          cursorColor: Colors.blue, // If this is null it will default to the ambient
          // clearAll is NOT required, you can delete it
          // takes any widget, so you can implement your design
          clearAll: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'clear all',
              style: TextStyle(fontSize: 14.0, decoration: TextDecoration.underline, color: Colors.blue[700]),
            ),
          ),
          onCompleted: (String value) {
            setState(() {
              _smsCode = value;
              tryVerificationCode();
            });
          },
          onEditing: (bool value) {
            setState(() {
              _onEditing = value;
            });
            if (!_onEditing) FocusScope.of(context).unfocus();
          },
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Center(
            child: _onEditing ? Text('Please enter full code') : Text('Your code: $_smsCode'),
          ),
        )
      ],
    );
  }






  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackroundThemeColor,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: OnboardingColumn(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    'What is your phone number?  📞',
                    style: kTitleStyle,
                  ),
                ),
                Text(
                  'Just to make sure you are real :)',
                  style: kSmallInfoStyle,
                ),
                SizedBox(
                  height: 30,
                ),
                PhoneNumberCollector(
                  onChange: (enteredNumber) {
                    countryCode != null
                        ? phoneNumberEntered = '$countryCode $enteredNumber'
                        : phoneNumberEntered = '+1 $enteredNumber';
                    print(phoneNumberEntered);
                  },
                  onCountryPick: (newCode) {
                    countryCode = newCode;
                  },

                  //TODO Yoni add phone login logic
                  onTap: () {
                    if(phoneNumberEntered!=null && phoneNumberEntered!.length>0){
                    tryLoginPhone(phoneNumber: phoneNumberEntered!);}
                    print('pressed next with phone number as $phoneNumberEntered');
                    // Get.offAllNamed(OnboardingFlowController.instance
                    //     .nextRoute(PhoneScreen.routeName));
                  },
                ),
                if(showVerificationWidget) _buildVerificationWidget(),
              ],
            ),
            Column(
              children: const [
                Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Text(
                    'Kept private and wont be in your profile  🔒',
                    style: kSmallInfoStyle,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
