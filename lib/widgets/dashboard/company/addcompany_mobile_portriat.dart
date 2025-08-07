import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:job_buddy/cubit/company/company_cubit.dart';
import 'package:job_buddy/widgets/common/alert_dialog_widget.dart';
import 'package:image/image.dart' as img;

class AddCompanyMobilePortrait extends StatefulWidget {
  const AddCompanyMobilePortrait({super.key});

  @override
  State<AddCompanyMobilePortrait> createState() =>
      _AddCompanyMobilePortraitState();
}

class _AddCompanyMobilePortraitState extends State<AddCompanyMobilePortrait> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _companyNameController = TextEditingController(text:'Vinaro');
  final TextEditingController _companyAddressController =
      TextEditingController(text: 'Cebu');
  final TextEditingController _contactNumberController =
      TextEditingController(text: '09154520173');
  final TextEditingController _emailController = TextEditingController(text: '');
  final TextEditingController _establishedDateController =
      TextEditingController(text: '2025-04-01');

  File? _companyLogo;
  String? _base64Logo; // This will hold the base64 string
  final ImagePicker _picker = ImagePicker();
  final AlertDialogWidget alertDialog = AlertDialogWidget();
  Future<void> _pickLogo() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      // Show loading dialog
      alertDialog.showLoadingDialog(context: context, onPressed: () {},loadingMessage: 'Uploading image...');

      // Let the UI render the loading dialog
      await Future.delayed(Duration(milliseconds: 100));

      final file = File(pickedFile.path);
      final originalBytes = await file.readAsBytes();

      final image = img.decodeImage(originalBytes);
      if (image == null) {
        Navigator.of(context, rootNavigator: true).pop(); // Close dialog
        return;
      }

      final resizedImage = img.copyResize(image, width: 300);
      final compressedBytes = img.encodeJpg(resizedImage, quality: 70);

      setState(() {
        _companyLogo = file;
        _base64Logo = base64Encode(compressedBytes);
      });

      // Close loading dialog
      Navigator.of(context, rootNavigator: true).pop();
    }
  }


  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      _establishedDateController.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  void _submitForm() {
     print("_base64Logo.toString(): ${_base64Logo?.length.toString()}");
     print("_base64Logo.toString(): ${_base64Logo.toString()}");
     
    if (_formKey.currentState!.validate()) {
      // Construct payload here or send data to backend
      Object payload = {
        'company_name': _companyNameController.text,
        'company_address': _companyAddressController.text,
        'contact_number': _contactNumberController.text,
        'email': _emailController.text,
        'established_date': _establishedDateController.text,
        'company_logo': _base64Logo.toString(),
        // Add employer_id & company_id if you fetch them elsewhere
      };
      BlocProvider.of<CompanyCubit>(context).createCompany(payload: payload);return;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please complete all fields and select a logo.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CompanyCubit, CompanyState>(
      listener: (context, state) {
         if (state is FailureState) {
                Navigator.of(context, rootNavigator: true).pop();
                alertDialog.showAlertDialog(
                  isError: state.isError,
                  title: 'Create Company',
                  content: state.errorMessage,
                  onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop();
                       context.go('/add_post');
                  },
                  context: context,
                );
              }

              if (state is SuccessState) {
                Navigator.of(context, rootNavigator: true).pop();
                alertDialog.showAlertDialog(
                  isError: state.isError,
                  title: 'Create Company',
                  content: state.successMessage,
                  onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop();
                       context.go('/add_post');
                  },
                  context: context,
                );
              }

              if (state is LoadingState && state.isLoading) {
                alertDialog.showLoadingDialog(
                    context: context, onPressed: () {});
              }
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: const Color(0xffB5E5E6),
          appBar: AppBar(
            backgroundColor: const Color(0xffB5E5E6),
            title: const Text("Add Company"),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.pop(),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildTextField("Company Name", _companyNameController),
                  _buildTextField("Company Address", _companyAddressController),
                  _buildTextField("Contact Number", _contactNumberController,
                      keyboardType: TextInputType.phone),
                  _buildTextField("Company Email", _emailController,
                      keyboardType: TextInputType.emailAddress),
                  GestureDetector(
                    onTap: () => _selectDate(context),
                    child: AbsorbPointer(
                      child: _buildTextField(
                          "Established Date", _establishedDateController),
                    ),
                  ),
                  const SizedBox(height: 10),
                  _companyLogo == null
                      ? ElevatedButton(
                          onPressed: _pickLogo,
                          child: const Text("Select Company Logo"),
                        )
                      : Column(
                          children: [
                            Image.file(_companyLogo!, height: 100),
                            TextButton(
                              onPressed: _pickLogo,
                              child: const Text("Change Logo"),
                            )
                          ],
                        ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffE6D2DB),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                    child: const Text("Submit",
                        style: TextStyle(color: Colors.black, fontSize: 16)),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller,
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
        ),
      ),
    );
  }
}
