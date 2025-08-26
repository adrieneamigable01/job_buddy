import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:job_buddy/models/notification_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationCard extends StatelessWidget {
  final NotificationModel notification;

  const NotificationCard({
    super.key,
    required this.notification,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        // SharedPreferences prefs = await SharedPreferences.getInstance();
        // prefs.setString('notification_id',notification.id.toString()) ?? 'No ID found';
        // context.push('/notification_details');
        
        // Your action here
          SharedPreferences prefs =
              await SharedPreferences
                  .getInstance();

          // Save skill (or any string, int, bool)
          await prefs.setString(
              'job_offers_id',
              notification.jobOffersId.toString());
          context
              .go('/job_post_details');
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              notification.title.toString(),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'From : ${notification.jobOffersId} ${notification.companyName.toString()}',
              style: TextStyle(
                fontSize: 15,
                color: Colors.black54,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }
}
