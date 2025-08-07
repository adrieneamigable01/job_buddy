import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:job_buddy/constants/api_constants.dart';
import 'package:job_buddy/cubit/profile/profile_cubit.dart';
import 'package:job_buddy/models/company_model.dart';
import 'package:job_buddy/models/response_model.dart';

import 'package:meta/meta.dart';
import 'package:job_buddy/services/api_service.dart';

part 'company_state.dart';

class CompanyCubit extends Cubit<CompanyState> {
  CompanyCubit() : super(CompanyInitial());

  final APIServiceRepo _apiServiceRepo = APIServiceRepo();

  final CompanyBox _CompanyBox = CompanyBox();

  clearBoxes() async {
    // await _userBox.clear(); 
  }

  
 createCompany({required Object payload}) async {
    emit(LoadingState(true));
   
    var response = await _apiServiceRepo.post(kCreateCompany,payload);

    ResponseModel responseModel = ResponseModel(json: response);
    
    if (!responseModel.isError) {
      await ProfileCubit().getProfile();
      emit(LoadingState(false));
      emit(SuccessState(responseModel.message, responseModel.isError));
    } else {
      emit(LoadingState(false));
      emit(FailureState(responseModel.message, responseModel.isError));
     
    }
  }
  
}
