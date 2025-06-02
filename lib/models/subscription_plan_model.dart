import 'package:hive/hive.dart';
import 'package:job_buddy/models/response_model.dart';
import 'package:job_buddy/models/subscription_model.dart';

import '../helpers/hive_db_helper.dart';

import 'package:intl/intl.dart';

part 'subscription_plan_model.g.dart';



@HiveType(typeId: 3) // Must be unique across your app
class SubscriptionPlanModel {
  @HiveField(0)
  dynamic id;

  @HiveField(1)
  String? planName;

  @HiveField(2)
  String? description;

  @HiveField(3)
  dynamic price;

  @HiveField(4)
  int? durationDays;

  @HiveField(5)
  int? maxCompanies;

  @HiveField(6)
  int? maxPosts;

  @HiveField(7)
  String? createdAt;

  @HiveField(8)
  String? planId;

  SubscriptionPlanModel({
    this.id,
    this.planName,
    this.description,
    this.price,
    this.durationDays,
    this.maxCompanies,
    this.maxPosts,
    this.createdAt,
    this.planId,
  });

  SubscriptionPlanModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        planId = json['plan_id'],
        planName = json['name'],
        description = json['description'],
        price = json['price'],
        durationDays = int.parse(json['duration_days']),
        maxCompanies = int.parse(json['max_companies']),
        maxPosts = int.parse(json['max_posts']),
        createdAt = json['created_at'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'planName': planName,
        'description': description,
        'price': price,
        'duration_days': durationDays,
        'max_companies': maxCompanies,
        'max_posts': maxPosts,
        'created_at': createdAt,
        'plan_id': planId,
      };
}


class SubscriptionPlanBox {
  Box get _subscriptionPlanBox {
    return Hive.box(Boxes.subscriptionPlanBox); // Box plan_name from helper
  }

  List<SubscriptionPlanModel> get items {
    return _subscriptionPlanBox.values.cast<SubscriptionPlanModel>().toList();
  }

  List<SubscriptionPlanModel> getSubscription(dynamic id) {
    if(_subscriptionPlanBox.isEmpty){
      return [];
    }
    return _subscriptionPlanBox.values.cast<SubscriptionPlanModel>().where((p) => p.planId.toString() == id).toList();
  }
  dynamic getMaxPost() {
    SubscriptionBox _subscriptionBox = SubscriptionBox();
   
    if(_subscriptionPlanBox.isEmpty || _subscriptionBox.isEmpty){
      return 0;
    }

     dynamic id = _subscriptionBox.data.planId;

    var maxpost =  _subscriptionPlanBox.values.cast<SubscriptionPlanModel>().where((p){
      return p.planId.toString() == id.toString();
    }).first.maxPosts;
    print("maxpost : $maxpost");
    return maxpost == 0 ? 'unlimited' : maxpost;
  }

  Future<void> insert(Map<String, dynamic> json) async {
    print("subscription json json : ${json}");
    final data = SubscriptionPlanModel.fromJson(json);
    
    await _subscriptionPlanBox.clear();
    await _subscriptionPlanBox.add(data);
  }


  Future<void> insertAll(ResponseModel response) async {
     response.data.forEach((element) async {
        final data = SubscriptionPlanModel.fromJson(element);
        print("subscription plan data : $element");
        await _subscriptionPlanBox.put(data.id, data);
     });
  }

  List<SubscriptionPlanModel> search(String searchItem) {
    if (searchItem.trim().isEmpty) return [];

    String query = searchItem.toLowerCase();
    return _subscriptionPlanBox.values
        .cast<SubscriptionPlanModel>()
        .where((p) =>
            (p.planName?.toLowerCase().contains(query) ?? false) ||
            (p.description?.toLowerCase().contains(query) ?? false) ||
            (p.price?.toString().contains(query) ?? false) ||
            (p.durationDays?.toString().contains(query) ?? false))
        .toList();
  }

  int count() => _subscriptionPlanBox.length;

  SubscriptionPlanModel get data => _subscriptionPlanBox.getAt(0);

  Future<void> update(SubscriptionPlanModel plan) async {
    await _subscriptionPlanBox.putAt(0, plan);
  }

  Future<void> clear() async => await _subscriptionPlanBox.clear();

  String calculateDueDate(String startDateStr, int daysToAdd) {
    // Parse the string to DateTime
    DateTime startDate = DateTime.parse(startDateStr);

    // Add the duration
    DateTime dueDate = startDate.add(Duration(days: daysToAdd));

    // Format the due date to 'yyyy-MM-dd'
    return DateFormat('yyyy-MM-dd').format(dueDate);
  }

  bool get isEmpty => _subscriptionPlanBox.isEmpty;
}