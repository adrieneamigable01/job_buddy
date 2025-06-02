// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_plan_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SubscriptionPlanModelAdapter extends TypeAdapter<SubscriptionPlanModel> {
  @override
  final int typeId = 3;

  @override
  SubscriptionPlanModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SubscriptionPlanModel(
      id: fields[0] as dynamic,
      planName: fields[1] as String?,
      description: fields[2] as String?,
      price: fields[3] as dynamic,
      durationDays: fields[4] as int?,
      maxCompanies: fields[5] as int?,
      maxPosts: fields[6] as int?,
      createdAt: fields[7] as String?,
      planId: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, SubscriptionPlanModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.planName)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.price)
      ..writeByte(4)
      ..write(obj.durationDays)
      ..writeByte(5)
      ..write(obj.maxCompanies)
      ..writeByte(6)
      ..write(obj.maxPosts)
      ..writeByte(7)
      ..write(obj.createdAt)
      ..writeByte(8)
      ..write(obj.planId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubscriptionPlanModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
