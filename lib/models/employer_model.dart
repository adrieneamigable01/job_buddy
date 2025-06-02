import 'package:hive/hive.dart';
import 'package:job_buddy/helpers/hive_db_helper.dart';
import 'package:job_buddy/models/response_model.dart';

part 'employer_model.g.dart';

@HiveType(typeId: 13) // Make sure this ID is unique among all your Hive models
class EmployerModel {
  @HiveField(0)
  dynamic employerId;

  @HiveField(1)
  String? lastname;

  @HiveField(2)
  String? firstname;

  @HiveField(3)
  String? middlename;

  @HiveField(4)
  String? userId;

  @HiveField(5)
  String? email;

  @HiveField(6)
  String? phone;

  @HiveField(7)
  String? address;

  @HiveField(8)
  String? birthdate;

  @HiveField(9)
  String? gender;

  @HiveField(10)
  String? status;

  @HiveField(11)
  bool? isActive;

  @HiveField(12)
  String? createdAt;

  @HiveField(13)
  String? updatedAt;

  @HiveField(14)
  String? deletedAt;

  EmployerModel({
    this.employerId,
    this.lastname,
    this.firstname,
    this.middlename,
    this.userId,
    this.email,
    this.phone,
    this.address,
    this.birthdate,
    this.gender,
    this.status,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory EmployerModel.fromJson(Map<String, dynamic> json) {
    return EmployerModel(
      employerId: json['employer_id'],
      lastname: json['lastname'],
      firstname: json['firstname'],
      middlename: json['middlename'],
      userId: json['user_id'],
      email: json['email'],
      phone: json['phone'],
      address: json['address'],
      birthdate: json['birthdate'],
      gender: json['gender'],
      status: json['status'],
      isActive: json['is_active'] == "1",
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      deletedAt: json['deleted_at'],
    );
  }

  Map<String, dynamic> toJson() => {
        'employer_id': employerId,
        'lastname': lastname,
        'firstname': firstname,
        'middlename': middlename,
        'user_id': userId,
        'email': email,
        'phone': phone,
        'address': address,
        'birthdate': birthdate,
        'gender': gender,
        'status': status,
        'is_active': isActive == true ? "1" : "0",
        'created_at': createdAt,
        'updated_at': updatedAt,
        'deleted_at': deletedAt,
      };
}

class EmployerBox {
  Box get _employerBox => Hive.box(Boxes.employerBox);

  List<EmployerModel> get items => _employerBox.values.cast<EmployerModel>().toList();

  Future<void> insert(Map<String, dynamic> json) async {
    final data = EmployerModel.fromJson(json);
    await _employerBox.put(data.employerId, data);
  }

   Future<void> insertAll(ResponseModel response) async {
    for (var element in response.data) {
      final data = EmployerModel.fromJson(element);
      await _employerBox.put(data.employerId, data);
    }
  }


  EmployerModel? getById(dynamic id) => _employerBox.get(id);

  Future<void> update(EmployerModel employer) async {
    await _employerBox.put(employer.employerId, employer);
  }

  Future<void> clear() async => await _employerBox.clear();

  bool get isEmpty => _employerBox.isEmpty;
}
