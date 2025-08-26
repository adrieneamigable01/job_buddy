import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:job_buddy/cubit/app_review/appreview_cubit.dart';
import 'package:job_buddy/cubit/chat_threads/chat_cubit.dart';
import 'package:job_buddy/cubit/dashboard/dashboard_cubit.dart';
import 'package:job_buddy/cubit/joboffer/joboffer_cubit.dart';
import 'package:job_buddy/cubit/profile/profile_cubit.dart';
import 'package:job_buddy/cubit/skills/skills_cubit.dart';
import 'package:job_buddy/models/chat_thread_model.dart';
import 'package:job_buddy/models/company_model.dart';
import 'package:job_buddy/models/joboffer_model.dart';
import 'package:job_buddy/models/notification_model.dart';
import 'package:job_buddy/models/student_model.dart';
import 'package:job_buddy/models/subscription_model.dart';
import 'package:job_buddy/models/subscription_plan_model.dart';
import 'package:job_buddy/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:job_buddy/widgets/auth/login_mobile_portrait.dart';
import 'package:job_buddy/widgets/common/cards_widget.dart';
import 'package:job_buddy/widgets/common/color.dart';
import 'package:job_buddy/widgets/common/textfield_widget.dart';
import 'package:job_buddy/widgets/dashboard/chat/chat_thread_mobile_portrait.dart';
import 'package:job_buddy/widgets/dashboard/notification/notification.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool isFirstLoadFlag = true;
final UserBox _userBox = UserBox();
final SubscriptionBox _subscriptionBox = SubscriptionBox();
TextEditingController _searchKey = TextEditingController(text: "All");
DashboardCubit _dashboardCubit = DashboardCubit();
JobofferCubit _jobofferCubit = JobofferCubit();
StudentBox _studentBox = StudentBox();
final CompanyBox _companyBox = CompanyBox();
var bookingid = null;

class DashboardMobilePortrait extends StatefulWidget {
  DashboardMobilePortrait({super.key});

  @override
  State<DashboardMobilePortrait> createState() =>
      _DashboardMobilePortraitState();
}

