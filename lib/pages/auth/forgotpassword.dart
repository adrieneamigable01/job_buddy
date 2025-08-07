import 'package:flutter/material.dart';
import 'package:job_buddy/widgets/auth/forgot_password_mobile_portrait.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:job_buddy/widgets/auth/login_mobile_portrait.dart';

class ForgotPasswordPage extends StatefulWidget {
  // const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
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
          mobile: (BuildContext context) => ForgotPasswordPage(),
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
          mobile: (BuildContext context) => ForgotPasswordPage(),
          tablet: (BuildContext context) => Container(color: Colors.pink),
          desktop: (BuildContext context) => Container(color: Colors.pink),
          watch: (BuildContext context) => Container(color: Colors.purple),
        ),
      ),
    );
  }
}
