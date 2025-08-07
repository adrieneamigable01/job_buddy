import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:job_buddy/constants/api_constants.dart';
import 'package:job_buddy/cubit/profile/profile_cubit.dart';
import 'package:job_buddy/models/course_model.dart';
import 'package:job_buddy/models/response_model.dart';

import 'package:meta/meta.dart';
import 'package:job_buddy/services/api_service.dart';

part 'course_state.dart';

class CourseCubit extends Cubit<CourseState> {
  CourseCubit() : super(CourseInitial());

  final APIServiceRepo _apiServiceRepo = APIServiceRepo();

  final CourseBox _courseBox = CourseBox();

  clearBoxes() async {
    // await _userBox.clear(); 
  }

  
  getCourses() async {
    var response = await _apiServiceRepo.get(kGetCourse);
    ResponseModel responseModel = ResponseModel(json: response);
    
    if (!responseModel.isError) {
      await clearBoxes();
      await _courseBox.insertAll(responseModel);
    } else {
      emit(LoadingCourseState(false));
      emit(FailureCourseState(responseModel.message, responseModel.isError));
     
    }
  }
  
}
