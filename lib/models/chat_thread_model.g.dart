// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_thread_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChatThreadModelAdapter extends TypeAdapter<ChatThreadModel> {
  @override
  final int typeId = 11;

  @override
  ChatThreadModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChatThreadModel(
      threadId: fields[0] as String?,
      user1Id: fields[1] as String?,
      user2Id: fields[2] as String?,
      title: fields[3] as String?,
      threadCreatedAt: fields[4] as String?,
      createdBy: fields[5] as String?,
      createdByUsername: fields[6] as String?,
      lastMessage: fields[7] as String?,
      lastMessageTime: fields[8] as String?,
      lastMessageRead: fields[9] as String?,
      lastMessageSender: fields[10] as String?,
      createdByName: fields[11] as String?,
      participants: fields[12] as dynamic,
      companyId: fields[13] as dynamic,
      readByUsers: fields[14] as dynamic,
    );
  }

  @override
  void write(BinaryWriter writer, ChatThreadModel obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.threadId)
      ..writeByte(1)
      ..write(obj.user1Id)
      ..writeByte(2)
      ..write(obj.user2Id)
      ..writeByte(3)
      ..write(obj.title)
      ..writeByte(4)
      ..write(obj.threadCreatedAt)
      ..writeByte(5)
      ..write(obj.createdBy)
      ..writeByte(6)
      ..write(obj.createdByUsername)
      ..writeByte(7)
      ..write(obj.lastMessage)
      ..writeByte(8)
      ..write(obj.lastMessageTime)
      ..writeByte(9)
      ..write(obj.lastMessageRead)
      ..writeByte(10)
      ..write(obj.lastMessageSender)
      ..writeByte(11)
      ..write(obj.createdByName)
      ..writeByte(12)
      ..write(obj.participants)
      ..writeByte(13)
      ..write(obj.companyId)
      ..writeByte(14)
      ..write(obj.readByUsers);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatThreadModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
