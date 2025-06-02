
import 'package:flutter/material.dart';
import 'package:job_buddy/widgets/dashboard/joboffer/mobile/addpost_mobile_portriat.dart';
import 'package:job_buddy/widgets/dashboard/joboffer/mobile/candidates_details_mobile_portrait.dart';
import 'package:responsive_builder/responsive_builder.dart';


class CandidateDetailsPage extends StatefulWidget {
  // const DashboardPage({super.key});

  @override
  State<CandidateDetailsPage> createState() => _AddPostPageState();
}

class _AddPostPageState extends State<CandidateDetailsPage> {
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
          mobile: (BuildContext context) => CandidateDetailsPageMobilePortrait(),
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
          mobile: (BuildContext context) => CandidateDetailsPageMobilePortrait(),
          tablet: (BuildContext context) => Container(color: Colors.pink),
          desktop: (BuildContext context) => Container(color: Colors.pink),
          watch: (BuildContext context) => Container(color: Colors.purple),
        ),
      ),
    );
  }
}