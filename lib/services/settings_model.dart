import 'dart:async';
import 'package:betabeta/models/match_engine.dart';
import 'package:betabeta/models/userid.dart';
import 'package:betabeta/services/networking.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsData extends ChangeNotifier{
  //Some consts to facilitate share preferences access
  static const String PREFERRED_GENDER_KEY='gender_preferred';
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
  static const String LAST_SYNC_KEY = 'last_sync';
  static const String FCM_TOKEN_KEY = 'fcm_token';
  static const String REGISTERED_KEY = 'is_registered';
  static const String FIREBASE_UID_KEY = 'firebase_uid';
  static const String FACEBOOK_BIRTHDAY_KEY = 'facebook_birthday';
  static const String EMAIL_KEY = 'email';
  static const String USER_DESCRIPTION_KEY = 'user_description';
  static const String USER_GENDER_KEY = 'user_gender';
  static const String SHOW_USER_GENDER_KEY = 'show_user_gender';
  static const String USER_BIRTHDAY_KEY = 'user_birthday';
  static const String USER_RELATIONSHIP_TYPE_KEY = 'relationship_type';
  static const String LONGITUDE_KEY = 'longitude';
  static const String LATITUDE_KEY = 'latitude';
  static const String PROFILE_IMAGES_KEY = 'profile_images_urls';
  static const String LOCATION_DESCRIPTION_KEY = 'location_description';
  static const _debounceSettingsTime = Duration(seconds: 2); //Debounce time such that we notify listeners
  String _uid = '';
  String _name = '';
  String _facebookId = '';
  String _facebookProfileImageUrl = 'https://lunada.co.il/wp-content/uploads/2016/04/12198090531909861341man-silhouette.svg_.hi_-300x284.png';
  String _preferredGender = 'Everyone';
  int _minAge = 24;
  int _maxAge = 34;
  bool _readFromShared = false;
  Timer? _debounce;
  int _auditionCount = 4;
  String _filterName = '';
  String _filterDisplayImageUrl = '';
  String _celebId = 'No celeb was selected';
  double _tasteMixRatio = 0.5;
  double _radius = 20;
  double _lastSync = 0;
  String _fcmToken = '';
  String _facebookBirthday='';
  String _email = '';
  String _userDescription='';
  String _userGender = '';
  bool _showUserGender = true;
  String _userBirthday='';
  String _relationshipType='';
  double _longitude = 0.0;
  double _latitude = 0.0;
  String _locationDescription = '';
  bool _registered = false;
  List<String> _profileImagesUrls = [];

  SettingsData._privateConstructor(){

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
    _lastSync =sharedPreferences.getDouble(LAST_SYNC_KEY) ?? _lastSync;
    _fcmToken = sharedPreferences.getString(FCM_TOKEN_KEY) ?? _fcmToken;
    _facebookBirthday = sharedPreferences.getString(FACEBOOK_BIRTHDAY_KEY)?? _facebookBirthday;
    _uid = sharedPreferences.getString(FIREBASE_UID_KEY)??_uid;
    _email = sharedPreferences.getString(EMAIL_KEY)??_email;
    _userGender = sharedPreferences.getString(USER_GENDER_KEY)??_userGender;
    _userDescription = sharedPreferences.getString(USER_DESCRIPTION_KEY)??_userDescription;
    _showUserGender = sharedPreferences.getBool(SHOW_USER_GENDER_KEY)??_showUserGender;
    _userBirthday = sharedPreferences.getString(USER_BIRTHDAY_KEY)??_userBirthday;
    _relationshipType = sharedPreferences.getString(USER_RELATIONSHIP_TYPE_KEY)??_relationshipType;
    _latitude = sharedPreferences.getDouble(LATITUDE_KEY)??_latitude;
    _longitude = sharedPreferences.getDouble(LONGITUDE_KEY)??_longitude;
    _profileImagesUrls = sharedPreferences.getStringList(PROFILE_IMAGES_KEY)??_profileImagesUrls;
    _locationDescription = sharedPreferences.getString(LOCATION_DESCRIPTION_KEY)??_locationDescription;
    _registered = sharedPreferences.getBool(REGISTERED_KEY) ?? _registered;
    _readFromShared = true;

    return;
  }



  static final SettingsData _instance = SettingsData._privateConstructor();
  static SettingsData get instance => _instance;
  bool? get readFromShared{
    return _readFromShared;
  }




  String get preferredGender{
    return _preferredGender;
  }

  set preferredGender(String newPreferredGender){
    if(_preferredGender==newPreferredGender){return;}
    _preferredGender = newPreferredGender;
    savePreferences(PREFERRED_GENDER_KEY, newPreferredGender);
  }

  String get name{
    return _name;
  }

  set name(String newName){
    if(_name==newName){return;}
    _name = newName;
    savePreferences(NAME_KEY, newName);
  }


  String get facebookId{
    return _facebookId;
  }

  set facebookId(String newFacebookId){
    if(_facebookId == newFacebookId){return;}
    _facebookId = newFacebookId;
    savePreferences(FACEBOOK_ID_KEY, newFacebookId);
  }



  String get facebookProfileImageUrl{
    return _facebookProfileImageUrl;
  }

  set facebookProfileImageUrl(String newUrl){
    if(newUrl==_facebookProfileImageUrl) {return;}
    _facebookProfileImageUrl = newUrl;
    savePreferences(FACEBOOK_PROFILE_IMAGE_URL_KEY, newUrl);
  }


  int get minAge{
    return _minAge;
  }

   set minAge(int newMinAge){
    if(_minAge==newMinAge){return;}
    _minAge = newMinAge;
    savePreferences(MIN_AGE_KEY,newMinAge);
  }

  int get maxAge{
    return _maxAge;
  }

  set maxAge(int newMaxAge){
    if(_maxAge==newMaxAge){return;}
    _maxAge = newMaxAge;
    savePreferences(MAX_AGE_KEY, newMaxAge);
  }

  int get auditionCount{
    return _auditionCount;
  }

  set auditionCount(int newAuditionCount){
    if(auditionCount==_auditionCount){return;}
    _auditionCount = newAuditionCount;
    savePreferences(AUDITION_COUNT_KEY, newAuditionCount);
  }

  String get filterName{
    return _filterName;
  }

  set filterName(String newFilterName){
    if(newFilterName==_filterName) {return;}
    _filterName = newFilterName;
    savePreferences(FILTER_NAME_KEY, newFilterName);
  }

  String get filterDisplayImageUrl{
    return _filterDisplayImageUrl;
  }

  set filterDisplayImageUrl(String newFilterDisplayImageUrl){
    if(newFilterDisplayImageUrl==_filterDisplayImageUrl){return;}
    _filterDisplayImageUrl = newFilterDisplayImageUrl;
    savePreferences(FILTER_DISPLAY_IMAGE_URL_KEY, newFilterDisplayImageUrl);
  }

  String get celebId{
    return _celebId;
  }

  set celebId(String newCelebId){
    if(newCelebId==_celebId) {return;}
    _celebId = newCelebId;
    savePreferences(CELEB_ID_KEY, newCelebId);
  }

  double get tasteMixRatio{
    return _tasteMixRatio;
  }

  set tasteMixRatio(double newTasteMixRatio){
    if(newTasteMixRatio==_tasteMixRatio) {return;}
    _tasteMixRatio = newTasteMixRatio;
    savePreferences(TASTE_MIX_RATIO_KEY, newTasteMixRatio);
  }

  double get radius{
    return _radius;
  }

  set radius(double newRadius){
    if(newRadius==_radius){return;}
    _radius = newRadius;
    savePreferences(RADIUS_KEY, newRadius);
  }

  double get lastSync{
    return _lastSync;
  }

  set lastSync(double newLastSync){
    if(newLastSync==_lastSync) {return;}
    _lastSync = newLastSync;
    savePreferences(LAST_SYNC_KEY, newLastSync,sendServer: false);
  }
  
  UserId get id{
    return UserId(id: _facebookId, userType: UserType.REAL_USER);
  }

  String get fcmToken{
    return _fcmToken;
  }

  set fcmToken(String newToken){
    if(newToken==_fcmToken){return;}
    _fcmToken = newToken;
    savePreferences(FCM_TOKEN_KEY, newToken);
  }

  bool get registered{
    return _registered;
  }

  set registered(bool newRegistered){
    if(newRegistered==_registered) {return;}
    _registered = newRegistered;
    savePreferences(REGISTERED_KEY, newRegistered,sendServer: false);
  }

  String get uid{
    return _uid;
  }

  set uid(String newUid){
    if(newUid==_uid){return;}
    _uid = newUid;
    savePreferences(FIREBASE_UID_KEY, _uid);
  }

  String get facebookBirthday{
    return _facebookBirthday;
  }

  set facebookBirthday(String newFacebookBirthday){
    if(newFacebookBirthday==_facebookBirthday){return;}
    _facebookBirthday = newFacebookBirthday;
    savePreferences(FACEBOOK_BIRTHDAY_KEY, newFacebookBirthday);
  }

  String get email{
    return _email;
  }

  set email(String newEmail){
    if(_email==newEmail){return;}
    _email = newEmail;
    savePreferences(EMAIL_KEY, newEmail);
  }

  String get userGender{
    return _userGender;
  }

  set userGender(String newUserGender){
    if(newUserGender==_userGender){return;}
    _userGender = newUserGender;
    savePreferences(USER_GENDER_KEY, newUserGender);
  }

  String get userDescription{
    return _userDescription;
  }

  set userDescription(String newUserDescription){
    if(newUserDescription == _userDescription){
      return;
    }
    _userDescription = newUserDescription;
    savePreferences(USER_DESCRIPTION_KEY, newUserDescription);
  }

  bool get showUserGender{
    return _showUserGender;
  }

  set showUserGender(bool newShowUserGender){
    if(newShowUserGender==_showUserGender){return;}
    _showUserGender = newShowUserGender;
    savePreferences(SHOW_USER_GENDER_KEY, newShowUserGender);
  }

  String get userBirthday{
    return _userBirthday;
  }

  set userBirthday(String newUserBirthday){
    if(_userBirthday==newUserBirthday){return;}
    _userBirthday = newUserBirthday;
    savePreferences(USER_BIRTHDAY_KEY, newUserBirthday);
  }

  String get relationshipType{
    return _relationshipType;
  }

  set relationshipType(String newRelationshipType){
    if(_relationshipType==newRelationshipType){return;}
    _relationshipType = newRelationshipType;
    savePreferences(USER_RELATIONSHIP_TYPE_KEY, newRelationshipType);
  }
  double get longitude{
    return _longitude;
  }

  set longitude(double newLongitude){
    if(_longitude==newLongitude){return;}
    _longitude = newLongitude;
    savePreferences(LONGITUDE_KEY, newLongitude);
  }
  double get latitude{
    return _latitude;
  }

  set latitude(double newLatitude){
    if(_latitude==newLatitude){return;}
    _latitude = newLatitude;
    savePreferences(LATITUDE_KEY, newLatitude);
  }

  List<String> get profileImagesUrls{
    return _profileImagesUrls;
  }

  set profileImagesUrls(List<String> newUrlsList){
     _profileImagesUrls = newUrlsList;
     savePreferences(PROFILE_IMAGES_KEY, newUrlsList,sendServer: false);

  }

  String get locationDescription{
    return _locationDescription;
  }

  set locationDescription(String newLocationDescription){
    _locationDescription = newLocationDescription;
    savePreferences(LOCATION_DESCRIPTION_KEY, newLocationDescription,sendServer: false);
  }


  void savePreferences(String sharedPreferencesKey, dynamic newValue,{bool sendServer = true}) async {
    if(sendServer){
      if (_debounce?.isActive ?? false) {_debounce!.cancel();}
      _debounce = Timer(_debounceSettingsTime, () async{
        if(_uid.length>0){
        await NetworkHelper().postUserSettings();}
        MatchEngine().clear();
      });
    }
    print('notifying listeners');
    notifyListeners();
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

    if(newValue is List<String>){
      sharedPreferences.setStringList(sharedPreferencesKey, newValue);
      return;
    }

    return;

  }

}