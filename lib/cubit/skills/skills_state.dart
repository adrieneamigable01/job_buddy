part of 'skills_cubit.dart';


@immutable
abstract class SkillsState extends Equatable {
  const SkillsState();

  @override
  List<Object> get props => [];
}

class SkillsInitial extends SkillsState {}

class LoadingState extends SkillsState {
  bool isLoading;

  LoadingState(this.isLoading);

  @override
  List<Object> get props => [isLoading];
}


class FailureState extends SkillsState {
  String errorMessage;
  bool isError;

  FailureState(this.errorMessage, this.isError);

  @override
  List<Object> get props => [errorMessage, isError];

  @override
  String toString() {
    print("**** entication Failure State Message .... : ${errorMessage}");
    return errorMessage;
  }
}

class SuccessState extends SkillsState {
  String successMessage;
  bool isError;

  SuccessState(this.successMessage, this.isError);

  @override
  List<Object> get props => [successMessage, isError];

  @override
  String toString() {
    print("**** entication Success State Message .... : ${successMessage}");
    return successMessage;
  }
}
class SuccessSearchState extends SkillsState {
  bool isError;
  List<SkillsModel> data;

  SuccessSearchState(this.isError,this.data);

  @override
  List<Object> get props => [isError];

}

