import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:job_buddy/models/chat_thread_model.dart';
import 'package:job_buddy/models/company_model.dart';
import 'package:job_buddy/models/student_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatInfoPagePortrait extends StatefulWidget {


  const ChatInfoPagePortrait({
    super.key,
  });

  @override
  State<ChatInfoPagePortrait> createState() => _ChatInfoPagePortraitState();
}

class _ChatInfoPagePortraitState extends State<ChatInfoPagePortrait> {

  String? thread_id;
  List<Map<String, dynamic>> participants = [];
  CompanyModel? company = CompanyModel();
  ChatThreadModel chatTreadInfo = ChatThreadModel();
  DateTime? createdAt;
  Future<void> _initLoad() async {
    final prefs = await SharedPreferences.getInstance();
   
    setState(() {
      thread_id = prefs.getString('thread_id');
     

      final thread = ChatThreadBox().getByThreadId(thread_id.toString());
      chatTreadInfo = thread!;
      final rawParticipants = thread?.participants;


      if (rawParticipants != null) {
        participants = List<Map<String, dynamic>>.from(rawParticipants);
      } else {
        participants = [];
      }

      company = CompanyBox().getByCompanyId(thread?.companyId);
      createdAt = DateTime.parse(chatTreadInfo.threadCreatedAt.toString());
      print("createdAt: $createdAt");
      
    });
  }


  
  @override
  void initState() {
    super.initState();
    _initLoad();
  }
  
  @override
  Widget build(BuildContext context) {



  print("participants : $participants");
  print("chatTreadInfo.threadCreatedAt : $createdAt");

  


    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat Info"),
        backgroundColor: const Color(0xffB5E5E6),
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Title
            Text(
              chatTreadInfo.title.toString(),
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 24),

            /// Participants
            Text(
              'Participants',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            ...participants.map((user) {
              return ListTile(
                leading: const CircleAvatar(child: Icon(Icons.person)),
                title: Text(user['full_name'] ?? 'No name'),
                subtitle: Text(user['username'] ?? ''),
                trailing: Text(user['user_type']),
              );
            }),

            const Divider(height: 32),

            /// Created At
            Text(
              'Created On',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
           Text(
              createdAt != null
                  ? DateFormat('MMMM dd, yyyy – hh:mm a').format(createdAt!)
                  : 'Unknown date',
            ),


            const Divider(height: 32),

            /// Company Info
            Text(
              'Company Info',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(company!.companyName.toString()),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(company!.email.toString()),
                  Text(company!.companyAddress.toString()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
