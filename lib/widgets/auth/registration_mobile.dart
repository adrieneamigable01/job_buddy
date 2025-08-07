import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:job_buddy/cubit/auth/cubit/auth_cubit.dart';
import 'package:job_buddy/cubit/course/course_cubit.dart';
import 'package:job_buddy/models/course_model.dart';
import 'package:job_buddy/models/skills_model.dart';
import 'package:job_buddy/widgets/common/alert_dialog_widget.dart';
import 'package:job_buddy/widgets/common/color.dart';
import 'package:job_buddy/widgets/common/textfield_widget.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';

enum UserType { student, employer }

class RegistrationPageMobilePortrait extends StatefulWidget {
  const RegistrationPageMobilePortrait({super.key});

  @override
  State<RegistrationPageMobilePortrait> createState() =>
      _RegistrationPageMobilePortraitState();
}

class _RegistrationPageMobilePortraitState
    extends State<RegistrationPageMobilePortrait> {
  final _formKey = GlobalKey<FormState>();
  final alertDialog = AlertDialogWidget();

  UserType _selectedUserType = UserType.student;

  DateTime? _selectedDate;
  CourseModel? _selectedCourseItem;

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _middleNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _birthdateController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _skillsController =
      TextEditingController(); // student
  final TextEditingController _courseIdController =
      TextEditingController(); // student
  final TextEditingController _statusController =
      TextEditingController(); // student
  final TextEditingController _availableTimeController =
      TextEditingController(); // student
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final SkillsBox _skillsBox = SkillsBox();
  final CourseBox _courseBox = CourseBox();
    List<String> _skills = [];

  Future<void> _selectDate(BuildContext context) async {
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(1900),
    lastDate: DateTime.now(),
  );
  if (picked != null && picked != _selectedDate) {
    setState(() {
      _selectedDate = picked;
      _birthdateController.text = "${picked.toLocal()}".split(' ')[0]; // Format as YYYY-MM-DD
    });
  }
}

  @override
  Widget build(BuildContext context) {
    return SelectionArea(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: defaultBackgroundColor,
          body: BlocListener<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is FailureState) {
                Navigator.of(context, rootNavigator: true).pop();
                alertDialog.showAlertDialog(
                  isError: state.isError,
                  title: 'Registration Failed',
                  content: state.errorMessage,
                  onPressed: () =>
                      Navigator.of(context, rootNavigator: true).pop(),
                  context: context,
                );
              }

              if (state is SuccessAuthState) {
                alertDialog.showAlertDialog(
                  isError: state.isError,
                  title: 'Registration',
                  content: state.successMessage,
                  onPressed: () =>
                      Navigator.of(context, rootNavigator: true).pop(),
                  context: context,
                );
              }

              if (state is LoadingAuthState && state.isLoading) {
                alertDialog.showLoadingDialog(
                    context: context, onPressed: () {});
              }
            },
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const Image(
                          image: AssetImage('assets/logo/logo.png'),
                          width: 150),
                      const SizedBox(height: 20),

                      // User type selection
                      _buildUserTypeSelector(),


                      const SizedBox(height: 10),

                      // Common Fields
                      _buildTextField("First Name", _firstNameController),
                      _buildTextField("Last Name", _lastNameController),
                      _buildTextField("Middle Name", _middleNameController),
                      _buildTextField("Email", _emailController),
                      _buildTextField("Phone Number", _phoneController),
                      _buildTextField("Address", _addressController),
                      _buildBirthdateField("Birthdate", _birthdateController),
                      _buildGenderField("Gender", _genderController),

                      // Student-only Fields
                      if (_selectedUserType == UserType.student) ...[
                        _buildSkillsSelector(),
                        _buildCourseDropdown(),
                        _buildPreferredTimeField("Preferred Available Time",
                            _availableTimeController),
                      ],

                      const SizedBox(height: 10),
                      _buildPasswordField("Password", _passwordController),
                      _buildPasswordField(
                          "Confirm Password", _confirmPasswordController),

                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: defaultButtonBackgroundColor,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                             String skillsString = _skills.join(', ');
                            Object payload = {
                                'user_type': _selectedUserType == UserType.student ? 'student' : 'employer',
                                'email': _emailController.text.trim(),
                                'password': _passwordController.text.trim(),
                                'first_name': _firstNameController.text.trim(),
                                'last_name': _lastNameController.text.trim(),
                                'middle_name': _middleNameController.text.trim(),
                                'phone': _phoneController.text.trim(),
                                'address': _addressController.text.trim(),
                                'birthdate': _birthdateController.text.trim(),
                                'gender': _genderController.text.trim(),
                                'skills': skillsString, // Expected as an array
                                'course_id': _selectedCourseItem?.courseId.toString(), // Must match backend
                                'preferred_available_time': _availableTimeController.text.trim(),
                            };

                            BlocProvider.of<AuthCubit>(context)
                                .register(payload: payload);
                          }
                        },
                        child: BlocBuilder<AuthCubit, AuthState>(
                          builder: (context, state) {
                            return Text(
                              state is LoadingAuthState ? 'Please wait...' :  "Sign Up",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: defaultTextColor,
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserTypeSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: DropdownButtonFormField<UserType>(
        value: _selectedUserType,
        decoration: InputDecoration(
          labelText: "User Type",
          filled: true,
          fillColor: Colors.white, // White background
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
        ),
        items: UserType.values.map((UserType type) {
          return DropdownMenuItem<UserType>(
            value: type,
            child: Text(type == UserType.student ? 'Student' : 'Employer'),
          );
        }).toList(),
        onChanged: (UserType? newValue) {
          if (newValue != null) {
            setState(() {
              _selectedUserType = newValue;
            });
          }
        },
      ),
    );
  }
  Widget _buildCourseDropdown() {
    return DropdownButtonFormField<CourseModel>(
      isExpanded: true,
      value: _selectedCourseItem,
      decoration: InputDecoration(
        labelText: "Select Course",
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
      ),
      items: _courseBox.items.map((CourseModel item) {
        return DropdownMenuItem<CourseModel>(
          value: item,
          child: Text(item.courseName.toString()),
        );
      }).toList(),
      selectedItemBuilder: (BuildContext context) {
        return _courseBox.items.map((CourseModel item) {
          return Text(
            item.courseName.toString(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          );
        }).toList();
      },
      onChanged: (CourseModel? newValue) {
        setState(() {
          _selectedCourseItem = newValue;
        });
      },
    );
  }
  Widget _buildSkillsSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: MultiSelectDialogField(
        searchable: true,
        items: _skillsBox.items
            .map((skill) =>
                MultiSelectItem<String>(skill.name ?? '', skill.name ?? ''))
            .toList(),
        title: Text("Select Skills"),
        selectedColor: Color(0xff1F94D4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        buttonText: Text("Skills"),
        onConfirm: (values) {
          setState(() {
            _skills = values.cast<String>();
          });
        },
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: TextFieldWidget().textWithBorder(
        labelText: label,
        controller: controller,
        onChanged: (val) {},
        onFieldSubmitted: (val) {},
      ),
    );
  }
  Widget _buildTimeField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: TextFieldWidget().textWithBorder(
        labelText: label,
        controller: controller,
        onChanged: (val) {},
        onFieldSubmitted: (val) {},
      ),
    );
  }
  Widget _buildBirthdateField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: GestureDetector(
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
          );
          if (pickedDate != null) {
            controller.text = "${pickedDate.toLocal()}".split(' ')[0]; // Format as YYYY-MM-DD
          }
        },
        child: AbsorbPointer(
          child: TextFieldWidget().textWithBorder(
            labelText: label,
            controller: controller,
            onChanged: (val) {},
            onFieldSubmitted: (val) {},
          ),
        ),
      ),
    );
  }

  Widget _buildPreferredTimeField(String label, TextEditingController controller) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6.0),
    child: GestureDetector(
      onTap: () async {
        TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );
        if (pickedTime != null) {
          final hour = pickedTime.hour.toString().padLeft(2, '0');
          final minute = pickedTime.minute.toString().padLeft(2, '0');
          controller.text = '$hour:$minute'; // Format as HH:MM
        }
      },
      child: AbsorbPointer(
        child: TextFieldWidget().textWithBorder(
          labelText: label,
          controller: controller,
          onChanged: (val) {},
          onFieldSubmitted: (val) {},
        ),
      ),
    ),
  );
}


  Widget _buildGenderField(String label, TextEditingController controller) {
  final List<String> genderOptions = ['Male', 'Female'];

  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6.0),
    child: DropdownButtonFormField<String>(
      value: controller.text.isNotEmpty ? controller.text : null,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white, // Set white background
        border: OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
      ),
      items: genderOptions.map((String gender) {
        return DropdownMenuItem<String>(
          value: gender,
          child: Text(gender),
        );
      }).toList(),
      onChanged: (String? value) {
        if (value != null) {
          controller.text = value;
        }
      },
    ),
  );
}





  Widget _buildPasswordField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: TextFieldWidget().textWithBorder(
        labelText: label,
        controller: controller,
        obscureText: true,
        onChanged: (val) {},
        onFieldSubmitted: (val) {},
      ),
    );
  }
}
