import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:job_buddy/constants/api_constants.dart';
import 'package:job_buddy/cubit/profile/profile_cubit.dart';
import 'package:job_buddy/models/notification_model.dart';
import 'package:job_buddy/models/response_model.dart';

import 'package:meta/meta.dart';
import 'package:job_buddy/services/api_service.dart';

part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit() : super(NotificationInitial());

  final APIServiceRepo _apiServiceRepo = APIServiceRepo();

  final NotificationBox _notificationBox = NotificationBox();

  clearBoxes() async {
    await _notificationBox.clear(); 
  }

  getNotificationUpdated() async {
    final updateds = _notificationBox.items;

    print("updateds length : ${updateds.length}");
    emit(NotificationLoadedState(updateds)); // ⬅️ FINAL emit
  }

  
  getNotification() async {

    var response = await _apiServiceRepo.get(kGetNotification);
    ResponseModel responseModel = ResponseModel(json: response);

    if (!responseModel.isError) {
      await clearBoxes();
      await _notificationBox.insertAll(responseModel);
      final updateds = _notificationBox.items;

      print("updateds length : ${updateds.length}");
      emit(NotificationLoadedState(updateds)); // ⬅️ FINAL emit
    } else {
      emit(FailureNotificationState(responseModel.message, responseModel.isError));
    }

  }

  checkifHasNotificationItem(String Id) async {
    var Data = _notificationBox.getById(Id);
    emit(HasNotificationData(Data != null ? true : false));
  }
  
}
