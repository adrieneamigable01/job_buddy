import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:job_buddy/models/joboffer_model.dart';
import 'package:job_buddy/models/student_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

final JobOfferBox _jobOfferBox = JobOfferBox();

class CandidateDetailsPageMobilePortrait extends StatefulWidget {
  const CandidateDetailsPageMobilePortrait({super.key});

  @override
  _CandidateDetailsPageMobilePortraitState createState() => _CandidateDetailsPageMobilePortraitState();
}

class _CandidateDetailsPageMobilePortraitState extends State<CandidateDetailsPageMobilePortrait> {
  late String jobOfferId = '';

  @override
  void initState() {
    super.initState();
    _getJobOfferId();
  }

  Future<void> _getJobOfferId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      jobOfferId = prefs.getString('job_offers_id') ?? 'No ID found';
    });
  }

  @override
  Widget build(BuildContext context) {
    final jobOffer = _jobOfferBox.getById(jobOfferId);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey.shade200,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: Colors.black,
          title: const Text('Candidates Details', style: TextStyle(color: Colors.black)),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.go('/dashboard'),
          ),
        ),
        body: jobOffer == null
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: StudentBox().getByJobOfferId(jobOfferId).isNotEmpty
                    ? StudentBox()
                        .getByJobOfferId(jobOfferId)
                        .map<Widget>((candidate) {
                          return Card(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 4,
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: _buildHeader(candidate),
                            ),
                          );
                        }).toList()
                    : [const SizedBox.shrink()],
              ),
            )

      ),
    );
  }

  void _showDetailsModal(BuildContext context,String matchReason,String matchScore) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Reason:',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text(matchReason ?? 'N/A'),
              const SizedBox(height: 10),
              Text(
                'Score:',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text(matchScore ?? 'N/A'),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(StudentModel candidate) {
    return Stack(
      children: [
        // Main card content
        Padding(
          padding: const EdgeInsets.only(top: 12), // leave space for badge
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  '${candidate.firstname ?? 'N/A'} ${candidate.middlename ?? 'N/A'} ${candidate.lastname ?? 'N/A'}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton(
                    onPressed: () async {
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      await prefs.setString('studentId', candidate.studentId);
                      context.go('/candidate_detail');
                    },
                    child: const Text('Review', style: TextStyle(fontSize: 16)),
                  ),
                  TextButton(
                    onPressed: () => _showDetailsModal(
                      context,
                      candidate.matchReason.toString(),
                      candidate.matchScore.toString(),
                    ),
                    child: const Text('Show Details', style: TextStyle(fontSize: 16)),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Badge in the upper-left corner
        Positioned(
          top: 0,
          left: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _getBadgeColor(candidate),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: Text(
              _getBadgeText(candidate),
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  Color _getBadgeColor(dynamic candidate) {
    if (candidate.hasJobOffer == null) return Colors.grey;
    switch (candidate.jobOfferStatus) {
      case 'pending':
        return Colors.amber;
      case 'accepted':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getBadgeText(dynamic candidate) {
    if (candidate.hasJobOffer == null) return 'No Offer';
    switch (candidate.jobOfferStatus) {
      case 'pending':
        return 'Pending';
      case 'accepted':
        return 'Accepted';
      case 'rejected':
        return 'Rejected';
      default:
        return 'No Offer';
    }
  }


  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  static Widget _buildBulletPointsFromText(String text) {
    List<String> items = text.split(',').map((e) => e.trim()).toList();

    return Column(
      children: items.map((item) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('• ', style: TextStyle(fontSize: 16)),
              Expanded(child: Text(item)),
            ],
          ),
        );
      }).toList(),
    );
  }
}
