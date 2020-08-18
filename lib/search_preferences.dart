import 'package:shared_preferences/shared_preferences.dart';

class SearchPreferences{
  static const String DEFAULT_GENDER='Women';
  String _genderPreferred;
  SearchPreferences({genderPreferred}):_genderPreferred=genderPreferred;
   SearchPreferences.fromSharedPreferences(
      SharedPreferences sharedPreferences
      ){_genderPreferred = sharedPreferences.getString('preferredGender')??DEFAULT_GENDER;}

      set genderPreferred(String genderPreferred) {
     if(genderPreferred==_genderPreferred){return;}
     _genderPreferred=genderPreferred;
     updateSharedPreferences();
  }

  String get genderPreferred{
     return _genderPreferred;
  }

  @override
  bool operator==(Object other) => //Alternative is extending Equatable, see https://medium.com/flutter-community/dart-equatable-package-simplify-equality-comparisons-1a96a3fc4864
      identical(this, other) ||
          other is SearchPreferences &&
              runtimeType == other.runtimeType &&
              _genderPreferred == other._genderPreferred;

  @override
  int get hashCode => _genderPreferred.hashCode;

  SearchPreferences.clone(SearchPreferences other): this(genderPreferred: other.genderPreferred);



  updateSharedPreferences() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('preferredGender', _genderPreferred);
  }
}