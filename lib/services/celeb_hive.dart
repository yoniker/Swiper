import 'package:hive/hive.dart';
part 'celeb_hive.g.dart';

@HiveType(typeId: 1)
class CelebHive {
  CelebHive(
      {this.celeb_name, this.name, this.aliases, this.birthday, this.description, this.country, this.gender, this.code, this.famous_name, this.title});

  @HiveField(0)
  String celeb_name;

  @HiveField(1)
  String name;

  @HiveField(2)
  List<String> aliases;

  @HiveField(3)
  String birthday;

  @HiveField(4)
  String description;

  @HiveField(5)
  String country;

  @HiveField(6)
  String gender;

  @HiveField(7)
  String code;

  @HiveField(8)
  String famous_name;

  @HiveField(9)
  String title;


  @override
  String toString() {
    return '$name: $birthday';
  }

}
