import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:job_buddy/constants/api_constants.dart';
import 'package:job_buddy/models/joboffer_model.dart';
import 'package:job_buddy/models/response_model.dart';
import 'package:job_buddy/models/subscription_plan_model.dart';

import 'package:meta/meta.dart';
import 'package:job_buddy/services/api_service.dart';

part 'subscription_plan_state.dart';

class SubscriptionPlanCubit extends Cubit<SubscriptionPlanState> {
  SubscriptionPlanCubit() : super(SubscriptionPlanInitial());

  final APIServiceRepo _apiServiceRepo = APIServiceRepo();

  final SubscriptionPlanBox _subscriptionPlanBox = SubscriptionPlanBox();

  clearBoxes() async {
    // await _userBox.clear(); 
  }

  getSubsriptionPlan() async {
    var response = await _apiServiceRepo.get(kGetSubscriptionPlans);
    ResponseModel responseModel = ResponseModel(json: response);
    
    if (!responseModel.isError) {
      await clearBoxes();
      await _subscriptionPlanBox.insertAll(responseModel);
    } else {
      emit(LoadingState(false));
      emit(FailureState(responseModel.message, responseModel.isError));
     
    }
  }


  
}
