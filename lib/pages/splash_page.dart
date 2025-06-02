import 'dart:async';
import 'package:go_router/go_router.dart';
// import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:job_buddy/constants/api_constants.dart';
import 'package:job_buddy/cubit/course/course_cubit.dart';
import 'package:job_buddy/cubit/joboffer/joboffer_cubit.dart';
import 'package:job_buddy/cubit/notification/notification_cubit.dart';
import 'package:job_buddy/cubit/profile/profile_cubit.dart';
import 'package:job_buddy/cubit/skills/skills_cubit.dart';
import 'package:job_buddy/cubit/subscription_plan/subscription_plan_cubit.dart';
import 'package:job_buddy/models/company_model.dart';
import 'package:job_buddy/models/experience_model.dart';
import 'package:job_buddy/models/joboffer_model.dart';
import 'package:job_buddy/models/response_model.dart';
import 'package:job_buddy/models/student_model.dart';
import 'package:job_buddy/models/subscription_model.dart';
import 'package:job_buddy/models/subscription_plan_model.dart';
import 'package:job_buddy/models/user_model.dart';
import 'package:job_buddy/services/api_service.dart';

JobofferCubit _jobofferCubit = JobofferCubit();
ProfileCubit _profileCubit = ProfileCubit();
SkillsCubit _skillsCubit = SkillsCubit();
SubscriptionPlanCubit _subscriptionPlanCubit = SubscriptionPlanCubit();
CourseCubit _courseCubit = CourseCubit();
NotificationCubit _notificationCubit = NotificationCubit();

class SplashPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SplashPageState();
  }
}


class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    _initialize();
    super.initState();
  }

   Future<void> _initialize() async {
   
    print("trigger splash");
    startTimer();
  }
///Circle2
  final spinkit = SpinKitThreeBounce(
    // duration: Duration(milliseconds: 2000),
    size: 50.0,
    itemBuilder: (_, int index) {
      return DecoratedBox(
        decoration: BoxDecoration(
          color: Color(0xff010609),
          shape: BoxShape.circle,
        ),
      );
    },
  );
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(child: Image.asset('assets/logo/splash-logo.png', width: 100, height: 100)),
            SizedBox(height: 5),
            Text("Loading please wait...."),
          ],
        ),
      ),
    );
  }

  void startTimer() {
    Timer(Duration(seconds: 3), () {
      checkToken(); //It will redirect  after 3 seconds
    });
  }

  _clearBoxes() async {
    await CompanyBox().clear();
    await JobOfferBox().clear();
    await SubscriptionPlanBox().clear();
    await SubscriptionBox().clear();
    await StudentBox().clear();
    await ExperienceBox().clear();
    await _courseCubit.clearBoxes();
  }
  

  Future checkToken() async {
    final APIServiceRepo _apiServiceRepo = APIServiceRepo();
    var response = await _apiServiceRepo.get(kCheckToken);
    print("response : $response");
    ResponseModel responseModel = ResponseModel(json: response);
    print("responseModel.isError : ${responseModel.isError}");
    if(responseModel.isError){
      await _clearBoxes();
      await _skillsCubit.getSkills();
      await _courseCubit.getCourses();
      context.go('/');return false;
    }else{
      await _clearBoxes();
      await _profileCubit.getProfile();
      await _jobofferCubit.getJobOffers();
      await _subscriptionPlanCubit.getSubsriptionPlan();
      await _skillsCubit.getSkills();
      await _courseCubit.getCourses();
      await _notificationCubit.getNotification();
      context.go('/dashboard');
    }
  }
  


  void navigateUser() async {
    context.go('/');
  }
}