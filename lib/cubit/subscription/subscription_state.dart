part of 'subscription_cubit.dart';


@immutable
abstract class SubscriptionState extends Equatable {
  const SubscriptionState();

  @override
  List<Object> get props => [];
}

class SubscriptionInitial extends SubscriptionState {}

class LoadingSubcriptionState extends SubscriptionState {
  bool isLoading;

  LoadingSubcriptionState(this.isLoading);

  @override
  List<Object> get props => [isLoading];
}


class FailureSubscriptionState extends SubscriptionState {
  String errorMessage;
  bool isError;

  FailureSubscriptionState(this.errorMessage, this.isError);

  @override
  List<Object> get props => [errorMessage, isError];

  @override
  String toString() {
    print("**** entication Failure State Message .... : ${errorMessage}");
    return errorMessage;
  }
}

class SuccessSubscriptionState extends SubscriptionState {
  String successMessage;
  bool isError;

  SuccessSubscriptionState(this.successMessage, this.isError);

  @override
  List<Object> get props => [successMessage, isError];

  @override
  String toString() {
    print("**** entication Success State Message .... : ${successMessage}");
    return successMessage;
  }
}
class SuccessSubscriptionSearchState extends SubscriptionState {
  bool isError;
  List<JobOfferModel> data;

  SuccessSubscriptionSearchState(this.isError,this.data);

  @override
  List<Object> get props => [isError];

}