class _DashboardMobilePortraitState extends State<DashboardMobilePortrait> {
  final formKey = GlobalKey<FormState>();
  ScrollController _controller = ScrollController();
  final TextEditingController _searchJobController = TextEditingController();
  // final TextEditingController _departureDateController = TextEditingController();
  bool _isLoading = false;
  int _selectedIndex = 1;
  late Timer _timer;
  var fullDateFormat = DateFormat('EEEE, MMMM d, yyyy HH:mm:ss');
  String formattedDate = "";
  String phoneNumber = '';
  List<String> _options = ['Opon', 'Cebu'];
  late SharedPreferences _prefs;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> _initializeSharedPreferences() async {
    print('numberxxx initializeR');
    try {
      _prefs = await SharedPreferences.getInstance();
      // Load the stored value
      setState(() {
        String number = _prefs.getString('registerPhone') ?? 'No value';
        phoneNumber = number;
        print('numberxxx : $number');
      });
    } catch (e) {
      print('Error initializing shared preferences: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    // _initializeSharedPreferences();

    ChatCubit().getChatUpdatedTreads();

    // Start the periodic timer to trigger every 2 seconds
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      print('Triggering getChatTreads every 2 seconds');
      // You can add your condition here before triggering getChatTreads if needed
      context.read<ChatCubit>().getChatUpdatedTreads();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _onItemTapped(int index) {
      // if (index == 3) {
      //   BlocProvider.of<DashboardCubit>(context).logout();
      // } else {

      // }
      _dashboardCubit.setDashboardIndex(index);
    }

    String _getMaxPost() {
      return SubscriptionPlanBox().getMaxPost() == "unlimited"
          ? "${JobOfferBox().length()}"
          : "${JobOfferBox().length()} / ${SubscriptionPlanBox().getMaxPost()}";
    }

    void addRating() {
      showDialog(
        context: context,
        builder: (context) {
          double _rating = 0;
          final TextEditingController _commentController =
              TextEditingController();

          return StatefulBuilder(
            builder: (context, setState) {
              return BlocBuilder<AppReviewCubit, AppReviewState>(
                builder: (context, state) {
                  bool isLoadingReviewState = false;
                  if (state is LoadingAppReviewState) {
                    isLoadingReviewState = state.isLoading;
                  }
                  return AlertDialog(
                    title: Text('Leave a Review'),
                    content: Form(
                      key: formKey,
                      autovalidateMode: AutovalidateMode.disabled,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Star rating
                          RatingBar.builder(
                            initialRating: _rating,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {
                              if (!isLoadingReviewState) {
                                setState(() {
                                  _rating = rating;
                                });
                              }
                            },
                          ),
                          SizedBox(height: 20),
                          // Comment box
                          TextField(
                            controller: _commentController,
                            maxLines: 4,
                            readOnly: isLoadingReviewState,
                            decoration: InputDecoration(
                              hintText: 'Enter your review...',
                              border: OutlineInputBorder(),
                              fillColor:
                                  isLoadingReviewState ? Colors.grey : null,
                            ),
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => !isLoadingReviewState
                            ? Navigator.pop(context)
                            : null,
                        child: Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (isLoadingReviewState) {
                            return;
                          }

                          if (formKey.currentState!.validate()) {
                            Object payload = {
                              "rating": _rating,
                              "comment": _commentController.text
                            };
                            BlocProvider.of<AppReviewCubit>(context)
                                .createAppReview(payload: payload);
                          }
                        },
                        child:
                            Text(isLoadingReviewState ? 'Loading..' : 'Submit'),
                      ),
                    ],
                  );
                },
              );
            },
          );
        },
      );
    }

    void _showSelectionPopup({required String type}) async {
      final selectedValue = await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Select an $type'),
            content: SingleChildScrollView(
              child: ListBody(
                children: _options.map((String option) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context)
                          .pop(option); // Return selected option
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      margin: const EdgeInsets.symmetric(vertical: 4.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      alignment: Alignment.center, // Center the text
                      child: Text(
                        option,
                        textAlign:
                            TextAlign.center, // Center text inside container
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close without selection
                },
                child: Text('Cancel'),
              ),
            ],
          );
        },
      );

      // Update the selected value when a selection is made
    }

    _refresh() async {
      print("refreshing..");
      BlocProvider.of<ProfileCubit>(context).getProfile();
      BlocProvider.of<SkillsCubit>(context).getSkills();
    }

