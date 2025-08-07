// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserModelAdapter extends TypeAdapter<UserModel> {
  @override
  final int typeId = 0;

  @override
  UserModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserModel(
      userId: fields[0] as dynamic,
      studentid: fields[1] as String?,
      employerid: fields[2] as dynamic,
      lastname: fields[3] as String?,
      firstname: fields[4] as String?,
      middlename: fields[5] as String?,
      email: fields[6] as dynamic,
      phone: fields[7] as dynamic,
      address: fields[8] as String?,
      birthdate: fields[9] as String?,
      gender: fields[10] as String?,
      isactive: fields[11] as dynamic,
      createdat: fields[12] as String?,
      updatedat: fields[13] as String?,
      deletedat: fields[14] as String?,
      usertype: fields[15] as String?,
      profileImage: fields[17] as String?,
      validationStatus: fields[18] as String?,
      validationDocumentType: fields[19] as String?,
      validationDocumentPath: fields[20] as String?,
      alreadySubscribe: fields[21] as bool?,
      accesstoken: fields[16] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer
      ..writeByte(22)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.studentid)
      ..writeByte(2)
      ..write(obj.employerid)
      ..writeByte(3)
      ..write(obj.lastname)
      ..writeByte(4)
      ..write(obj.firstname)
      ..writeByte(5)
      ..write(obj.middlename)
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
      ..write(obj.isactive)
      ..writeByte(12)
      ..write(obj.createdat)
      ..writeByte(13)
      ..write(obj.updatedat)
      ..writeByte(14)
      ..write(obj.deletedat)
      ..writeByte(15)
      ..write(obj.usertype)
      ..writeByte(16)
      ..write(obj.accesstoken)
      ..writeByte(17)
      ..write(obj.profileImage)
      ..writeByte(18)
      ..write(obj.validationStatus)
      ..writeByte(19)
      ..write(obj.validationDocumentType)
      ..writeByte(20)
      ..write(obj.validationDocumentPath)
      ..writeByte(21)
      ..write(obj.alreadySubscribe);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
