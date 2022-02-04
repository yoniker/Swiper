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
      imageUrl: fields[0] as String,
      name: fields[1] as String,
      uid: fields[2] as String,
      changedTime: fields[3] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, InfoUser obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.imageUrl)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.uid)
      ..writeByte(3)
      ..write(obj.changedTime);
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
