part of 'subscription_plan_cubit.dart';


@immutable
abstract class SubscriptionPlanState extends Equatable {
  const SubscriptionPlanState();

  @override
  List<Object> get props => [];
}

class SubscriptionPlanInitial extends SubscriptionPlanState {}

class LoadingState extends SubscriptionPlanState {
  bool isLoading;

  LoadingState(this.isLoading);

  @override
  List<Object> get props => [isLoading];
}


class FailureState extends SubscriptionPlanState {
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

class SuccessState extends SubscriptionPlanState {
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
class SuccessSearchState extends SubscriptionPlanState {
  bool isError;
  List<JobOfferModel> data;

  SuccessSearchState(this.isError,this.data);

  @override
  List<Object> get props => [isError];

}

