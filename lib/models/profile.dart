import 'dart:convert';

import 'package:betabeta/constants/api_consts.dart';
import 'package:betabeta/services/new_networking.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
part 'profile.g.dart';

@HiveType(typeId : 0)
class Profile{
  @HiveField(0)
  final String username;
  @HiveField(1)
  final String uid;
  @HiveField(2)
  DateTime? matchChangedTime;
  @HiveField(3)
  List<String>? imageUrls;
  @HiveField(4)
  String? headline;
  @HiveField(5)
  String? description;
  @HiveField(6)
  int? age;
  @HiveField(7)
  String? location;
  @HiveField(8)
  double? distance;
  @HiveField(9)
  String? jobTitle;
  @HiveField(10)
  double? height;
  @HiveField(11)
  double? compatibilityScore;
  @HiveField(12)
  double? hotnessScore;
  @HiveField(13)
  String? religion;
  @HiveField(14)
  List<String> hobbies;
  @HiveField(15)
  List<String> pets;
  @HiveField(16)
  String covidVaccine;
  @HiveField(17)
  String children;
  @HiveField(18)
  String education;
  @HiveField(19)
  String drinking;
  @HiveField(20)
  String smoking;
  @HiveField(21)
  String fitness;
  @HiveField(22)
  String zodiac;
  @HiveField(23)
  String school;
  @HiveField(24)
  DateTime? lastUpdate;
  @HiveField(25)
  String preferredGender;
  @HiveField(26)
  String userGender;
  @HiveField(27)
  bool showUserGender;
  @HiveField(28)
  String relationshipType;




  Profile({required this.username,required this.uid,required this.matchChangedTime,this.imageUrls,this.headline,this.description,this.age,this.location,this.jobTitle,this.religion,this.height,this.compatibilityScore,this.hotnessScore,this.distance,
    required this.pets,required this.drinking,required this.hobbies,required this.covidVaccine,required this.children,required this.education,required this.smoking,required this.fitness,required this.zodiac,required this.school,
    this.lastUpdate,required this.preferredGender,required this.userGender,required this.showUserGender,required this.relationshipType

  });
  Profile.fromJson(Map json,{DateTime? lastUpdateTime}) :
        this.uid = json[API_CONSTS.USER_UID_KEY].toString(),
        this.hobbies=List<String>.from(jsonDecode( json[API_CONSTS.USER_HOBBIES]??jsonEncode([]))),
        this.pets = List<String>.from(jsonDecode( json[API_CONSTS.USER_PETS]??jsonEncode([]))),
        this.imageUrls = json[API_CONSTS.USER_IMAGES]!=null?List<String>.from(json[API_CONSTS.USER_IMAGES]):null,
        this.username = json[API_CONSTS.USER_NAME]??'',
        this.children = json[API_CONSTS.USER_CHILDREN]??'',
        this.education = json[API_CONSTS.USER_EDUCATION]??'',
        this.drinking = json[API_CONSTS.USER_DRINKING]??'',
        this.smoking = json[API_CONSTS.USER_SMOKING]??'',
        this.covidVaccine = json[API_CONSTS.USER_COVID_VACCINE]??'',
        this.fitness = json[API_CONSTS.USER_FITNESS]??'',
        this.zodiac = json[API_CONSTS.USER_ZODIAC]??'',
        this.religion = json[API_CONSTS.USER_RELIGION]??'',
        this.school = json[API_CONSTS.USER_SCHOOL]??'',
        this.description = json[API_CONSTS.USER_DESCRIPTION]??'',
        this.headline = json[API_CONSTS.USER_DESCRIPTION]??'',
        this.jobTitle = json[API_CONSTS.USER_JOB_TITLE]??'',
        this.hotnessScore = json[API_CONSTS.USER_HOTNESS],
        this.compatibilityScore = json[API_CONSTS.USER_COMPATABILITY],
        this.age = json[API_CONSTS.USER_AGE],
        this.distance = json[API_CONSTS.USER_LOCATION_DISTANCE],
        this.location = json[API_CONSTS.USER_LOCATION_DESCRIPTION]??'',
        this.height = json[API_CONSTS.USER_HEIGHT_IN_CM],
        this.userGender = json[API_CONSTS.USER_GENDER_KEY]??'',
        this.showUserGender = json[API_CONSTS.SHOW_USER_GENDER_KEY]!=null && json[API_CONSTS.SHOW_USER_GENDER_KEY]=='true',
        this.preferredGender = json[API_CONSTS.PREFERRED_GENDER_KEY]??'',
        this.relationshipType = json[API_CONSTS.USER_RELATIONSHIP_TYPE]??'',
        this.matchChangedTime = json[API_CONSTS.USER_MATCH_CHANGED_TIME]!=null? DateTime.fromMillisecondsSinceEpoch((json[API_CONSTS.USER_MATCH_CHANGED_TIME]*1000).toInt()).toUtc():null,
        this.lastUpdate = lastUpdateTime??DateTime(1990);


  types.User toUiUser(){
    return types.User(id:uid,firstName:username,imageUrl: NewNetworkService.getProfileImageUrl(profileImage));
  }

  bool hasImages(){
    return this.imageUrls!=null && this.imageUrls!.length>0;
  }

  String get profileImage{
    if(hasImages()){return imageUrls![0];}
    return NewNetworkService.shortProfileUrlImageById(uid);
  }

}