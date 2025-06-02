part of 'experience_cubit.dart';


@immutable
abstract class ExperienceState extends Equatable {
  const ExperienceState();

  @override
  List<Object> get props => [];
}

class ExperienceInitial extends ExperienceState {}

class LoadingExperienceState extends ExperienceState {
  bool isLoading;

  LoadingExperienceState(this.isLoading);

  @override
  List<Object> get props => [isLoading];
}


class FailureExperienceState extends ExperienceState {
  String errorMessage;
  bool isError;

  FailureExperienceState(this.errorMessage, this.isError);

  @override
  List<Object> get props => [errorMessage, isError];

  @override
  String toString() {
    print("**** entication Failure ExperienceState Message .... : ${errorMessage}");
    return errorMessage;
  }
}

class SuccessExperienceState extends ExperienceState {
  String successMessage;
  bool isError;

  SuccessExperienceState(this.successMessage, this.isError);

  @override
  List<Object> get props => [successMessage, isError];

  @override
  String toString() {
    print("**** entication Success ExperienceState Message .... : ${successMessage}");
    return successMessage;
  }
}
class SuccessSearchExperienceState extends ExperienceState {
  bool isError;
  List<ExperienceModel> data;

  SuccessSearchExperienceState(this.isError,this.data);

  @override
  List<Object> get props => [isError];

}

