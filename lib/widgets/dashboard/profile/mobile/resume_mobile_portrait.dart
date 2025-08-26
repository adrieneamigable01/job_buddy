import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:job_buddy/cubit/course/course_cubit.dart';
import 'package:job_buddy/cubit/education/education_cubit.dart';
import 'package:job_buddy/cubit/experience/experience_cubit.dart';
import 'package:job_buddy/cubit/profile/profile_cubit.dart';
import 'package:job_buddy/cubit/skills/skills_cubit.dart';
import 'package:job_buddy/models/course_model.dart';
import 'package:job_buddy/models/education_model.dart';
import 'package:job_buddy/models/experience_model.dart';
import 'package:job_buddy/models/student_model.dart';
import 'package:job_buddy/models/user_model.dart';
import 'package:job_buddy/widgets/dashboard/profile/mobile/educational_form.dart';
import 'package:job_buddy/widgets/dashboard/profile/mobile/experience_form.dart';
import 'package:job_buddy/widgets/dashboard/profile/mobile/personalinfo_form.dart';
import 'package:job_buddy/widgets/common/alert_dialog_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

final UserBox _userBox = UserBox();
final StudentBox _studentBox = StudentBox();
final alertDialog = AlertDialogWidget();

class ResumeMobilePortrait extends StatefulWidget {
  const ResumeMobilePortrait({super.key});

  @override
  State<ResumeMobilePortrait> createState() => _ResumeMobilePortraitState();
}

class _ResumeMobilePortraitState extends State<ResumeMobilePortrait> {
  late String studentId = '';

