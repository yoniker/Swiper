import 'dart:math';

import 'package:betabeta/models/userid.dart';
import 'package:betabeta/services/networking.dart';

class Profile {
  final List<String> imageUrls;
  final String username;
  final String headline;
  final String description;
  final int age;
  final String location;
  final double distance;
  final String jobTitle;
  final String serverUserImagesLocation;
  final String height;
  final double compatibilityScore;
  final double hotnessScore;


  UserId userId;
  Profile( { this.compatibilityScore, this.hotnessScore, this.imageUrls, this.username, this.headline, this.description, this.age, this.location,this.distance,this.jobTitle,this.serverUserImagesLocation,this.height, this.userId}){
    if (this.userId ==null){
      this.userId =  UserId(id: this.username, userType: UserType.POF_USER);
    }
  }

  factory Profile.fromServer(dynamic match){
    List images=match['images'];
    List<String> imagesUrls = images.cast<String>();
    UserId userId = UserId(id: match['pof_id'].toString(), userType: UserType.POF_USER); //TODO change here when implementing real users profiles
    String locationDesc ='';
    if(match['state_id']!=null){
      locationDesc += match['state_id']+' , ';
    }
    if(match['city']!=null){
      locationDesc += match['city'];
    }
  return Profile(username: match['username'],headline: match['headline'],description: match['description'],age:match['age'],
      location: locationDesc,distance: match['distance'],jobTitle: match['profession'],
      serverUserImagesLocation: match['server_user_images_location'],
      height: match['height'],
      userId: userId,
      hotnessScore: match['hotness'] * 100,
      compatibilityScore: match['compatibility'] * 100 ,
      imageUrls: NetworkHelper.serverImagesUrl(imagesUrls)
  );}
}
