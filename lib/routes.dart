// Mobile Pages
import 'package:job_buddy/pages/auth/login.dart';
import 'package:job_buddy/pages/auth/registation.dart';
import 'package:job_buddy/pages/dashboard/addcompany.dart';
import 'package:job_buddy/pages/dashboard/addpost.dart';
import 'package:job_buddy/pages/dashboard/candidate_detail.dart';
import 'package:job_buddy/pages/dashboard/candidate_details.dart';
import 'package:job_buddy/pages/dashboard/chatinfo.dart';
import 'package:job_buddy/pages/dashboard/chatmessages.dart';
import 'package:job_buddy/pages/dashboard/dashboard.dart';
import 'package:job_buddy/pages/dashboard/jobpost_details.dart';
import 'package:job_buddy/pages/dashboard/newmessage.dart';
import 'package:job_buddy/pages/dashboard/notification_detail.dart';
import 'package:job_buddy/pages/dashboard/profile.dart';
import 'package:job_buddy/pages/dashboard/resume_page.dart';
import 'package:job_buddy/pages/dashboard/subscirption_plan.dart';
import 'package:job_buddy/pages/dashboard/subscription.dart';
import 'package:job_buddy/pages/dashboard/user_validation_form.dart';
import 'package:job_buddy/pages/dashboard/company_info.dart';
import 'package:job_buddy/pages/splash_page.dart';

//Imports
import 'package:go_router/go_router.dart';
import 'package:job_buddy/widgets/auth/forgot_password_mobile_portrait.dart';
import 'package:job_buddy/widgets/auth/reset_password_mobile_portrait.dart';
import 'package:job_buddy/widgets/dashboard/subscription_plan/mobile/subscription_result.dart';

// GoRouter configuration
final router = GoRouter(
  // initialLocation: '/mobile_add_store',
  initialLocation: '/splash',
  // initialLocation: '/dashboard_web',
  routes: <RouteBase>[
    GoRoute(path: '/', builder: (context, state) => LoginPage()),
    GoRoute(
        path: '/registration', builder: (context, state) => RegistrationPage()),
    GoRoute(
        path: '/forgot-password',
        builder: (context, state) => ForgotPasswordPage()),
    GoRoute(
        path: '/reset-password',
        builder: (context, state) => ResetPasswordMobilePortait()),
    GoRoute(path: '/dashboard', builder: (context, state) => DashboardPage()),
    GoRoute(path: '/profile', builder: (context, state) => ProfilePage()),
    GoRoute(
        path: '/subscription_plan',
        builder: (context, state) => SubscriptionPlanPage()),
    GoRoute(
        path: '/subscription', builder: (context, state) => SubscriptionPage()),
    GoRoute(path: '/add_post', builder: (context, state) => AddPostPage()),
    GoRoute(
        path: '/job_post_details',
        builder: (context, state) => JobPostDetailPage()),
    GoRoute(
        path: '/candidate_details',
        builder: (context, state) => CandidateDetailsPage()),
    GoRoute(
        path: '/candidate_detail',
        builder: (context, state) => CandidateDetailPage()),
    GoRoute(
        path: '/add_company', builder: (context, state) => AddCompanyPage()),
    GoRoute(path: '/resume_page', builder: (context, state) => ResumePage()),
    GoRoute(
        path: '/chatmessages', builder: (context, state) => ChatMessagesPage()),
    GoRoute(
        path: '/newmessages',
        builder: (context, state) => NewChatMessagesPage()),
    GoRoute(path: '/chatinfo', builder: (context, state) => ChatInfoPage()),
    GoRoute(
        path: '/notification_details',
        builder: (context, state) => NotificationDetailPage()),
    GoRoute(
        path: '/user_validation',
        builder: (context, state) => UserValidationPage()),
    GoRoute(
        path: '/company_info',
        builder: (context, state) => CompanyInfoPage()),
    GoRoute(
      path: '/subscription-result',
      builder: (context, state) {
        final status = state.queryParams['status'] ?? 'cancel';
        return SubscriptionResultPage(status: status);
      },
    ),
    GoRoute(
      path: '/splash',
      builder: (context, state) => SplashPage(),
    ),
  ],
);
