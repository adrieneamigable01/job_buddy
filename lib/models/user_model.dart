import 'package:hive/hive.dart';

import '../helpers/hive_db_helper.dart';

part 'user_model.g.dart';

///HiveDB Annotation
///
/// This annotation is use for the hive_generator plugin to generate an adapter.
/// Type id must be unique and hive field indexes can start from 0-223.
@HiveType(typeId: 0)
class UserModel {
  @HiveField(0)
  dynamic userId;
  @HiveField(1)
  String? studentid;
  @HiveField(2)
  dynamic employerid;
  @HiveField(3)
  String? lastname;
  @HiveField(4)
  String? firstname;
  @HiveField(5)
  String? middlename;
  @HiveField(6)
  dynamic email;
  @HiveField(7)
  dynamic phone;
  @HiveField(8)
  String? address;
  @HiveField(9)
  String? birthdate;
  @HiveField(10)
  String? gender;
  @HiveField(11)
  dynamic isactive;
  @HiveField(12)
  String? createdat;
  @HiveField(13)
  String? updatedat;
  @HiveField(14)
  String? deletedat;
  @HiveField(15)
  String? usertype;
  @HiveField(16)
  String? accesstoken;
  @HiveField(17)
  String? profileImage;
  @HiveField(18)
  String? validationStatus;
  @HiveField(19)
  String? validationDocumentType;
  @HiveField(20)
  String? validationDocumentPath;
  @HiveField(21)
  bool? alreadySubscribe;

  UserModel({
    this.userId,
    this.studentid,
    this.employerid,
    this.lastname,
    this.firstname,
    this.middlename,
    this.email,
    this.phone,
    this.address,
    this.birthdate,
    this.gender,
    this.isactive,
    this.createdat,
    this.updatedat,
    this.deletedat,
    this.usertype,
    this.profileImage,
    this.validationStatus,
    this.validationDocumentType,
    this.validationDocumentPath,
    this.alreadySubscribe,
    String? accesstoken // Make this nullable in the constructor
  }) : accesstoken = accesstoken ?? '';

  UserModel.fromJson(Map<String, dynamic> json)
      : userId = json['user_id'],
        studentid = json['studentid'],
        employerid = json['employerid'],
        lastname = json['lastname'],
        firstname = json['firstname'],
        middlename = json['middlename'],
        email = json['email'],
        phone = json['phone'],
        address = json['address'],
        birthdate = json['birthdate'],
        gender = json['gender'],
        isactive = json['isactive'],
        createdat = json['createdat'],
        updatedat = json['updatedat'],
        deletedat = json['updatedat'],
        usertype = json['usertype'],
        profileImage = null,
        accesstoken = json['accessToken'],
        alreadySubscribe = json['already_subscribe'],
        validationDocumentType = json['validation_document_type'],
        validationDocumentPath = json['validation_document_path'],
        validationStatus = json['validation_status']??'';

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'studentid': studentid,
        'employerid': employerid,
        'lastname': lastname,
        'firstname': firstname,
        'middlename': middlename,
        'email': email,
        'phone': phone,
        'address': address,
        'birthdate': birthdate,
        'gender': gender,
        'isactive': isactive,
        'createdat': createdat,
        'updatedat': updatedat,
        'deletedat': deletedat,
        'usertype': usertype,
        'accesstoken':accesstoken,
        'profileImage':profileImage,
        'validationStatus':validationStatus,
        'validationDocumentType':validationDocumentType,
        'validationDocumentPath':validationDocumentPath,
        'alreadySubscribe':alreadySubscribe,
      };
}

///customer Box
///
/// This class handles the customer data crud operation to box.
class UserBox {
  Box get _userBox {
    return Hive.box(Boxes.userBox);
  }

  Future<void> insert(json) async {
    final data = UserModel.fromJson(json);
    await _userBox.clear();
    await _userBox.add(data);
  }

  int count({required String status}){
    return _userBox.values.where((element) => element.status == status).length;
  }

  UserModel get data {
    return _userBox.getAt(0);
  }

  Future<void> update(UserModel customerData) async {
    await _userBox.putAt(0, customerData);
  }

