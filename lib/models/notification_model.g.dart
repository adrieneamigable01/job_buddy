// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NotificationModelAdapter extends TypeAdapter<NotificationModel> {
  @override
  final int typeId = 12;

  @override
  NotificationModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NotificationModel(
      id: fields[0] as String?,
      receiveBy: fields[1] as String?,
      createdBy: fields[2] as String?,
      companyId: fields[3] as String?,
      companyName: fields[4] as String?,
      title: fields[5] as String?,
      message: fields[6] as String?,
      isRead: fields[7] as bool?,
      createdAt: fields[8] as String?,
      senderName: fields[9] as String?,
      receiverName: fields[10] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, NotificationModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.receiveBy)
      ..writeByte(2)
      ..write(obj.createdBy)
      ..writeByte(3)
      ..write(obj.companyId)
      ..writeByte(4)
      ..write(obj.companyName)
      ..writeByte(5)
      ..write(obj.title)
      ..writeByte(6)
      ..write(obj.message)
      ..writeByte(7)
      ..write(obj.isRead)
      ..writeByte(8)
      ..write(obj.createdAt)
      ..writeByte(9)
      ..write(obj.senderName)
      ..writeByte(10)
      ..write(obj.receiverName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
