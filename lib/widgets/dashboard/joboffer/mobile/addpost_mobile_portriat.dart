import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:job_buddy/cubit/auth/cubit/auth_cubit.dart';
import 'package:job_buddy/cubit/joboffer/joboffer_cubit.dart';
import 'package:job_buddy/models/company_model.dart';
import 'package:job_buddy/models/skills_model.dart';
import 'package:job_buddy/models/user_model.dart';
import 'package:job_buddy/widgets/common/alert_dialog_widget.dart';
import 'package:job_buddy/widgets/common/textfield_widget.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';  // Import the package

class AddPostMobilePortrait extends StatefulWidget {
  const AddPostMobilePortrait({Key? key}) : super(key: key);

  @override
  State<AddPostMobilePortrait> createState() => _AddPostMobilePortraitState();
}

class _AddPostMobilePortraitState extends State<AddPostMobilePortrait> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _jobTitleController = TextEditingController();
  final TextEditingController _skillsController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _minSalaryController = TextEditingController();
  final TextEditingController _maxSalaryController = TextEditingController();
  final TextEditingController _expiredAtController = TextEditingController();
  final TextEditingController _jobDescriptionController = TextEditingController();
  final TextEditingController _companyOverviewController = TextEditingController(); // Add for company overview
  final TextEditingController _qualificationsController = TextEditingController(); // Add for qualifications
  final TextEditingController _preferredStartTimeController = TextEditingController(); // Add for qualifications
  final TextEditingController _preferredEndTimeController = TextEditingController(); // Add for qualifications

  List<String> _skills = [];
  List<String> _qualifications = [];  // List to store qualifications
  final UserBox _userBox = UserBox();
  final SkillsBox _skillsBox = SkillsBox();
  final CompanyBox _companyBox = CompanyBox();
  final AlertDialogWidget alertDialog = AlertDialogWidget();

  String _employmentType = "Full Time"; // Default

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _expiredAtController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<JobofferCubit, JobofferState>(
      listener: (context, state) {
        if (state is SuccessState) {
          alertDialog.showConfirmDialog(
            isError: false,
            title: 'Success',
            content: state.successMessage,
            onPressCancel: () {
              Navigator.of(context).pop(); // Close the dialog
              context.push('/dashboard');
            },
            onPressedConfirm: () async {
              Navigator.of(context).pop(); // Close the dialog
              context.push('/dashboard');
            },
            context: context);
        }
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: const Color(0xffB5E5E6),
          appBar: AppBar(
            title: const Text('Add Job Post'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                context.push('/dashboard');
              },
            ),
            backgroundColor: const Color(0xffB5E5E6),
            elevation: 0,
            foregroundColor: Colors.black,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTextField("Job Title", _jobTitleController),
                  _buildSkillsSelector(),
                  _buildTextField("Location", _locationController),
                  _buildTextField("Min Salary", _minSalaryController,
                      keyboardType: TextInputType.number),
                  _buildTextField("Max Salary", _maxSalaryController,
                      keyboardType: TextInputType.number),
                  GestureDetector(
                    onTap: () => _selectDate(context),
                    child: AbsorbPointer(
                      child:
                          _buildTextField("Expired At", _expiredAtController),
                    ),
                  ),
                  _buildTextField("Job Description", _jobDescriptionController,
                      maxLines: 5),
                  const SizedBox(height: 10),
                  _buildQualificationsSection(),  // Add qualifications section here
                  const SizedBox(height: 10),
                  _buildTextField("Company Overview", _companyOverviewController, maxLines: 3), // Add company overview section
                  const SizedBox(height: 10),
                   _buildPreferredTimeField("Preferred Available Start Time",
                                  _preferredStartTimeController),
                  SizedBox(height: 10),
                  _buildPreferredTimeField("Preferred Available End Time",
                                  _preferredEndTimeController),
                  const SizedBox(height: 10),
                  Text(
                    "Employment Type",
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DropdownButtonFormField<String>(
                      value: _employmentType,
                      decoration:
                          const InputDecoration(border: InputBorder.none),
                      items: [
                        "Full Time",
                        "Part Time",
                        "Contract",
                        "Internship",
                      ]
                          .map((type) => DropdownMenuItem(
                                value: type,
                                child: Text(type),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _employmentType = value!;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: BlocBuilder<JobofferCubit, JobofferState>(
                      builder: (context, state) {
                        return ElevatedButton(
                          onPressed: () {
                            if (state is LoadingState) {
                              return;
                            }

                            if (_formKey.currentState!.validate()) {

                              if(_companyBox.isEmpty){
                                alertDialog.showConfirmDialog(
                                  isError: true,
                                  title: 'Error',
                                  content: 'Please add your company first',
                                  onPressCancel: () {
                                    Navigator.of(context).pop(); // Close the dialog
                                    context.push('/dashboard');
                                  },
                                  onPressedConfirm: () async {
                                    Navigator.of(context).pop(); // Close the dialog
                                    context.push('/dashboard');
                                  },
                                  context: context);return;
                              }

                              String skillsString = _skills.join(', ');
                            
                              Object payload = {
                                'job_title': _jobTitleController.text,
                                'skills': skillsString,
                                'location': _locationController.text,
                                'min_salary': _minSalaryController.text,
                                'max_salary': _maxSalaryController.text,
                                'company_id': _companyBox.data.companyId,
                                'expired_at': _expiredAtController.text,
                                'job_description': _jobDescriptionController.text,
                                'company_overview': _companyOverviewController.text,  // Include company overview
                                'employment_type': _employmentType,
                                'work_start': _preferredStartTimeController.text,
                                'work_end': _preferredEndTimeController.text,
                                'qualifications': _qualifications.join(', '),  // Add qualifications to payload
                              };
                            
                              if (_formKey.currentState!.validate()) {
                                BlocProvider.of<JobofferCubit>(context)
                                    .createJobOffer(payload: payload);
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xffE6D2DB),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 50, vertical: 15),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                          ),
                          child: Text(
                            state is LoadingState ? "Loading" : "Submit",
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
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

  Widget _buildQualificationsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Qualifications",
          style: TextStyle(fontSize: 14, color: Colors.grey[700]),
        ),
        const SizedBox(height: 5),
        TextFormField(
          controller: _qualificationsController,
          decoration: InputDecoration(
            labelText: "Add Qualification",
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onFieldSubmitted: (value) {
            if (value.isNotEmpty) {
              setState(() {
                _qualifications.add(value);
                _qualificationsController.clear();
              });
            }
          },
        ),
        const SizedBox(height: 10),
        // Display qualifications with bullets + remove button
        ..._qualifications.asMap().entries.map((entry) {
          int index = entry.key;
          String qualification = entry.value;

          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.brightness_1, size: 10, color: Colors.black),
              const SizedBox(width: 5),
              Expanded(child: Text(qualification)),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.red, size: 18),
                onPressed: () {
                  setState(() {
                    _qualifications.removeAt(index);
                  });
                },
              ),
            ],
          );
        }).toList(),
      ],
    );
  }


  Widget _buildTextField(String label, TextEditingController controller,
      {int maxLines = 1, TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Please enter $label";
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xff1F94D4)),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
