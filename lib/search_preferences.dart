import 'package:betabeta/search_preferences_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchPreferences{
  String genderPreferred;
  SearchPreferences({this.genderPreferred});
   SearchPreferences.fromSharedPreferences(
      SharedPreferences sharedPreferences
      ){genderPreferred = sharedPreferences.getString('preferredGender');}

  @override
  bool operator==(Object other) => //Alternative is extending Equatable, see https://medium.com/flutter-community/dart-equatable-package-simplify-equality-comparisons-1a96a3fc4864
      identical(this, other) ||
          other is SearchPreferences &&
              runtimeType == other.runtimeType &&
              genderPreferred == other.genderPreferred;

  @override
  int get hashCode => genderPreferred.hashCode;
}