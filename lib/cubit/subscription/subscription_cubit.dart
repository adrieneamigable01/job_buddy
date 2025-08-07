import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:job_buddy/constants/api_constants.dart';
import 'package:job_buddy/cubit/profile/profile_cubit.dart';
import 'package:job_buddy/models/joboffer_model.dart';
import 'package:job_buddy/models/response_model.dart';
import 'package:job_buddy/models/subscription_model.dart';

import 'package:meta/meta.dart';
import 'package:job_buddy/services/api_service.dart';

part 'subscription_state.dart';

class SubscriptionCubit extends Cubit<SubscriptionState> {
  SubscriptionCubit() : super(SubscriptionInitial());

  final APIServiceRepo _apiServiceRepo = APIServiceRepo();

  final SubscriptionBox _subscriptionBox = SubscriptionBox();
  final ProfileCubit _profileCubit = ProfileCubit();

  clearBoxes() async {
    // await _userBox.clear(); 
  }

  subscribe({required dynamic plan_id}) async {
    print("Selecting subcription.... plan id ${plan_id}");
    emit(LoadingSubcriptionState(true));
    Object payload = {
      'plan_id':plan_id,
    };

    var response = await _apiServiceRepo.post(kSubscribe,payload);

    ResponseModel responseModel = ResponseModel(json: response);
    
    if (!responseModel.isError) {
      await clearBoxes();
      await _profileCubit.getProfile();
      emit(LoadingSubcriptionState(false));
      emit(SuccessSubscriptionState(responseModel.message, responseModel.isError));
    } else {
      emit(LoadingSubcriptionState(false));
      emit(FailureSubscriptionState(responseModel.message, responseModel.isError));
     
    }
  }


  
}
