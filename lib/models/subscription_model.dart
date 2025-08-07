import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:job_buddy/helpers/hive_db_helper.dart';
import 'package:job_buddy/models/response_model.dart';

part 'subscription_model.g.dart';

@HiveType(typeId: 4) // Make sure this is unique in your project
class SubscriptionModel {
  @HiveField(0)
  dynamic id;

  @HiveField(1)
  dynamic userId;

  @HiveField(2)
  dynamic planId;

  @HiveField(3)
  String? startDate;

  @HiveField(4)
  String? endDate;

  @HiveField(5)
  bool? isActive;

  @HiveField(6)
  bool? autoRenew;

  @HiveField(7)
  String? createdAt;

  @HiveField(8)
  String? updatedAt;

  @HiveField(9)
  bool? isExpired;

  SubscriptionModel({
    this.id,
    this.userId,
    this.planId,
    this.startDate,
    this.endDate,
    this.isActive,
    this.autoRenew,
    this.createdAt,
    this.updatedAt,
    this.isExpired,
  });

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionModel(
      id: json['id'],
      userId: json['user_id'],
      planId: json['plan_id'],
      startDate: json['start_date'],
      endDate: json['end_date'],
      isActive: json['is_active'] == true || json['is_active'] == 1,
      autoRenew: json['auto_renew'] == true || json['auto_renew'] == 1,
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      isExpired:  json['is_expired'] == true || json['is_expired'] == 1,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'plan_id': planId,
        'start_date': startDate,
        'end_date': endDate,
        'is_active': isActive,
        'auto_renew': autoRenew,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'isExpired': isExpired,
      };
}
class SubscriptionBox {
  Box get _subscriptionBox {
    return Hive.box(Boxes.subscriptionBox); // Box plan_name from helper
  }

  SubscriptionModel get data {
    return _subscriptionBox.getAt(0);
  }


  List<SubscriptionModel> get items {
    return _subscriptionBox.values.cast<SubscriptionModel>().toList();
  }

  Future<void> insert(Map<String, dynamic> json) async {
    print("subscription json json : ${json}");
    final data = SubscriptionModel.fromJson(json);
    
    await _subscriptionBox.clear();
    await _subscriptionBox.add(data);
  }


  Future<void> insertAll(ResponseModel response) async {
     response.data.forEach((element) async {
        final data = SubscriptionModel.fromJson(element);
        await _subscriptionBox.put(data.id, data);
     });
  }

 

  int count() => _subscriptionBox.length;


  Future<void> update(SubscriptionModel plan) async {
    await _subscriptionBox.putAt(0, plan);
  }

  Future<void> clear() async => await _subscriptionBox.clear();

  String calculateDueDate(String startDateStr, int daysToAdd) {
    // Parse the string to DateTime
    DateTime startDate = DateTime.parse(startDateStr);

    // Add the duration
    DateTime dueDate = startDate.add(Duration(days: daysToAdd));

    // Format the due date to 'yyyy-MM-dd'
    return DateFormat('yyyy-MM-dd').format(dueDate);
  }

  bool get isEmpty => _subscriptionBox.isEmpty;
}