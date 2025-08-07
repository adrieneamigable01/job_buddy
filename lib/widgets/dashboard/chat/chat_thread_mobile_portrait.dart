import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:job_buddy/cubit/chat_threads/chat_cubit.dart';
import 'package:job_buddy/models/chat_thread_model.dart';
import 'package:job_buddy/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatThreadsWidget extends StatelessWidget {
  final List<ChatThreadModel> threads;

  const ChatThreadsWidget({super.key, required this.threads});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: threads.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        final thread = threads[index];
        
        // Format the last message time
        String formattedTime = _formatLastMessageTime(thread.lastMessageTime);

        // Retrieve the user ID
        return FutureBuilder<SharedPreferences>(
          future: SharedPreferences.getInstance(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              final prefs = snapshot.data;
              final String userId = UserBox().data.userId;
              bool isRead = thread.readByUsers == null ? false :_isUserInReadList(userId, thread.readByUsers);

              // Build the UI
              return ListTile(
                leading: const CircleAvatar(
                  backgroundImage: NetworkImage(""),
                ),
                title: Text(
                  thread.title ?? "", 
                  style: TextStyle(
                    fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  thread.lastMessage ?? "",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Text(formattedTime),
                onTap: () async {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  prefs.setString('thread_id', thread.threadId.toString()) ?? 'No ID found';
                  context.push('/chatmessages');
                },
              );
            } else {
              return const CircularProgressIndicator();  // You can show a loading indicator if data is still loading.
            }
          },
        );
      },
    );
  }

  bool _isUserInReadList(String userId, String readByUsers) {
    if (readByUsers.isEmpty) return false;
    // Split the readByUsers string and check if the userId is in the list
    List<String> readUsers = readByUsers.split(',');
    return readUsers.contains(userId);
  }

  String _formatLastMessageTime(String? lastMessageTime) {
    if (lastMessageTime == null) {
      return '';
    }

    // Parse the last message time to a DateTime object
    DateTime messageTime = DateTime.parse(lastMessageTime);
    DateTime now = DateTime.now();

    // Check if the message is today
    if (_isSameDay(now, messageTime)) {
      Duration difference = now.difference(messageTime);

      // Display relative time if the message is recent (less than 24 hours)
      if (difference.inMinutes < 1) {
        return 'Just now';
      } else if (difference.inMinutes < 60) {
        return '${difference.inMinutes} min ago';
      } else if (difference.inHours < 24) {
        return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
      }
    }

    // If the message is not today, format it to show the date and time in minutes:seconds
    return DateFormat('HH:mm').format(messageTime);
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
  }
}
