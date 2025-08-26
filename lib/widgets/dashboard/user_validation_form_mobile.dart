import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:job_buddy/cubit/user_validation/user_validation_cubit.dart';
import 'package:job_buddy/widgets/common/alert_dialog_widget.dart';
import 'package:path/path.dart' as path;

class UploadValidationMobilePortrait extends StatefulWidget {
  const UploadValidationMobilePortrait({Key? key}) : super(key: key);

  @override
  State<UploadValidationMobilePortrait> createState() =>
      _UploadValidationMobilePortraitState();
}

class _UploadValidationMobilePortraitState
    extends State<UploadValidationMobilePortrait> {
  final _formKey = GlobalKey<FormState>();
  final AlertDialogWidget alertDialog = AlertDialogWidget();
  bool isLoading = false;
  File? _selectedImage;
  File? _selectedSelfie;
  String? _selectedDocType;
  String? base64SelfieFormatted;

  final List<String> _docTypes = [
    'Business Permit',
    'Valid ID',
    'Company Registration',
    'Student ID',
    'Other'
  ];

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 30, // Compress to low quality (0-100)
      maxWidth: 600, // Resize for smaller Base64
      maxHeight: 600,
    );

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void _submit() async {
    final isValidForm = _formKey.currentState?.validate() ?? false;
    final hasImage = _selectedImage != null;

    if (isValidForm && hasImage) {
      try {
        final bytes = await _selectedImage!.readAsBytes();
        final base64Content = base64Encode(bytes);
        final fileName = _selectedImage!.path.split('/').last;
        String fileExtension = fileName.split('.').last.toLowerCase();

        // Normalize extension: jpg -> jpeg
        if (fileExtension == 'jpg') {
          fileExtension = 'jpeg';
        }

        final base64Formatted = 'data:@file/$fileExtension;base64,$base64Content';

        final payload = {
          'document_type': _selectedDocType,
          'document_path': base64Formatted,
          'base64Selfie': base64SelfieFormatted,
          'file_name': fileName,
        };

        BlocProvider.of<UserValidationCubit>(context).uploadUserValidation(payload);

        alertDialog.showConfirmDialog(
          isError: false,
          title: 'Submitted',
          content: 'Your document has been uploaded for validation.',
          onPressCancel: () => context.pop(),
          onPressedConfirm: () => context.go('/dashboard'),
          context: context,
        );
      } catch (e) {
        alertDialog.showConfirmDialog(
          isError: true,
          title: 'Error',
          content: 'An error occurred while processing the file. Please try again.',
          onPressCancel: () => context.pop(),
          onPressedConfirm: () => context.pop(),
          context: context,
        );
      }
    } else {
      alertDialog.showConfirmDialog(
        isError: true,
        title: 'Missing Information',
        content: 'Please select both a document type and a file.',
        onPressCancel: () => context.pop(),
        onPressedConfirm: () => context.pop(),
        context: context,
      );
    }
  }

  String _getMimeType(String extension) {
    switch (extension) {
      case 'pdf':
        return 'application/pdf';
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'doc':
        return 'application/msword';
      case 'docx':
        return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
      default:
        return 'application/octet-stream'; // Fallback MIME type
    }
  }

  Future<void> _makeSelfie() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.front,
      imageQuality: 75,
    );

    if (pickedFile != null) {
      final file = File(pickedFile.path);
      final bytes = await file.readAsBytes();
      final base64Selfie = base64Encode(bytes);

      // Get file extension
      String fileExtension = path.extension(pickedFile.path).replaceFirst('.', '');
      if (fileExtension == 'jpg') {
        fileExtension = 'jpeg';
      }
      // Format as data URI
      final formatted = 'data:@file/$fileExtension;base64,$base64Selfie';

      setState(() {
        _selectedSelfie = file;
        base64SelfieFormatted = formatted;
      });
      
      print("📸 Base64 Formatted Selfie: ${formatted.substring(0, 60)}...");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffB5E5E6),
      appBar: AppBar(
        title: const Text('Upload Validation Document'),
        backgroundColor: const Color(0xffB5E5E6),
        elevation: 0,
        foregroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView( // Added SingleChildScrollView here
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                value: _selectedDocType,
                decoration: InputDecoration(
                  labelText: 'Select Document Type',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                items: _docTypes
                    .map((type) =>
                        DropdownMenuItem(value: type, child: Text(type)))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedDocType = value;
                  });
                },
                validator: (value) =>
                    value == null ? 'Please select a document type' : null,
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 250,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: _selectedImage == null
                      ? const Center(child: Text("Tap to select an image"))
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: FittedBox(
                            fit: BoxFit.contain,
                            alignment: Alignment.center,
                            child: Image.file(
                              _selectedImage!,
                            ),
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: _makeSelfie,
                child: Container(
                  height: 250,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: base64SelfieFormatted == null
                      ? const Center(child: Text("Tap to capture a selfie"))
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: FittedBox(
                            fit: BoxFit.contain,
                            alignment: Alignment.center,
                            child: Image.file(_selectedSelfie!),
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 30),
              BlocBuilder<UserValidationCubit, UserValidationState>(
                builder: (context, state) {
                  if (state is LoadingUserValidationState) {
                    isLoading = state.isLoading;
                  }
                  return ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffE6D2DB),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                    child: Text(isLoading ? 'Uploading' : "Submit",
                        style: isLoading ? TextStyle(color: Colors.grey, fontSize: 16) : TextStyle(color: Colors.black, fontSize: 16)),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}