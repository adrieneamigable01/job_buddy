import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:job_buddy/constants/api_constants.dart';
import 'package:job_buddy/cubit/notification/notification_cubit.dart';
import 'package:job_buddy/models/education_model.dart';
import 'package:job_buddy/models/experience_model.dart';
import 'package:job_buddy/models/joboffer_model.dart';
import 'package:job_buddy/models/response_model.dart';
import 'package:job_buddy/models/student_model.dart';
import 'package:job_buddy/models/user_model.dart';

import 'package:meta/meta.dart';
import 'package:job_buddy/services/api_service.dart';

part 'joboffer_state.dart';

class JobofferCubit extends Cubit<JobofferState> {
  JobofferCubit() : super(JobofferInitial());

  final APIServiceRepo _apiServiceRepo = APIServiceRepo();
  final UserBox _userBox = UserBox();
  final JobOfferBox _jobOfferBox = JobOfferBox();
  final StudentBox _studentBox = StudentBox();
  final EducationBox _educationBox = EducationBox();
  final ExperienceBox _experienceBox = ExperienceBox();
  
  NotificationCubit _notificationCubit = NotificationCubit();

  clearBoxes() async {
    // await _userBox.clear(); 
    await _jobOfferBox.clear();
  }

  getJobOffers() async {
    var response = await _apiServiceRepo.get(kGetJobOffers);
    ResponseModel responseModel = ResponseModel(json: response);
    
    if (!responseModel.isError) {
      await clearBoxes();
      await _jobOfferBox.insertAll(responseModel);
      int i = 1;
      for (var jobOffer in responseModel.data) {
      
        Map<String, dynamic> data = {};
        
        // Only add candidates if the list is not empty



        if (_userBox.data.usertype == "employer") {
           
          print("jobOffer : ${jobOffer['job_offers_id']}");

          

          var candidates = jobOffer['candidates'];

          for (var candidate in candidates) {
            candidate['index'] = i;
            candidate['jobOffersId'] = jobOffer['job_offers_id'].toString();

          
            Map<String, dynamic> educationData = {
              'isError':'false',
              'message':'success',
              'data':candidate['education'],
            };

            ResponseModel responseEducationModel = ResponseModel(json: educationData);
            await _educationBox.insertAll(responseEducationModel);

            Map<String, dynamic> experienceData = {
              'isError':'false',
              'message':'success',
              'data':candidate['experience'],
            };
            ResponseModel responseExperienceModel = ResponseModel(json: experienceData);
            await _experienceBox.insertAll(responseExperienceModel);

            print("index: $i");
            print("candidate['index']: ${candidate['index']}");
            print("candidate['jobOffersId']: ${candidate['jobOffersId']}");

            i++;
          }

          print("candidates : $candidates");

          data['data'] = candidates;
          data['isError'] = false;
          data['message'] = "Success";
          ResponseModel responseStudentModel = ResponseModel(json: data);
          await _studentBox.insertAll(responseStudentModel);
          
        }
      }
      
     
    } else {
      emit(LoadingState(false));
      emit(FailureState(responseModel.message, responseModel.isError));
     
    }
  }

  createJobOffer({required Object payload}) async {
    print("Selecting subcription....");
    emit(LoadingState(true));
   
    var response = await _apiServiceRepo.post(kCreateJobOffers,payload);

    ResponseModel responseModel = ResponseModel(json: response);
    
    if (!responseModel.isError) {
      await getJobOffers();
      emit(LoadingState(false));
      emit(SuccessState(responseModel.message, responseModel.isError));
    } else {
      emit(LoadingState(false));
      emit(FailureState(responseModel.message, responseModel.isError));
     
    }
  }

  sendStudentOffer({required Object payload}) async {
    print("Selecting subcription....");
    emit(LoadingState(true));
   
    var response = await _apiServiceRepo.post(kSendStudentOffer,payload);

    ResponseModel responseModel = ResponseModel(json: response);
    
    if (!responseModel.isError) {
      await getJobOffers();
      await _notificationCubit.getNotification();
      emit(LoadingState(false));
      emit(SuccessState(responseModel.message, responseModel.isError));
    } else {
      emit(LoadingState(false));
      emit(FailureState(responseModel.message, responseModel.isError));
     
    }
  }
  studentAcceptOffer({required Object payload}) async {
    print("Selecting subcription....");
    emit(LoadingState(true));
   
    var response = await _apiServiceRepo.post(kStudentAcceptOffer,payload);

    ResponseModel responseModel = ResponseModel(json: response);
    
    if (!responseModel.isError) {
      await getJobOffers();
      await _notificationCubit.getNotification();
      emit(LoadingState(false));
      emit(SuccessState(responseModel.message, responseModel.isError));
    } else {
      emit(LoadingState(false));
      emit(FailureState(responseModel.message, responseModel.isError));
     
    }
  }
  studentRejectOffer({required Object payload}) async {
    print("Selecting subcription....");
    emit(LoadingState(true));
   
    var response = await _apiServiceRepo.post(kStudentRejectOffer,payload);

    ResponseModel responseModel = ResponseModel(json: response);
    
    if (!responseModel.isError) {
      await getJobOffers();
      await _notificationCubit.getNotification();
      emit(LoadingState(false));
      emit(SuccessState(responseModel.message, responseModel.isError));
    } else {
      emit(LoadingState(false));
      emit(FailureState(responseModel.message, responseModel.isError));
     
    }
  }

  void searchJobOffers(String searchItem) async {
  
    emit(LoadingState(true));
    await Future.delayed(Duration(seconds: 1));
    List<JobOfferModel> jobOfferSearch  = JobOfferBox().search(searchItem); 
    print("searchJobOffers.... : ${jobOfferSearch}");
    await Future.delayed(Duration(seconds: 1));
    emit(SuccessSearchState(true,jobOfferSearch));
    // emit(const LoadingState(false));
    
  }
  
}
