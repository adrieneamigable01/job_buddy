import 'package:hive/hive.dart';
import 'package:job_buddy/helpers/hive_db_helper.dart';
import 'package:job_buddy/models/response_model.dart';

part 'experience_model.g.dart';

@HiveType(typeId: 10) // Ensure this typeId is unique across all your models
class ExperienceModel {
  @HiveField(0)
  dynamic experienceId;

  @HiveField(1)
  dynamic studentId;

  @HiveField(2)
  String? companyName;

  @HiveField(3)
  String? positionTitle;

  @HiveField(4)
  String? location;

  @HiveField(5)
  String? skills;

  @HiveField(6)
  String? startDate; // Format: 'YYYY-MM-DD'

  @HiveField(7)
  String? endDate; // Format: 'YYYY-MM-DD'

  @HiveField(8)
  bool? isCurrent;

  @HiveField(9)
  String? description;

  @HiveField(10)
  String? createdAt;

  @HiveField(11)
  String? updatedAt;

  ExperienceModel({
    this.experienceId,
    this.studentId,
    this.companyName,
    this.positionTitle,
    this.location,
    this.skills,
    this.startDate,
    this.endDate,
    this.isCurrent,
    this.description,
    this.createdAt,
    this.updatedAt,
  });

  factory ExperienceModel.fromJson(Map<String, dynamic> json) {
    return ExperienceModel(
      experienceId: json['experience_id'],
      studentId: json['student_id'],
      companyName: json['company_name'],
      positionTitle: json['position_title'],
      location: json['location'],
      skills: json['skills'],
      startDate: json['start_date'],
      endDate: json['end_date'],
      isCurrent: json['is_current'] == true || json['is_current'] == "1",
      description: json['description'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() => {
        'experience_id': experienceId,
        'student_id': studentId,
        'company_name': companyName,
        'position_title': positionTitle,
        'location': location,
        'skills': skills,
        'start_date': startDate,
        'end_date': endDate,
        'is_current': isCurrent,
        'description': description,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };
}
class ExperienceBox {
  Box get _experienceBox {
    return Hive.box(Boxes.experienceBox); // Ensure 'experienceBox' is defined in your Boxes helper
  }

  ExperienceModel? getById(dynamic id) => _experienceBox.get(id);

  List<ExperienceModel> getByStudentId(dynamic id){
    return _experienceBox.values.where((element){
      print("exp : ${element.studentId} == ${id}");
      return element.studentId.toString() == id.toString();
    }).cast<ExperienceModel>().toList();
  }

  List<ExperienceModel> get items => _experienceBox.values.cast<ExperienceModel>().toList();

  int count() => _experienceBox.length;

  bool get isEmpty => _experienceBox.isEmpty;

  Future<void> insert(Map<String, dynamic> json) async {
    final data = ExperienceModel.fromJson(json);
    await _experienceBox.put(data.experienceId, data);
  }

  Future<void> insertAll(ResponseModel response) async {
    for (var element in response.data) {
      final data = ExperienceModel.fromJson(element);
      await _experienceBox.put(data.experienceId, data);
    }
  }

  Future<void> update(ExperienceModel experience) async {
    await _experienceBox.put(experience.experienceId, experience);
  }

  Future<void> clear() async => await _experienceBox.clear();
}
