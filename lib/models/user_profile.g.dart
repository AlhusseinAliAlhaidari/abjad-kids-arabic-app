// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserProfileAdapter extends TypeAdapter<UserProfile> {
  @override
  final int typeId = 0;

  @override
  UserProfile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserProfile(
      id: fields[0] as String,
      name: fields[1] as String,
      age: fields[2] as int,
      avatarPath: fields[3] as String?,
      coins: fields[4] as int?,
      badges: (fields[5] as List?)?.cast<String>(),
      purchasedCharacters: (fields[6] as List?)?.cast<String>(),
      currentTheme: fields[7] as String?,
      levelProgress: (fields[8] as Map?)?.cast<dynamic, dynamic>(),
      createdAt: fields[9] as DateTime?,
      lastPlayed: fields[10] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, UserProfile obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.age)
      ..writeByte(3)
      ..write(obj.avatarPath)
      ..writeByte(4)
      ..write(obj.coins)
      ..writeByte(5)
      ..write(obj.badges)
      ..writeByte(6)
      ..write(obj.purchasedCharacters)
      ..writeByte(7)
      ..write(obj.currentTheme)
      ..writeByte(8)
      ..write(obj.levelProgress)
      ..writeByte(9)
      ..write(obj.createdAt)
      ..writeByte(10)
      ..write(obj.lastPlayed);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserProfileAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
