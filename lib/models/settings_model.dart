import 'dart:async';
import 'package:betabeta/models/match_engine.dart';
import 'package:betabeta/services/networking.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsData extends ChangeNotifier{
  //Some consts to facilitate share preferences access
  static const String PREFERRED_GENDER_KEY='preferredGender';
  static const String NAME_KEY = 'name';
  static const String FACEBOOK_ID_KEY = 'facebook_id';
  static const String FACEBOOK_PROFILE_IMAGE_URL_KEY = 'facebook_profile_image_url';
  static const String MIN_AGE_KEY = 'min_age';
  static const String MAX_AGE_KEY = 'max_age';
  static const String AUDITION_COUNT_KEY = 'audition_count';
  static const String FILTER_NAME_KEY = 'filter_name';
  static const String FILTER_DISPLAY_IMAGE_URL_KEY = 'filter_display_image';
  static const String CELEB_ID_KEY = 'celeb_id';
  static const String TASTE_MIX_RATIO_KEY = 'taste_mix_ratio';
  static const String RADIUS_KEY = 'radius';
  static const _debounceSettingsTime = Duration(seconds: 2); //Debounce time such that we notify listeners
  String _name;
  String _facebookId;
  String _facebookProfileImageUrl;
  String _preferredGender;
  int _minAge;
  int _maxAge;
  bool _readFromShared;
  Timer _debounce;
  int _auditionCount;
  String _filterName;
  String _filterDisplayImageUrl;
  String _celebId;
  double _tasteMixRatio;
  double _radius;

  SettingsData._privateConstructor(){
    //Fill in some "default" values which should be filled in within milliseconds of opening the App
    _readFromShared = false;
    _name = '';
    _facebookId = '';
    _facebookProfileImageUrl = 'https://lunada.co.il/wp-content/uploads/2016/04/12198090531909861341man-silhouette.svg_.hi_-300x284.png';
    _preferredGender = 'Everyone';
    _minAge = 18;
    _maxAge = 75;
    _auditionCount = 4;
    _filterName = '';
    _filterDisplayImageUrl = '';
    _celebId = 'No celeb was selected';
    _tasteMixRatio = 0.5;
    _radius = 20;

    //And after that, read settings from shared
    readSettingsFromShared();

  }

  Future<void> readSettingsFromShared() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    _preferredGender = sharedPreferences.getString(PREFERRED_GENDER_KEY)??_preferredGender;
    _name = sharedPreferences.getString(NAME_KEY) ?? _name;
    _facebookId = sharedPreferences.getString(FACEBOOK_ID_KEY) ?? _facebookId;
    _facebookProfileImageUrl = sharedPreferences.getString(FACEBOOK_PROFILE_IMAGE_URL_KEY) ?? _facebookProfileImageUrl;
    _minAge = sharedPreferences.getInt(MIN_AGE_KEY) ?? _minAge;
    _maxAge = sharedPreferences.getInt(MAX_AGE_KEY) ?? _maxAge;
    _auditionCount = sharedPreferences.getInt(AUDITION_COUNT_KEY)?? _auditionCount;
    _filterName = sharedPreferences.getString(FILTER_NAME_KEY) ?? _filterName;
    _filterDisplayImageUrl = sharedPreferences.getString(FILTER_DISPLAY_IMAGE_URL_KEY) ?? _filterDisplayImageUrl;
    _celebId = sharedPreferences.getString(CELEB_ID_KEY) ?? _celebId;
    _tasteMixRatio = sharedPreferences.getDouble(TASTE_MIX_RATIO_KEY) ?? _tasteMixRatio;
    _readFromShared = true;
    return;
  }



  static final SettingsData _instance = SettingsData._privateConstructor();

  factory SettingsData() {
    return _instance;
  }

  bool get readFromShared{
    return _readFromShared;
  }




  String get preferredGender{
    return _preferredGender;
  }

  set preferredGender(String newPreferredGender){
    _preferredGender = newPreferredGender;
    savePreferences(PREFERRED_GENDER_KEY, newPreferredGender);
  }

  String get name{
    return _name;
  }

  set name(String newName){
    _name = newName;
    savePreferences(NAME_KEY, newName);
  }


  String get facebookId{
    return _facebookId;
  }

  set facebookId(String newFacebookId){
    _facebookId = newFacebookId;
    savePreferences(FACEBOOK_ID_KEY, newFacebookId);
  }



  String get facebookProfileImageUrl{
    return _facebookProfileImageUrl;
  }

  set facebookProfileImageUrl(String newUrl){
    _facebookProfileImageUrl = newUrl;
    savePreferences(FACEBOOK_PROFILE_IMAGE_URL_KEY, newUrl);
  }


  int get minAge{
    return _minAge;
  }

   set minAge(int newMinAge){
    _minAge = newMinAge;
    savePreferences(MIN_AGE_KEY,newMinAge);
  }

  int get maxAge{
    return _maxAge;
  }

  set maxAge(int newMaxAge){
    _maxAge = newMaxAge;
    savePreferences(MAX_AGE_KEY, newMaxAge);
  }

  int get auditionCount{
    return _auditionCount;
  }

  set auditionCount(int newAuditionCount){
    _auditionCount = newAuditionCount;
    savePreferences(AUDITION_COUNT_KEY, newAuditionCount);
  }

  String get filterName{
    return _filterName;
  }

  set filterName(String newFilterName){
    _filterName = newFilterName;
    savePreferences(FILTER_NAME_KEY, newFilterName);
  }

  String get filterDisplayImageUrl{
    return _filterDisplayImageUrl;
  }

  set filterDisplayImageUrl(String newFilterDisplayImageUrl){
    _filterDisplayImageUrl = newFilterDisplayImageUrl;
    savePreferences(FILTER_DISPLAY_IMAGE_URL_KEY, newFilterDisplayImageUrl);
  }

  String get celebId{
    return _celebId;
  }

  set celebId(String newCelebId){
    _celebId = newCelebId;
    savePreferences(CELEB_ID_KEY, newCelebId);
  }

  double get tasteMixRatio{
    return _tasteMixRatio;
  }

  set tasteMixRatio(double newTasteMixRatio){
    _tasteMixRatio = newTasteMixRatio;
    savePreferences(TASTE_MIX_RATIO_KEY, newTasteMixRatio);
  }

  double get radius{
    return _radius;
  }

  set radius(double newRadius){
    _radius = newRadius;
    savePreferences(RADIUS_KEY, newRadius);
  }



  void savePreferences(String sharedPreferencesKey, dynamic newValue) async {
    if (_debounce?.isActive ?? false) _debounce.cancel();
    _debounce = Timer(_debounceSettingsTime, () async{
      if(_facebookId !=null && _facebookId.length>0){
      await NetworkHelper().postUserSettings();}
      MatchEngine().clear();
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