  Future<void> _getStudentId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      studentId = prefs.getString('studentId') ?? 'No ID found';
    });
    print("studentId : $studentId");
  }

  @override
  void initState() {
    super.initState();
    _getStudentId();
  }

  @override
  Widget build(BuildContext context) {
    final user = _userBox.data;

    return BlocListener<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is LoadingProfileState && state.isLoading) {}
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
            title: Row(
              children: [
                Spacer(),
                Text('My Resume'),
                Spacer(),
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    context.go('/dashboard');
                  },
                ),
              ],
            ),
            centerTitle: true,
            automaticallyImplyLeading: false,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                // Header with image and name
                BlocBuilder<ProfileCubit, ProfileState>(
                  builder: (context, state) {
                    if (state is LoadingProfileState && state.isLoading) {
                      return Text("Fetching data...");
                    }

                    return Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 45,
                              backgroundImage: user.profileImage != null &&
                                      user.profileImage != ""
                                  ? MemoryImage(
                                      base64Decode(user.profileImage!))
                                  : NetworkImage(
                                          'https://via.placeholder.com/150')
                                      as ImageProvider,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      "${_studentBox.getByStudentId(studentId).firstname} ${_studentBox.getByStudentId(studentId).middlename ?? ''} ${_studentBox.getByStudentId(studentId).lastname}",
                                      style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 4),
                                  Text(
                                      _studentBox
                                              .getByStudentId(studentId)
                                              .email ??
                                          '',
                                      style: TextStyle(fontSize: 14)),
                                  Text(
                                      _studentBox
                                              .getByStudentId(studentId)
                                              .phone ??
                                          '',
                                      style: TextStyle(fontSize: 14)),
                                  Text(
                                      _studentBox
                                              .getByStudentId(studentId)
                                              .address ??
                                          '',
                                      style: TextStyle(fontSize: 14)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        // Personal Information
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Personal Information", style: sectionTitle),
                            _userBox.data.usertype != "student"
                                ? SizedBox()
                                : IconButton(
                                    icon: Icon(Icons.edit,
                                        size: 18, color: Colors.grey),
                                    onPressed: () {
                                      _showPersonalInfoEditForm(context,
                                          entry: _studentBox
                                              .getByStudentId(studentId));
                                    },
                                  ),
                          ],
                        ),
                        Divider(),
                        _buildInfoRow(
                            "Birthdate",
                            _studentBox.getByStudentId(studentId).birthdate ??
                                ''),
                        _buildInfoRow("Gender",
                            _studentBox.getByStudentId(studentId).gender ?? ''),
                      ],
                    );
                  },
                ),

                // Education Section with Edit Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Education", style: sectionTitle),
                    _userBox.data.usertype != "student"
                        ? SizedBox()
                        : IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () async {
                              await BlocProvider.of<CourseCubit>(context).getCourses();
                              _showEducationEditForm(context);
                            },
                          ),
                  ],
                ),
                Divider(),

                BlocBuilder<EducationCubit, EducationState>(
                  builder: (context, state) {
                    if (state is LoadingEducationState) {
                      return Text("Fetching data...");
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: getEducationDetails().length,
                      itemBuilder: (context, index) {
                        return buildEducationEntry(
                            getEducationDetails()[index], context);
                      },
                    );
                  },
                ),

                // Education Section with Edit Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Experience", style: sectionTitle),
                    _userBox.data.usertype != "student"
                        ? SizedBox()
                        : IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () async {
                              await BlocProvider.of<SkillsCubit>(context).getSkills();
                              _showExperienceEditForm(context);
                            },
                          ),
                  ],
                ),
                Divider(),

                BlocBuilder<ExperienceCubit, ExperienceState>(
                  builder: (context, state) {
                    if (state is LoadingExperienceState) {
                      return Text("Fetching data...");
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: getExperienceDetails().length,
                      itemBuilder: (context, index) {
                        return buildExprienceEntry(
                            getExperienceDetails()[index], context);
                      },
                    );
                  },
                ),

                // Skills
                const SizedBox(height: 16),
                Text("Skills", style: sectionTitle),
                Divider(),
                BlocBuilder<ProfileCubit, ProfileState>(
                  builder: (context, state) {
                     if (state is LoadingProfileState && state.isLoading) {
                      return const Text("Fetching data...");
                    }
                    return Text(
                        getStudentDetails().skills ?? 'No skills listed',
                        style: normalText);
                  },
                ),

                // Employment Preferences
                const SizedBox(height: 16),
                Text("Preferences", style: sectionTitle),
                Divider(),
                BlocBuilder<ProfileCubit, ProfileState>(
                  builder: (context, state) {
                    if (state is LoadingProfileState && state.isLoading) {
                      return const Text("Fetching data...");
                    }
                    return Column(
                      children: [
                        _buildInfoRow("Preferred Start Time",
                            getStudentDetails().prefereAvailableStartTime ?? ''),
                        _buildInfoRow("Preferred End Time",
                            getStudentDetails().prefereAvailableEndTime ?? ''),
                        _buildInfoRow("Employment Type",
                            getStudentDetails().employmentType ?? ''),
                      ],
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  StudentModel getStudentDetails() {
    return StudentBox().getByStudentId(studentId);
  }

  List<EducationModel> getEducationDetails() {
    print("education studentId: ${studentId}");
    return EducationBox().getByStudentId(studentId);
  }

  List<ExperienceModel> getExperienceDetails() {
    print("exp studentId: ${studentId}");
    return ExperienceBox().getByStudentId(studentId);
  }

  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text("$title:", style: normalText)),
          Expanded(flex: 3, child: Text(value, style: boldText)),
        ],
      ),
    );
  }

  Widget buildEducationEntry(EducationModel entry, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(entry.schoolName.toString(),
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 2),
                Text(
                    CourseBox()
                        .getByCourseId(entry.courseId)!
                        .courseName
                        .toString(),
                    style: TextStyle(color: Colors.grey[700], fontSize: 14)),
                const SizedBox(height: 4),
                Text(
                    '${entry.startYear.toString()} - ${entry.endYear.toString()}',
                    style: TextStyle(color: Colors.grey[600], fontSize: 13)),
              ],
            ),
          ),
          _userBox.data.usertype != "student"
              ? SizedBox()
              : IconButton(
                  icon: Icon(Icons.edit, size: 18, color: Colors.grey),
                  onPressed: () {
                    _showEducationEditForm(context, entry: entry);
                  },
                ),
        ],
      ),
    );
  }

  Widget buildExprienceEntry(ExperienceModel entry, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(entry.companyName.toString().toUpperCase(),
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 2),
                Text(entry.positionTitle.toString().toUpperCase(),
                    style: TextStyle(color: Colors.grey[700], fontSize: 14)),
                const SizedBox(height: 4),
                Text(entry.skills.toString(),
                    style: TextStyle(color: Colors.grey[700], fontSize: 14)),
                const SizedBox(height: 4),
                Text(
                    entry.isCurrent ?? false
                        ? entry.startDate.toString()
                        : '${entry.startDate.toString()} - ${entry.endDate.toString()}',
                    style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                const SizedBox(height: 4),
              ],
            ),
          ),
          _userBox.data.usertype != "student"
              ? SizedBox()
              : IconButton(
                  icon: Icon(Icons.edit, size: 18, color: Colors.grey),
                  onPressed: () {
                    _showExperienceEditForm(context, entry: entry);
                  },
                ),
        ],
      ),
    );
  }

  void _showPersonalInfoEditForm(BuildContext context, {StudentModel? entry}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: SingleChildScrollView(
          child: PersonalInfoForm(existingEntry: entry),
        ),
      ),
    );
  }

  void _showEducationEditForm(BuildContext context, {EducationModel? entry}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: SingleChildScrollView(
          child: EducationForm(existingEntry: entry),
        ),
      ),
    );
  }

  void _showExperienceEditForm(BuildContext context, {ExperienceModel? entry}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: SingleChildScrollView(
          child: ExperienceForm(existingEntry: entry),
        ),
      ),
    );
  }
}

const sectionTitle = TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
const normalText = TextStyle(fontSize: 16, color: Colors.black87);
const boldText = TextStyle(fontSize: 16, fontWeight: FontWeight.w500);
