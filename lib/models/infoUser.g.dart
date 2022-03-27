// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'infoUser.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class InfoUserAdapter extends TypeAdapter<InfoUser> {
  @override
  final int typeId = 0;

  @override
  InfoUser read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return InfoUser(
      username: fields[0] as String,
      uid: fields[1] as String,
      matchChangedTime: fields[2] as DateTime?,
      imageUrls: (fields[3] as List?)?.cast<String>(),
      headline: fields[4] as String?,
      description: fields[5] as String?,
      age: fields[6] as int?,
      location: fields[7] as String?,
      jobTitle: fields[9] as String?,
      religion: fields[13] as String?,
      height: fields[10] as double?,
      compatibilityScore: fields[11] as double?,
      hotnessScore: fields[12] as double?,
      distance: fields[8] as double?,
      pets: (fields[15] as List).cast<String>(),
      drinking: fields[19] as String,
      hobbies: (fields[14] as List).cast<String>(),
      covidVaccine: fields[16] as String,
      children: fields[17] as String,
      education: fields[18] as String,
      smoking: fields[20] as String,
      fitness: fields[21] as String,
      zodiac: fields[22] as String,
      school: fields[23] as String,
    );
  }

  @override
  void write(BinaryWriter writer, InfoUser obj) {
    writer
      ..writeByte(24)
      ..writeByte(0)
      ..write(obj.username)
      ..writeByte(1)
      ..write(obj.uid)
      ..writeByte(2)
      ..write(obj.matchChangedTime)
      ..writeByte(3)
      ..write(obj.imageUrls)
      ..writeByte(4)
      ..write(obj.headline)
      ..writeByte(5)
      ..write(obj.description)
      ..writeByte(6)
      ..write(obj.age)
      ..writeByte(7)
      ..write(obj.location)
      ..writeByte(8)
      ..write(obj.distance)
      ..writeByte(9)
      ..write(obj.jobTitle)
      ..writeByte(10)
      ..write(obj.height)
      ..writeByte(11)
      ..write(obj.compatibilityScore)
      ..writeByte(12)
      ..write(obj.hotnessScore)
      ..writeByte(13)
      ..write(obj.religion)
      ..writeByte(14)
      ..write(obj.hobbies)
      ..writeByte(15)
      ..write(obj.pets)
      ..writeByte(16)
      ..write(obj.covidVaccine)
      ..writeByte(17)
      ..write(obj.children)
      ..writeByte(18)
      ..write(obj.education)
      ..writeByte(19)
      ..write(obj.drinking)
      ..writeByte(20)
      ..write(obj.smoking)
      ..writeByte(21)
      ..write(obj.fitness)
      ..writeByte(22)
      ..write(obj.zodiac)
      ..writeByte(23)
      ..write(obj.school);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InfoUserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
