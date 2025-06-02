part of 'notification_cubit.dart';


@immutable
abstract class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object> get props => [];
}

class NotificationInitial extends NotificationState {}

class LoadingNotificationState extends NotificationState {
  bool isLoading;

  LoadingNotificationState(this.isLoading);

  @override
  List<Object> get props => [isLoading];
}


class FailureNotificationState extends NotificationState {
  String errorMessage;
  bool isError;

  FailureNotificationState(this.errorMessage, this.isError);

  @override
  List<Object> get props => [errorMessage, isError];

  @override
  String toString() {
    print("**** entication Failure State Message .... : ${errorMessage}");
    return errorMessage;
  }
}

class NotificationLoadedState extends NotificationState {
  List<NotificationModel> updateds;

  NotificationLoadedState(this.updateds);

  @override
  List<Object> get props => [updateds];


}

class SuccessNotificationState extends NotificationState {
  String successMessage;
  bool isError;

  SuccessNotificationState(this.successMessage, this.isError);

  @override
  List<Object> get props => [successMessage, isError];

  @override
  String toString() {
    print("**** entication Success State Message .... : ${successMessage}");
    return successMessage;
  }
}

class HasNotificationData extends NotificationState {
  bool hasData;

  HasNotificationData(this.hasData);

  @override
  List<Object> get props => [hasData];
}
