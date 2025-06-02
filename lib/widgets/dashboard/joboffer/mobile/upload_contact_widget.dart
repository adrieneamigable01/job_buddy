import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_buddy/cubit/joboffer/joboffer_cubit.dart';
import 'package:job_buddy/models/student_model.dart';

class UploadContractForm extends StatefulWidget {
  final String studentId;

  const UploadContractForm({
    super.key,
    required this.studentId,
  });

  @override
  State<UploadContractForm> createState() => _UploadContractFormState();
}

class _UploadContractFormState extends State<UploadContractForm> {
  final TextEditingController contractTitleController = TextEditingController();
  File? _selectedImage;
  String? selectedFilePath;

  final StudentBox _studentBox = StudentBox();

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null) {
      setState(() {
        _selectedImage = File(result.files.single.path.toString());
        selectedFilePath = result.files.single.path;
      });
    }
  }

  void _submitContract() async {
    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

     final bytes = await _selectedImage!.readAsBytes();
      final base64Content = base64Encode(bytes);
      final fileName = _selectedImage!.path.split('/').last;
      String fileExtension = fileName.split('.').last.toLowerCase();

      // Normalize extension: jpg -> jpeg
      if (fileExtension == 'jpg') {
        fileExtension = 'jpeg';
      }

      final base64Formatted = 'data:@file/$fileExtension;base64,$base64Content';

    Object payload = {
      'student_id':
          _studentBox.getByStudentId(widget.studentId).studentId,
      'job_offer_id':
          _studentBox.getByStudentId(widget.studentId).jobOffersId,
      'pdf_path':base64Formatted
    };
    BlocProvider.of<JobofferCubit>(context)
        .sendStudentOffer(payload: payload);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500,
      child: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Upload Contract", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _pickFile,
                icon: const Icon(Icons.attach_file),
                label: const Text('Pick PDF File'),
              ),
              if (selectedFilePath != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text('Selected: ${selectedFilePath!.split('/').last}'),
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitContract,
                child: const Text('Submit Contract'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
