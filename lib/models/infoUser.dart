import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
part 'infoUser.g.dart';

@HiveType(typeId : 0)
class InfoUser{
  @HiveField(0)
  String imageUrl;
  @HiveField(1)
  String name;
  @HiveField(2)
  String uid;
  @HiveField(3)
  DateTime changedTime;
  InfoUser({required this.imageUrl,required this.name,required this.uid,required this.changedTime});
  InfoUser.fromJson(Map json) :
        this.uid = json['firebase_uid']??'',
        this.imageUrl = json['facebook_profile_image_url']??'https://commons.wikimedia.org/wiki/File:Felis_catus-cat_on_snow.jpg', //TODO support getting profile image with a simple link
        this.name = json['name'],
  this.changedTime = json['match_changed_time']!=null? DateTime.fromMillisecondsSinceEpoch((json['match_changed_time']*1000).toInt()).toUtc():DateTime.now().toUtc();


  types.User toUiUser(){
    return types.User(id:uid,firstName:name,imageUrl: imageUrl);
  }

}