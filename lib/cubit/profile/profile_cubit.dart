import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:job_buddy/constants/api_constants.dart';
import 'package:job_buddy/models/company_model.dart';
import 'package:job_buddy/models/education_model.dart';
import 'package:job_buddy/models/employer_model.dart';
import 'package:job_buddy/models/experience_model.dart';
import 'package:job_buddy/models/response_model.dart';
import 'package:job_buddy/models/student_model.dart';
import 'package:job_buddy/models/subscription_model.dart';
import 'package:job_buddy/models/subscription_plan_model.dart';
import 'package:meta/meta.dart';

import 'package:job_buddy/services/api_service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:job_buddy/models/user_model.dart';
import 'package:device_info_plus/device_info_plus.dart';

part 'profile_state.dart';

final APIServiceRepo _apiServiceRepo = APIServiceRepo();
UserBox _userBox = UserBox();
SubscriptionBox _subscriptionBox = SubscriptionBox();
CompanyBox _companyBox = CompanyBox();
StudentBox _studentBox = StudentBox();
EmployerBox _employerBox = EmployerBox();
EducationBox _educationBox = EducationBox();
ExperienceBox _experienceBox = ExperienceBox();

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());

  
  getProfile() async {
    emit(LoadingProfileState(true));
    Map<String, dynamic> data = {};
    Object payload = {
      'user_id':_userBox.data.userId.toString()
    };
    var response = await _apiServiceRepo.post(kGetProfile,payload);
   
    ResponseModel responseModel = ResponseModel(json: response);
   

    if (!responseModel.isError) {
      await _userBox.updateProfile(
        newFirstName: responseModel.data['info'][0]['firstname']??'',
        newLastName: responseModel.data['info'][0]['lastname']??'',
        newMiddleName: responseModel.data['info'][0]['middlename']??'',
        newBirthDate: responseModel.data['info'][0]['birthdate']??'',
      );
      
      await _userBox.updateStatus(
        validationStatus: responseModel.data['validation_status'],
        validationDocumentPath: responseModel.data['validation_document']['document_type']??"",
        validationDocumentType: responseModel.data['validation_document']['document_path']??"",
      );
      // await _userBox.updateContact(
      //   mobile: responseModel.data['contact_info']['mobile']??'',
      //   email: responseModel.data['contact_info']['email']??'',
      // );
      print("responseModel.data['validation_status'] : ${responseModel.data['validation_status']}");
      print("responseModel.data['user_type'] : ${responseModel.data['user_type']}");
      print("responseModel.data['already_subscribe'] : ${responseModel.data['already_subscribe']}");
      if(responseModel.data['user_type'] == "employer"){
        var employer = responseModel.data['info'][0];
        await _employerBox.insert(employer);
        if(responseModel.data['subscription'].length > 0){
          _subscriptionBox.insert(responseModel.data['subscription'][0]);
        }
        if(responseModel.data['company'].length > 0){
          _companyBox.insert(responseModel.data['company'][0]);
        }
        await _userBox.updateSubscription(
          alreadySubscribe: responseModel.data['already_subscribe'],
        );
      }
      if(responseModel.data['user_type'] == "student"){
       
        var student = responseModel.data['info'][0];
        student["index"] = 1; 
        await _studentBox.insert(student);

        Map<String, dynamic> educationData = {
          'isError':'false',
          'message':'success',
          'data':responseModel.data['education'],
        };

        ResponseModel responseEducationModel = ResponseModel(json: educationData);
        await _educationBox.insertAll(responseEducationModel);

        Map<String, dynamic> experienceData = {
          'isError':'false',
          'message':'success',
          'data':responseModel.data['experience'],
        };
        ResponseModel responseExperienceModel = ResponseModel(json: experienceData);
        await _experienceBox.insertAll(responseExperienceModel);
      }
      emit(LoadingProfileState(false));
      emit(SuccessProfileState(responseModel.message, responseModel.isError));
    } else {
      emit(LoadingProfileState(false));
      emit(FailureProfileState(responseModel.message, responseModel.isError));
     
    }
  }
  updateStudentInfo({required Object payload}) async {
     print("Selecting subcription....");
    emit(LoadingProfileState(true));
   
    var response = await _apiServiceRepo.post(kUpdateStudentProfile,payload);

    ResponseModel responseModel = ResponseModel(json: response);
    
    if (!responseModel.isError) {
      await getProfile();
      emit(LoadingProfileState(false));
      emit(SuccessProfileState(responseModel.message, responseModel.isError));
    } else {
      emit(LoadingProfileState(false));
      emit(FailureProfileState(responseModel.message, responseModel.isError));
     
    }
  }
  getProfileCron() async {
    Object payload = {
      'user_id':_userBox.data.userId.toString()
    };
    var response = await _apiServiceRepo.post(kGetProfile,payload);
   
    ResponseModel responseModel = ResponseModel(json: response);
    if (!responseModel.isError) {
      await _userBox.updateProfile(
        newFirstName: responseModel.data['person_info']['first_name']??'',
        newLastName: responseModel.data['person_info']['last_name']??'',
        newMiddleName: responseModel.data['person_info']['middle_name']??'',
        newBirthDate: responseModel.data['person_info']['date_of_birth']??'',
      );
      await _userBox.updateContact(
        mobile: responseModel.data['contact_info']['mobile']??'',
        email: responseModel.data['contact_info']['email']??'',
      );
    }
  }


  // updateProfile(Object payload) async {
  //   emit(const LoadingProfileState(true));

  //   var response = await _apiServiceRepo.post(kUpdateProfile,payload);
   
  //   ResponseModel responseModel = ResponseModel(json: response);
  //   if (!responseModel.isError) {
  //     await _userBox.updateProfile(
  //       newFirstName: responseModel.data['person_info']['first_name']??'',
  //       newLastName: responseModel.data['person_info']['last_name']??'',
  //       newMiddleName: responseModel.data['person_info']['middle_name']??'',
  //       newBirthDate: responseModel.data['person_info']['date_of_birth']??'',
  //     );
  //     await _userBox.updateContact(
  //       mobile: responseModel.data['contact_info']['mobile']??'',
  //       email: responseModel.data['contact_info']['email']??'',
  //     );
  //     emit(const LoadingProfileState(false));
  //     emit(SuccessProfileState(responseModel.message, responseModel.isError));
  //   } else {
  //     emit(const LoadingProfileState(false));
  //     emit(FailureProfileState(responseModel.message, responseModel.isError));
     
  //   }
  // }

  // updateProfileImage(Object payload) async {
  //   emit(const LoadingUpdateImageState(true));

  //   var response = await _apiServiceRepo.post(kUpdateProfileImage,payload);
   
  //   ResponseModel responseModel = ResponseModel(json: response);
  //   if (!responseModel.isError) {
  //     await _userBox.updateImage(
  //       profileImage: responseModel.data['image']??'',
  //     );
  //     emit(const LoadingUpdateImageState(false));
  //     emit(SuccessUpdateImageProfileState(responseModel.message, responseModel.isError));
  //   } else {
  //     emit(const LoadingUpdateImageState(false));
  //     emit(FailureUpdateImageState(responseModel.message, responseModel.isError));
     
  //   }
  // }
  // getProfileImage() async {
  //   emit(const LoadingUpdateImageState(true));
  //   Object payload = {
  //     'user_id': _userBox.data.userId.toString()
  //   };
  //   var response = await _apiServiceRepo.post(kGetProfileImage,payload);
   
  //   ResponseModel responseModel = ResponseModel(json: response);
  //   if (!responseModel.isError) {
  //     await _userBox.updateImage(
  //       profileImage: responseModel.data['image']??'',
  //     );
  //     emit(const LoadingUpdateImageState(false));
  //     emit(SuccessUpdateImageProfileState(responseModel.message, responseModel.isError));
  //   } else {
  //     emit(const LoadingUpdateImageState(false));
  //     emit(FailureUpdateImageState(responseModel.message, responseModel.isError));
     
  //   }
  // }

  // changeImage(dynamic image){
  //   emit(SetProfileImage(image));
  // }
  

}
