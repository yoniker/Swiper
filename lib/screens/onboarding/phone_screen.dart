import 'dart:async';

import 'package:betabeta/constants/color_constants.dart';
import 'package:betabeta/constants/onboarding_consts.dart';
import 'package:betabeta/models/loginService.dart';
import 'package:betabeta/services/aws_networking.dart';
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
  final void Function()? onNext;
  static const int verificationCodeLength = 6;
  static const String INVALID_SMS_CODE = 'invalid-verification-code';
  static const String ALREADY_LINKED_MESSAGE =
      'com.google.firebase.FirebaseException: User has already been linked to the given provider.';

  const PhoneScreen({Key? key, this.onNext}) : super(key: key);
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
  bool isMainLoginMethod = (Get.arguments == true);
  bool currentlyTryingToLogin = false;

  void tryLoginPhone({required String phoneNumber}) async {
    setState(() {
      currentlyTryingToLogin = true;
    });

    await FirebaseAuth.instance.verifyPhoneNumber(
      //Nitzan +1 416 8766549
      phoneNumber: phoneNumber,

      verificationCompleted: (PhoneAuthCredential credential) {
        _phoneCredential = credential;
        tryLinkPhone();
      },

      verificationFailed: (FirebaseAuthException e) {
        Get.snackbar('Login failed', e.toString(),
                duration: Duration(seconds: 15))
            .show(); //TODO show the user the error e in the UI
        _phoneCredential = null;
      },
      codeSent: (String verificationId, int? resendToken) async {
        //When Firebase sends an SMS code to the device,
        _verificationId = verificationId;

        setState(() {
          showVerificationWidget = true;
        });
      },

      codeAutoRetrievalTimeout: (String verificationId) async {
        // After timeout where a phone couldn't find the sms sent to it.
        _verificationId = verificationId;
        if (mounted)
          setState(() {
            showVerificationWidget = true;
          });
      },
    );
    setState(() {
      currentlyTryingToLogin = false;
    });
  }

  void tryVerificationCode() async {
    if (_verificationId == null) {
      Get.snackbar('empty verification id', 'empty verification id',
          duration:
              Duration(seconds: 10)); //Without a bug, should never be here
      return;
    }

    if (_smsCode == null ||
        _smsCode!.length != PhoneScreen.verificationCodeLength) {
      Get.snackbar('Bad length verification', 'Bad length verification',
          duration: Duration(seconds: 10)); //TODO show this in UI
      setState(() {
        showBadCodeMessage = true;
      });
      return;
    }

    _phoneCredential = PhoneAuthProvider.credential(
        verificationId: _verificationId!, smsCode: _smsCode!);
    print('trying to link phone...');
    await tryLinkPhone();
  }

  Future<void> tryLinkPhone() async {
    UserCredential? resultOfSigning;

    try {
      if (!isMainLoginMethod)

      //Try to link the phone with user. If successful,move on to next screen in onboarding
      {
        resultOfSigning = await FirebaseAuth.instance.currentUser
            ?.linkWithCredential(_phoneCredential!);
      } else {
        //This is main login method, so try to create a user with this phone credentials
        resultOfSigning = await LoginsService.instance
            .signInUser(credential: _phoneCredential!);
      }
    } on FirebaseAuthException catch (exception) {
      if (exception.code == PhoneScreen.INVALID_SMS_CODE) {
        Get.snackbar('Wrong sms code', 'Wrong sms code',
            duration: Duration(seconds: 10)); //TODO show this in UI
        setState(() {
          showBadCodeMessage = true;
        });
        return;
      }
      if (exception.message == PhoneScreen.ALREADY_LINKED_MESSAGE) {
        //Do nothing - everything is fine (user was already linked with this phone).
      }
    }
    String? currentTokenId =
        await FirebaseAuth.instance.currentUser?.getIdToken();
    await AWSServer.instance.verifyToken(
        firebaseIdToken:
            currentTokenId!); //TODO API in server which gets all the info from user's token (and later produces a JWT)
    if (!isMainLoginMethod) {
      widget.onNext?.call();
    } else {
      Get.back(result: resultOfSigning);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: kBackroundThemeColor,
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: currentlyTryingToLogin
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Column(
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
                            'We will send you a pin code',
                            style: kSmallInfoStyle,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          AnimatedContainer(
                            duration: Duration(milliseconds: 300),
                            height: showVerificationWidget
                                ? 0
                                : MediaQuery.of(context).size.height * 0.10,
                            child: SingleChildScrollView(
                              physics: NeverScrollableScrollPhysics(),
                              child: PhoneNumberCollector(
                                onChange: (enteredNumber) {
                                  countryCode != null
                                      ? phoneNumberEntered =
                                          '$countryCode $enteredNumber'
                                      : phoneNumberEntered =
                                          '+1 $enteredNumber';
                                  print(phoneNumberEntered);
                                },
                                onCountryPick: (newCode) {
                                  countryCode = newCode;
                                },
                                onTap: () {
                                  if (phoneNumberEntered != null &&
                                      phoneNumberEntered!.length > 0) {
                                    print(
                                        'pressed next with phone number as $phoneNumberEntered');
                                    tryLoginPhone(
                                        phoneNumber: phoneNumberEntered!);
                                  }
                                },
                              ),
                            ),
                          ),
                          if (showVerificationWidget)
                            buildVerificationWidget(
                              pinController: pinController,
                              focusNode: pinFocusNode,
                              onCompleted: (pin) {
                                print('onCompleted $pin');
                                _smsCode = pin;
                                print('will try to verify with $pin');
                                tryVerificationCode();
                              },
                              onSubmitted: (String pin) {
                                print('onSubmit $pin');
                                _smsCode = pin;
                                print('will try to verify with $pin');
                                tryVerificationCode();
                              },
                              phoneNumberEntered: phoneNumberEntered != null
                                  ? phoneNumberEntered!
                                  : 'No phone number',
                            ),
                          if (showBadCodeMessage)
                            Text(
                              'Wrong verification code',
                              style: TextStyle(color: Colors.red),
                            )
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

class buildVerificationWidget extends StatefulWidget {
  final TextEditingController? pinController;
  final FocusNode? focusNode;
  final String phoneNumberEntered;
  final void Function(String)? onCompleted;
  final void Function(String)? onSubmitted;

  const buildVerificationWidget(
      {Key? key,
      this.pinController,
      this.focusNode,
      this.onCompleted,
      this.phoneNumberEntered = '',
      this.onSubmitted})
      : super(key: key);

  @override
  State<buildVerificationWidget> createState() =>
      _buildVerificationWidgetState();
}

class _buildVerificationWidgetState extends State<buildVerificationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation _animation;

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500))
          ..addListener(() {
            setState(() {});
          })
          ..forward();
    _animation = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cursor = Align(
      alignment: Alignment.center,
      child: Container(
        decoration: BoxDecoration(
          color: Color.fromRGBO(68, 73, 80, 1),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
    final defaultPinTheme = PinTheme(
      width: 60,
      height: 64,
      textStyle: GoogleFonts.poppins(fontSize: 20, color: Colors.grey),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black.withOpacity(0.3), width: 1),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(-2, 0),
            blurRadius: 5,
          )
        ],
      ),
    );
    return Opacity(
      opacity: _animation.value,
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                'Enter the code sent to',
                style: LargeTitleStyle.copyWith(
                    fontSize: 18, color: Colors.black.withOpacity(0.4)),
              ),
            ),
          ),
          Text(
            widget.phoneNumberEntered,
            style:
                LargeTitleStyle.copyWith(fontSize: 15, color: Colors.black54),
          ),
          SizedBox(
            height: 20,
          ),
          Pinput(
            length: PhoneScreen.verificationCodeLength,
            controller: widget.pinController,
            focusNode: widget.focusNode,
            defaultPinTheme: defaultPinTheme,
            separator: SizedBox(width: 16),
            focusedPinTheme: defaultPinTheme.copyWith(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Colors.black87, width: 2),
              ),
            ),
            submittedPinTheme: defaultPinTheme.copyWith(
              decoration: BoxDecoration(
                color: Colors.white70,
                border: Border.all(color: Colors.grey, width: 1.3),
                borderRadius: BorderRadius.all(
                  Radius.circular(15),
                ),
              ),
            ),
            onCompleted: widget.onCompleted,
            onSubmitted: widget.onSubmitted,
            showCursor: false,
            cursor: cursor,
          ),
        ],
      ),
    );
  }
}
