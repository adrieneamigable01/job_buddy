const _kProductionDomain = '192.168.1.18';
const kProductionDomain = '192.168.1.18';

// const _kDevelopmentDomain = '192.168.1.26:8000';

const _kAPIDomain = _kProductionDomain;

const apiFolder = 'job_buddy_api_repo';

var kBuildNumber = "0.0.1";

// Auth
Uri kSubscriptionUrl =
    Uri.http(_kAPIDomain, '/$apiFolder/paypal/subscription/subscribe'); // Login

Uri kAuthLogin = Uri.http(_kAPIDomain, '/$apiFolder/auth/login'); // Login
Uri kAuthRegister =
    Uri.http(_kAPIDomain, '/$apiFolder/auth/register'); // register
Uri kSendResetPassword =
    Uri.http(_kAPIDomain, '/$apiFolder/auth/request_password_reset'); // logout
Uri kResetPasswordWithToken = Uri.http(
    _kAPIDomain, '/$apiFolder/auth/reset_password_with_token'); // logout
Uri kLogout = Uri.http(_kAPIDomain, '/$apiFolder/auth/logout'); // logout
Uri kCheckToken =
    Uri.http(_kAPIDomain, '/$apiFolder/user/checktoken'); // checktoken

Uri kUploadValidation =
    Uri.http(_kAPIDomain, '/$apiFolder/userdocuments/create'); // checktoken

Uri kUploadContract =
    Uri.http(_kAPIDomain, '/$apiFolder/contract/upload'); // checktoken

Uri kGetAppReview =
    Uri.http(_kAPIDomain, '/$apiFolder/appreview/get'); // checktoken
Uri kAddAppReview =
    Uri.http(_kAPIDomain, '/$apiFolder/appreview/create'); // checktoken

//Job Offers
Uri kGetJobOffers =
    Uri.http(_kAPIDomain, '/$apiFolder/joboffer/get'); // get joboffer
Uri kCreateJobOffers =
    Uri.http(_kAPIDomain, '/$apiFolder/joboffer/create'); // create joboffer
Uri kSendStudentOffer = Uri.http(
    _kAPIDomain, '/$apiFolder/joboffer/sendOffer'); // StudentJobOfferModelfer
Uri kStudentAcceptOffer = Uri.http(_kAPIDomain,
    '/$apiFolder/joboffer/acceptJobOffer'); // StudentJobOfferModelfer
Uri kStudentRejectOffer = Uri.http(_kAPIDomain,
    '/$apiFolder/joboffer/rejectJobOffer'); // StudentJobOfferModelfer

//User
Uri kGetProfile =
    Uri.http(_kAPIDomain, '/$apiFolder/user/profile'); // user profile
//Student
Uri kUpdateStudentProfile =
    Uri.http(_kAPIDomain, '/$apiFolder/student/update'); // student update

//Subscription Plans
Uri kGetSubscriptionPlans = Uri.http(
    _kAPIDomain, '/$apiFolder/subscriptionplan/get'); // subscription plan get

//Subscription
Uri kSubscribe = Uri.http(
    _kAPIDomain, '/$apiFolder/subscription/subscribe_free'); // subscribe

//Skills
Uri kGetSkills = Uri.http(_kAPIDomain, '/$apiFolder/skills/get'); // get skills

//Chat
Uri kGetChatThread =
    Uri.http(_kAPIDomain, '/$apiFolder/chat/getThreads'); // chat get threads
Uri kGetChatMessageThread = Uri.http(_kAPIDomain,
    '/$apiFolder/chat/getMessagesByThread'); // get message by thread
Uri kChatSendMessage =
    Uri.http(_kAPIDomain, '/$apiFolder/chat/sendMessage'); // chat send message
Uri kChatCreateThreadMessage =
    Uri.http(_kAPIDomain, '/$apiFolder/chat/createThread'); // create thread
Uri kChatMarkAsRead =
    Uri.http(_kAPIDomain, '/$apiFolder/chat/markAllAsRead'); // mark read

//Company
Uri kCreateCompany =
    Uri.http(_kAPIDomain, '/$apiFolder/company/create'); // create company
//Course
Uri kGetCourse = Uri.http(_kAPIDomain, '/$apiFolder/course/get'); // get courses

Uri kGetNotification =
    Uri.http(_kAPIDomain, '/$apiFolder/notification/get'); // get notification
//Education
Uri kCreateEducation =
    Uri.http(_kAPIDomain, '/$apiFolder/student/addEducation'); // add education
Uri kUpdateEducation = Uri.http(
    _kAPIDomain, '/$apiFolder/student/updateEducation'); // update education
//Experience
Uri kCreateExperience = Uri.http(
    _kAPIDomain, '/$apiFolder/student/addExperience'); // add experience
Uri kUpdateExperience = Uri.http(
    _kAPIDomain, '/$apiFolder/student/updateExperience'); // update experience
