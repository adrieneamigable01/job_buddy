// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employer_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EmployerModelAdapter extends TypeAdapter<EmployerModel> {
  @override
  final int typeId = 13;

  @override
  EmployerModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EmployerModel(
      employerId: fields[0] as dynamic,
      lastname: fields[1] as String?,
      firstname: fields[2] as String?,
      middlename: fields[3] as String?,
      userId: fields[4] as String?,
      email: fields[5] as String?,
      phone: fields[6] as String?,
      address: fields[7] as String?,
      birthdate: fields[8] as String?,
      gender: fields[9] as String?,
      status: fields[10] as String?,
      isActive: fields[11] as bool?,
      createdAt: fields[12] as String?,
      updatedAt: fields[13] as String?,
      deletedAt: fields[14] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, EmployerModel obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.employerId)
      ..writeByte(1)
      ..write(obj.lastname)
      ..writeByte(2)
      ..write(obj.firstname)
      ..writeByte(3)
      ..write(obj.middlename)
      ..writeByte(4)
      ..write(obj.userId)
      ..writeByte(5)
      ..write(obj.email)
      ..writeByte(6)
      ..write(obj.phone)
      ..writeByte(7)
      ..write(obj.address)
      ..writeByte(8)
      ..write(obj.birthdate)
      ..writeByte(9)
      ..write(obj.gender)
      ..writeByte(10)
      ..write(obj.status)
      ..writeByte(11)
      ..write(obj.isActive)
      ..writeByte(12)
      ..write(obj.createdAt)
      ..writeByte(13)
      ..write(obj.updatedAt)
      ..writeByte(14)
      ..write(obj.deletedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EmployerModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
