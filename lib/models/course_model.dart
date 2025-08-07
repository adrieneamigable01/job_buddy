import 'package:hive/hive.dart';
import 'package:job_buddy/helpers/hive_db_helper.dart';
import 'package:job_buddy/models/response_model.dart';

part 'course_model.g.dart';

@HiveType(typeId: 8) // Ensure this typeId is unique across your models
class CourseModel {
  @HiveField(0)
  dynamic courseId;

  @HiveField(1)
  String? courseName;

  @HiveField(2)
  String? createdAt;

  @HiveField(3)
  String? updatedAt;

  @HiveField(4)
  String? deletedAt;

  @HiveField(5)
  bool? isActive;

  CourseModel({
    this.courseId,
    this.courseName,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.isActive,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      courseId: json['course_id'],
      courseName: json['courses'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      deletedAt: json['deleted_at'],
      isActive: json['is_active'] == true || json['is_active'] == 1,
    );
  }

  Map<String, dynamic> toJson() => {
        'course_id': courseId,
        'courses': courseName,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'deleted_at': deletedAt,
        'is_active': isActive,
      };
}

class CourseBox {
  Box get _courseBox {
    return Hive.box(Boxes.courseBox); // Ensure 'courseBox' is defined in your Boxes helper
  }

  CourseModel get data {
    return _courseBox.getAt(0);
  }

  List<CourseModel> get items {
    return _courseBox.values.cast<CourseModel>().toList();
  }

  Future<void> insert(Map<String, dynamic> json) async {
    final data = CourseModel.fromJson(json);
    await _courseBox.put(data.courseId, data);
  }

  Future<void> insertAll(ResponseModel response) async {
    for (var element in response.data) {
      final data = CourseModel.fromJson(element);
      await _courseBox.put(data.courseId, data);
    }
  }

  int count() => _courseBox.length;

  CourseModel? getById(dynamic id) => _courseBox.get(id);

  CourseModel? getByCourseId(dynamic id){
    return _courseBox.values.where((element) => element.courseId == id).first;
  }

  Future<void> update(CourseModel course) async {
    await _courseBox.put(course.courseId, course);
  }

  Future<void> clear() async => await _courseBox.clear();

  bool get isEmpty => _courseBox.isEmpty;
}
