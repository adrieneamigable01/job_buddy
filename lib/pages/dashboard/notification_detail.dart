import 'package:flutter/material.dart';
import 'package:job_buddy/widgets/dashboard/chat/chat_messages_portrait.dart';
import 'package:job_buddy/widgets/dashboard/chat/new_message_portrait.dart';
import 'package:job_buddy/widgets/dashboard/notification/notification_detail.dart';
import 'package:responsive_builder/responsive_builder.dart';


class NotificationDetailPage extends StatefulWidget {
  // const NotificationDetailPage({super.key});

  @override
  State<NotificationDetailPage> createState() => _NotificationDetailPageState();
}

class _NotificationDetailPageState extends State<NotificationDetailPage> {
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
          mobile: (BuildContext context) => NotificationDetailScreen(),
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
          mobile: (BuildContext context) => NotificationDetailScreen(),
          tablet: (BuildContext context) => Container(color: Colors.pink),
          desktop: (BuildContext context) => Container(color: Colors.pink),
          watch: (BuildContext context) => Container(color: Colors.purple),
        ),
      ),
    );
  }
}