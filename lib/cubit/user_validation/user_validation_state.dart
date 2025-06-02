part of 'user_validation_cubit.dart';


@immutable
abstract class UserValidationState extends Equatable {
  const UserValidationState();

  @override
  List<Object> get props => [];
}

class UserValidationThreadInitial extends UserValidationState {}

class LoadingUserValidationState extends UserValidationState {
  bool isLoading;

  LoadingUserValidationState(this.isLoading);

  @override
  List<Object> get props => [isLoading];
}

class SuccessUserValidationState extends UserValidationState {
  String successMessage;
  bool isError;

  SuccessUserValidationState(this.successMessage, this.isError);

  @override
  List<Object> get props => [successMessage, isError];

  @override
  String toString() {
    print("**** entication Success State Message .... : ${successMessage}");
    return successMessage;
  }
}

class FailureUserValidationState extends UserValidationState {
  String errorMessage;
  bool isError;

  FailureUserValidationState(this.errorMessage, this.isError);

  @override
  List<Object> get props => [errorMessage, isError];

  @override
  String toString() {
    print("**** entication Failure State Message .... : ${errorMessage}");
    return errorMessage;
  }
}

class HasUserValidationThreadData extends UserValidationState {
  bool hasData;

  HasUserValidationThreadData(this.hasData);

  @override
  List<Object> get props => [hasData];
}
