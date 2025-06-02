import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:job_buddy/constants/api_constants.dart';
import 'package:job_buddy/models/skills_model.dart';
import 'package:job_buddy/models/response_model.dart';

import 'package:meta/meta.dart';
import 'package:job_buddy/services/api_service.dart';

part 'skills_state.dart';

class SkillsCubit extends Cubit<SkillsState> {
  SkillsCubit() : super(SkillsInitial());

  final APIServiceRepo _apiServiceRepo = APIServiceRepo();

  final SkillsBox _skillsBox = SkillsBox();

  clearBoxes() async {
    // await _userBox.clear(); 
  }

  getSkills() async {
    var response = await _apiServiceRepo.get(kGetSkills);
    ResponseModel responseModel = ResponseModel(json: response);
    
    if (!responseModel.isError) {
      await clearBoxes();
      await _skillsBox.insertAll(responseModel);
    } else {
      emit(LoadingState(false));
      emit(FailureState(responseModel.message, responseModel.isError));
     
    }
  }

  
}
