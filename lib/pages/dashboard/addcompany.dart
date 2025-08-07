import 'package:flutter/material.dart';
import 'package:job_buddy/widgets/dashboard/company/addcompany_mobile_portriat.dart';
import 'package:job_buddy/widgets/dashboard/joboffer/mobile/addpost_mobile_portriat.dart';
import 'package:responsive_builder/responsive_builder.dart';


class AddCompanyPage extends StatefulWidget {
  // const DashboardPage({super.key});

  @override
  State<AddCompanyPage> createState() => _AddCompanyPageState();
}

class _AddCompanyPageState extends State<AddCompanyPage> {
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
          mobile: (BuildContext context) => AddCompanyMobilePortrait(),
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
          mobile: (BuildContext context) => AddCompanyMobilePortrait(),
          tablet: (BuildContext context) => Container(color: Colors.pink),
          desktop: (BuildContext context) => Container(color: Colors.pink),
          watch: (BuildContext context) => Container(color: Colors.purple),
        ),
      ),
    );
  }
}