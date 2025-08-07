import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:job_buddy/cubit/joboffer/joboffer_cubit.dart';
import 'package:job_buddy/models/joboffer_model.dart';
import 'package:job_buddy/models/student_model.dart';
import 'package:job_buddy/models/user_model.dart';
import 'package:job_buddy/widgets/dashboard/joboffer/mobile/student_contact_preview.dart';
import 'package:shared_preferences/shared_preferences.dart';

final JobOfferBox _jobOfferBox = JobOfferBox();
final StudentBox _studentBox = StudentBox();
final UserBox _userBox = UserBox();

class JobPostDetailPageMobilePortrait extends StatefulWidget {
  const JobPostDetailPageMobilePortrait({super.key});

  @override
  _JobPostDetailPageMobilePortraitState createState() =>
      _JobPostDetailPageMobilePortraitState();
}

class _JobPostDetailPageMobilePortraitState
    extends State<JobPostDetailPageMobilePortrait> {
  late String jobOfferId;
  JobOfferModel? jobOffer;

  @override
  void initState() {
    super.initState();
    _getJobOfferId();
  }

  Future<void> _getJobOfferId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      jobOfferId = prefs.getString('job_offers_id') ??
          'No ID found'; // Default value if not set
      jobOffer = _jobOfferBox.getById(jobOfferId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xffB5E5E6),
        appBar: AppBar(
          backgroundColor: const Color(0xffB5E5E6),
          elevation: 0,
          foregroundColor: Colors.black,
          title: const Text('Job Details'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.go('/dashboard'),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20),
            height: MediaQuery.of(context).size.height + 100,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _jobOfferBox.getById(jobOfferId)?.jobTitle ??
                      'N/A'.toString(),
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, size: 18),
                    const SizedBox(width: 5),
                    Text(_jobOfferBox.getById(jobOfferId)?.location ??
                        'N/A'.toString()),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Icon(Icons.business_center_outlined, size: 18),
                    const SizedBox(width: 5),
                    Flexible(
                      child: Text(_jobOfferBox.getById(jobOfferId)?.skills ??
                          'N/A'.toString(),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Icon(Icons.access_time_outlined, size: 18),
                    const SizedBox(width: 5),
                    Text(_jobOfferBox.getById(jobOfferId)?.employmenType ??
                        'N/A'.toString()),
                  ],
                ),
                const SizedBox(height: 20),
                const Divider(),
                const SizedBox(height: 10),
                const Text(
                  'Company Overview',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(_jobOfferBox.getById(jobOfferId)?.companyOverview ??
                    'N/A'.toString()),
                const SizedBox(height: 20),
                const Text(
                  'Qualifications:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                _buildBulletPointsFromText(
                    _jobOfferBox.getById(jobOfferId)?.qualifications ??
                        'N/A'.toString()),
                const SizedBox(height: 20),
                const Text(
                  'Job Description:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  _jobOfferBox.getById(jobOfferId)?.jobDescription ??
                      'N/A'.toString(),
                ),
                const SizedBox(height: 20),
                // Display the retrieved job_offer_id
                Text(
                  'Job Offer ID: $jobOfferId',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Visibility(
                  visible: _userBox.data.usertype == "student",
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Employer Subscription Details:',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      // Display the retrieved job_offer_id
                      Text(
                        'Plan: ${_jobOfferBox.getById(jobOfferId)?.subscription[0]['plan_name']} Plan',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Plan Description: ${_jobOfferBox.getById(jobOfferId)?.subscription[0]['description']}',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Display the retrieved job_offer_id
                Visibility(
                  visible: _userBox.data.usertype == "student",
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       const Text(
                        'AI Score:',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Reason: ${_jobOfferBox.getById(jobOfferId)?.matchReason ?? 'N/A'}',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      // Display the retrieved job_offer_id
                      Text(
                        'Score: ${_jobOfferBox.getById(jobOfferId)?.matchScore ?? 'N/A'}',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        
        floatingActionButton: _userBox.data.usertype == "student"
            ? BlocBuilder<JobofferCubit, JobofferState>(
                builder: (context, state) {
                  if (state is LoadingState) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: SizedBox(
                        width: double.infinity,
                        child: Text(
                          'Loading, please wait...',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    );
                  }

                  return (jobOffer == null || !jobOffer?.hasJobOffer || jobOffer?.jobOfferStatus != "pending")
                ? const SizedBox() : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              // final payload = {
                              //   'student_id': _studentBox.data.studentId,
                              //   'job_offer_id': jobOfferId,
                              // };
                              // BlocProvider.of<JobofferCubit>(context).studentAcceptOffer(payload: payload);
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.vertical(top: Radius.circular(20)),
                                ),
                                builder: (context) => PdfWithSignaturePage(
                                  studentId: _studentBox.data.studentId,
                                  jobOfferId:jobOfferId,
                                  base64Pdf: _jobOfferBox.data.contract.toString(),
                                ),
                              );

                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: const Text(
                              'Accept Offer',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              // TODO: Handle Decline Offer
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: const Text(
                              'Decline Offer',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              )
            : SizedBox(
                width: 200,
                child: FloatingActionButton.extended(
                  backgroundColor: const Color(0xffE6D2DB),
                  foregroundColor: Colors.black,
                  onPressed: () {
                    context.go('/candidate_details');
                  },
                  label: const Text('Candidates'),
                  icon: const Icon(Icons.people_outline),
                ),
              ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  static Widget _buildBulletPointsFromText(String text) {
    // Split the text by commas and remove any extra spaces.
    List<String> items = text.split(',').map((e) => e.trim()).toList();

    // Create a list of widgets with bullet points for each item.
    List<Widget> bulletPoints = items.map((item) {
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
    }).toList();

    // Return a column containing all the bullet points.
    return Column(children: bulletPoints);
  }
}
