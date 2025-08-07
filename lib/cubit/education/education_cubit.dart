import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:job_buddy/constants/api_constants.dart';
import 'package:job_buddy/cubit/profile/profile_cubit.dart';
import 'package:job_buddy/models/education_model.dart';
import 'package:job_buddy/models/response_model.dart';

import 'package:meta/meta.dart';
import 'package:job_buddy/services/api_service.dart';

part 'education_state.dart';

class EducationCubit extends Cubit<EducationState> {
  EducationCubit() : super(EducationInitial());

  final APIServiceRepo _apiServiceRepo = APIServiceRepo();

  final EducationBox _EducationBox = EducationBox();

  clearBoxes() async {
    // await _userBox.clear(); 
  }

  
 createEducation({required Object payload}) async {
    emit(LoadingEducationState(true));
   
    var response = await _apiServiceRepo.post(kCreateEducation,payload);

    ResponseModel responseModel = ResponseModel(json: response);
    
    if (!responseModel.isError) {
      await ProfileCubit().getProfile();
      emit(LoadingEducationState(false));
      emit(SuccessEducationState(responseModel.message, responseModel.isError));
    } else {
      emit(LoadingEducationState(false));
      emit(FailureEducationState(responseModel.message, responseModel.isError));
     
    }
  }
  updateEducation({required Object payload}) async {
    emit(LoadingEducationState(true));
   
    var response = await _apiServiceRepo.post(kUpdateEducation,payload);

    ResponseModel responseModel = ResponseModel(json: response);
    
    if (!responseModel.isError) {
      await ProfileCubit().getProfile();
      emit(LoadingEducationState(false));
      emit(SuccessEducationState(responseModel.message, responseModel.isError));
    } else {
      emit(LoadingEducationState(false));
      emit(FailureEducationState(responseModel.message, responseModel.isError));
     
    }
  }
  
}
