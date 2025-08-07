import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:job_buddy/constants/api_constants.dart';
import 'package:job_buddy/cubit/profile/profile_cubit.dart';
import 'package:job_buddy/models/response_model.dart';
import 'package:job_buddy/models/user_model.dart';

import 'package:meta/meta.dart';
import 'package:job_buddy/services/api_service.dart';

part 'user_validation_state.dart';

class UserValidationCubit extends Cubit<UserValidationState> {
  UserValidationCubit() : super(UserValidationThreadInitial());

  final APIServiceRepo _apiServiceRepo = APIServiceRepo();
  UserBox _userBox = UserBox();


  clearBoxes() async {
  }



  uploadUserValidation(Object payload) async {
    emit(LoadingUserValidationState(true)); // ⬅️ FINAL emit
    var response = await _apiServiceRepo.post(kUploadValidation,payload);
    ResponseModel responseModel = ResponseModel(json: response);

    if (!responseModel.isError) {
      emit(SuccessUserValidationState(responseModel.message,responseModel.isError)); 
      emit(LoadingUserValidationState(false)); // ⬅️ FINAL emit
    } else {
      emit(FailureUserValidationState(responseModel.message, responseModel.isError));
      emit(LoadingUserValidationState(false)); // ⬅️ FINAL emit
    }

  }

  
  
}
