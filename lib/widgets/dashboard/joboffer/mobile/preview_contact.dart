import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_buddy/cubit/joboffer/joboffer_cubit.dart';
import 'package:path_provider/path_provider.dart';
import 'package:signature/signature.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PreviewContract extends StatefulWidget {
  final String base64Pdf;

  const PreviewContract({super.key, required this.base64Pdf});

  @override
  State<PreviewContract> createState() => _PreviewContractState();
}

class _PreviewContractState extends State<PreviewContract> {
  String? localPdfPath;
  final SignatureController _signatureController =
      SignatureController(penStrokeWidth: 3, penColor: Colors.black);
  Offset signatureOffset = const Offset(100, 100);
  bool isAddingSignature = false;
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  final PdfViewerController _pdfViewerController = PdfViewerController();

  int currentPage = 1;
  int totalPages = 1;

  @override
  void initState() {
    super.initState();
    _loadPdfFromBase64(widget.base64Pdf);
  }

  Future<void> _loadPdfFromBase64(String base64Pdf) async {
    final base64Clean = widget.base64Pdf.replaceFirst(RegExp(r'data:.*;base64,'), '');
    final bytes = base64Decode(base64Clean);
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/temp.pdf');
    await file.writeAsBytes(bytes);

    final document = PdfDocument(inputBytes: bytes);
    totalPages = document.pages.count;
    print("Original PDF has $totalPages pages");
    document.dispose();

    setState(() {
      localPdfPath = file.path;
      currentPage = 1;
    });
  }


  Widget _buildSignatureOverlay() {
    return Stack(
      children: [
        Positioned(
          left: signatureOffset.dx,
          top: signatureOffset.dy,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag Handle
              GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    signatureOffset += details.delta;
                  });
                },
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue.withOpacity(0.8),
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(Icons.open_with, size: 16, color: Colors.white),
                ),
              ),
              // Signature Box
              Container(
                width: 150,
                height: 75,
                margin: const EdgeInsets.only(top: 4),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue),
                  color: Colors.transparent,
                ),
                child: Signature(
                  controller: _signatureController,
                  backgroundColor: Colors.transparent,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }



  @override
  void dispose() {
    _signatureController.dispose();
    _pdfViewerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("PDF with Signature"),
        actions: [
          if (!isAddingSignature)
            IconButton(
              icon: const Icon(Icons.navigate_before),
              onPressed: () {
                if (currentPage > 1) {
                  setState(() => currentPage--);
                  _pdfViewerController.jumpToPage(currentPage);
                }
              },
            ),
          if (!isAddingSignature)
            IconButton(
              icon: const Icon(Icons.navigate_next),
              onPressed: () {
                if (currentPage < totalPages) {
                  setState(() => currentPage++);
                  _pdfViewerController.jumpToPage(currentPage);
                }
              },
            ),
        ],
      ),
      body: localPdfPath == null
          ? const Center(child: Text("Loading PDF...."))
          : Stack(
              children: [
                SfPdfViewer.file(
                  File(localPdfPath!),
                  key: _pdfViewerKey,
                  controller: _pdfViewerController,
                  onPageChanged: (details) {
                    setState(() => currentPage = details.newPageNumber);
                  },
                ),
              ],
            ),
    );
  }
}
