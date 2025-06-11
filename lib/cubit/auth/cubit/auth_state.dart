part of 'auth_cubit.dart';

@immutable
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class LoadingAuthState extends AuthState {
  final bool isLoading;

  const LoadingAuthState(this.isLoading);

  @override
  List<Object> get props => [isLoading];
}

class LogoutState extends AuthState {}

class FailureState extends AuthState {
  final String errorMessage;
  final bool isError;

  const FailureState(this.errorMessage, this.isError);

  @override
  List<Object> get props => [errorMessage, isError];

  @override
  String toString() {
    print("**** Authentication Failure State Message .... : ${errorMessage}");
    return errorMessage;
  }
}

class SuccessAuthState extends AuthState {
  String successMessage;
  bool isError;

  SuccessAuthState(this.successMessage, this.isError);

  @override
  List<Object> get props => [successMessage, isError];

  @override
  String toString() {
    print("**** Authentication Success State Message .... : ${successMessage}");
    return successMessage;
  }
}

class FailureLogoutState extends AuthState {
  String errorMessage;
  bool isError;

  FailureLogoutState(this.errorMessage, this.isError);

  @override
  List<Object> get props => [errorMessage, isError];

  @override
  String toString() {
    print("**** Authentication Failure State Message .... : ${errorMessage}");
    return errorMessage;
  }
}

class SuccessLogoutAuthState extends AuthState {
  String successMessage;
  bool isError;

  SuccessLogoutAuthState(this.successMessage, this.isError);

  @override
  List<Object> get props => [successMessage, isError];

  @override
  String toString() {
    print("**** Authentication Failure State Message .... : ${successMessage}");
    return successMessage;
  }
}

class LoadingLogoutState extends AuthState {
  bool isLoading;

  LoadingLogoutState(this.isLoading);

  @override
  List<Object> get props => [isLoading];
}

class SuccessForgotPasswordState extends AuthState {
  String successMessage;
  bool isError;

  SuccessForgotPasswordState(this.successMessage, this.isError);

  @override
  List<Object> get props => [successMessage, isError];

  @override
  String toString() {
    print("**** Authentication Success State Message .... : ${successMessage}");
    return successMessage;
  }
}

class FailureForgotPasswordState extends AuthState {
  final String errorMessage;
  final bool isError;

  const FailureForgotPasswordState(this.errorMessage, this.isError);

  @override
  List<Object> get props => [errorMessage, isError];

  @override
  String toString() {
    print("**** Authentication Failure State Message .... : ${errorMessage}");
    return errorMessage;
  }
}
