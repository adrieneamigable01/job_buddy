import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_buddy/cubit/profile/profile_cubit.dart';
import 'package:job_buddy/models/course_model.dart';
import 'package:job_buddy/models/skills_model.dart';
import 'package:job_buddy/models/student_model.dart';
import 'package:job_buddy/widgets/common/alert_dialog_widget.dart';
import 'package:job_buddy/widgets/common/textfield_widget.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';

class PersonalInfoForm extends StatefulWidget {
  final StudentModel? existingEntry;

  const PersonalInfoForm({Key? key, this.existingEntry}) : super(key: key);

  @override
  _PersonalInfoFormState createState() => _PersonalInfoFormState();
}

class _PersonalInfoFormState extends State<PersonalInfoForm> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for form fields
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _middlenameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _birthdateController = TextEditingController();
  final TextEditingController _skillsController = TextEditingController();
  final TextEditingController _preferredStartTimeController = TextEditingController();
  final TextEditingController _preferredEndTimeController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _selectedEmploymentTypeController = TextEditingController();
  final TextEditingController _selectedCourseItemController = TextEditingController();

  List<String> _skills = [];
  String? _selectedGender;
  String? _selectedEmploymentType;
  CourseModel? _selectedCourseItem;
  final CourseBox _courseBox = CourseBox();
  final SkillsBox  _skillsBox = SkillsBox();
  final alertDialog = AlertDialogWidget();

  @override
  void initState() {
    super.initState();
   
    if (widget.existingEntry != null) {
      final entry = widget.existingEntry!;
      _lastnameController.text = entry.lastname ?? '';
      _firstnameController.text = entry.firstname ?? '';
      _middlenameController.text = entry.middlename ?? '';
      _emailController.text = entry.email ?? '';
      _phoneController.text = entry.phone ?? '';
      _addressController.text = entry.address ?? '';
      _birthdateController.text = entry.birthdate ?? '';
      _skillsController.text = entry.skills ?? '';
      _preferredStartTimeController.text = entry.prefereAvailableStartTime ?? '';
      _preferredEndTimeController.text = entry.prefereAvailableEndTime ?? '';
      _selectedGender = entry.gender??'Male';
      _selectedEmploymentType = entry.employmentType == "" ? "Full Time" : entry.employmentType ?? 'Full Time';
       _skills = entry.skills!.split(',').map((s) => s.trim()).toList();

      _selectedCourseItem = _courseBox.items.firstWhere(
        (course) => course.courseId == entry.courseId,
        // orElse: () => null,
      );
    }
  }

  @override
  void dispose() {
    _lastnameController.dispose();
    _firstnameController.dispose();
    _middlenameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _birthdateController.dispose();
    _skillsController.dispose();
    _preferredStartTimeController.dispose();
    _preferredEndTimeController.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: Colors.grey.shade400),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: Colors.teal),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
    );
  }

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    DateTime initialDate = DateTime.tryParse(controller.text) ?? DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      controller.text = picked.toIso8601String().split('T')[0];
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is FailureProfileState) {
          Navigator.of(context, rootNavigator: true).pop();
          alertDialog.showAlertDialog(
            isError: state.isError,
            title: 'Operation Failed',
            content: state.errorMessage,
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
            context: context,
          );
        }

        if (state is SuccessProfileState) {
          Navigator.of(context, rootNavigator: true).pop();
          alertDialog.showAlertDialog(
            isError: state.isError,
            title: 'Operation Success',
            content: state.successMessage,
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
              _formKey.currentState?.reset();
            },
            context: context,
          );
        }

        if (state is LoadingProfileState && state.isLoading) {
          alertDialog.showLoadingDialog(context: context, onPressed: () {});
        }
      },
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Text(
              widget.existingEntry != null ? 'Edit Personal Info' : 'Add Personal Info',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _lastnameController,
              decoration: _inputDecoration('Last Name'),
              validator: (value) => value == null || value.isEmpty ? 'Please enter last name' : null,
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _firstnameController,
              decoration: _inputDecoration('First Name'),
              validator: (value) => value == null || value.isEmpty ? 'Please enter first name' : null,
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _middlenameController,
              decoration: _inputDecoration('Middle Name'),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              decoration: _inputDecoration('Email'),
              validator: (value) => value == null || value.isEmpty ? 'Please enter email' : null,
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _phoneController,
              decoration: _inputDecoration('Phone'),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _addressController,
              decoration: _inputDecoration('Address'),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _birthdateController,
              decoration: _inputDecoration('Birthdate'),
              readOnly: true,
              onTap: () => _selectDate(context, _birthdateController),
            ),
            SizedBox(height: 16),
            _buildGenderField('Gender',_genderController),
            SizedBox(height: 16),
            _buildSkillsSelector(),
            SizedBox(height: 16),
            _buildCourseDropdown(),
            SizedBox(height: 16),
            _buildPreferredTimeField("Preferred Available Start Time",
                            _preferredStartTimeController),
            SizedBox(height: 16),
            _buildPreferredTimeField("Preferred Available End Time",
                            _preferredEndTimeController),
            SizedBox(height: 16),
            _buildEmploymentTypeField('Employment Type',_selectedEmploymentTypeController),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                   String skillsString = _skills.join(', ');
                  final personalInfoPayload = {
                    'last_name': _lastnameController.text.trim(),
                    'first_name': _firstnameController.text.trim(),
                    'middle_name': _middlenameController.text.trim(),
                    'email': _emailController.text.trim(),
                    'phone': _phoneController.text.trim(),
                    'address': _addressController.text.trim(),
                    'birthdate': _birthdateController.text.trim(),
                    'gender': _selectedGender,
                    'skills': skillsString,
                    'course_id': _selectedCourseItem?.courseId.toString(),
                    'prefere_available_start_time': _preferredStartTimeController.text.trim(),
                    'prefere_available_end_time': _preferredEndTimeController.text.trim(),
                    'employment_type': _selectedEmploymentType.toString(),
                  };


                  if (widget.existingEntry != null) {
                    BlocProvider.of<ProfileCubit>(context).updateStudentInfo(
                      payload: personalInfoPayload,
                    );
                  }
                }
              },
              child: Text('Save'),
            ),
          ],
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

   Widget _buildEmploymentTypeField(String label, TextEditingController controller) {
    final List<String> employmentType = ['Full Time', 'Part Time', 'Contract', 'Internship'];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: DropdownButtonFormField<String>(
        value: _selectedEmploymentType,
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
        items: employmentType.map((String employmentValue) {
          return DropdownMenuItem<String>(
            value: employmentValue,
            child: Text(employmentValue),
          );
        }).toList(),
        onChanged: (String? value) {
          if (value != null) {
            setState(() {
              _selectedEmploymentType = value;
              controller.text = value;
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
          _selectedCourseItemController.text = newValue!.courseName.toString();
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
        initialValue: _skills,
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

   Widget _buildGenderField(String label, TextEditingController controller) {
    final List<String> genderOptions = ['Male', 'Female'];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: DropdownButtonFormField<String>(
        value: _selectedGender,
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
            _selectedGender = value;
            controller.text = value;
          }
        },
      ),
    );
  }

 
}
