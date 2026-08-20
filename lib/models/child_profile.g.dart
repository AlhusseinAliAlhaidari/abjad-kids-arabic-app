// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'child_profile.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChildProfileAdapter extends TypeAdapter<ChildProfile> {
  @override
  final int typeId = 0;

  @override
  ChildProfile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChildProfile(
      name: fields[0] as String,
      age: fields[1] as int,
      currentLevel: fields[2] as int,
      totalPoints: fields[3] as int,
      hasCompletedPlacementTest: fields[4] as bool,
      placementTestScore: fields[5] as int,
      createdAt: fields[6] as DateTime,
      lastActiveAt: fields[7] as DateTime,
      totalStars: fields[8] as int,
      completedLessons: fields[11] as int,
      purchasedCharacters: (fields[9] as List?)?.cast<String>(),
      selectedCharacter: fields[10] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ChildProfile obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.age)
      ..writeByte(2)
      ..write(obj.currentLevel)
      ..writeByte(3)
      ..write(obj.totalPoints)
      ..writeByte(4)
      ..write(obj.hasCompletedPlacementTest)
      ..writeByte(5)
      ..write(obj.placementTestScore)
      ..writeByte(6)
      ..write(obj.createdAt)
      ..writeByte(7)
      ..write(obj.lastActiveAt)
      ..writeByte(8)
      ..write(obj.totalStars)
      ..writeByte(9)
      ..write(obj.purchasedCharacters)
      ..writeByte(10)
      ..write(obj.selectedCharacter)
      ..writeByte(11)
      ..write(obj.completedLessons);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChildProfileAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