    return MultiBlocProvider(
      providers: [
        BlocProvider<DashboardCubit>.value(value: _dashboardCubit..loadData()),
        BlocProvider<JobofferCubit>.value(
            value: _jobofferCubit..searchJobOffers(_searchJobController.text)),
      ],
      child: RefreshIndicator(
        onRefresh: _refresh,
        child: SafeArea(
            child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: defaultBackgroundColor,
          appBar: AppBar(
            title: Row(
              children: [
                // Logo
                GestureDetector(
                  child: Image.asset('assets/logo/logo.png', height: 40),
                  onTap: () {
                    _scaffoldKey.currentState?.openDrawer();
                  }, // Open drawer on tap,
                ), // Replace with your logo asset
                SizedBox(width: 20),
                Spacer(),
                _subscriptionBox.isEmpty
                    ? _userBox.data.usertype == "student"
                        ? SizedBox()
                        : GestureDetector(
                            onTap: () {
                              // Your subscribe logic here
                              // ScaffoldMessenger.of(context).showSnackBar(
                              //   SnackBar(content: Text(_subscriptionPlanBox.data.planName.toString())),
                              // );
                              if (_subscriptionBox.isEmpty) {
                                context.go('/subscription_plan');
                              } else {
                                context.go('/subscription');
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 12),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFFFDF0B1),
                                    Color(0xFFF9C920)
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'Subscribe',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                    : Spacer(),
                Spacer(),
                // Notifications
                IconButton(
                  icon: Icon(Icons.notifications_outlined),
                  onPressed: () {
                    _dashboardCubit.setDashboardIndex(3);
                  },
                ),
                // User Profile
                IconButton(
                  icon: CircleAvatar(
                    backgroundImage: NetworkImage(
                        'https://picsum.photos/200/300'), // Replace with user profile image
                  ),
                  onPressed: () {
                    context.push('/profile');
                  },
                ),
              ],
            ),
            elevation: 0,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            automaticallyImplyLeading: false, // Hide the leading back button
          ),
          bottomNavigationBar: BlocBuilder<DashboardCubit, DashboardState>(
            builder: (context, state) {
              if (state is SetDashboardIndex) {
                if (state.index <= 4) {
                  _selectedIndex = state.index;
                }
                // chat_tread
              }

              return BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                backgroundColor: defaultBackgroundColor, //background color/b
                selectedFontSize: 10.0,
                unselectedFontSize: 10.0,
                iconSize: 30.0, // Adjust the size of the icons if needed
                items: <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.search),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: Image.asset(
                      'assets/logo/logo.png', // Replace with your image path
                      width: 40, // Adjust the size as needed
                      height: 40,
                    ),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.notifications),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.message_rounded),
                    label: '',
                  ),
                ],

                currentIndex: _selectedIndex,
                selectedItemColor: Color(0xffFFFFFF),
                unselectedItemColor: Color(0xffe6d2db),
                onTap: _onItemTapped,
              );
            },
          ),
          body: BlocBuilder<DashboardCubit, DashboardState>(
            builder: (context, state) {
              int index = 0;
              if (state is SetDashboardIndex) {
                index = state.index;
              }
              return SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.only(bottom: 10),
                  height: MediaQuery.of(context).size.height * .85, // Set the
                  child: Column(
                    children: [
                      Visibility(
                        visible: index == 0,
                        child: Expanded(
                          child: Stack(
                            children: [
                              Container(
                                height: MediaQuery.of(context).size.height,
                                child: Column(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(15),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 10.0),
                                          Align(
                                              alignment: Alignment.topLeft,
                                              child: Row(
                                                children: [
                                                  Text(
                                                    _userBox.data.usertype ==
                                                            "employer"
                                                        ? "Latest posts"
                                                        : 'Offers Received',
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    _userBox.data.usertype ==
                                                            "employer"
                                                        ? _getMaxPost()
                                                        : '',
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ],
                                              )),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: GridView.builder(
                                          controller: _controller,
                                          itemCount: JobOfferBox().items.length,
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                            childAspectRatio: 12.0 / 7.0,
                                            crossAxisCount: 1,
                                          ),
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return Container(
                                              padding: EdgeInsets.all(10),
                                              child: CardWidget().actionCard(
                                                onPressed: () async {
                                                  // Your action here
                                                  SharedPreferences prefs =
                                                      await SharedPreferences
                                                          .getInstance();

                                                  // Save skill (or any string, int, bool)
                                                  await prefs.setString(
                                                      'job_offers_id',
                                                      JobOfferBox()
                                                          .items[index]
                                                          .jobOffersId
                                                          .toString());
                                                  context
                                                      .go('/job_post_details');
                                                },
                                                padding: 0,
                                                context: context,
                                                widget: Container(
                                                  padding: EdgeInsets.all(10),
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                          Container(
                                                            child: const Center(
                                                              child: Image(
                                                                width: 30,
                                                                image: AssetImage(
                                                                    'assets/logo/logo.png'),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(width: 5),
                                                          Text(
                                                            'Job Buddy',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontSize: 10,
                                                                color: Color(
                                                                    0xff010609)),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.8,
                                                            padding:
                                                                EdgeInsets.all(
                                                                    20.0),
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  "${JobOfferBox().items[index].jobTitle} ( ${JobOfferBox().items[index].employmenType} )",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          13),
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  maxLines: 2,
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    const Icon(Icons.location_on_outlined, size: 14),
                                                                    const SizedBox(width: 5),
                                                                    Text(JobOfferBox().items[index]?.location.toString().toUpperCase() ??
                                                                        'N/A'.toString()),
                                                                  ],
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    const Icon(Icons.business , size: 14),
                                                                    const SizedBox(width: 5),
                                                                    Text(JobOfferBox().items[index]?.companyName.toString().toUpperCase() ??
                                                                        'N/A'.toString()),
                                                                  ],
                                                                ),
                                                                const SizedBox(height: 5),
                                                                Row(
                                                                  children: [
                                                                    const Icon(Icons.business_center_outlined, size: 14),
                                                                    const SizedBox(width: 5),
                                                                    Flexible(
                                                                      child: Text(JobOfferBox().items[index]?.skills ??
                                                                          'N/A'.toString(),
                                                                          overflow: TextOverflow.ellipsis,
                                                                          maxLines: 1,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    const Icon(Icons.access_time_outlined, size: 14),
                                                                    const SizedBox(width: 5),
                                                                    Text(' ${JobOfferBox().items[index]?.workStart ?? 'N/A'.toString()} : ${JobOfferBox().items[index]?.workEnd ?? 'N/A'.toString()}}'),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Align(
                                                            alignment: Alignment
                                                                .topCenter,
                                                            child: Icon(
                                                              Icons
                                                                  .bookmark_border_outlined,
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          }),
                                    ),
                                  ],
                                ),
                              ),

                              // Add Post Button Floating
                              // Add Post Button Floating
                              _userBox.data.usertype == "student"
                                  ? SizedBox()
                                  : Positioned(
                                      bottom: 20,
                                      right: 20,
                                      child: BlocBuilder<ProfileCubit,
                                          ProfileState>(
                                        builder: (context, state) {
                                          bool _isLoadingVerification = false;
                                          if (state is LoadingProfileState) {
                                            _isLoadingVerification =
                                                state.isLoading;
                                          }

                                          bool _canAddCompany = true;


                                          if (_subscriptionBox.isEmpty || _userBox.data.validationStatus != "Validated") {
                                            _canAddCompany = false;
                                          } else {
                                            final maxPost = SubscriptionPlanBox().getMaxPost();
                                            if (maxPost != "unlimited") {
                                              final max = int.tryParse(maxPost.toString()) ?? 0;
                                              if (JobOfferBox().items.length >= max) {
                                                _canAddCompany = false;
                                              }
                                            }
                                          }

                                          print("_canAddCompany: $_canAddCompany");

                                          
                                          
                                          return ElevatedButton(
                                            onPressed: () {
                                              // action to add post
                                              if(_isLoadingVerification) return;
                                              if (_subscriptionBox.isEmpty) {
                                                bool isExpired = false;
                                                final endDateString =
                                                    _subscriptionBox.data
                                                        .endDate; // e.g., "2025-07-01"
                                                if (endDateString != null) {
                                                  final endDate =
                                                      DateTime.tryParse(
                                                          endDateString);
                                                  if (endDate != null) {
                                                    isExpired =
                                                        endDate.isBefore(
                                                            DateTime.now());
                                                  }
                                                }

                                                if (isExpired) {
                                                  alertDialog.showConfirmDialog(
                                                      isError: true,
                                                      title:
                                                          'Subscription Expired',
                                                      content:
                                                          '"Your subscription already expired."',
                                                      onPressCancel: () {
                                                        Navigator.of(context)
                                                            .pop(); // Close the dialog
                                                      },
                                                      onPressedConfirm:
                                                          () async {
                                                        if (_subscriptionBox
                                                            .isEmpty) {
                                                          Navigator.of(context)
                                                              .pop(); // Close the dialog
                                                          context.go(
                                                              '/subscription_plan');
                                                        } else {
                                                          Navigator.of(context)
                                                              .pop(); // Close the dialog
                                                          context.go(
                                                              '/subscription');
                                                        }
                                                      },
                                                      context: context);
                                                  return;
                                                }
                                              }

                                              if (_userBox
                                                      .data.validationStatus !=
                                                  "Validated") {
                                                alertDialog.showConfirmDialog(
                                                  isError: true,
                                                  title: 'Account Incomplete',
                                                  content: _userBox.data
                                                              .validationStatus ==
                                                          "Need Validate"
                                                      ? "Update your validation?"
                                                      :  'You need to complete your verification before you can use this feature.',
                                                  onPressCancel: () {
                                                    Navigator.of(context)
                                                        .pop(); // Close the dialog
                                                  },
                                                  onPressedConfirm: () async {
                                                    Navigator.of(context)
                                                        .pop(); // Close the dialog
                                                    context.push(
                                                        '/user_validation');
                                                  },
                                                  context: context,
                                                );
                                                return;
                                              }

                                              if (SubscriptionPlanBox()
                                                      .getMaxPost() !=
                                                  "unlimited") {
                                                if (JobOfferBox()
                                                        .items
                                                        .length ==
                                                    SubscriptionPlanBox()
                                                        .getMaxPost()) {
                                                  alertDialog.showConfirmDialog(
                                                      isError: true,
                                                      title:
                                                          'Posting Limit Reached',
                                                      content:
                                                          '"You have reached the maximum number of allowed postings. Please upgrade your subscription to add more job posts."',
                                                      onPressCancel: () {
                                                        Navigator.of(context)
                                                            .pop(); // Close the dialog
                                                      },
                                                      onPressedConfirm:
                                                          () async {
                                                        if (_subscriptionBox
                                                            .isEmpty) {
                                                          Navigator.of(context)
                                                              .pop(); // Close the dialog
                                                          context.go(
                                                              '/subscription_plan');
                                                        } else {
                                                          Navigator.of(context)
                                                              .pop(); // Close the dialog
                                                          context.go(
                                                              '/subscription');
                                                        }
                                                      },
                                                      context: context);
                                                } else {
                                                  if (CompanyBox().isEmpty) {
                                                    alertDialog
                                                        .showConfirmDialog(
                                                      isError: true,
                                                      title: 'No Company Found',
                                                      content:
                                                          'You must add your company details before creating a job post.',
                                                      onPressCancel: () {
                                                        Navigator.of(context)
                                                            .pop(); // Close the dialog
                                                        context.push(
                                                            '/add_company');
                                                      },
                                                      onPressedConfirm:
                                                          () async {
                                                        Navigator.of(context)
                                                            .pop(); // Close the dialog
                                                        context.push(
                                                            '/add_company');
                                                      },
                                                      context: context,
                                                    );
                                                    return;
                                                  } else {
                                                    context.push('/add_post');
                                                  }
                                                }
                                              } else {
                                                if (CompanyBox().isEmpty) {
                                                  alertDialog.showConfirmDialog(
                                                    isError: true,
                                                    title: 'No Company Found',
                                                    content:
                                                        'You must add your company details before creating a job post.',
                                                    onPressCancel: () {
                                                      Navigator.of(context)
                                                          .pop(); // Close the dialog
                                                      context
                                                          .push('/add_company');
                                                    },
                                                    onPressedConfirm: () async {
                                                      Navigator.of(context)
                                                          .pop(); // Close the dialog
                                                      context
                                                          .push('/add_company');
                                                    },
                                                    context: context,
                                                  );
                                                  return;
                                                } else {
                                                  context.push('/add_post');
                                                }
                                              }
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: !_canAddCompany
                                                  ? Color(0xFFEDCDCD)
                                                  : Colors.blueAccent,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 20, vertical: 12),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                              ),
                                              elevation: 5,
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  "Post",
                                                  style: TextStyle(
                                                    color:_canAddCompany ? Colors.white : Colors.grey,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                SizedBox(width: 10),
                                                Container(
                                                  width: 30,
                                                  height: 30,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Icon(
                                                    Icons.add,
                                                    size: 20,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      ),
                      Visibility(
                        visible: index == 1,
                        child: Expanded(
                          child: Container(
                            height: MediaQuery.of(context).size.height,
                            child: Column(
                              children: [
                                Container(
                                  // margin: EdgeInsets.only(left: 20),
                                  padding: EdgeInsets.all(15),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TextFieldWidget().textWithBorder(
                                        labelText: 'Search a job',
                                        controller: _searchJobController,
                                        onChanged: (string) => {},
                                        onFieldSubmitted: (string) => {
                                          _jobofferCubit.searchJobOffers(
                                              _searchJobController.text)
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                Container(child:
                                    BlocBuilder<JobofferCubit, JobofferState>(
                                        builder: (context, state) {
                                  Widget widget = Text("...");
                                  List<JobOfferModel> datas = [];
                                  if (state is SuccessSearchState) {
                                    print("state.data1: ${state.data}");
                                    datas = state.data;

                                    if (datas.length > 0) {
                                      widget = Expanded(
                                          child: GridView.builder(
                                              controller: _controller,
                                              itemCount: datas.length,
                                              gridDelegate:
                                                  SliverGridDelegateWithFixedCrossAxisCount(
                                                childAspectRatio: 12.0 / 7.0,
                                                crossAxisCount: 1,
                                              ),
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return Container(
                                                  padding: EdgeInsets.all(10),
                                                  child:
                                                      CardWidget().actionCard(
                                                    onPressed: () {
                                                      // Your action here
                                                    },
                                                    padding: 0,
                                                    context: context,
                                                    widget: Container(
                                                      padding:
                                                          EdgeInsets.all(10),
                                                      child: Column(
                                                        children: [
                                                          Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: <Widget>[
                                                              Container(
                                                                child:
                                                                    const Center(
                                                                  child: Image(
                                                                    width: 30,
                                                                    image: AssetImage(
                                                                        'assets/logo/logo.png'),
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                  width: 5),
                                                              Text(
                                                                'Job Buddy',
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    fontSize:
                                                                        10,
                                                                    color: Color(
                                                                        0xff010609)),
                                                              ),
                                                            ],
                                                          ),
                                                          Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Container(
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.8, // 80% of the screen width
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            20.0),
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    // Removed the Expanded widget
                                                                    Text(
                                                                      "${datas[index].jobTitle} ( ${datas[index].employmenType} )",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              13),
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis, // Handle overflow
                                                                      maxLines:
                                                                          2, // Allow text to wrap to a maximum of 2 lines
                                                                    ),
                                                                    Text(
                                                                      "${datas[index].companyName}",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              8),
                                                                    ),
                                                                    SizedBox(
                                                                        height:
                                                                            10),
                                                                    Text(
                                                                      "${datas[index].employmenType}",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              9),
                                                                    ),
                                                                    Text(
                                                                      "${datas[index].location}",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              9),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Align(
                                                                alignment:
                                                                    Alignment
                                                                        .topCenter,
                                                                child: Icon(
                                                                  Icons
                                                                      .bookmark_border_outlined,
                                                                  color: Colors
                                                                      .grey,
                                                                ),
                                                              ),
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }));
                                    } else {
                                      widget = Container(
                                          padding: EdgeInsets.all(10),
                                          child: Align(
                                            child: Text(
                                                "#${_searchJobController.text}"),
                                            alignment: Alignment.centerLeft,
                                          ));
                                    }
                                  }

                                  if (state is LoadingState) {
                                    widget = Text("Loading please wait....");
                                  }

                                  return widget;
                                })),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                          visible: index == 2,
                          child: Expanded(
                              child: SingleChildScrollView(
                            child: BlocListener<AppReviewCubit, AppReviewState>(
                              listener: (context, state) {
                                if (state is SuccessAppReviewState) {
                                  alertDialog.showConfirmDialog(
                                      isError: false,
                                      title: 'Success',
                                      content: state.successMessage,
                                      onPressCancel: () {
                                        Navigator.of(context)
                                            .pop(); // Close the dialog
                                        context.push('/dashboard');
                                      },
                                      onPressedConfirm: () async {
                                        Navigator.of(context)
                                            .pop(); // Close the dialog
                                        context.push('/dashboard');
                                      },
                                      context: context);
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 30),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Title
                                    Text(
                                      'Contact Information',
                                      style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xffDB2222),
                                      ),
                                    ),
                                    SizedBox(height: 20),

                                    // Phone Number
                                    Row(
                                      children: [
                                        Icon(Icons.phone,
                                            color: Color(0xff4175FE)),
                                        SizedBox(width: 10),
                                        Text(
                                          '+63 920 355 1832',
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Color(0xff828282),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 20),

                                    // Email Address
                                    Row(
                                      children: [
                                        Icon(Icons.email,
                                            color: Color(0xff4175FE)),
                                        SizedBox(width: 10),
                                        Text(
                                          'jobbuddy@gmail.com',
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Color(0xff828282),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 20),

                                    // Physical Address
                                    Row(
                                      children: [
                                        Icon(Icons.location_on,
                                            color: Color(0xff4175FE)),
                                        SizedBox(width: 10),
                                        Flexible(
                                          child: Text(
                                            'Cebu City',
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Color(0xff828282),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 30),

                                    // Optional footer or other contact info
                                    Text(
                                      'Follow us on social media for updates:',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Icon(Icons.facebook,
                                            color: Color(0xff4175FE)),
                                        Text(' Face Book')
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Icon(FontAwesomeIcons.instagram,
                                            color: Color(0xff4175FE)),
                                        Text(' Instagram')
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Icon(FontAwesomeIcons.twitter,
                                            color: Color(0xff4175FE)),
                                        Text(' Twitter')
                                      ],
                                    ),

                                    SizedBox(height: 30),

                                    // App Review Button
                                    Center(
                                      child: ElevatedButton.icon(
                                        onPressed: () {
                                          addRating();
                                        },
                                        icon: Icon(Icons.rate_review),
                                        label: Text('Leave a Review'),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Color(0xff4175FE),
                                          foregroundColor: Colors.white,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 12),
                                          textStyle: TextStyle(fontSize: 16),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ))),
                      Visibility(
                          visible: index == 3,
                          child: Expanded(
                            child: ListView.builder(
                              itemCount: NotificationBox().items.length,
                              itemBuilder: (context, index) {
                                final item = NotificationBox().items[index];
                                return NotificationCard(
                                    notification:
                                        NotificationBox().items[index]);
                              },
                            ),
                          )),
                      Visibility(
                          visible: index == 4,
                          child: Expanded(
                              child: SingleChildScrollView(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 30),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Title
                                  Text(
                                    'Chat Messages',
                                    style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  BlocBuilder<ChatCubit, ChatState>(
                                    builder: (context, state) {
                                      if (state is LoadingChatThreadState &&
                                          state.isLoading) {
                                        return const CircularProgressIndicator();
                                      }

                                      if (state is ChatLoadedState) {
                                        print(
                                            "state.updatedThreads : ${state.updatedThreads.length}");
                                        return ChatThreadsWidget(
                                            threads: state.updatedThreads);
                                      }

                                      if (state is FailureChatThreadState) {
                                        return Text("Error");
                                      }

                                      return const Text("No threads to show.");
                                    },
                                  )
                                ],
                              ),
                            ),
                          ))),
                    ],
                  ),
                ),
              );
            },
          ),
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                    decoration: BoxDecoration(color: Color(0xFFEDCDCD)),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            const SizedBox(width: 20),
                            _userBox.data.profileImage == "" ||
                                    _userBox.data.profileImage == null
                                ? CircleAvatar(
                                    radius: 30,
                                    backgroundColor: Colors.white,
                                    child: Text(
                                      "${_userBox.data.firstname?[0] ?? ''}${_userBox.data.lastname?[0] ?? ''}",
                                      style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )
                                : ClipOval(
                                    child: Image.memory(
                                      base64.decode(
                                          _userBox.data.profileImage ?? ''),
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${_userBox.data.firstname ?? ''}  ${_userBox.data.lastname ?? ''}",
                                    style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                  Text(
                                    "${_userBox.data.email ?? ''}",
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  BlocBuilder<ProfileCubit, ProfileState>(
                                    builder: (context, state) {
                                      bool _isLoadingVerification = false;
                                      if (state is LoadingProfileState) {
                                        _isLoadingVerification =
                                            state.isLoading;
                                      }
                                      return Row(
                                        children: [
                                          const Icon(Icons.verified,
                                              color: Colors.white, size: 16),
                                          const SizedBox(width: 4),
                                          GestureDetector(
                                            onTap: () {
                                              if (_userBox
                                                      .data.validationStatus !=
                                                  "Validated") {
                                                context
                                                    .push('/user_validation');
                                              }
                                            },
                                            child: Container(
                                              child: _isLoadingVerification
                                                  ? Text(
                                                      "${_userBox.data
                                                                  .validationStatus}",
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 12,
                                                      ),
                                                    )
                                                  : Text(
                                                      _userBox.data
                                                                  .validationStatus !=
                                                              "Validated"
                                                          ? 'Unverified'
                                                          : '${_userBox.data
                                                                  .validationStatus}',
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 20),
                          ],
                        ),
                      ],
                    )),
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text('Profile'),
                  onTap: () {
                    // Handle tap
                    context.push('/profile');
                  },
                ),
                Visibility(
                    visible: _userBox.data.usertype == "employer" &&
                        !_companyBox.isEmpty,
                    child: ListTile(
                      leading: Icon(Icons.business),
                      title: Text(
                          'Company ( ${_companyBox.isEmpty ? '' : _companyBox.data.companyName} )'),
                      onTap: () {
                        // Handle tap
                        context.push('/company_info');
                      },
                    )),
                Visibility(
                    visible: _companyBox.isEmpty && _userBox.data.usertype == "employer",
                    child: ListTile(
                      leading: Icon(Icons.business),
                      title: Text('Add Company'),
                      onTap: () {
                        // Handle tap
                        context.push('/add_company');
                      },
                    )),
                Visibility(
                  visible: _userBox.data.usertype == "student",
                  child: ListTile(
                    leading: Icon(Icons.card_membership_outlined),
                    title: Text('My Resume'),
                    onTap: () async {
                      if (_userBox.data.validationStatus != "Validated") {
                        alertDialog.showConfirmDialog(
                          isError: true,
                          title: 'Account Incomplete',
                          content: _userBox.data.validationStatus ==
                                  "Need Validate"
                              ? "Update your validation?"
                              : 'You need to complete your verification before posting a job.',
                          onPressCancel: () {
                            Navigator.of(context).pop(); // Close the dialog
                          },
                          onPressedConfirm: () async {
                            Navigator.of(context).pop(); // Close the dialog
                            context.push('/user_validation');
                          },
                          context: context,
                        );
                        return;
                      }
                      // Handle tap
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();

                      // Save skill (or any string, int, bool)
                      await prefs.setString(
                          'studentId', _studentBox.data.studentId);
                      context.go('/candidate_detail');
                      context.push('/resume_page');
                    },
                  ),
                ),
                Visibility(
                  visible: _userBox.data.usertype == "employer",
                  child: ListTile(
                    leading: Icon(Icons.subscriptions),
                    title: Text('Subscription'),
                    onTap: () {
                      // Handle tap
                      if (_subscriptionBox.isEmpty) {
                        context.go('/subscription_plan');
                      } else {
                        context.go('/subscription');
                      }
                    },
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.settings),
                  title: Text('Settings'),
                  onTap: () {
                    // Handle tap
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        )),
      ),
    );
  }
}
