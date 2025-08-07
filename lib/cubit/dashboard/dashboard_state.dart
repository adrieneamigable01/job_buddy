part of 'dashboard_cubit.dart';

@immutable
abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object> get props => [];
}


class DashboardInitial extends DashboardState {}


class LoadingDashboardState extends DashboardState {
  final bool isLoading;

  const LoadingDashboardState(this.isLoading);

  @override
  List<Object> get props => [isLoading];
}

class FailureDashboardState extends DashboardState {
  final String errorMessage;
  final bool isError;

  const FailureDashboardState(this.errorMessage, this.isError);

  @override
  List<Object> get props => [errorMessage, isError];

  @override
  String toString() {
    print("**** Authentication Failure State Message .... : ${errorMessage}");
    return errorMessage;
  }
}

class SuccessLogoutState extends DashboardState {
  final String successMessage;
  final bool isError;

  const SuccessLogoutState(this.successMessage, this.isError);

  @override
  List<Object> get props => [successMessage, isError];

  @override
  String toString() {
    print("**** Success Link State Message .... : ${successMessage}");
    return successMessage;
  }
}

class SuccessState extends DashboardState {
  final String successMessage;
  final bool isError;

  const SuccessState(this.successMessage, this.isError);

  @override
  List<Object> get props => [successMessage, isError];

  @override
  String toString() {
    print("**** Success Link State Message .... : ${successMessage}");
    return successMessage;
  }
}

class SetDashboardIndex extends DashboardState {
  final int index;

  const SetDashboardIndex(this.index);

  @override
   List<Object> get props => [index];
}
