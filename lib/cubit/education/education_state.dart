part of 'education_cubit.dart';


@immutable
abstract class EducationState extends Equatable {
  const EducationState();

  @override
  List<Object> get props => [];
}

class EducationInitial extends EducationState {}

class LoadingEducationState extends EducationState {
  bool isLoading;

  LoadingEducationState(this.isLoading);

  @override
  List<Object> get props => [isLoading];
}


class FailureEducationState extends EducationState {
  String errorMessage;
  bool isError;

  FailureEducationState(this.errorMessage, this.isError);

  @override
  List<Object> get props => [errorMessage, isError];

  @override
  String toString() {
    print("**** entication Failure EducationState Message .... : ${errorMessage}");
    return errorMessage;
  }
}

class SuccessEducationState extends EducationState {
  String successMessage;
  bool isError;

  SuccessEducationState(this.successMessage, this.isError);

  @override
  List<Object> get props => [successMessage, isError];

  @override
  String toString() {
    print("**** entication Success EducationState Message .... : ${successMessage}");
    return successMessage;
  }
}
class SuccessSearchEducationState extends EducationState {
  bool isError;
  List<EducationModel> data;

  SuccessSearchEducationState(this.isError,this.data);

  @override
  List<Object> get props => [isError];

}

