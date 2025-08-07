part of 'course_cubit.dart';


@immutable
abstract class CourseState extends Equatable {
  const CourseState();

  @override
  List<Object> get props => [];
}

class CourseInitial extends CourseState {}

class LoadingCourseState extends CourseState {
  bool isLoading;

  LoadingCourseState(this.isLoading);

  @override
  List<Object> get props => [isLoading];
}


class FailureCourseState extends CourseState {
  String errorMessage;
  bool isError;

  FailureCourseState(this.errorMessage, this.isError);

  @override
  List<Object> get props => [errorMessage, isError];

  @override
  String toString() {
    print("**** entication Failure CourseState Message .... : ${errorMessage}");
    return errorMessage;
  }
}

class SuccessCourseState extends CourseState {
  String successMessage;
  bool isError;

  SuccessCourseState(this.successMessage, this.isError);

  @override
  List<Object> get props => [successMessage, isError];

  @override
  String toString() {
    print("**** entication Success CourseState Message .... : ${successMessage}");
    return successMessage;
  }
}
class SuccessSearchCourseState extends CourseState {
  bool isError;
  List<CourseModel> data;

  SuccessSearchCourseState(this.isError,this.data);

  @override
  List<Object> get props => [isError];

}

