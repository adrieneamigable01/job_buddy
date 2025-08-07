import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:job_buddy/cubit/joboffer/joboffer_cubit.dart';
import 'package:job_buddy/models/joboffer_model.dart';
import 'package:job_buddy/models/student_model.dart';
import 'package:job_buddy/widgets/dashboard/joboffer/mobile/preview_contact.dart';
import 'package:job_buddy/widgets/dashboard/joboffer/mobile/upload_contact_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:job_buddy/widgets/common/alert_dialog_widget.dart';

final StudentBox _studentBox = StudentBox();
final AlertDialogWidget alertDialog = AlertDialogWidget();

class CandidateDetailPageMobilePortrait extends StatefulWidget {
  const CandidateDetailPageMobilePortrait({super.key});

  @override
  _CandidateDetailPageMobilePortraitState createState() =>
      _CandidateDetailPageMobilePortraitState();
}

class _CandidateDetailPageMobilePortraitState
    extends State<CandidateDetailPageMobilePortrait> {
  late String studentId = '';
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  StudentModel? studentDetails;

  @override
  void initState() {
    super.initState();
    _getStudentId();
  }

  Future<void> _getStudentId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    studentId = prefs.getString('studentId') ?? 'No ID found';
    print("studentId : $studentId");
    // After getting studentId, fetch student details
    final details = _studentBox.getByStudentId(studentId);

    if (details != null) {
      setState(() {
        firstNameController.text = details.firstname ?? '';
        lastNameController.text = details.lastname ?? '';
        emailController.text = details.email ?? '';
        phoneController.text = details.phone ?? '';
        studentDetails = details;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocListener<JobofferCubit, JobofferState>(
        listener: (context, state) {
          if (state is SuccessState) {
            alertDialog.showAlertMessage(
                isError: false,
                title: 'Success',
                desc: "Successfuly send job offer",
                context: context);
          }
        },
        child: Scaffold(
          backgroundColor: Colors.grey.shade300,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () => context.go('/dashboard'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // // TODO: Handle Send Offer
                    // Object payload = {
                    //   'student_id':
                    //       _studentBox.getByStudentId(studentId).studentId,
                    //   'job_offer_id':
                    //       _studentBox.getByStudentId(studentId).jobOffersId,
                    // };
                    // BlocProvider.of<JobofferCubit>(context)
                    //     .sendStudentOffer(payload: payload);
                    
                     showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      builder: (context) => UploadContractForm(
                        studentId: studentDetails?.studentId ?? '',
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.greenAccent.shade400,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                  ),
                  child: BlocBuilder<JobofferCubit, JobofferState>(
                    builder: (context, state) {
                      return Text(
                        state is LoadingState ? 'Sending..' : 'Send Offer',
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          body: studentDetails == null
              ? const Center(child: Text("No Details"))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildTextField(firstNameController, 'First Name'),
                      const SizedBox(height: 10),
                      _buildTextField(lastNameController, 'Last Name'),
                      const SizedBox(height: 10),
                      _buildTextField(emailController, 'Email Address'),
                      const SizedBox(height: 10),
                      _buildTextField(phoneController, 'Phone Number'),
                      const SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _bottomButton(
                              'Message', const Color(0xff26A9EB), Colors.black),
                          _bottomButton('View Resume', const Color(0xffE6D2DB),
                              const Color(0xff1F94D4)),
                        ],
                      ),
                      SizedBox(height:25),
                      Visibility(
                        visible: studentDetails?.contract != null,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _bottomButton('View Contract', const Color(0xffE6D2DB),
                                const Color(0xff1F94D4)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _bottomButton(String label, Color color, Color textColor) {
    return ElevatedButton(
      onPressed: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
  
          // Save skill (or any string, int, bool)
          await prefs.setString('studentId', studentId);

        if(label == "Message"){
          context.push('/newmessages');
        }else if(label == "View Contract"){
          print("studentDetails?.contract : ${studentDetails?.contract}");
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (context) => PreviewContract(
              base64Pdf: studentDetails?.contract ?? '',
            ),
          );
        }
        else{
           
            context.go('/resume_page');
        }
       
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        elevation: 5,
      ),
      child: Text(
        label,
        style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
      ),
    );
  }
}
