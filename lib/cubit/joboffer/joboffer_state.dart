part of 'joboffer_cubit.dart';


@immutable
abstract class JobofferState extends Equatable {
  const JobofferState();

  @override
  List<Object> get props => [];
}

class JobofferInitial extends JobofferState {}

class LoadingState extends JobofferState {
  bool isLoading;

  LoadingState(this.isLoading);

  @override
  List<Object> get props => [isLoading];
}


class FailureState extends JobofferState {
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

class SuccessState extends JobofferState {
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
class SuccessSearchState extends JobofferState {
  bool isError;
  List<JobOfferModel> data;

  SuccessSearchState(this.isError,this.data);

  @override
  List<Object> get props => [isError];

}

