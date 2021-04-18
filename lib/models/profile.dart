import 'package:betabeta/services/networking.dart';

class Profile {
  final List<String> imageUrls;
  final String username;
  final String headline;
  final String description;
  final int age;
  final String location;
  final double distance;
  Profile({  this.imageUrls, this.username, this.headline, this.description, this.age, this.location,this.distance});

  factory Profile.fromMatch(dynamic match){
    List images=match['images'];
    List<String> imagesUrls=images.cast<String>();
  return Profile(username: match['username'],headline: match['headline'],description: match['description'],age:match['age'],location: match['location_desc'],distance: match['distance'], imageUrls: NetworkHelper.serverImagesUrl(imagesUrls)
  );}
}
