import 'package:flutter/material.dart';
import 'package:job_buddy/widgets/dashboard/subcription/mobile/subscirption_mobile_portriat.dart';
import 'package:job_buddy/widgets/dashboard/subscription_plan/mobile/subscirption_plan_mobile_portriat.dart';
import 'package:responsive_builder/responsive_builder.dart';

class SubscriptionPlanPage extends StatefulWidget {
  // const LoginPage({super.key});
  

  @override
  State<SubscriptionPlanPage> createState() => _SubscriptionPlanPageState();
}



class _SubscriptionPlanPageState extends State<SubscriptionPlanPage> {
  
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
          mobile: (BuildContext context) => SubscriptionPlanMobilePortrait(),
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
          mobile: (BuildContext context) => SubscriptionPlanMobilePortrait(),
          tablet: (BuildContext context) => Container(color: Colors.pink),
          desktop: (BuildContext context) => Container(color: Colors.pink),
          watch: (BuildContext context) => Container(color: Colors.purple),
        ),
      ),
    );
  }
}