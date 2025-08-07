import 'package:hive/hive.dart';
import 'package:job_buddy/helpers/hive_db_helper.dart';
import 'package:job_buddy/models/response_model.dart';

part 'education_model.g.dart';

@HiveType(typeId: 9) // Ensure this typeId is unique across all Hive models
class EducationModel {
  @HiveField(0)
  dynamic id;

  @HiveField(1)
  dynamic studentId;

  @HiveField(2)
  dynamic courseId;

  @HiveField(3)
  String? schoolName;

  @HiveField(4)
  String? degree;

  @HiveField(5)
  String? fieldOfStudy;

  @HiveField(6)
  String? startYear;

  @HiveField(7)
  String? endYear;

  @HiveField(8)
  String? grade;

  @HiveField(9)
  String? activities;

  @HiveField(10)
  String? description;

  @HiveField(11)
  String? createdAt;

  EducationModel({
    this.id,
    this.studentId,
    this.courseId,
    this.schoolName,
    this.degree,
    this.fieldOfStudy,
    this.startYear,
    this.endYear,
    this.grade,
    this.activities,
    this.description,
    this.createdAt,
  });

  factory EducationModel.fromJson(Map<String, dynamic> json) {
    return EducationModel(
      id: json['id'],
      studentId: json['student_id'],
      courseId: json['course_id'],
      schoolName: json['school_name'],
      degree: json['degree'],
      fieldOfStudy: json['field_of_study'],
      startYear: json['start_year'],
      endYear: json['end_year'],
      grade: json['grade'],
      activities: json['activities'],
      description: json['description'],
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'student_id': studentId,
        'course_id': courseId,
        'school_name': schoolName,
        'degree': degree,
        'field_of_study': fieldOfStudy,
        'start_year': startYear,
        'end_year': endYear,
        'grade': grade,
        'activities': activities,
        'description': description,
        'created_at': createdAt,
      };
}


class EducationBox {
  Box get _educationBox => Hive.box(Boxes.educationBox); // Define 'educationBox' in your HiveDBHelper

  EducationModel? getById(dynamic id) => _educationBox.get(id);

  List<EducationModel> getByStudentId(dynamic id){
    return _educationBox.values.where((element){
      print("element.studentId.toString() : ${element.studentId} == ${id}");
      return element.studentId.toString() == id.toString();
    }).cast<EducationModel>().toList();
  }

  List<EducationModel> get items => _educationBox.values.cast<EducationModel>().toList();

  Future<void> insert(Map<String, dynamic> json) async {
    final data = EducationModel.fromJson(json);
    await _educationBox.put(data.id, data);
  }

  Future<void> insertAll(ResponseModel response) async {
    for (var element in response.data) {
      final data = EducationModel.fromJson(element);
      await _educationBox.put(data.id, data);
    }
  }

  Future<void> update(EducationModel education) async {
    await _educationBox.put(education.id, education);
  }

  Future<void> clear() async => await _educationBox.clear();

  bool get isEmpty => _educationBox.isEmpty;
}
