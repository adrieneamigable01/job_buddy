import 'package:flutter/material.dart';
import 'package:job_buddy/widgets/dashboard/subcription/mobile/subscirption_mobile_portriat.dart';
import 'package:job_buddy/widgets/dashboard/user_validation_form_mobile.dart';
import 'package:responsive_builder/responsive_builder.dart';

class UserValidationPage extends StatefulWidget {
  // const LoginPage({super.key});
  

  @override
  State<UserValidationPage> createState() => _UserValidationPageState();
}



class _UserValidationPageState extends State<UserValidationPage> {
  
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
          mobile: (BuildContext context) => UploadValidationMobilePortrait(),
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
          mobile: (BuildContext context) => UploadValidationMobilePortrait(),
          tablet: (BuildContext context) => Container(color: Colors.pink),
          desktop: (BuildContext context) => Container(color: Colors.pink),
          watch: (BuildContext context) => Container(color: Colors.purple),
        ),
      ),
    );
  }
}