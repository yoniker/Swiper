import 'dart:convert';

import 'package:betabeta/constants/api_consts.dart';
import 'package:betabeta/services/new_networking.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
part 'infoUser.g.dart';

@HiveType(typeId : 0)
class InfoUser{
  @HiveField(0)
  final String username;
  @HiveField(1)
  final String uid;
  @HiveField(2)
  final DateTime matchChangedTime;
  @HiveField(3)
  List<String>? imageUrls;
  @HiveField(4)
  final String? headline;
  @HiveField(5)
  final String? description;
  @HiveField(6)
  final int? age;
  @HiveField(7)
  final String? location;
  @HiveField(8)
  final double? distance;
  @HiveField(9)
  final String? jobTitle;
  @HiveField(10)
  final double? height;
  @HiveField(11)
  final double? compatibilityScore;
  @HiveField(12)
  final double? hotnessScore;
  @HiveField(13)
  final String? religion;
  @HiveField(14)
  final List<String> hobbies;
  @HiveField(15)
  final List<String> pets;
  @HiveField(16)
  final String covidVaccine;
  @HiveField(17)
  final String children;
  @HiveField(18)
  final String education;
  @HiveField(19)
  final String drinking;
  @HiveField(20)
  final String smoking;
  @HiveField(21)
  final String fitness;
  @HiveField(22)
  final String zodiac;
  @HiveField(23)
  final String school;




  InfoUser({required this.username,required this.uid,required this.matchChangedTime,this.imageUrls,this.headline,this.description,this.age,this.location,this.jobTitle,this.religion,this.height,this.compatibilityScore,this.hotnessScore,this.distance,
    required this.pets,required this.drinking,required this.hobbies,required this.covidVaccine,required this.children,required this.education,required this.smoking,required this.fitness,required this.zodiac,required this.school,

  });
  InfoUser.fromJson(Map json) :
        this.uid = json[API_CONSTS.USER_UID_KEY]??'',
        this.hobbies=List<String>.from(jsonDecode( json[API_CONSTS.USER_HOBBIES]??jsonEncode([]))),
        this.pets = List<String>.from(jsonDecode( json[API_CONSTS.USER_PETS]??jsonEncode([]))),
        this.imageUrls = List<String>.from(jsonDecode(json[API_CONSTS.USER_IMAGES]??jsonEncode([NewNetworkService.getImageProfileByUserId(json[API_CONSTS.USER_UID_KEY])]))),
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



  this.hotnessScore =0,
  this.compatibilityScore =0,
  this.age =0,
  this.description = '',
  this.distance =0,
  this.height =0,
  this.location = '',
  this.headline = '',
  this.jobTitle = '',

  this.matchChangedTime = json['match_changed_time']!=null? DateTime.fromMillisecondsSinceEpoch((json['match_changed_time']*1000).toInt()).toUtc():DateTime.now().toUtc();


  types.User toUiUser(){
    return types.User(id:uid,firstName:username,imageUrl: imageUrls![0]);
  }

}