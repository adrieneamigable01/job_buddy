import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_buddy/cubit/app_review/appreview_cubit.dart';
import 'package:job_buddy/cubit/auth/cubit/auth_cubit.dart';
import 'package:job_buddy/cubit/chat_threads/chat_cubit.dart';
import 'package:job_buddy/cubit/company/company_cubit.dart';
import 'package:job_buddy/cubit/course/course_cubit.dart';
import 'package:job_buddy/cubit/education/education_cubit.dart';
import 'package:job_buddy/cubit/experience/experience_cubit.dart';
import 'package:job_buddy/cubit/joboffer/joboffer_cubit.dart';
import 'package:job_buddy/cubit/profile/profile_cubit.dart';
import 'package:job_buddy/cubit/skills/skills_cubit.dart';
import 'package:job_buddy/cubit/subscription/subscription_cubit.dart';
import 'package:job_buddy/cubit/user_validation/user_validation_cubit.dart';

// Register all providers here
class BlocProviders {
  static List<BlocProvider> get() {
    return [
      BlocProvider<AuthCubit>(create: (context) => AuthCubit()),
      BlocProvider<ProfileCubit>(create: (context) => ProfileCubit()),
      BlocProvider<SubscriptionCubit>(create: (context) => SubscriptionCubit()),
      BlocProvider<JobofferCubit>(create: (context) => JobofferCubit()),
      BlocProvider<SkillsCubit>(create: (context) => SkillsCubit()),
      BlocProvider<CompanyCubit>(create: (context) => CompanyCubit()),
      BlocProvider<EducationCubit>(create: (context) => EducationCubit()),
      BlocProvider<ExperienceCubit>(create: (context) => ExperienceCubit()),
      BlocProvider<ChatCubit>(create: (context) => ChatCubit()),
      BlocProvider<UserValidationCubit>(create: (context) => UserValidationCubit()),
      BlocProvider<AppReviewCubit>(create: (context) => AppReviewCubit()),
      BlocProvider<CourseCubit>(create: (context) => CourseCubit()),
    ];
  }
}