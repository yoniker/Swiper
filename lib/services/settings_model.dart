import 'dart:async';
import 'dart:convert';
import 'package:betabeta/constants/enums.dart';
import 'package:betabeta/models/match_engine.dart';
import 'package:betabeta/services/new_networking.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsData extends ChangeNotifier {
  //Some consts to facilitate share preferences access
  static const String PREFERRED_GENDER_KEY = 'gender_preferred';
  static const String NAME_KEY = 'name';
  static const String FACEBOOK_ID_KEY = 'facebook_id';
  static const String FACEBOOK_PROFILE_IMAGE_URL_KEY =
      'facebook_profile_image_url';
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
  static const String SEARCH_DISTANCE_ENABLED_KEY = 'search_distance_enabled';
  static const String GET_DUMMY_PROFILES_KEY = 'show_dummy_profiles';
  static const String JOB_TITLE_KEY = 'job_title';
  static const String SCHOOL_KEY = 'school';
  static const String RELIGION_KEY = 'religion';
  static const String ZODIAC_KEY = 'zodiac';
  static const String FITNESS_KEY = 'fitness';
  static const String SMOKING_KEY = 'smoking';
  static const String DRINKING_KEY = 'drinking';
  static const String EDUCATION_KEY = 'education';
  static const String CHILDREN_KEY = 'children';
  static const String COVID_VACCINE_KEY = 'covid_vaccine';
  static const String HOBBIES_KEY = 'hobbies';
  static const String PETS_KEY = 'pets';
  static const String HEIGHT_IN_CM_KEY = 'height_in_cm';
  static const String TEXT_SEARCH_KEY = 'text_search';
  static const String REGISTRATION_STATUS_KEY = 'registration_status';

  static const _debounceSettingsTime =
      Duration(seconds: 2); //Debounce time such that we notify listeners

  static bool shouldResetMatchEngineAfterPosting = false; //This exists because of a situation where one send to server but dont reset engine overrode the send to server and reset (and matches were not reset)

  static bool isNotEmptyString(dynamic s){
    if(s==null){return false;}
    if(!(s is String)){return false;}
    return s.length >0;
  }

  static bool castStringToBool(dynamic s,{bool onNoCast=false}){
    if (!isNotEmptyString(s)){return onNoCast;}
    return s.toLowerCase()=='true';
  }
  
  static List<String> castToListString(dynamic s,{List<String> onNoCast= const []}){
    if(s==null){return onNoCast;}
    if(!(s is String)) {return onNoCast;}
    try{
      List<String> castedList = List<String>.from(jsonDecode(s));
      return castedList;


    }

    catch(e){
      return onNoCast;
    }

  }

  static int castToInt(dynamic s , {required int onNoCast}){
    if(s==null){return onNoCast;}
    if(s is int){return s;}
    if(s is double){return s.round();}
    return onNoCast;
  }

  String _uid = '';
  String _name = '';
  String _facebookId = '';
  String _facebookProfileImageUrl =
      'https://lunada.co.il/wp-content/uploads/2016/04/12198090531909861341man-silhouette.svg_.hi_-300x284.png';
  String _preferredGender = 'Everyone';
  int _minAge = 24;
  int _maxAge = 34;
  bool _readFromShared = false;
  Timer? _debounceServer;
  int _auditionCount = 4;
  String _filterName = '';
  String _filterDisplayImageUrl = '';
  String _celebId = 'No celeb was selected';
  double _tasteMixRatio = 0.5;
  double _radius = 20.0;
  double _lastSync = 0;
  String _fcmToken = '';
  String _facebookBirthday = '';
  String _email = '';
  String _userDescription = '';
  String _userGender = '';
  bool _showUserGender = true;
  String _userBirthday = '';
  String _relationshipType = '';
  double _longitude = 0.0;
  double _latitude = 0.0;
  String _locationDescription = '';
  bool _searchDistanceEnabled = false;
  bool _showDummyProfiles = false;
  List<String> _profileImagesUrls = [];

  String _school = '';
  String _religion = '';
  String _zodiac = '';
  String _fitness = '';
  String _smoking = '';
  String _drinking = '';
  String _education = '';
  String _children = '';
  String _jobTitle = '';
  String _covid_vaccine = '';
  String _textSearch = '';
  List<String> _hobbies = [];
  List<String> _pets = [];
  int _heightInCm = 0;
  String _registrationStatus = '';

  SettingsData._privateConstructor() {
    //And after that, read settings from shared
    readSettingsFromShared();
  }


  Future<void> readSettingsFromShared() async {
    if(_readFromShared == true) {return;}
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    _preferredGender =
        sharedPreferences.getString(PREFERRED_GENDER_KEY) ?? _preferredGender;
    _name = sharedPreferences.getString(NAME_KEY) ?? _name;
    _facebookId = sharedPreferences.getString(FACEBOOK_ID_KEY) ?? _facebookId;
    _facebookProfileImageUrl =
        sharedPreferences.getString(FACEBOOK_PROFILE_IMAGE_URL_KEY) ??
            _facebookProfileImageUrl;
    _minAge = sharedPreferences.getInt(MIN_AGE_KEY) ?? _minAge;
    _maxAge = sharedPreferences.getInt(MAX_AGE_KEY) ?? _maxAge;
    _auditionCount =
        sharedPreferences.getInt(AUDITION_COUNT_KEY) ?? _auditionCount;
    _filterName = sharedPreferences.getString(FILTER_NAME_KEY) ?? _filterName;
    _filterDisplayImageUrl =
        sharedPreferences.getString(FILTER_DISPLAY_IMAGE_URL_KEY) ?? _filterDisplayImageUrl;
    _celebId = sharedPreferences.getString(CELEB_ID_KEY) ?? _celebId;
    _tasteMixRatio =
        sharedPreferences.getDouble(TASTE_MIX_RATIO_KEY) ?? _tasteMixRatio;
    _lastSync = sharedPreferences.getDouble(LAST_SYNC_KEY) ?? _lastSync;
    _fcmToken = sharedPreferences.getString(FCM_TOKEN_KEY) ?? _fcmToken;
    _facebookBirthday =
        sharedPreferences.getString(FACEBOOK_BIRTHDAY_KEY) ?? _facebookBirthday;
    _uid = sharedPreferences.getString(FIREBASE_UID_KEY) ?? _uid;
    _email = sharedPreferences.getString(EMAIL_KEY) ?? _email;
    _userGender = sharedPreferences.getString(USER_GENDER_KEY) ?? _userGender;
    _userDescription =
        sharedPreferences.getString(USER_DESCRIPTION_KEY) ?? _userDescription;
    _showUserGender =
        sharedPreferences.getBool(SHOW_USER_GENDER_KEY) ?? _showUserGender;
    _userBirthday =
        sharedPreferences.getString(USER_BIRTHDAY_KEY) ?? _userBirthday;
    _relationshipType =
        sharedPreferences.getString(USER_RELATIONSHIP_TYPE_KEY) ??
            _relationshipType;
    _latitude = sharedPreferences.getDouble(LATITUDE_KEY) ?? _latitude;
    _longitude = sharedPreferences.getDouble(LONGITUDE_KEY) ?? _longitude;
    _profileImagesUrls = sharedPreferences.getStringList(PROFILE_IMAGES_KEY) ??
        _profileImagesUrls;
    _locationDescription =
        sharedPreferences.getString(LOCATION_DESCRIPTION_KEY) ??
            _locationDescription;
    _searchDistanceEnabled =
        sharedPreferences.getBool(SEARCH_DISTANCE_ENABLED_KEY) ??
            _searchDistanceEnabled;
    _radius = sharedPreferences.getDouble(RADIUS_KEY) ?? _radius;
    _showDummyProfiles =
        sharedPreferences.getBool(GET_DUMMY_PROFILES_KEY) ?? _showDummyProfiles;

    _school = sharedPreferences.getString(SCHOOL_KEY) ?? _school;
    _religion = sharedPreferences.getString(RELIGION_KEY) ?? _religion;
    _zodiac = sharedPreferences.getString(ZODIAC_KEY) ?? _zodiac;
    _fitness = sharedPreferences.getString(FITNESS_KEY) ?? _fitness;
    _smoking = sharedPreferences.getString(SMOKING_KEY) ?? _smoking;
    _drinking = sharedPreferences.getString(DRINKING_KEY) ?? _drinking;
    _education = sharedPreferences.getString(EDUCATION_KEY) ?? _education;
    _children = sharedPreferences.getString(CHILDREN_KEY) ?? _children;
    _covid_vaccine =
        sharedPreferences.getString(COVID_VACCINE_KEY) ?? _covid_vaccine;
    _hobbies = sharedPreferences.getStringList(HOBBIES_KEY) ?? _hobbies;
    _pets = sharedPreferences.getStringList(PETS_KEY) ?? _pets;
    _heightInCm = sharedPreferences.getInt(HEIGHT_IN_CM_KEY) ?? _heightInCm;
    _jobTitle = sharedPreferences.getString(JOB_TITLE_KEY) ?? _jobTitle;
    _textSearch = sharedPreferences.getString(TEXT_SEARCH_KEY)??_textSearch;
    _registrationStatus = sharedPreferences.getString(REGISTRATION_STATUS_KEY)??_registrationStatus;
    _readFromShared = true;

    return;
  }

  static final SettingsData _instance = SettingsData._privateConstructor();
  static SettingsData get instance => _instance;
  bool? get readFromShared {
    return _readFromShared;
  }




  void updateFromServerData(Map<dynamic,dynamic> userData){
      _uid = userData[SettingsData.FIREBASE_UID_KEY] ?? _uid;
    _preferredGender = userData[PREFERRED_GENDER_KEY] ?? _preferredGender;
    _name = userData[NAME_KEY] ?? _name;
    _facebookId = userData[FACEBOOK_ID_KEY] ?? _facebookId;
    _facebookProfileImageUrl = userData[FACEBOOK_PROFILE_IMAGE_URL_KEY] ?? _facebookProfileImageUrl;
    _minAge = userData[MIN_AGE_KEY].round() ?? _minAge;
    _maxAge = userData[MAX_AGE_KEY].round() ?? _maxAge;
    _auditionCount = castToInt(userData[AUDITION_COUNT_KEY],onNoCast: auditionCount);
    _filterName = userData[FILTER_NAME_KEY] ?? _filterName;
    _filterDisplayImageUrl = userData[FILTER_DISPLAY_IMAGE_URL_KEY] ?? _filterDisplayImageUrl;
    _celebId = userData[CELEB_ID_KEY] ?? _celebId;
    _tasteMixRatio = userData[TASTE_MIX_RATIO_KEY] ?? _tasteMixRatio;
    _lastSync = 0;
    _fcmToken = userData[FCM_TOKEN_KEY] ?? _fcmToken;
    _facebookBirthday = userData[FACEBOOK_BIRTHDAY_KEY] ?? _facebookBirthday;
    _email = userData[EMAIL_KEY] ?? _email;
    _userGender = userData[USER_GENDER_KEY] ?? _userGender;
    _userDescription = userData[USER_DESCRIPTION_KEY] ?? _userDescription;
    _showUserGender = castStringToBool(userData[SHOW_USER_GENDER_KEY],onNoCast: _showUserGender);
    _userBirthday = userData[USER_BIRTHDAY_KEY] ?? _userBirthday;
    _relationshipType = userData[USER_RELATIONSHIP_TYPE_KEY] ?? _relationshipType;
    _profileImagesUrls = userData[PROFILE_IMAGES_KEY] ?? _profileImagesUrls;
    _locationDescription = userData[LOCATION_DESCRIPTION_KEY] ?? _locationDescription;
    _searchDistanceEnabled = castStringToBool(userData[SEARCH_DISTANCE_ENABLED_KEY],onNoCast: _searchDistanceEnabled);
    _radius = userData[RADIUS_KEY] ?? _radius;
    _showDummyProfiles = castStringToBool(userData[GET_DUMMY_PROFILES_KEY],onNoCast: _showDummyProfiles);
    _school = userData[SCHOOL_KEY] ?? _school;
    _religion = userData[RELIGION_KEY] ?? _religion;
    _zodiac = userData[ZODIAC_KEY] ?? _zodiac;
    _fitness = userData[FITNESS_KEY] ?? _fitness;
    _smoking = userData[SMOKING_KEY] ?? _smoking;
    _drinking = userData[DRINKING_KEY] ?? _drinking;
    _education = userData[EDUCATION_KEY] ?? _education;
    _children = userData[CHILDREN_KEY] ?? _children;
    _covid_vaccine = userData[COVID_VACCINE_KEY] ?? _covid_vaccine;
    _hobbies = castToListString(userData[HOBBIES_KEY],onNoCast: _hobbies);
    _pets = castToListString(userData[PETS_KEY],onNoCast: _pets);
    _heightInCm = castToInt(userData[HEIGHT_IN_CM_KEY], onNoCast: _heightInCm);
    _jobTitle = userData[JOB_TITLE_KEY] ?? _jobTitle;
    _textSearch = userData[TEXT_SEARCH_KEY]??_textSearch;
    _registrationStatus = userData[REGISTRATION_STATUS_KEY]??_registrationStatus;

      savePreferences(FIREBASE_UID_KEY, _uid,sendServer: false,resetMatchEngine: false);
      savePreferences(PREFERRED_GENDER_KEY, _preferredGender,sendServer: false,resetMatchEngine: false);
      savePreferences(NAME_KEY, _name,sendServer: false,resetMatchEngine: false);
      savePreferences(FACEBOOK_PROFILE_IMAGE_URL_KEY, _facebookProfileImageUrl,sendServer: false,resetMatchEngine: false);
      savePreferences(MIN_AGE_KEY, _minAge,sendServer: false,resetMatchEngine: false);
      savePreferences(MAX_AGE_KEY, _maxAge,sendServer: false,resetMatchEngine: false);
      savePreferences(AUDITION_COUNT_KEY, _auditionCount,sendServer: false,resetMatchEngine: false);
      savePreferences(FILTER_NAME_KEY, _filterName,sendServer: false,resetMatchEngine: false);
      savePreferences(FILTER_DISPLAY_IMAGE_URL_KEY, _filterDisplayImageUrl,sendServer: false,resetMatchEngine: false);
      savePreferences(CELEB_ID_KEY, _celebId,sendServer: false,resetMatchEngine: false);
      savePreferences(TASTE_MIX_RATIO_KEY, _tasteMixRatio,sendServer: false,resetMatchEngine: false);
      savePreferences(FCM_TOKEN_KEY, _fcmToken,sendServer: false,resetMatchEngine: false);
      savePreferences(FACEBOOK_BIRTHDAY_KEY, _facebookBirthday,sendServer: false,resetMatchEngine: false);
      savePreferences(EMAIL_KEY, _email,sendServer: false,resetMatchEngine: false);
      savePreferences(USER_GENDER_KEY, _userGender,sendServer: false,resetMatchEngine: false);
      savePreferences(USER_DESCRIPTION_KEY, _userDescription,sendServer: false,resetMatchEngine: false);
      savePreferences(SHOW_USER_GENDER_KEY, _showUserGender,sendServer: false,resetMatchEngine: false);
      savePreferences(USER_BIRTHDAY_KEY, _userBirthday,sendServer: false,resetMatchEngine: false);
      savePreferences(USER_RELATIONSHIP_TYPE_KEY, _relationshipType,sendServer: false,resetMatchEngine: false);
      savePreferences(PROFILE_IMAGES_KEY, _profileImagesUrls,sendServer: false,resetMatchEngine: false);
      savePreferences(LOCATION_DESCRIPTION_KEY, _locationDescription,sendServer: false,resetMatchEngine: false);
      savePreferences(SEARCH_DISTANCE_ENABLED_KEY, _searchDistanceEnabled,sendServer: false,resetMatchEngine: false);
      savePreferences(RADIUS_KEY, _radius,sendServer: false,resetMatchEngine: false);
      savePreferences(GET_DUMMY_PROFILES_KEY, _showDummyProfiles,sendServer: false,resetMatchEngine: false);
      savePreferences(SCHOOL_KEY, _school,sendServer: false,resetMatchEngine: false);
      savePreferences(RELIGION_KEY, _religion,sendServer: false,resetMatchEngine: false);
      savePreferences(ZODIAC_KEY, _zodiac,sendServer: false,resetMatchEngine: false);
      savePreferences(FITNESS_KEY, _fitness,sendServer: false,resetMatchEngine: false);
      savePreferences(SMOKING_KEY, _smoking,sendServer: false,resetMatchEngine: false);
      savePreferences(DRINKING_KEY, _drinking,sendServer: false,resetMatchEngine: false);
      savePreferences(EDUCATION_KEY, _education,sendServer: false,resetMatchEngine: false);
      savePreferences(CHILDREN_KEY, _children,sendServer: false,resetMatchEngine: false);
      savePreferences(COVID_VACCINE_KEY, _covid_vaccine,sendServer: false,resetMatchEngine: false);
      savePreferences(HOBBIES_KEY, _hobbies,sendServer: false,resetMatchEngine: false);
      savePreferences(PETS_KEY, _pets,sendServer: false,resetMatchEngine: false);
      savePreferences(HEIGHT_IN_CM_KEY, _heightInCm,sendServer: false,resetMatchEngine: false);
      savePreferences(JOB_TITLE_KEY, _jobTitle,sendServer: false,resetMatchEngine: false);
      savePreferences(TEXT_SEARCH_KEY, _textSearch,sendServer: false,resetMatchEngine: false);
      savePreferences(REGISTRATION_STATUS_KEY, _registrationStatus,sendServer: false,resetMatchEngine: false);
  }






  String get preferredGender {
    return _preferredGender;
  }

  set preferredGender(String newPreferredGender) {
    if (_preferredGender == newPreferredGender) {
      return;
    }
    _preferredGender = newPreferredGender;
    savePreferences(PREFERRED_GENDER_KEY, newPreferredGender);
  }

  String get name {
    return _name;
  }

  set name(String newName) {
    if (_name == newName) {
      return;
    }
    _name = newName;
    savePreferences(NAME_KEY, newName, resetMatchEngine: false);
  }

  String get facebookId {
    return _facebookId;
  }

  set facebookId(String newFacebookId) {
    if (_facebookId == newFacebookId) {
      return;
    }
    _facebookId = newFacebookId;
    savePreferences(FACEBOOK_ID_KEY, newFacebookId, resetMatchEngine: false);
  }

  String get facebookProfileImageUrl {
    return _facebookProfileImageUrl;
  }

  set facebookProfileImageUrl(String newUrl) {
    if (newUrl == _facebookProfileImageUrl) {
      return;
    }
    _facebookProfileImageUrl = newUrl;
    savePreferences(FACEBOOK_PROFILE_IMAGE_URL_KEY, newUrl,
        resetMatchEngine: false);
  }

  int get minAge {
    return _minAge;
  }

  set minAge(int newMinAge) {
    if (_minAge == newMinAge) {
      return;
    }
    _minAge = newMinAge;
    savePreferences(MIN_AGE_KEY, newMinAge);
  }

  int get maxAge {
    return _maxAge;
  }

  set maxAge(int newMaxAge) {
    if (_maxAge == newMaxAge) {
      return;
    }
    _maxAge = newMaxAge;
    savePreferences(MAX_AGE_KEY, newMaxAge);
  }

  int get auditionCount {
    return _auditionCount;
  }

  set auditionCount(int newAuditionCount) {
    if (auditionCount == _auditionCount) {
      return;
    }
    _auditionCount = newAuditionCount;
    savePreferences(AUDITION_COUNT_KEY, newAuditionCount);
  }

  String get filterName{ //TODO remove public support?
    return _filterName;
  }

   set filterName(String newFilterName){ //TODO remove public support
    if(newFilterName==_filterName) {return;}
    _filterName = newFilterName;
    savePreferences(FILTER_NAME_KEY, newFilterName);
  }

  FilterType get filterType{
    return FilterType.values.firstWhere((filter) => filter.name==_filterName,orElse:()=>FilterType.NONE);
  }

  set filterType(FilterType filterType){
    this.filterName = filterType.name;
  }

  String get filterDisplayImageUrl{
    return _filterDisplayImageUrl;
  }

  set filterDisplayImageUrl(String newFilterDisplayImageUrl) {
    if (newFilterDisplayImageUrl == _filterDisplayImageUrl) {
      return;
    }
    _filterDisplayImageUrl = newFilterDisplayImageUrl;
    savePreferences(FILTER_DISPLAY_IMAGE_URL_KEY, newFilterDisplayImageUrl);
  }

  String get celebId {
    return _celebId;
  }

  set celebId(String newCelebId) {
    if (newCelebId == _celebId) {
      return;
    }
    _celebId = newCelebId;
    savePreferences(CELEB_ID_KEY, newCelebId);
  }

  double get tasteMixRatio {
    return _tasteMixRatio;
  }

  set tasteMixRatio(double newTasteMixRatio) {
    if (newTasteMixRatio == _tasteMixRatio) {
      return;
    }
    _tasteMixRatio = newTasteMixRatio;
    savePreferences(TASTE_MIX_RATIO_KEY, newTasteMixRatio);
  }

  double get radius {
    return _radius;
  }

  set radius(double newRadius) {
    if (newRadius == _radius) {
      return;
    }
    _radius = newRadius;
    savePreferences(RADIUS_KEY, newRadius);
  }

  bool get showDummyProfiles {
    return _showDummyProfiles;
  }

  set showDummyProfiles(bool newShowDummyProfiles) {
    _showDummyProfiles = newShowDummyProfiles;
    savePreferences(GET_DUMMY_PROFILES_KEY, newShowDummyProfiles);
  }

  double get lastSync {
    return _lastSync;
  }

  set lastSync(double newLastSync) {
    if (newLastSync == _lastSync) {
      return;
    }
    _lastSync = newLastSync;
    savePreferences(LAST_SYNC_KEY, newLastSync,
        sendServer: false, resetMatchEngine: false);
  }

  String get fcmToken {
    return _fcmToken;
  }

  set fcmToken(String newToken) {
    if (newToken == _fcmToken) {
      return;
    }
    _fcmToken = newToken;
    savePreferences(FCM_TOKEN_KEY, newToken, resetMatchEngine: false);
  }



  String get uid {
    return _uid;
  }

  set uid(String newUid) {
    if (newUid == _uid) {
      return;
    }
    _uid = newUid;
    savePreferences(FIREBASE_UID_KEY, _uid);
  }

  String get facebookBirthday {
    return _facebookBirthday;
  }

  set facebookBirthday(String newFacebookBirthday) {
    if (newFacebookBirthday == _facebookBirthday) {
      return;
    }
    _facebookBirthday = newFacebookBirthday;
    savePreferences(FACEBOOK_BIRTHDAY_KEY, newFacebookBirthday,
        resetMatchEngine: false);
  }

  String get email {
    return _email;
  }

  set email(String newEmail) {
    if (_email == newEmail) {
      return;
    }
    _email = newEmail;
    savePreferences(EMAIL_KEY, newEmail, resetMatchEngine: false);
  }

  String get userGender {
    return _userGender;
  }

  set userGender(String newUserGender) {
    if (newUserGender == _userGender) {
      return;
    }
    _userGender = newUserGender;
    savePreferences(USER_GENDER_KEY, newUserGender, resetMatchEngine: false);
  }

  String get userDescription {
    return _userDescription;
  }

  set userDescription(String newUserDescription) {
    if (newUserDescription == _userDescription) {
      return;
    }
    _userDescription = newUserDescription;
    savePreferences(USER_DESCRIPTION_KEY, newUserDescription,
        resetMatchEngine: false);
  }

  bool get showUserGender {
    return _showUserGender;
  }

  set showUserGender(bool newShowUserGender) {
    if (newShowUserGender == _showUserGender) {
      return;
    }
    _showUserGender = newShowUserGender;
    savePreferences(SHOW_USER_GENDER_KEY, newShowUserGender,
        resetMatchEngine: false);
  }

  String get userBirthday {
    return _userBirthday;
  }

  set userBirthday(String newUserBirthday) {
    if (_userBirthday == newUserBirthday) {
      return;
    }
    _userBirthday = newUserBirthday;
    savePreferences(USER_BIRTHDAY_KEY, newUserBirthday,
        resetMatchEngine: false);
  }

  String get relationshipType {
    return _relationshipType;
  }

  set relationshipType(String newRelationshipType) {
    if (_relationshipType == newRelationshipType) {
      return;
    }
    _relationshipType = newRelationshipType;
    savePreferences(USER_RELATIONSHIP_TYPE_KEY, newRelationshipType,
        resetMatchEngine: false);
  }

  double get longitude {
    return _longitude;
  }

  set longitude(double newLongitude) {
    if (_longitude == newLongitude) {
      return;
    }
    _longitude = newLongitude;
    savePreferences(LONGITUDE_KEY, newLongitude, resetMatchEngine: false);
  }

  double get latitude {
    return _latitude;
  }

  set latitude(double newLatitude) {
    if (_latitude == newLatitude) {
      return;
    }
    _latitude = newLatitude;
    savePreferences(LATITUDE_KEY, newLatitude, resetMatchEngine: false);
  }

  List<String> get profileImagesUrls {
    return _profileImagesUrls;
  }

  set profileImagesUrls(List<String> newUrlsList) {
    _profileImagesUrls = newUrlsList;
    savePreferences(PROFILE_IMAGES_KEY, newUrlsList,
        sendServer: false, resetMatchEngine: false);
  }

  String get locationDescription {
    return _locationDescription;
  }

  set locationDescription(String newLocationDescription) {
    _locationDescription = newLocationDescription;
    savePreferences(LOCATION_DESCRIPTION_KEY, newLocationDescription,
        sendServer: false, resetMatchEngine: false);
  }

  String get school {
    return _school;
  }

  set school(String newSchool) {
    if (_school == newSchool) {
      return;
    }
    _school = newSchool;
    savePreferences(SCHOOL_KEY, newSchool, resetMatchEngine: false);
  }

  String get religion {
    return _religion;
  }

  set religion(String newReligion) {
    if (_religion == newReligion) {
      return;
    }
    _religion = newReligion;
    savePreferences(RELIGION_KEY, newReligion, resetMatchEngine: false);
  }

  String get zodiac {
    return _zodiac;
  }

  set zodiac(String newZodiac) {
    if (_zodiac == newZodiac) {
      return;
    }
    _zodiac = newZodiac;
    savePreferences(ZODIAC_KEY, newZodiac, resetMatchEngine: false);
  }

  String get fitness {
    return _fitness;
  }

  set fitness(String newFitness) {
    if (_fitness == newFitness) {
      return;
    }
    _fitness = newFitness;
    savePreferences(FITNESS_KEY, newFitness, resetMatchEngine: false);
  }

  String get smoking {
    return _smoking;
  }

  set smoking(String newSmoking) {
    if (_smoking == newSmoking) {
      return;
    }
    _smoking = newSmoking;
    savePreferences(SMOKING_KEY, newSmoking, resetMatchEngine: false);
  }

  String get drinking {
    return _drinking;
  }

  set drinking(String newDrinking) {
    if (_drinking == newDrinking) {
      return;
    }
    _drinking = newDrinking;
    savePreferences(DRINKING_KEY, newDrinking, resetMatchEngine: false);
  }

  String get education {
    return _education;
  }

  set education(String newEducation) {
    if (_education == newEducation) {
      return;
    }
    _education = newEducation;
    savePreferences(EDUCATION_KEY, newEducation, resetMatchEngine: false);
  }

  String get children {
    return _children;
  }

  set children(String newChildren) {
    if (_children == newChildren) {
      return;
    }
    _children = newChildren;
    savePreferences(CHILDREN_KEY, newChildren, resetMatchEngine: false);
  }

  String get covid_vaccine {
    return _covid_vaccine;
  }

  set covid_vaccine(String newCovidVaccine) {
    if (_covid_vaccine == newCovidVaccine) {
      return;
    }
    _covid_vaccine = newCovidVaccine;
    savePreferences(COVID_VACCINE_KEY, newCovidVaccine,
        resetMatchEngine: false);
  }

  String get jobTitle {
    return _jobTitle;
  }

  set jobTitle(String newJobTitle) {
    if (_jobTitle == newJobTitle) {
      return;
    }
    _jobTitle = newJobTitle;
    savePreferences(JOB_TITLE_KEY, newJobTitle, resetMatchEngine: false);
  }

  List<String> get hobbies {
    return List.unmodifiable(_hobbies);
  }

  set hobbies(List<String> newHobbies) {
    print('setting hobbies to $newHobbies');
    _hobbies = newHobbies;
    savePreferences(HOBBIES_KEY, newHobbies, resetMatchEngine: false);
  }

  List<String> get pets {
    return List.unmodifiable(_pets);
  }

  set pets(List<String> newPets) {
    _pets = newPets;
    savePreferences(PETS_KEY, newPets, resetMatchEngine: false);
  }


  String get textSearch {
    return _textSearch;
  }

  set textSearch(String newTextSearch) {
    _textSearch = newTextSearch;
    savePreferences(TEXT_SEARCH_KEY, newTextSearch);
  }


  String get registrationStatus  {
    return _registrationStatus;
  }

  set registrationStatus(String newRegistrationStatus) {
    _registrationStatus = newRegistrationStatus;
    savePreferences(REGISTRATION_STATUS_KEY, newRegistrationStatus);
  }


  int get heightInCm {
    return _heightInCm;
  }

  set heightInCm(int newHeightInCm) {
    if (newHeightInCm == _heightInCm) {
      return;
    }
    _heightInCm = newHeightInCm;
    savePreferences(HEIGHT_IN_CM_KEY, newHeightInCm, resetMatchEngine: false);
  }

  bool get searchDistanceEnabled {
    return _searchDistanceEnabled;
  }

  set searchDistanceEnabled(bool newSearchDistanceEnabled) {
    _searchDistanceEnabled = newSearchDistanceEnabled;
    savePreferences(SEARCH_DISTANCE_ENABLED_KEY, newSearchDistanceEnabled);
  }

  void savePreferences(String sharedPreferencesKey, dynamic newValue,
      {bool sendServer = true, bool resetMatchEngine = true}) async {
      if(sendServer){
        shouldResetMatchEngineAfterPosting |= resetMatchEngine; //See the comment up in the def to understand why it's here
      if (_debounceServer?.isActive ?? false) {
        _debounceServer!.cancel();
      }
      _debounceServer = Timer(_debounceSettingsTime, () async {
        if (_uid.length > 0) {
          await NewNetworkService.instance.postUserSettings();
          if (shouldResetMatchEngineAfterPosting) {
            MatchEngine.instance.clear();
            shouldResetMatchEngineAfterPosting = false;
          }
        }
      });}
      else if (resetMatchEngine){
        MatchEngine.instance.clear();
      }

    notifyListeners();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (newValue is int) {
      sharedPreferences.setInt(sharedPreferencesKey, newValue);
      return;
    }

    if (newValue is String) {
      sharedPreferences.setString(sharedPreferencesKey, newValue);
      return;
    }

    if (newValue is bool) {
      sharedPreferences.setBool(sharedPreferencesKey, newValue);
      return;
    }

    if (newValue is double) {
      sharedPreferences.setDouble(sharedPreferencesKey, newValue);
      return;
    }

    if (newValue is List<String>) {
      sharedPreferences.setStringList(sharedPreferencesKey, newValue);
      return;
    }

    return;
  }
}
