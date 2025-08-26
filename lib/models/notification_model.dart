import 'package:hive/hive.dart';
import 'package:job_buddy/helpers/hive_db_helper.dart';
import 'package:job_buddy/models/response_model.dart';

part 'notification_model.g.dart';

@HiveType(typeId: 12) // Make sure this ID is unique
class NotificationModel {
  @HiveField(0)
  String? id;

  @HiveField(1)
  String? receiveBy;

  @HiveField(2)
  String? createdBy;

  @HiveField(3)
  String? companyId;

  @HiveField(4)
  String? companyName;

  @HiveField(5)
  String? title;

  @HiveField(6)
  String? message;

  @HiveField(7)
  bool? isRead;

  @HiveField(8)
  String? createdAt;

  @HiveField(9)
  String? senderName;

  @HiveField(10)
  String? receiverName;

  @HiveField(11)
  dynamic jobOffersId;

  NotificationModel({
    this.id,
    this.receiveBy,
    this.createdBy,
    this.companyId,
    this.companyName,
    this.title,
    this.message,
    this.isRead,
    this.createdAt,
    this.senderName,
    this.receiverName,
    this.jobOffersId,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id']?.toString(),
      receiveBy: json['receive_by']?.toString(),
      createdBy: json['created_by']?.toString(),
      companyId: json['company_id']?.toString(),
      companyName: json['company_name'],
      title: json['title'],
      message: json['message'],
      isRead: json['is_read'] == '1' || json['is_read'] == true,
      createdAt: json['created_at'],
      senderName: json['sender_name'],
      receiverName: json['receiver_name'],
      jobOffersId: json['job_offers_id'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'receive_by': receiveBy,
        'created_by': createdBy,
        'company_id': companyId,
        'company_name': companyName,
        'title': title,
        'message': message,
        'is_read': isRead,
        'created_at': createdAt,
        'sender_name': senderName,
        'receiver_name': receiverName,
        'jobOffersId': jobOffersId,
      };
}


class NotificationBox {
  Box get _notificationBox => Hive.box(Boxes.notificationBox); // Make sure Boxes.notificationBox exists

  NotificationModel get data => _notificationBox.getAt(0);

  List<NotificationModel> get items =>
      _notificationBox.values.cast<NotificationModel>().toList();

  Future<void> insert(Map<String, dynamic> json) async {
    final data = NotificationModel.fromJson(json);
    await _notificationBox.put(data.id, data);
  }

  Future<void> insertAll(ResponseModel response) async {
    for (var element in response.data) {
      final data = NotificationModel.fromJson(element);
      await _notificationBox.put(data.id, data);
    }
  }

  int count() => _notificationBox.length;

  NotificationModel? getById(String id) => _notificationBox.get(id);

  Future<void> update(NotificationModel notification) async {
    await _notificationBox.put(notification.id, notification);
  }

  Future<void> clear() async => await _notificationBox.clear();

  bool get isEmpty => _notificationBox.isEmpty;
}
