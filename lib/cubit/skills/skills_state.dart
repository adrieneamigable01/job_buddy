part of 'skills_cubit.dart';


@immutable
abstract class SkillsState extends Equatable {
  const SkillsState();

  @override
  List<Object> get props => [];
}

class SkillsInitial extends SkillsState {}

class LoadingSkillsState extends SkillsState {
  bool isLoading;

  LoadingSkillsState(this.isLoading);

  @override
  List<Object> get props => [isLoading];
}


class FailureSkillsState extends SkillsState {
  String errorMessage;
  bool isError;

  FailureSkillsState(this.errorMessage, this.isError);

  @override
  List<Object> get props => [errorMessage, isError];

  @override
  String toString() {
    print("**** entication Failure State Message .... : ${errorMessage}");
    return errorMessage;
  }
}

class SuccessSkillsState extends SkillsState {
  String successMessage;
  bool isError;

  SuccessSkillsState(this.successMessage, this.isError);

  @override
  List<Object> get props => [successMessage, isError];

  @override
  String toString() {
    print("**** entication Success State Message .... : ${successMessage}");
    return successMessage;
  }
}
class SuccessSearchSkillsState extends SkillsState {
  bool isError;
  List<SkillsModel> data;

  SuccessSearchSkillsState(this.isError,this.data);

  @override
  List<Object> get props => [isError];

}

