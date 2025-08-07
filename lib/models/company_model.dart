import 'package:hive/hive.dart';
import 'package:job_buddy/helpers/hive_db_helper.dart';
import 'package:job_buddy/models/response_model.dart';

part 'company_model.g.dart';

@HiveType(typeId: 5) // Make sure this is unique and not same as others
class CompanyModel {
  @HiveField(0)
  dynamic companyId;

  @HiveField(1)
  String? companyName;

  @HiveField(2)
  String? companyAddress;

  @HiveField(3)
  String? contactNumber;

  @HiveField(4)
  String? email;

  @HiveField(5)
  String? establishedDate;

  @HiveField(6)
  bool? isActive;

  @HiveField(7)
  String? createdAt;

  @HiveField(8)
  String? updatedAt;

  @HiveField(9)
  String? companLogo;

  CompanyModel({
    this.companyId,
    this.companyName,
    this.companyAddress,
    this.contactNumber,
    this.email,
    this.establishedDate,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.companLogo
  });

  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
      companyId: json['company_id'],
      companyName: json['company_name'],
      companyAddress: json['company_address'],
      contactNumber: json['contact_number'],
      email: json['email'],
      establishedDate: json['established_date'],
      isActive: json['is_active'] == true || json['is_active'] == 1,
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      companLogo: json['company_logo'],
    );
  }

  Map<String, dynamic> toJson() => {
        'company_id': companyId,
        'company_name': companyName,
        'company_address': companyAddress,
        'contact_number': contactNumber,
        'email': email,
        'established_date': establishedDate,
        'is_active': isActive,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'company_logo': companLogo
      };
}

class CompanyBox {
  Box get _companyBox {
    return Hive.box(Boxes.companyBox); // Box name should be declared in your helper
  }

  CompanyModel get data {
    return _companyBox.getAt(0);
  }

  List<CompanyModel> get items {
    return _companyBox.values.cast<CompanyModel>().toList();
  }

  Future<void> insert(Map<String, dynamic> json) async {
    final data = CompanyModel.fromJson(json);
    await _companyBox.put(data.companyId, data);
  }

  Future<void> insertAll(ResponseModel response) async {
    for (var element in response.data) {
      final data = CompanyModel.fromJson(element);
      await _companyBox.put(data.companyId, data);
    }
  }

  int count() => _companyBox.length;

  CompanyModel? getById(dynamic id) => _companyBox.get(id);

  CompanyModel? getByCompanyId(String id){
    return _companyBox.values.where((element){
            print("thread?.companyId ${element.companyId}: ${id}");
      return element.companyId.toString() == id.toString();
    }).first;
  }

  Future<void> update(CompanyModel company) async {
    await _companyBox.put(company.companyId, company);
  }

  Future<void> clear() async => await _companyBox.clear();

  bool get isEmpty => _companyBox.isEmpty;
}