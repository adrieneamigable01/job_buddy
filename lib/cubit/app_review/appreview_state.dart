part of 'appreview_cubit.dart';


@immutable
abstract class AppReviewState extends Equatable {
  const AppReviewState();

  @override
  List<Object> get props => [];
}

class AppReviewInitial extends AppReviewState {}

class LoadingAppReviewState extends AppReviewState {
  bool isLoading;

  LoadingAppReviewState(this.isLoading);

  @override
  List<Object> get props => [isLoading];
}


class FailureAppReviewState extends AppReviewState {
  String errorMessage;
  bool isError;

  FailureAppReviewState(this.errorMessage, this.isError);

  @override
  List<Object> get props => [errorMessage, isError];

  @override
  String toString() {
    print("**** entication Failure State Message .... : ${errorMessage}");
    return errorMessage;
  }
}

class SuccessAppReviewState extends AppReviewState {
  String successMessage;
  bool isError;

  SuccessAppReviewState(this.successMessage, this.isError);

  @override
  List<Object> get props => [successMessage, isError];

  @override
  String toString() {
    print("**** entication Success State Message .... : ${successMessage}");
    return successMessage;
  }
}
class SuccessAppReviewSearchState extends AppReviewState {
  bool isError;
  List<AppReviewModel> data;

  SuccessAppReviewSearchState(this.isError,this.data);

  @override
  List<Object> get props => [isError];

}

