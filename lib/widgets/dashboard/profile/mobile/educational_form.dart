import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_buddy/cubit/education/education_cubit.dart';
import 'package:job_buddy/models/course_model.dart';
import 'package:job_buddy/models/education_model.dart';
import 'package:job_buddy/widgets/common/alert_dialog_widget.dart';

class EducationForm extends StatefulWidget {
  final EducationModel? existingEntry;

  const EducationForm({Key? key, this.existingEntry}) : super(key: key);

  @override
  _EducationFormState createState() => _EducationFormState();
}

class _EducationFormState extends State<EducationForm> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for form fields
  final TextEditingController _schoolNameController = TextEditingController();
  final TextEditingController _degreeController = TextEditingController();
  final TextEditingController _fieldOfStudyController = TextEditingController();
  final TextEditingController _startYearController = TextEditingController();
  final TextEditingController _endYearController = TextEditingController();
  final TextEditingController _gradeController = TextEditingController();
  // final TextEditingController _activitiesController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  CourseModel? _selectedCourseItem;
  final CourseBox _courseBox = CourseBox();
  final alertDialog = AlertDialogWidget();

  @override
  void initState() {
    super.initState();
    print("widget.existingEntry : ${widget.existingEntry}");
    if (widget.existingEntry != null) {
      final entry = widget.existingEntry!;
      _schoolNameController.text = entry.schoolName ?? '';
      _degreeController.text = entry.degree ?? '';
      _fieldOfStudyController.text = entry.fieldOfStudy ?? '';
      _startYearController.text = entry.startYear?.toString() ?? '';
      _endYearController.text = entry.endYear?.toString() ?? '';
      _gradeController.text = entry.grade ?? '';
      // _activitiesController.text = entry.activities ?? '';
      _descriptionController.text = entry.description ?? '';

      // Assuming you have a method to get CourseModel by ID
      _selectedCourseItem = _courseBox.items.firstWhere(
        (course) => course.courseId == entry.courseId,
        // orElse: () => null,
      );
    }
  }

  @override
  void dispose() {
    _schoolNameController.dispose();
    _degreeController.dispose();
    _fieldOfStudyController.dispose();
    _startYearController.dispose();
    _endYearController.dispose();
    _gradeController.dispose();
    // _activitiesController.dispose();
    _descriptionController.dispose();
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

  Future<void> _selectYear(
      BuildContext context, TextEditingController controller) async {
    final currentYear = DateTime.now().year;
    int selectedYear = int.tryParse(controller.text) ?? currentYear;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Year'),
          content: Container(
            width: 300,
            height: 400,
            child: YearPicker(
              firstDate: DateTime(currentYear - 100),
              lastDate: DateTime(currentYear + 10),
              initialDate: DateTime(selectedYear),
              selectedDate: DateTime(selectedYear),
              onChanged: (DateTime dateTime) {
                controller.text = dateTime.year.toString();
                Navigator.pop(context);
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EducationCubit, EducationState>(
      listener: (context, state) {
        if (state is FailureEducationState) {
          Navigator.of(context, rootNavigator: true).pop();
          alertDialog.showAlertDialog(
            isError: state.isError,
            title: 'Operation Failed',
            content: state.errorMessage,
            onPressed: () =>
                Navigator.of(context, rootNavigator: true).pop(),
            context: context,
          );
        }

        if (state is SuccessEducationState) {
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

        if (state is LoadingEducationState && state.isLoading) {
          alertDialog.showLoadingDialog(
              context: context, onPressed: () {});
        }
      },
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Text(
              widget.existingEntry != null ? 'Edit Education' : 'Add Education',
              style: sectionTitle,
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _schoolNameController,
              decoration: _inputDecoration('College Name'),
              validator: (value) => value == null || value.isEmpty
                  ? 'Please enter school name'
                  : null,
            ),
            SizedBox(height: 16),
            _buildCourseDropdown(),
            SizedBox(height: 16),
            TextFormField(
              controller: _degreeController,
              decoration: _inputDecoration('Degree'),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _fieldOfStudyController,
              decoration: _inputDecoration('Field of Study'),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _startYearController,
              decoration: _inputDecoration('Start Year'),
              readOnly: true,
              onTap: () => _selectYear(context, _startYearController),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _endYearController,
              decoration: _inputDecoration('End Year'),
              readOnly: true,
              onTap: () => _selectYear(context, _endYearController),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _gradeController,
              decoration: _inputDecoration('GPA'),
            ),
            // SizedBox(height: 16),
            // TextFormField(
            //   controller: _activitiesController,
            //   decoration: _inputDecoration('Activities'),
            // ),
            SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: _inputDecoration('Description'),
              maxLines: 3,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  

                  if (widget.existingEntry != null) {
                    // Update existing entry
                      
                      Object educationPayload = {
                        'education_id': widget.existingEntry!.id,
                        'course_id': _selectedCourseItem?.courseId.toString(),
                        'school_name': _schoolNameController.text.trim(),
                        'degree': _degreeController.text.trim(),
                        'field_of_study': _fieldOfStudyController.text.trim(),
                        'start_year': _startYearController.text.trim(),
                        'end_year': _endYearController.text.trim(),
                        'grade': _gradeController.text.trim(),
                        // 'activities': _activitiesController.text.trim(),
                        'description': _descriptionController.text.trim(),
                      };
                      BlocProvider.of<EducationCubit>(context).updateEducation(
                        payload: educationPayload,
                      );
                    
                  } else {
                    Object educationPayload = {
                    'course_id': _selectedCourseItem?.courseId.toString(),
                    'school_name': _schoolNameController.text.trim(),
                    'degree': _degreeController.text.trim(),
                    'field_of_study': _fieldOfStudyController.text.trim(),
                    'start_year': _startYearController.text.trim(),
                    'end_year': _endYearController.text.trim(),
                    'grade': _gradeController.text.trim(),
                    // 'activities': _activitiesController.text.trim(),
                    'description': _descriptionController.text.trim(),
                    };
                    // Create new entry
                    BlocProvider.of<EducationCubit>(context).createEducation(
                      payload: educationPayload,
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

  Widget _buildCourseDropdown() {
    return DropdownButtonFormField<CourseModel>(
      isExpanded: true,
      value: _selectedCourseItem,
      decoration: _inputDecoration('Course'),
      items: _courseBox.items.map((CourseModel item) {
        return DropdownMenuItem<CourseModel>(
          value: item,
          child: Text(
            item.courseName.toString(),
            overflow: TextOverflow.ellipsis,
          ),
        );
      }).toList(),
      onChanged: (CourseModel? newValue) {
        setState(() {
          _selectedCourseItem = newValue;
        });
      },
    );
  }
}

const sectionTitle = TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
