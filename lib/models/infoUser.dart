import 'dart:convert';

import 'package:betabeta/constants/api_consts.dart';
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
  final List<String>? imageUrls;
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
  final List<String>? hobbies;



  InfoUser({required this.username,required this.uid,required this.matchChangedTime,this.imageUrls,this.headline,this.description,this.age,this.location,this.jobTitle,this.hobbies,this.religion,this.height,this.compatibilityScore,this.hotnessScore,this.distance});
  InfoUser.fromJson(Map json) :
        this.uid = json[API_CONSTS.USER_UID_KEY]??'',
        this.hobbies=jsonDecode( json[API_CONSTS.USER_HOBBIES]),
  this.imageUrls=[], //TODO complete
        this.username = json['name'],
  this.hotnessScore =0,
  this.compatibilityScore =0,
  this.age =0,
  this.description = '',
  this.distance =0,
  this.height =0,
  this.location = '',
  this.headline = '',
  this.jobTitle = '',
  this.religion='',

  this.matchChangedTime = json['match_changed_time']!=null? DateTime.fromMillisecondsSinceEpoch((json['match_changed_time']*1000).toInt()).toUtc():DateTime.now().toUtc();


  types.User toUiUser(){
    return types.User(id:uid,firstName:username,imageUrl: imageUrls![0]);
  }

}