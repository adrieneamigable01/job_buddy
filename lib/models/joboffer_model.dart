import 'package:hive/hive.dart';
import 'package:job_buddy/models/response_model.dart';

import '../helpers/hive_db_helper.dart';

part 'joboffer_model.g.dart';

///HiveDB Annotation
///
/// This annotation is use for the hive_generator plugin to generate an adapter.
/// Type id must be unique and hive field indexes can start from 0-223.
@HiveType(typeId: 1)
class JobOfferModel {
  @HiveField(0)
  dynamic jobOffersId;
  @HiveField(1)
  String? jobTitle;
  @HiveField(2)
  String? skills;
  @HiveField(3)
  String? location;
  @HiveField(4)
  dynamic minSalary;
  @HiveField(5)
  dynamic maxSalary;
  @HiveField(6)
  dynamic salaryRange;
  @HiveField(7)
  dynamic employerId;
  @HiveField(8)
  String? jobDescription;
  @HiveField(9)
  dynamic companyId;
  @HiveField(10)
  String? dateAdded;
  @HiveField(11)
  String? expiredAt;
  @HiveField(12)
  dynamic isActive;
  @HiveField(13)
  String? status;
  @HiveField(14)
  String? companyName;
  @HiveField(15)
  String? employmenType;
  @HiveField(16)
  String? companyOverview;
  @HiveField(17)
  String? qualifications;
   @HiveField(18)
  dynamic matchScore;
  @HiveField(19)
  String? matchReason;
  @HiveField(20)
  dynamic hasJobOffer;
  @HiveField(21)
  String? jobOfferStatus;
  @HiveField(23)
  String? contract;
  @HiveField(24)
  dynamic subscription;
 

  JobOfferModel({
    this.jobOffersId,
    this.jobTitle,
    this.skills,
    this.location,
    this.minSalary,
    this.maxSalary,
    this.salaryRange,
    this.employerId,
    this.jobDescription,
    this.companyId,
    this.dateAdded,
    this.expiredAt,
    this.isActive,
    this.status,
    this.companyName,
    this.employmenType,
    this.companyOverview,
    this.qualifications,
    this.matchScore,
    this.matchReason,
    this.hasJobOffer,
    this.jobOfferStatus,
    this.contract,
    this.subscription,

  });
  JobOfferModel.fromJson(Map<String, dynamic> json)
      : jobOffersId = json['job_offers_id'],
        jobTitle = json['job_title'],
        skills = json['skills'],
        location = json['location'],
        minSalary = json['min_salary'],
        maxSalary = json['max_salary'],
        salaryRange = json['salary_range'],
        employerId = json['employer_id'],
        jobDescription = json['job_description'],
        companyId = json['company_id'],
        dateAdded = json['date_added'],
        expiredAt = json['expired_at'],
        isActive = json['is_active'],
        status = json['status'],
        companyName = json['company_name'],
        employmenType = json['employment_type'],
        companyOverview = json['company_overview'],
        qualifications = json['qualifications'],
        matchScore = json['match_score'],
        matchReason = json['match_reason'],
        hasJobOffer = json['has_job_offer'],
        jobOfferStatus = json['job_offer_status'],
        contract = json['contract'],
        subscription = json['subscription'];

  Map<String, dynamic> toJson() => {
        'jobOffersId': jobOffersId,
        'jobTitle': jobTitle,
        'skills': skills,
        'location': location,
        'minSalary': minSalary,
        'maxSalary': maxSalary,
        'salaryRange': salaryRange,
        'employerId': employerId,
        'jobDescription': jobDescription,
        'companyId': companyId,
        'dateAdded': dateAdded,
        'expiredAt': expiredAt,
        'isActive': isActive,
        'status': status,
        'companyName': companyName,
        'employmenType': employmenType,
        'companyOverview': companyOverview,
        'qualifications': qualifications,
        'matchScore': matchScore,
        'matchReason': matchReason,
        'hasJobOffer': hasJobOffer,
        'jobOfferStatus': jobOfferStatus,
        'contract': contract,
        'subscription': subscription,
       
      };
}

///customer Box
///
/// This class handles the customer data crud operation to box.
class JobOfferBox {
  Box get _jobOfferBox {
    return Hive.box(Boxes.jobOfferBox);
  }

   List<JobOfferModel> get items {
    return _jobOfferBox.values.cast<JobOfferModel>().toList(); 
  }

  Future<void> insert(json) async {
    final data = JobOfferModel.fromJson(json);
    await _jobOfferBox.clear();
    await _jobOfferBox.add(data);
  }

   Future<void> insertAll(ResponseModel response) async {
     response.data.forEach((element) async {
        final data = JobOfferModel.fromJson(element);
        await _jobOfferBox.put(data.jobOffersId, data);
     });
  }

  List<JobOfferModel> search(String searchItem) {
    if (searchItem.trim().isEmpty) return [];

    String lowerSearchItem = searchItem.trim().toLowerCase();

    List<JobOfferModel> data = _jobOfferBox.values
        .cast<JobOfferModel>()
        .where((p) {
          String skills = p.skills?.toLowerCase() ?? "";
          String employmentType = p.employmenType?.toLowerCase() ?? "";
          String jobDescription = p.jobDescription?.toLowerCase() ?? "";
          String jobTitle = p.jobTitle?.toLowerCase() ?? "";
          String location = p.location?.toLowerCase() ?? "";
          String minSalaryStr = p.minSalary?.toString() ?? "";
          String maxSalaryStr = p.maxSalary?.toString() ?? "";

          return jobTitle.contains(lowerSearchItem) ||
                skills.contains(lowerSearchItem) ||
                employmentType.contains(lowerSearchItem) ||
                jobDescription.contains(lowerSearchItem) ||
                location.contains(lowerSearchItem) ||
                minSalaryStr.contains(lowerSearchItem) ||
                maxSalaryStr.contains(lowerSearchItem);
        })
        .toList();

    print("🔍 Filtered Data Length: ${data.length}");
    return data;
  }


  JobOfferModel? getById(dynamic id) => _jobOfferBox.get(id);

  int count({required String status}){
    return _jobOfferBox.values.where((element) => element.status == status).length;
  }
  
  int length(){
    return _jobOfferBox.isEmpty ? 0 : _jobOfferBox.values.length;
  }

  JobOfferModel get data {
    return _jobOfferBox.getAt(0);
  }

  Future<void> update(JobOfferModel customerData) async {
    await _jobOfferBox.putAt(0, customerData);
  }

  
  Future<void> clear() async {
    await _jobOfferBox.clear();
  }

  bool get isEmpty {
    return _jobOfferBox.isEmpty;
  }
}