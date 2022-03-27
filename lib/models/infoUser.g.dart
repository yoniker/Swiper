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
      matchChangedTime: fields[2] as DateTime,
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
    );
  }

  @override
  void write(BinaryWriter writer, InfoUser obj) {
    writer
      ..writeByte(14)
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
      ..write(obj.religion);
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
