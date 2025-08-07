import 'package:flutter/material.dart';
import 'package:job_buddy/widgets/dashboard/joboffer/mobile/jobpost_details_mobile_portrait.dart';
import 'package:job_buddy/widgets/dashboard/profile/mobile/profile_mobile_portrait.dart';
import 'package:responsive_builder/responsive_builder.dart';

class JobPostDetailPage extends StatefulWidget {
  // const LoginPage({super.key});
  

  @override
  State<JobPostDetailPage> createState() => _JobPostDetailPageState();
}



class _JobPostDetailPageState extends State<JobPostDetailPage> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Login Page'),
      // ),
      body: OrientationLayoutBuilder(
        portrait: (context) => ScreenTypeLayout.builder(
          // breakpoints: ScreenBreakpoints(
          //   tablet: 768,
          //   desktop: 1200,
          //   watch: 300,
          // ),
          mobile: (BuildContext context) => JobPostDetailPageMobilePortrait(),
          tablet: (BuildContext context) => Container(color: Colors.pink),
          desktop: (BuildContext context) => Container(color: Colors.pink),
          watch: (BuildContext context) => Container(color: Colors.pink),
        ),
        landscape: (context) => ScreenTypeLayout.builder(
          // breakpoints: ScreenBreakpoints(
          //   tablet: 768.0,
          //   desktop: 1200,
          //   watch: 300,
          // ),
          mobile: (BuildContext context) => JobPostDetailPageMobilePortrait(),
          tablet: (BuildContext context) => Container(color: Colors.pink),
          desktop: (BuildContext context) => Container(color: Colors.pink),
          watch: (BuildContext context) => Container(color: Colors.purple),
        ),
      ),
    );
  }
}