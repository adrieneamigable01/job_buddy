import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:job_buddy/constants/api_constants.dart';
import 'package:job_buddy/cubit/profile/profile_cubit.dart';
import 'package:job_buddy/models/app_review_model.dart';
import 'package:job_buddy/models/response_model.dart';

import 'package:meta/meta.dart';
import 'package:job_buddy/services/api_service.dart';

part 'appreview_state.dart';

class AppReviewCubit extends Cubit<AppReviewState> {
  AppReviewCubit() : super(AppReviewInitial());

  final APIServiceRepo _apiServiceRepo = APIServiceRepo();
  AppReviewBox appReviewBox = AppReviewBox();

  clearBoxes() async {
    await appReviewBox.clear(); 
  }

  getAppReview() async {

    var response = await _apiServiceRepo.get(kGetAppReview);
    ResponseModel responseModel = ResponseModel(json: response);

    if (!responseModel.isError) {
      await clearBoxes();
      await appReviewBox.insertAll(responseModel.data);
      final updateds = appReviewBox.items;

      print("updateds length : ${updateds.length}");
      emit(SuccessAppReviewState(responseModel.message, responseModel.isError));
    } else {
      emit(FailureAppReviewState(responseModel.message, responseModel.isError));
    }

  }
  
 createAppReview({required Object payload}) async {
    emit(LoadingAppReviewState(true));
   
    var response = await _apiServiceRepo.post(kAddAppReview,payload);

    ResponseModel responseModel = ResponseModel(json: response);
    
    if (!responseModel.isError) {
      emit(LoadingAppReviewState(false));
      emit(SuccessAppReviewState(responseModel.message, responseModel.isError));
    } else {
      emit(LoadingAppReviewState(false));
      emit(FailureAppReviewState(responseModel.message, responseModel.isError));
     
    }
  }
  
}
