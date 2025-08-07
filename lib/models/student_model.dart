import 'package:hive/hive.dart';
import 'package:job_buddy/helpers/hive_db_helper.dart';
import 'package:job_buddy/models/response_model.dart';

part 'student_model.g.dart';

@HiveType(typeId: 7) // Make sure this is unique
class StudentModel {
  @HiveField(0)
  dynamic index;

  @HiveField(1)
  dynamic studentId;

  @HiveField(2)
  String? lastname;

  @HiveField(3)
  String? firstname;

  @HiveField(4)
  String? middlename;

  @HiveField(5)
  String? userId;

  @HiveField(6)
  String? email;

  @HiveField(7)
  String? phone;

  @HiveField(8)
  String? address;

  @HiveField(9)
  String? birthdate;

  @HiveField(10)
  String? gender;

  @HiveField(11)
  bool? isActive;

  @HiveField(12)
  String? skills;

  @HiveField(13)
  String? courseId;

  @HiveField(14)
  String? createdAt;

  @HiveField(15)
  String? updatedAt;

  @HiveField(16)
  String? deletedAt;

  @HiveField(17)
  String? status;

  @HiveField(18)
  String? prefereAvailableTime;

  @HiveField(19)
  String? employmentType;

  @HiveField(20)
  dynamic jobOffersId;

  @HiveField(21)
  dynamic courses;

   @HiveField(22)
  String? matchReason;

  @HiveField(23)
  dynamic matchScore;

  @HiveField(24)
  dynamic hasJobOffer;

  @HiveField(25)
  String? jobOfferStatus;

  @HiveField(26)
  String? contract;

  @HiveField(27)
  String? contractStatus;

  StudentModel({
    this.index,
    this.studentId,
    this.lastname,
    this.firstname,
    this.middlename,
    this.userId,
    this.email,
    this.phone,
    this.address,
    this.birthdate,
    this.gender,
    this.isActive,
    this.skills,
    this.courseId,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.status,
    this.prefereAvailableTime,
    this.employmentType,
    this.jobOffersId,
    this.courses,
    this.matchReason,
    this.matchScore,
    this.hasJobOffer,
    this.jobOfferStatus,
    this.contract,
    this.contractStatus,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      index: json['index'],
      studentId: json['student_id'],
      lastname: json['lastname'],
      firstname: json['firstname'],
      middlename: json['middlename'],
      userId: json['user_id'],
      email: json['email'],
      phone: json['phone'],
      address: json['address'],
      birthdate: json['birthdate'],
      gender: json['gender'],
      isActive: json['is_active'] == "1",
      skills: json['skills'],
      courseId: json['course_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      deletedAt: json['deleted_at'],
      status: json['status'],
      prefereAvailableTime: json['prefere_available_time'],
      employmentType: json['employment_type'],
      jobOffersId: json['jobOffersId'],
      courses: json['courses'],
      matchReason:json['match_reason'],
      matchScore:json['match_score'],
      hasJobOffer:json['has_job_offer'],
      jobOfferStatus:json['job_offer_status'],
      contract:json['contract'],
      contractStatus:json['contract_status'],
    );
  }

  Map<String, dynamic> toJson() => {
        'index': index,
        'student_id': studentId,
        'lastname': lastname,
        'firstname': firstname,
        'middlename': middlename,
        'user_id': userId,
        'email': email,
        'phone': phone,
        'address': address,
        'birthdate': birthdate,
        'gender': gender,
        'is_active': isActive == true ? "1" : "0",
        'skills': skills,
        'course_id': courseId,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'deleted_at': deletedAt,
        'status': status,
        'prefere_available_time': prefereAvailableTime,
        'employment_type': employmentType,
        'jobOffersId': jobOffersId,
        'courses': courses,
        'matchReason': matchReason,
        'matchScore': matchScore,
        'hasJobOffer': hasJobOffer,
        'jobOfferStatus': jobOfferStatus,
        'contract': contract,
        'contractStatus': contractStatus
      };
}

class StudentBox {
  Box get _studentBox {
    return Hive.box(Boxes.studentBox); // Box name should be declared in your helper
  }

  StudentModel get data {
    return _studentBox.getAt(0);
  }

  List<StudentModel> get items {
    return _studentBox.values.cast<StudentModel>().toList();
  }

  Future<void> insert(Map<String, dynamic> json) async {
    final data = StudentModel.fromJson(json);
    await _studentBox.put(data.studentId, data);
  }

  Future<void> insertAll(ResponseModel response) async {
    for (var element in response.data) {
      final data = StudentModel.fromJson(element);
      await _studentBox.put(data.index, data);
    }
  }

  int count() => _studentBox.length;

  StudentModel? getById(dynamic id) => _studentBox.get(id);

  StudentModel getByUserId(dynamic userId) {
    return _studentBox.values.where((element){
      print("element.userId : ${element.userId}");
      print("userId : ${userId}");
      return element.userId.toString() == userId.toString();
    }).first;
  }
  

  List<StudentModel> getByJobOfferId(dynamic jobOffersId) {
 
    if (jobOffersId == null) {
      return [];
    }
    print('_studentBox.values.length : ${_studentBox.values.length}');
    return _studentBox.values.cast<StudentModel>().where((element){
      print('element : $element');
      print("element.jobOffersId : ${element.jobOffersId}");
      print("jobOffersId : ${jobOffersId}");
      return element.jobOffersId.toString() == jobOffersId.toString();
    }).toList();
  }

  StudentModel getByStudentId(dynamic studentId) {
    return _studentBox.values.cast<StudentModel>().where((element){
      return element.studentId.toString() == studentId.toString();
    }).first;
  }


  Future<void> update(StudentModel student) async {
    await _studentBox.put(student.studentId, student);
  }

  Future<void> clear() async => await _studentBox.clear();

  bool get isEmpty => _studentBox.isEmpty;
}
