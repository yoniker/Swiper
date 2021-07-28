// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'celeb_hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CelebAdapter extends TypeAdapter<CelebHive> {
  @override
  final int typeId = 1;

  @override
  CelebHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CelebHive(
      celeb_name: fields[0] as String,
      name: fields[1] as String,
      aliases: (fields[2] as List).cast<String>(),
      birthday: fields[3] as String,
      description: fields[4] as String,
      country: fields[5] as String,
      gender: fields[6] as String,
      code: fields[7] as String,
      famous_name: fields[8] as String,
      title: fields[9] as String,
    );
  }

  @override
  void write(BinaryWriter writer, CelebHive obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.celeb_name)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.aliases)
      ..writeByte(3)
      ..write(obj.birthday)
      ..writeByte(4)
      ..write(obj.description)
      ..writeByte(5)
      ..write(obj.country)
      ..writeByte(6)
      ..write(obj.gender)
      ..writeByte(7)
      ..write(obj.code)
      ..writeByte(8)
      ..write(obj.famous_name)
      ..writeByte(9)
      ..write(obj.title);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is CelebAdapter &&
              runtimeType == other.runtimeType &&
              typeId == other.typeId;
}
