import 'dart:async';
import 'package:betabeta/services/networking.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/*
* This is essentially the same class as the singleton SettingsData, but with a different debounce and different network call,
* and without resetting the match engine on a set.
* 
* If there's a need to change the shared code (which is thin as is) make an abstract class that both inherit from
* */


class DetailsData extends ChangeNotifier{
  //Some consts to facilitate share preferences access
  static const String ABOUT_ME_KEY = 'about_me';
  static const String JOB_KEY = 'job';
  static const String COMPANY_KEY = 'company';
  static const _debounceDetailsTime = Duration(seconds: 2); //Debounce time such that we notify listeners
  bool? _readFromShared;
  Timer? _debounce;
  String? _aboutMe;
  String? _job;
  String? _company;

  DetailsData._privateConstructor(){
    //Fill in some "default" values which should be filled in within milliseconds of opening the App
    _readFromShared = false;
    _aboutMe = '';
    _job = '';
    _company = '';
    
    //And after that, read settings from shared
    readDetailsFromShared();

  }

  Future<void> readDetailsFromShared() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    
    _aboutMe = sharedPreferences.getString(ABOUT_ME_KEY)??_aboutMe;
    _job = sharedPreferences.getString(JOB_KEY) ?? _job;
    _company = sharedPreferences.getString(COMPANY_KEY) ??_company;
    _readFromShared = true;
    return;
  }



  static final DetailsData _instance = DetailsData._privateConstructor();

  factory DetailsData() {
    return _instance;
  }

  bool? get readFromShared{
    return _readFromShared;
  }

  
  
  String? get aboutMe{
    return _aboutMe;
  }
  
  set aboutMe(String? newAboutMe){
    _aboutMe = newAboutMe;
    saveDetails(ABOUT_ME_KEY, newAboutMe);
  }



  String? get job{
    return _job;
  }

  set job(String? newJob){
    _job = newJob;
    saveDetails(JOB_KEY, newJob);
  }
  
  String? get company{
    return _company;
  }
  
  set company(String? newCompany){
    _company = newCompany;
    saveDetails(COMPANY_KEY, newCompany);
  }



  void saveDetails(String sharedPreferencesKey, dynamic newValue) async {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(_debounceDetailsTime, () async{
      
        await NetworkHelper().postUserDetails();
    });
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if(newValue is int) {
      sharedPreferences.setInt(sharedPreferencesKey, newValue);
      return;
    }

    if(newValue is String){
      sharedPreferences.setString(sharedPreferencesKey, newValue);
      return;
    }

    if (newValue is bool){
      sharedPreferences.setBool(sharedPreferencesKey, newValue);
      return;}

    if (newValue is double){
      sharedPreferences.setDouble(sharedPreferencesKey, newValue);
      return;
    }

    return;

  }

}