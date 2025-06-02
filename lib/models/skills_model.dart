import 'package:hive/hive.dart';
import 'package:job_buddy/helpers/hive_db_helper.dart';
import 'package:job_buddy/models/response_model.dart';

part 'skills_model.g.dart';

@HiveType(typeId: 6) // Make sure this is unique
class SkillsModel {
  @HiveField(0)
  dynamic id;

  @HiveField(1)
  String? name;

  @HiveField(2)
  String? description;

  @HiveField(3)
  String? createdAt;

  @HiveField(4)
  String? updatedAt;

  SkillsModel({
    this.id,
    this.name,
    this.description,
    this.createdAt,
    this.updatedAt,
  });

  factory SkillsModel.fromJson(Map<String, dynamic> json) {
    return SkillsModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };
}

class SkillsBox {
  Box get _skillsBox {
    return Hive.box(Boxes.skillsBox); // define 'skillsBox' in your Boxes helper
  }

  List<SkillsModel> get items {
    return _skillsBox.values.cast<SkillsModel>().toList();
  }

  SkillsModel get data => _skillsBox.getAt(0);

  Future<void> insert(Map<String, dynamic> json) async {
    final data = SkillsModel.fromJson(json);
    await _skillsBox.put(data.id, data);
  }

  Future<void> insertAll(ResponseModel response) async {
    for (var element in response.data) {
      final data = SkillsModel.fromJson(element);
      await _skillsBox.put(data.id, data);
    }
  }

  Future<void> update(SkillsModel skill) async {
    await _skillsBox.put(skill.id, skill);
  }

  SkillsModel? getById(dynamic id) => _skillsBox.get(id);

  Future<void> clear() async => await _skillsBox.clear();

  int count() => _skillsBox.length;

  bool get isEmpty => _skillsBox.isEmpty;
}
