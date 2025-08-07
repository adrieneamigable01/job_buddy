// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'education_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EducationModelAdapter extends TypeAdapter<EducationModel> {
  @override
  final int typeId = 9;

  @override
  EducationModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EducationModel(
      id: fields[0] as dynamic,
      studentId: fields[1] as dynamic,
      courseId: fields[2] as dynamic,
      schoolName: fields[3] as String?,
      degree: fields[4] as String?,
      fieldOfStudy: fields[5] as String?,
      startYear: fields[6] as String?,
      endYear: fields[7] as String?,
      grade: fields[8] as String?,
      activities: fields[9] as String?,
      description: fields[10] as String?,
      createdAt: fields[11] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, EducationModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.studentId)
      ..writeByte(2)
      ..write(obj.courseId)
      ..writeByte(3)
      ..write(obj.schoolName)
      ..writeByte(4)
      ..write(obj.degree)
      ..writeByte(5)
      ..write(obj.fieldOfStudy)
      ..writeByte(6)
      ..write(obj.startYear)
      ..writeByte(7)
      ..write(obj.endYear)
      ..writeByte(8)
      ..write(obj.grade)
      ..writeByte(9)
      ..write(obj.activities)
      ..writeByte(10)
      ..write(obj.description)
      ..writeByte(11)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EducationModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
