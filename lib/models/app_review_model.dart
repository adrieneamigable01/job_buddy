import 'package:hive/hive.dart';
import 'package:job_buddy/helpers/hive_db_helper.dart';

part 'app_review_model.g.dart';

@HiveType(typeId: 14) // Ensure this is a unique ID
class AppReviewModel {
  @HiveField(0)
  String? reviewId;

  @HiveField(1)
  String? userId;

  @HiveField(2)
  String? comment;

  @HiveField(3)
  int? rating;

  @HiveField(4)
  String? createdAt;

  @HiveField(5)
  String? username;

  AppReviewModel({
    this.reviewId,
    this.userId,
    this.comment,
    this.rating,
    this.createdAt,
    this.username,
  });

  factory AppReviewModel.fromJson(Map<String, dynamic> json) {
    return AppReviewModel(
      reviewId: json['review_id'],
      userId: json['user_id'],
      comment: json['comment'],
      rating: json['rating'],
      createdAt: json['created_at'],
      username: json['username'],
    );
  }

  Map<String, dynamic> toJson() => {
        'review_id': reviewId,
        'user_id': userId,
        'comment': comment,
        'rating': rating,
        'created_at': createdAt,
        'username': username,
      };
}

class AppReviewBox {
  Box get _box => Hive.box(Boxes.appReviewBox); // Define 'appReviewBox' in your Boxes helper

  AppReviewModel get data => _box.getAt(0);

  List<AppReviewModel> get items => _box.values.cast<AppReviewModel>().toList();

  Future<void> insert(Map<String, dynamic> json) async {
    final data = AppReviewModel.fromJson(json);
    await _box.put(data.reviewId, data);
  }

  Future<void> insertAll(List<dynamic> jsonList) async {
    for (var element in jsonList) {
      final data = AppReviewModel.fromJson(element);
      await _box.put(data.reviewId, data);
    }
  }

  int count() => _box.length;

  AppReviewModel? getById(String id) => _box.get(id);

  Future<void> update(AppReviewModel review) async {
    await _box.put(review.reviewId, review);
  }

  Future<void> clear() async => await _box.clear();

  bool get isEmpty => _box.isEmpty;
}
