// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StudentModelAdapter extends TypeAdapter<StudentModel> {
  @override
  final int typeId = 7;

  @override
  StudentModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StudentModel(
      index: fields[0] as dynamic,
      studentId: fields[1] as dynamic,
      lastname: fields[2] as String?,
      firstname: fields[3] as String?,
      middlename: fields[4] as String?,
      userId: fields[5] as String?,
      email: fields[6] as String?,
      phone: fields[7] as String?,
      address: fields[8] as String?,
      birthdate: fields[9] as String?,
      gender: fields[10] as String?,
      isActive: fields[11] as bool?,
      skills: fields[12] as String?,
      courseId: fields[13] as String?,
      createdAt: fields[14] as String?,
      updatedAt: fields[15] as String?,
      deletedAt: fields[16] as String?,
      status: fields[17] as String?,
      prefereAvailableTime: fields[18] as String?,
      employmentType: fields[19] as String?,
      jobOffersId: fields[20] as dynamic,
      courses: fields[21] as dynamic,
      matchReason: fields[22] as String?,
      matchScore: fields[23] as dynamic,
      hasJobOffer: fields[24] as dynamic,
      jobOfferStatus: fields[25] as String?,
      contract: fields[26] as String?,
      contractStatus: fields[27] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, StudentModel obj) {
    writer
      ..writeByte(28)
      ..writeByte(0)
      ..write(obj.index)
      ..writeByte(1)
      ..write(obj.studentId)
      ..writeByte(2)
      ..write(obj.lastname)
      ..writeByte(3)
      ..write(obj.firstname)
      ..writeByte(4)
      ..write(obj.middlename)
      ..writeByte(5)
      ..write(obj.userId)
      ..writeByte(6)
      ..write(obj.email)
      ..writeByte(7)
      ..write(obj.phone)
      ..writeByte(8)
      ..write(obj.address)
      ..writeByte(9)
      ..write(obj.birthdate)
      ..writeByte(10)
      ..write(obj.gender)
      ..writeByte(11)
      ..write(obj.isActive)
      ..writeByte(12)
      ..write(obj.skills)
      ..writeByte(13)
      ..write(obj.courseId)
      ..writeByte(14)
      ..write(obj.createdAt)
      ..writeByte(15)
      ..write(obj.updatedAt)
      ..writeByte(16)
      ..write(obj.deletedAt)
      ..writeByte(17)
      ..write(obj.status)
      ..writeByte(18)
      ..write(obj.prefereAvailableTime)
      ..writeByte(19)
      ..write(obj.employmentType)
      ..writeByte(20)
      ..write(obj.jobOffersId)
      ..writeByte(21)
      ..write(obj.courses)
      ..writeByte(22)
      ..write(obj.matchReason)
      ..writeByte(23)
      ..write(obj.matchScore)
      ..writeByte(24)
      ..write(obj.hasJobOffer)
      ..writeByte(25)
      ..write(obj.jobOfferStatus)
      ..writeByte(26)
      ..write(obj.contract)
      ..writeByte(27)
      ..write(obj.contractStatus);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StudentModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
