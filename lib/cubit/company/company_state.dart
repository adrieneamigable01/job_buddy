part of 'company_cubit.dart';


@immutable
abstract class CompanyState extends Equatable {
  const CompanyState();

  @override
  List<Object> get props => [];
}

class CompanyInitial extends CompanyState {}

class LoadingState extends CompanyState {
  bool isLoading;

  LoadingState(this.isLoading);

  @override
  List<Object> get props => [isLoading];
}


class FailureState extends CompanyState {
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

class SuccessState extends CompanyState {
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
class SuccessSearchState extends CompanyState {
  bool isError;
  List<CompanyModel> data;

  SuccessSearchState(this.isError,this.data);

  @override
  List<Object> get props => [isError];

}

