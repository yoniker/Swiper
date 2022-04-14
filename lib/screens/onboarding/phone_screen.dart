import 'dart:async';

import 'package:betabeta/constants/onboarding_consts.dart';
import 'package:betabeta/models/loginService.dart';
import 'package:betabeta/services/new_networking.dart';
import 'package:betabeta/services/onboarding_flow_controller.dart';
import 'package:betabeta/widgets/onboarding/onboarding_column.dart';
import 'package:betabeta/widgets/onboarding/phone_number_collector.dart';
import 'package:country_code_picker/country_code.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';

class PhoneScreen extends StatefulWidget {
  static const String routeName = '/phoneScreen';
  static const int verificationCodeLength = 6;
  static const String INVALID_SMS_CODE = 'invalid-verification-code';
  static const String ALREADY_LINKED_MESSAGE = 'com.google.firebase.FirebaseException: User has already been linked to the given provider.';

  const PhoneScreen({Key? key}) : super(key: key);
  @override
  _PhoneScreenState createState() => _PhoneScreenState();
}

class _PhoneScreenState extends State<PhoneScreen> {
  String? phoneNumberEntered;
  CountryCode? countryCode;
  String? _smsCode;
  PhoneAuthCredential? _phoneCredential;
  bool showVerificationWidget = false;
  bool showBadCodeMessage = false;
  String? _verificationId;
  final pinController = TextEditingController();
  final pinFocusNode = FocusNode();
  bool isMainLoginMethod = (Get.arguments==true);
  


  void tryLoginPhone({required String phoneNumber}){
     FirebaseAuth.instance.verifyPhoneNumber(
      //Nitzan +1 416 8766549
      phoneNumber: phoneNumber,

      verificationCompleted: (PhoneAuthCredential credential) {
        _phoneCredential = credential;
        tryLinkPhone();
        
      },


      verificationFailed: (FirebaseAuthException e) {
        Get.snackbar('Login failed', e.toString(),duration: Duration(seconds: 15)).show(); //TODO show the user the error e in the UI
        _phoneCredential = null;
      },
      codeSent: (String verificationId, int? resendToken) async { //When Firebase sends an SMS code to the device,
        _verificationId = verificationId;
        setState(() {
          showVerificationWidget = true;
        });
      },

      codeAutoRetrievalTimeout: (String verificationId) async {// After timeout where a phone couldn't find the sms sent to it.
        _verificationId = verificationId;
        if(mounted)setState(() {
          showVerificationWidget = true;
        });


      },
    );

    

  }


  void tryVerificationCode()async{
    if(_verificationId==null){
      Get.snackbar('empty verification id', 'empty verification id',duration: Duration(seconds: 10));//Without a bug, should never be here
      return;
    }
    
    if(_smsCode==null ||_smsCode!.length!=PhoneScreen.verificationCodeLength){
      Get.snackbar('Bad length verification', 'Bad length verification',duration: Duration(seconds: 10)); //TODO show this in UI
      setState(() {
        showBadCodeMessage = true;
      });
      return;
    }


    
     _phoneCredential = PhoneAuthProvider.credential(verificationId: _verificationId!, smsCode: _smsCode!);
    print('trying to link phone...');
    await tryLinkPhone();

    
  }


  Future<void> tryLinkPhone()async{
    UserCredential? resultOfSigning;

    try {



      if(!isMainLoginMethod)

        //Try to link the phone with user. If successful,move on to next screen in onboarding
    {resultOfSigning= await FirebaseAuth.instance.currentUser
        ?.linkWithCredential(_phoneCredential!);}

      else{
        //This is main login method, so try to create a user with this phone credentials
        resultOfSigning = await LoginsService.instance.signInUser(credential: _phoneCredential!);
      }
  }
  on FirebaseAuthException catch (exception){
    if(exception.code==PhoneScreen.INVALID_SMS_CODE){
      Get.snackbar('Wrong sms code', 'Wrong sms code',duration: Duration(seconds: 10)); //TODO show this in UI
      setState(() {
        showBadCodeMessage = true;
      });
      return;
    }
    if(exception.message == PhoneScreen.ALREADY_LINKED_MESSAGE){
      //Do nothing - everything is fine (user was already linked with this phone).
    }

  }
    String? currentTokenId = await FirebaseAuth.instance.currentUser?.getIdToken();
    await NewNetworkService.instance.verifyToken(firebaseIdToken: currentTokenId!); //TODO API in server which gets all the info from user's token (and later produces a JWT)
    if(!isMainLoginMethod)
    {Get.offAllNamed(OnboardingFlowController.instance.nextRoute(PhoneScreen.routeName));}
    else{Get.back(result:resultOfSigning);}


  }




  Widget _buildVerificationWidget(){
    final cursor = Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: 21,
        height: 1,
        margin: EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Color.fromRGBO(68, 73, 80, 1),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
    final defaultPinTheme = PinTheme(
      width: 60,
      height: 64,
      textStyle: GoogleFonts.poppins(
          fontSize: 20, color: Color.fromRGBO(70, 69, 66, 1)),
      decoration: BoxDecoration(
        color: Color.fromRGBO(116, 117, 120, 0.37),
        borderRadius: BorderRadius.circular(24),
      ),
    );
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
        Pinput(
          length: PhoneScreen.verificationCodeLength,
          controller: pinController,
          focusNode: pinFocusNode,
          defaultPinTheme: defaultPinTheme,
          separator: SizedBox(width: 16),
          focusedPinTheme: defaultPinTheme.copyWith(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.05999999865889549),
                  offset: Offset(0, 3),
                  blurRadius: 16,
                )
              ],
            ),
          ),
          onCompleted: (pin){
            print('onCompleted $pin');
            _smsCode = pin;
            print('will try to verify with $pin');
            tryVerificationCode();
          },
          onSubmitted: (String pin){
            print('onSubmit $pin');
            _smsCode = pin;
            print('will try to verify with $pin');
            tryVerificationCode();

          },
          showCursor: true,
          cursor: cursor,
        ),
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
                  onTap: () {
                    if(phoneNumberEntered!=null && phoneNumberEntered!.length>0){
                    tryLoginPhone(phoneNumber: phoneNumberEntered!);}
                    print('pressed next with phone number as $phoneNumberEntered');

                  },
                ),
                if(showVerificationWidget) _buildVerificationWidget(),
                if(showBadCodeMessage) Text('Wrong verification code',style: TextStyle(color: Colors.red),)
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

  @override
  void dispose() {
    pinController.dispose();
    pinFocusNode.dispose();
    super.dispose();
  }
}
