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

class PdfWithSignaturePage extends StatefulWidget {
  final String base64Pdf;
  final String? studentId;
  final String? jobOfferId;

  const PdfWithSignaturePage({super.key, required this.base64Pdf, required this.studentId, required this.jobOfferId});

  @override
  State<PdfWithSignaturePage> createState() => _PdfWithSignaturePageState();
}

class _PdfWithSignaturePageState extends State<PdfWithSignaturePage> {
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

  Future<void> _savePdfWithSignature() async {
    if (_signatureController.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Please provide a signature")));
      return;
    }

    final pngBytes = await _signatureController.toPngBytes();
    if (pngBytes == null) return;

    final originalBytes = await File(localPdfPath!).readAsBytes();
    final document = PdfDocument(inputBytes: originalBytes);

    print("Signing page: $currentPage / Total: ${document.pages.count}");
    final page = document.pages[currentPage - 1];

    final image = PdfBitmap(pngBytes);
    page.graphics.drawImage(image, Rect.fromLTWH(signatureOffset.dx, signatureOffset.dy, 150, 75));

    final savedBytes = await document.save();
    document.dispose();

    final newFile = File('${(await getTemporaryDirectory()).path}/signed.pdf');
    await newFile.writeAsBytes(savedBytes);

    final checkDoc = PdfDocument(inputBytes: savedBytes);
    print("Signed PDF has ${checkDoc.pages.count} pages");
    checkDoc.dispose();

    final newBase64 = base64Encode(savedBytes);
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('PDF saved with signature!')));

    final base64Formatted = 'data:@file/pdf;base64,$newBase64';
    final payload = {
      'student_id': widget.studentId,
      'job_offer_id': widget.jobOfferId,
      'base64_image':base64Formatted,
    };
    BlocProvider.of<JobofferCubit>(context).studentAcceptOffer(payload: payload);   

    setState(() {
      localPdfPath = newFile.path;
      _signatureController.clear();
      isAddingSignature = false;
    });

    print('Signed base64 length: ${newBase64.length}');
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
                if (isAddingSignature) _buildSignatureOverlay(),
              ],
            ),
      floatingActionButton: isAddingSignature
          ? Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FloatingActionButton(
                  heroTag: 'clear',
                  onPressed: () => _signatureController.clear(),
                  child: const Icon(Icons.clear),
                ),
                const SizedBox(width: 16),
                FloatingActionButton(
                  heroTag: 'save',
                  onPressed: _savePdfWithSignature,
                  child: const Icon(Icons.check),
                ),
              ],
            )
          : FloatingActionButton(
              onPressed: () => setState(() => isAddingSignature = true),
              child: const Icon(Icons.edit),
            ),
    );
  }
}