  Future<void> updateProfile({
    required String newFirstName, 
    required String newMiddleName, 
    required String newLastName, 
    required String newBirthDate,
  }) async {
    final user = _userBox.getAt(0) as UserModel; // Get the current user data

    // Create a new UserModel instance with updated firstName and lastName
    final updatedUser = UserModel(
      userId: user.userId,
      studentid: user.email,
      employerid: user.employerid,
      lastname: newLastName,
      firstname: newFirstName,
      middlename: newMiddleName,
      email: user.email,
      phone: user.phone, // Update the timestamp
      address: user.address, // Update firstName
      birthdate: user.birthdate,
      gender: user.gender, // Update lastName
      isactive: user.isactive,
      createdat: user.createdat,
      updatedat:user.updatedat,
      deletedat: user.deletedat,
      usertype: user.usertype,
      accesstoken: user.accesstoken,
      profileImage:user.profileImage,
      alreadySubscribe:user.alreadySubscribe,
      validationStatus:user.validationStatus,
      validationDocumentType:user.validationDocumentType,
      validationDocumentPath:user.validationDocumentPath,
    );

    // Save the updated user back to Hive
    await _userBox.putAt(0, updatedUser);
  }
  Future<void> updateSubscription({
    required bool alreadySubscribe
  }) async {
    final user = _userBox.getAt(0) as UserModel; // Get the current user data

    // Create a new UserModel instance with updated firstName and lastName
    final updatedUser = UserModel(
      userId: user.userId,
      studentid: user.email,
      employerid: user.employerid,
      lastname: user.lastname,
      firstname: user.firstname,
      middlename: user.middlename,
      email: user.email,
      phone: user.phone, // Update the timestamp
      address: user.address, // Update firstName
      birthdate: user.birthdate,
      gender: user.gender, // Update lastName
      isactive: user.isactive,
      createdat: user.createdat,
      updatedat:user.updatedat,
      deletedat: user.deletedat,
      usertype: user.usertype,
      accesstoken: user.accesstoken,
      profileImage:user.profileImage,
      alreadySubscribe:alreadySubscribe,
      validationStatus:user.validationStatus,
      validationDocumentType:user.validationDocumentType,
      validationDocumentPath:user.validationDocumentPath,
    );

    // Save the updated user back to Hive
    await _userBox.putAt(0, updatedUser);
  }

  Future<void> updateContact({
    required String mobile, 
    required String email, 
  }) async {
    final user = _userBox.getAt(0) as UserModel; // Get the current user data

    // Create a new UserModel instance with updated firstName and lastName
    final updatedUser = UserModel(


      userId: user.userId,
      studentid: user.email,
      employerid: user.employerid,
      lastname: user.lastname,
      firstname: user.firstname,
      middlename: user.middlename,
      email: email,
      phone: mobile, // Update the timestamp
      address: user.address, // Update firstName
      birthdate: user.birthdate,
      gender: user.gender, // Update lastName
      isactive: user.isactive,
      createdat: user.createdat,
      updatedat:user.updatedat,
      deletedat: user.deletedat,
      usertype: user.usertype,
      accesstoken: user.accesstoken,
      profileImage:user.profileImage,
      alreadySubscribe:user.alreadySubscribe,
      validationStatus:user.validationStatus,
      validationDocumentType:user.validationDocumentType,
      validationDocumentPath:user.validationDocumentPath,
    );

    // Save the updated user back to Hive
    await _userBox.putAt(0, updatedUser);
  }

 
 

  Future<void> updateStatus({
    required String validationStatus,
    required String validationDocumentPath,
    required String validationDocumentType,
  }) async {
    final user = _userBox.getAt(0) as UserModel; // Get the current user data

    // Create a new UserModel instance with updated firstName and lastName
    final updatedUser = UserModel(


      userId: user.userId,
      studentid: user.email,
      employerid: user.employerid,
      lastname: user.lastname,
      firstname: user.firstname,
      middlename: user.middlename,
      email: user.email,
      phone: user.phone, // Update the timestamp
      address: user.address, // Update firstName
      birthdate: user.birthdate,
      gender: user.gender, // Update lastName
      isactive: user.isactive,
      createdat: user.createdat,
      updatedat:user.updatedat,
      deletedat: user.deletedat,
      usertype: user.usertype,
      accesstoken: user.accesstoken,
      profileImage:user.profileImage,
      validationStatus:validationStatus,
      validationDocumentPath: validationDocumentPath,
      validationDocumentType: validationDocumentType,
      alreadySubscribe:user.alreadySubscribe
    );

    // Save the updated user back to Hive
    await _userBox.putAt(0, updatedUser);
  }

  


  Future<void> clear() async {
    await _userBox.clear();
  }

  bool get isEmpty {
    return _userBox.isEmpty;
  }
}