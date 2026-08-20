// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lesson_progress.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LessonProgressAdapter extends TypeAdapter<LessonProgress> {
  @override
  final int typeId = 1;

  @override
  LessonProgress read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LessonProgress(
      lessonId: fields[0] as String,
      isCompleted: fields[1] as bool,
      stars: fields[2] as int,
      completedAt: fields[3] as DateTime?,
      attempts: fields[4] as int,
      bestScore: fields[5] as int,
    );
  }

  @override
  void write(BinaryWriter writer, LessonProgress obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.lessonId)
      ..writeByte(1)
      ..write(obj.isCompleted)
      ..writeByte(2)
      ..write(obj.stars)
      ..writeByte(3)
      ..write(obj.completedAt)
      ..writeByte(4)
      ..write(obj.attempts)
      ..writeByte(5)
      ..write(obj.bestScore);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LessonProgressAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
