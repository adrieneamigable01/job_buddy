// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'experience_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ExperienceModelAdapter extends TypeAdapter<ExperienceModel> {
  @override
  final int typeId = 10;

  @override
  ExperienceModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ExperienceModel(
      experienceId: fields[0] as dynamic,
      studentId: fields[1] as dynamic,
      companyName: fields[2] as String?,
      positionTitle: fields[3] as String?,
      location: fields[4] as String?,
      skills: fields[5] as String?,
      startDate: fields[6] as String?,
      endDate: fields[7] as String?,
      isCurrent: fields[8] as bool?,
      description: fields[9] as String?,
      createdAt: fields[10] as String?,
      updatedAt: fields[11] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ExperienceModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.experienceId)
      ..writeByte(1)
      ..write(obj.studentId)
      ..writeByte(2)
      ..write(obj.companyName)
      ..writeByte(3)
      ..write(obj.positionTitle)
      ..writeByte(4)
      ..write(obj.location)
      ..writeByte(5)
      ..write(obj.skills)
      ..writeByte(6)
      ..write(obj.startDate)
      ..writeByte(7)
      ..write(obj.endDate)
      ..writeByte(8)
      ..write(obj.isCurrent)
      ..writeByte(9)
      ..write(obj.description)
      ..writeByte(10)
      ..write(obj.createdAt)
      ..writeByte(11)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExperienceModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
