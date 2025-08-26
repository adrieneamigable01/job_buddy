// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'joboffer_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class JobOfferModelAdapter extends TypeAdapter<JobOfferModel> {
  @override
  final int typeId = 1;

  @override
  JobOfferModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return JobOfferModel(
      jobOffersId: fields[0] as dynamic,
      jobTitle: fields[1] as String?,
      skills: fields[2] as String?,
      location: fields[3] as String?,
      minSalary: fields[4] as dynamic,
      maxSalary: fields[5] as dynamic,
      salaryRange: fields[6] as dynamic,
      employerId: fields[7] as dynamic,
      jobDescription: fields[8] as String?,
      companyId: fields[9] as dynamic,
      dateAdded: fields[10] as String?,
      expiredAt: fields[11] as String?,
      isActive: fields[12] as dynamic,
      status: fields[13] as String?,
      companyName: fields[14] as String?,
      employmenType: fields[15] as String?,
      companyOverview: fields[16] as String?,
      qualifications: fields[17] as String?,
      matchScore: fields[18] as dynamic,
      matchReason: fields[19] as String?,
      hasJobOffer: fields[20] as dynamic,
      jobOfferStatus: fields[21] as String?,
      contract: fields[23] as String?,
      subscription: fields[24] as dynamic,
      workStart: fields[25] as dynamic,
      workEnd: fields[26] as dynamic,
    );
  }

  @override
  void write(BinaryWriter writer, JobOfferModel obj) {
    writer
      ..writeByte(26)
      ..writeByte(0)
      ..write(obj.jobOffersId)
      ..writeByte(1)
      ..write(obj.jobTitle)
      ..writeByte(2)
      ..write(obj.skills)
      ..writeByte(3)
      ..write(obj.location)
      ..writeByte(4)
      ..write(obj.minSalary)
      ..writeByte(5)
      ..write(obj.maxSalary)
      ..writeByte(6)
      ..write(obj.salaryRange)
      ..writeByte(7)
      ..write(obj.employerId)
      ..writeByte(8)
      ..write(obj.jobDescription)
      ..writeByte(9)
      ..write(obj.companyId)
      ..writeByte(10)
      ..write(obj.dateAdded)
      ..writeByte(11)
      ..write(obj.expiredAt)
      ..writeByte(12)
      ..write(obj.isActive)
      ..writeByte(13)
      ..write(obj.status)
      ..writeByte(14)
      ..write(obj.companyName)
      ..writeByte(15)
      ..write(obj.employmenType)
      ..writeByte(16)
      ..write(obj.companyOverview)
      ..writeByte(17)
      ..write(obj.qualifications)
      ..writeByte(18)
      ..write(obj.matchScore)
      ..writeByte(19)
      ..write(obj.matchReason)
      ..writeByte(20)
      ..write(obj.hasJobOffer)
      ..writeByte(21)
      ..write(obj.jobOfferStatus)
      ..writeByte(23)
      ..write(obj.contract)
      ..writeByte(24)
      ..write(obj.subscription)
      ..writeByte(25)
      ..write(obj.workStart)
      ..writeByte(26)
      ..write(obj.workEnd);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JobOfferModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
