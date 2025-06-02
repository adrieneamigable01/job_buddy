import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:job_buddy/models/app_review_model.dart';
import 'package:job_buddy/models/chat_thread_model.dart';
import 'package:job_buddy/models/company_model.dart';
import 'package:job_buddy/models/course_model.dart';
import 'package:job_buddy/models/education_model.dart';
import 'package:job_buddy/models/employer_model.dart';
import 'package:job_buddy/models/experience_model.dart';
import 'package:job_buddy/models/joboffer_model.dart';
import 'package:job_buddy/models/notification_model.dart';
import 'package:job_buddy/models/skills_model.dart';
import 'package:job_buddy/models/student_model.dart';
import 'package:job_buddy/models/subscription_model.dart';
import 'package:job_buddy/models/subscription_plan_model.dart';
import 'package:job_buddy/models/user_model.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;

///HiveDB Helper
///
/// A simple helper to centralize boxes initialization and adapter registrations.
class HiveDBHelper {
  ///Initializes the boxes and registers its corresponding adapters.
  Future openAndRegisterBoxes() async {
    if (kIsWeb) {
      await Hive.initFlutter();
    } else {
      final appDocumentDir =
          await pathProvider.getApplicationDocumentsDirectory();
      Hive.init(appDocumentDir.path);
    }

    Hive.registerAdapter(Adapters.userModelAdapter);
    Hive.registerAdapter(Adapters.jobOfferModelAdapter);
    Hive.registerAdapter(Adapters.subscriptionPlanModelAdapter);
    Hive.registerAdapter(Adapters.subscriptionModelAdapter);
    Hive.registerAdapter(Adapters.companyModelAdapter);
    Hive.registerAdapter(Adapters.skillsModelAdapter);
    Hive.registerAdapter(Adapters.studentModelAdapter);
    Hive.registerAdapter(Adapters.courseModelADapter);
    Hive.registerAdapter(Adapters.educationModelAdapter);
    Hive.registerAdapter(Adapters.experienceModelAdapter);
    Hive.registerAdapter(Adapters.chatThreadModelAdapter);
    Hive.registerAdapter(Adapters.notificationModelAdapter);
    Hive.registerAdapter(Adapters.employerModelAdapter);
    Hive.registerAdapter(Adapters.appReviewModelAdapter);

    await Hive.openBox(Boxes.userBox);
    await Hive.openBox(Boxes.jobOfferBox);
    await Hive.openBox(Boxes.subscriptionPlanBox);
    await Hive.openBox(Boxes.subscriptionBox);
    await Hive.openBox(Boxes.companyBox);
    await Hive.openBox(Boxes.skillsBox);
    await Hive.openBox(Boxes.studentBox);
    await Hive.openBox(Boxes.courseBox);
    await Hive.openBox(Boxes.educationBox);
    await Hive.openBox(Boxes.experienceBox);
    await Hive.openBox(Boxes.chatThreadBox);
    await Hive.openBox(Boxes.notificationBox);
    await Hive.openBox(Boxes.employerBox);
    await Hive.openBox(Boxes.appReviewBox);
  }

  ///Initializes the box and register its corresponding adapter.
  ///
  ///An optional method to open and register a single box and adapter.
  Future openAndRegisterBox(adapter, box) async {
    final appDocumentDir =
        await pathProvider.getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);
    
    Hive.registerAdapter(adapter);


    await Hive.openBox(box);
  }

  ///Closes all the boxes used in the app, may be called during app close.
  closeBoxes() {
    Hive.close();
  }

  Future truncateBoxes() async {
    await Hive.deleteFromDisk();
  }
}

///Static box list.
///
/// All box names must be declared here, box name and box variable must be the same.
class Boxes {
   static const String userBox             = 'userBox';
   static const String jobOfferBox         = 'jobOfferBox';
   static const String subscriptionPlanBox         = 'subscriptionPlanBox';
   static const String subscriptionBox         = 'subscriptionBox';
   static const String companyBox         = 'companyBox';
   static const String skillsBox         = 'skillsBox';
   static const String studentBox         = 'studentBox';
   static const String courseBox         = 'courseBox';
   static const String educationBox         = 'educationBox';
   static const String experienceBox         = 'experienceBox';
   static const String chatThreadBox         = 'chatThreadBox';
   static const String notificationBox         = 'notificationBox';
   static const String employerBox         = 'employerBox';
   static const String appReviewBox         = 'appReviewBox';
}

///Static adapter list.
///
/// Although hive supports primitives, maps and list types, still in order for us to insert custom objects
/// an adapter must be generated using the hive_generator plugin.
///
/// All adapters must be declared here, adapter class ***pascal case*** and adapter variable ***camel case***
/// must be of same name for intuitive declaration.
class Adapters {
  static final UserModelAdapter userModelAdapter  = UserModelAdapter();
  static final JobOfferModelAdapter jobOfferModelAdapter  = JobOfferModelAdapter();
  static final SubscriptionPlanModelAdapter subscriptionPlanModelAdapter  = SubscriptionPlanModelAdapter();
  static final SubscriptionModelAdapter subscriptionModelAdapter  = SubscriptionModelAdapter();
  static final CompanyModelAdapter companyModelAdapter  = CompanyModelAdapter();
  static final SkillsModelAdapter skillsModelAdapter  = SkillsModelAdapter();
  static final StudentModelAdapter studentModelAdapter  = StudentModelAdapter();
  static final CourseModelAdapter courseModelADapter  = CourseModelAdapter();
  static final EducationModelAdapter educationModelAdapter  = EducationModelAdapter();
  static final ExperienceModelAdapter experienceModelAdapter  = ExperienceModelAdapter();
  static final ChatThreadModelAdapter chatThreadModelAdapter  = ChatThreadModelAdapter();
  static final NotificationModelAdapter notificationModelAdapter  = NotificationModelAdapter();
  static final EmployerModelAdapter employerModelAdapter  = EmployerModelAdapter();
  static final AppReviewModelAdapter appReviewModelAdapter  = AppReviewModelAdapter();


}