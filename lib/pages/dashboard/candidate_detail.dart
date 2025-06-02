import 'package:flutter/material.dart';
import 'package:job_buddy/widgets/dashboard/joboffer/mobile/addpost_mobile_portriat.dart';
import 'package:job_buddy/widgets/dashboard/joboffer/mobile/cadidate_detail_mobile_portrait.dart';
import 'package:job_buddy/widgets/dashboard/joboffer/mobile/candidates_details_mobile_portrait.dart';
import 'package:responsive_builder/responsive_builder.dart';


class CandidateDetailPage extends StatefulWidget {
  // const DashboardPage({super.key});

  @override
  State<CandidateDetailPage> createState() => _AddPostPageState();
}

class _AddPostPageState extends State<CandidateDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Dashboard Page'),
      // ),
      body: OrientationLayoutBuilder(
        portrait: (context) => ScreenTypeLayout.builder(
          // breakpoints: ScreenBreakpoints(
          //   tablet: 768,
          //   desktop: 1200,
          //   watch: 300,
          // ),
          mobile: (BuildContext context) => CandidateDetailPageMobilePortrait(),
          tablet: (BuildContext context) => Container(color: Colors.pink),
          desktop: (BuildContext context) => Container(color: Colors.purple),
          watch: (BuildContext context) => Container(color: Colors.pink),
        ),
        landscape: (context) => ScreenTypeLayout.builder(
          // breakpoints: ScreenBreakpoints(
          //   tablet: 768.0,
          //   desktop: 1200,
          //   watch: 300,
          // ),
          mobile: (BuildContext context) => CandidateDetailPageMobilePortrait(),
          tablet: (BuildContext context) => Container(color: Colors.pink),
          desktop: (BuildContext context) => Container(color: Colors.pink),
          watch: (BuildContext context) => Container(color: Colors.purple),
        ),
      ),
    );
  }
}