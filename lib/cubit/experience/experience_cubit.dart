import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:job_buddy/constants/api_constants.dart';
import 'package:job_buddy/cubit/profile/profile_cubit.dart';
import 'package:job_buddy/models/experience_model.dart';
import 'package:job_buddy/models/response_model.dart';
import 'package:meta/meta.dart';
import 'package:job_buddy/services/api_service.dart';

part 'experience_state.dart';

class ExperienceCubit extends Cubit<ExperienceState> {
  ExperienceCubit() : super(ExperienceInitial());

  final APIServiceRepo _apiServiceRepo = APIServiceRepo();


  clearBoxes() async {
    // await _userBox.clear(); 
  }

  
 createExperience({required Object payload}) async {
    emit(LoadingExperienceState(true));
   
    var response = await _apiServiceRepo.post(kCreateExperience,payload);

    ResponseModel responseModel = ResponseModel(json: response);
    
    if (!responseModel.isError) {
      await ProfileCubit().getProfile();
      emit(LoadingExperienceState(false));
      emit(SuccessExperienceState(responseModel.message, responseModel.isError));
    } else {
      emit(LoadingExperienceState(false));
      emit(FailureExperienceState(responseModel.message, responseModel.isError));
     
    }
  }
  updateExperience({required Object payload}) async {
    emit(LoadingExperienceState(true));
   
    var response = await _apiServiceRepo.post(kUpdateExperience,payload);

    ResponseModel responseModel = ResponseModel(json: response);
    
    if (!responseModel.isError) {
      await ProfileCubit().getProfile();
      emit(LoadingExperienceState(false));
      emit(SuccessExperienceState(responseModel.message, responseModel.isError));
    } else {
      emit(LoadingExperienceState(false));
      emit(FailureExperienceState(responseModel.message, responseModel.isError));
     
    }
  }
  
}
