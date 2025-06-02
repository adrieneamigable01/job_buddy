// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_review_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AppReviewModelAdapter extends TypeAdapter<AppReviewModel> {
  @override
  final int typeId = 14;

  @override
  AppReviewModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AppReviewModel(
      reviewId: fields[0] as String?,
      userId: fields[1] as String?,
      comment: fields[2] as String?,
      rating: fields[3] as int?,
      createdAt: fields[4] as String?,
      username: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, AppReviewModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.reviewId)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.comment)
      ..writeByte(3)
      ..write(obj.rating)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.username);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppReviewModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
