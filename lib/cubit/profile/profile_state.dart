part of 'profile_cubit.dart';

@immutable
abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

class ProfileInitial extends ProfileState {}

class LoadingProfileState extends ProfileState {
  bool isLoading;

  LoadingProfileState(this.isLoading);

  @override
  List<Object> get props => [isLoading];
}

class FailureProfileState extends ProfileState {
  String errorMessage;
  bool isError;

  FailureProfileState(this.errorMessage, this.isError);

  @override
  List<Object> get props => [errorMessage, isError];

  @override
  String toString() {
    print("**** Authentication Failure State Message .... : ${errorMessage}");
    return errorMessage;
  }
}


class SuccessProfileState extends ProfileState {
  String successMessage;
  bool isError;

  SuccessProfileState(this.successMessage, this.isError);

  @override
  List<Object> get props => [successMessage, isError];

  @override
  String toString() {
    print("**** Authentication Failure State Message .... : ${successMessage}");
    return successMessage;
  }
}




class LoadingUpdateImageState extends ProfileState {
  bool isLoading;

  LoadingUpdateImageState(this.isLoading);

  @override
  List<Object> get props => [isLoading];
}

class FailureUpdateImageState extends ProfileState {
  String errorMessage;
  bool isError;

  FailureUpdateImageState(this.errorMessage, this.isError);

  @override
  List<Object> get props => [errorMessage, isError];

  @override
  String toString() {
    print("**** Authentication Failure State Message .... : ${errorMessage}");
    return errorMessage;
  }
}


class SuccessUpdateImageProfileState extends ProfileState {
  String successMessage;
  bool isError;

  SuccessUpdateImageProfileState(this.successMessage, this.isError);

  @override
  List<Object> get props => [successMessage, isError];

  @override
  String toString() {
    print("**** Authentication Failure State Message .... : ${successMessage}");
    return successMessage;
  }
}



class SetProfileImage extends ProfileState {
  dynamic imageByte;

  SetProfileImage(this.imageByte);

  @override
  List<Object> get props => [imageByte];
 
}