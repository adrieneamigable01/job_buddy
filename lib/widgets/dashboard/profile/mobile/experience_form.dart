import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_buddy/cubit/experience/experience_cubit.dart';
import 'package:job_buddy/models/experience_model.dart';
import 'package:job_buddy/widgets/common/alert_dialog_widget.dart';

class ExperienceForm extends StatefulWidget {
  final ExperienceModel? existingEntry;

  const ExperienceForm({Key? key, this.existingEntry}) : super(key: key);

  @override
  _ExperienceFormState createState() => _ExperienceFormState();
}

class _ExperienceFormState extends State<ExperienceForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _positionTitleController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _skillsController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final alertDialog = AlertDialogWidget();
  bool _isCurrent = false;

  @override
  void initState() {
    super.initState();
    if (widget.existingEntry != null) {
      final entry = widget.existingEntry!;
      _companyNameController.text = entry.companyName ?? '';
      _positionTitleController.text = entry.positionTitle ?? '';
      _locationController.text = entry.location ?? '';
      _skillsController.text = entry.skills ?? '';
      _startDateController.text = entry.startDate ?? '';
      _endDateController.text = entry.endDate ?? '';
      _descriptionController.text = entry.description ?? '';
      _isCurrent = entry.isCurrent ?? false;
    }
  }

  @override
  void dispose() {
    _companyNameController.dispose();
    _positionTitleController.dispose();
    _locationController.dispose();
    _skillsController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
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

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    DateTime initialDate = DateTime.now();
    try {
      if (controller.text.isNotEmpty) {
        initialDate = DateTime.parse(controller.text);
      }
    } catch (_) {}

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      controller.text = picked.toIso8601String().split('T').first;
    }
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      final experiencePayload = {
        'company_name': _companyNameController.text.trim(),
        'position_title': _positionTitleController.text.trim(),
        'location': _locationController.text.trim(),
        'skills': _skillsController.text.trim(),
        'start_date': _startDateController.text.trim(),
        'end_date': _isCurrent ? null : _endDateController.text.trim(),
        'is_current': _isCurrent,
        'description': _descriptionController.text.trim(),
      };

      if (widget.existingEntry != null) {
        experiencePayload['experience_id'] = widget.existingEntry!.experienceId;
        BlocProvider.of<ExperienceCubit>(context).updateExperience(payload: experiencePayload);
      } else {
        BlocProvider.of<ExperienceCubit>(context).createExperience(payload: experiencePayload);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ExperienceCubit, ExperienceState>(
      listener: (context, state) {
        if (state is FailureExperienceState) {
          Navigator.of(context, rootNavigator: true).pop();
          alertDialog.showAlertDialog(
            isError: state.isError,
            title: 'Operation Failed',
            content: state.errorMessage,
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
            context: context,
          );
        }

        if (state is SuccessExperienceState) {
          Navigator.of(context, rootNavigator: true).pop();
          alertDialog.showAlertDialog(
            isError: state.isError,
            title: 'Operation Success',
            content: state.successMessage,
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
              _formKey.currentState?.reset();
              Navigator.of(context, rootNavigator: true).pop();
            },
            context: context,
          );
        }

        if (state is LoadingExperienceState && state.isLoading) {
          alertDialog.showLoadingDialog(context: context, onPressed: () {});
        }
      },
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Text(
              widget.existingEntry != null ? 'Edit Experience' : 'Add Experience',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _companyNameController,
              decoration: _inputDecoration('Company Name'),
              validator: (value) =>
                  value == null || value.isEmpty ? 'Please enter company name' : null,
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _positionTitleController,
              decoration: _inputDecoration('Position Title'),
              validator: (value) =>
                  value == null || value.isEmpty ? 'Please enter position title' : null,
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _locationController,
              decoration: _inputDecoration('Location'),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _skillsController,
              decoration: _inputDecoration('Skills'),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _startDateController,
              decoration: _inputDecoration('Start Date'),
              readOnly: true,
              onTap: () => _selectDate(context, _startDateController),
              validator: (value) =>
                  value == null || value.isEmpty ? 'Please select start date' : null,
            ),
            SizedBox(height: 16),
            if (!_isCurrent)
              TextFormField(
                controller: _endDateController,
                decoration: _inputDecoration('End Date'),
                readOnly: true,
                onTap: () => _selectDate(context, _endDateController),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Please select end date' : null,
              ),
            if (!_isCurrent) SizedBox(height: 16),
            CheckboxListTile(
              title: Text('Currently Working Here'),
              value: _isCurrent,
              onChanged: (bool? value) {
                setState(() {
                  _isCurrent = value ?? false;
                  if (_isCurrent) {
                    _endDateController.clear();
                  }
                });
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: _inputDecoration('Description'),
              maxLines: 3,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveForm,
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
