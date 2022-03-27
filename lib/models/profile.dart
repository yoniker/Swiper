import 'package:betabeta/models/userid.dart';
import 'package:betabeta/services/new_networking.dart';

class Profile {
  final List<String>? imageUrls;
  final String? username;
  final String? headline;
  final String? description;
  final int? age;
  final String? location;
  final double? distance;
  final String? jobTitle;
  final double? height;
  final double? compatibilityScore;
  final double? hotnessScore;
  final String? religion;

  UserId? userId;
  Profile(
      {this.compatibilityScore,
      this.hotnessScore,
      this.imageUrls,
      this.username,
      this.headline,
      this.description,
      this.age,
      this.location,
      this.distance,
      this.jobTitle,
      this.height,
      this.userId,
      this.religion}) {
    if (this.userId == null) {
      this.userId = UserId(id: this.username, userType: UserType.DUMMY);
    }
  }

  factory Profile.fromServer(dynamic match) {
    List images = match['images'];
    List<String> imagesUrls = images.cast<String>();
    UserType userType =
        match['user_type'] == 'real' ? UserType.REAL_USER : UserType.DUMMY;
    UserId userId =
        UserId(id: match['firebase_uid'].toString(), userType: userType);
    Profile toReturn = Profile(
        username: match['username'] ?? match['name'],
        headline: match['headline'] ?? match['user_description'],
        description: match['user_description'] ?? match['headline'],
        age: match['age'],
        location: match['location_description'],
        distance: match['distance'],
        jobTitle: match['job_title'],
        height: match['height_in_cm'],
        userId: userId,
        hotnessScore: match['hotness'] * 100,
        compatibilityScore: match['compatibility'] * 100,
        imageUrls: NewNetworkService.serverImagesUrl(imagesUrls));
    return toReturn;
  }
}
