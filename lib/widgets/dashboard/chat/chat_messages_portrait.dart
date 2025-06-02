import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:job_buddy/constants/api_constants.dart';
import 'package:job_buddy/cubit/auth/cubit/auth_cubit.dart';
import 'package:job_buddy/cubit/chat_threads/chat_cubit.dart';
import 'package:job_buddy/models/chat_thread_model.dart';
import 'package:job_buddy/models/response_model.dart';
import 'package:job_buddy/models/user_model.dart';
import 'package:job_buddy/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

final UserBox _userBox = UserBox();

class ChatMessagesPageMobilePortrait extends StatefulWidget {
  const ChatMessagesPageMobilePortrait({super.key});

  @override
  State<ChatMessagesPageMobilePortrait> createState() =>
      _ChatMessagesPageMobilePortraitState();
}

class _ChatMessagesPageMobilePortraitState
    extends State<ChatMessagesPageMobilePortrait> {
  String? _threadId;
  String? _userId;
  bool hasThreadData = false;

  List<ChatMessage> _messages = [];
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadThreadId();
  }

  Future<void> _loadThreadId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _threadId = prefs.getString('thread_id');
      _userId = _userBox.data.userId;
    });
    debugPrint('Loaded thread_id: $_threadId');
    checkifHasChatThreadItem();
    fetchMessages();

    Object payload = {
      "thread_id": _threadId.toString()
    };
    BlocProvider.of<ChatCubit>(context)
        .chatMarkAsRead(payload);
  }

  Future<void> fetchMessages() async {
    if (_threadId != null && _threadId!.isNotEmpty) {
      final APIServiceRepo _apiServiceRepo = APIServiceRepo();
      var payload = {'thread_id': _threadId};
      var response = await _apiServiceRepo.post(kGetChatMessageThread, payload);
      debugPrint("response : $response");

      ResponseModel responseModel = ResponseModel(json: response);
      if (!responseModel.isError) {
        final List<ChatMessage> loadedMessages =
            (responseModel.data as List<dynamic>)
                .map((item) => ChatMessage.fromJson(item))
                .toList();
        setState(() {
          _messages = loadedMessages;
        });
      }
    }

    await Future.delayed(const Duration(seconds: 2));
    fetchMessages(); // keep polling
  }

  String formatTimestamp(String createdAt) {
    final now = DateTime.now();
    final msgTime = DateTime.tryParse(createdAt);
    if (msgTime == null) return '';

    final diff = now.difference(msgTime);

    if (now.day == msgTime.day &&
        now.month == msgTime.month &&
        now.year == msgTime.year) {
      if (diff.inSeconds < 60) return '${diff.inSeconds} sec ago';
      if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
      if (diff.inHours < 24) return '${diff.inHours} hr ago';
    }

    // If message is from another day
    return DateFormat('MMM d, yyyy - h:mm a').format(msgTime);
  }

  bool _isMe(String senderId) {
    print("_userId: ${_userId}");
    return senderId == _userId;
  }

  checkifHasChatThreadItem() async {
     BlocProvider.of<ChatCubit>(context).checkifHasChatThreadItem(_threadId.toString());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChatCubit, ChatState>(
      listener: (context, state) {
        if(state is SuccessChatState){
           _controller.clear();
        }
        if(state is HasChatThreadData){
          hasThreadData = state.hasData;
          print("hasThreadData : $hasThreadData");
        }
      },
      child:  Scaffold(
        appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.push('/dashboard');
          },
        ),
        title:  !hasThreadData ? Text("Fetching chat data...",style: TextStyle(fontSize: 13,),) : Text(
          "${ChatThreadBox().getByThreadId(_threadId.toString())?.title.toString()}",
          style: TextStyle(fontSize: 13,),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setString('thread_id',_threadId.toString()) ?? 'No ID found';
              context.push('/chatinfo'); // Go back to the previous screen
            },
          ),
        ],
        backgroundColor: const Color(0xffB5E5E6),
        foregroundColor: Colors.black,
        elevation: 0,
      ),

        backgroundColor: const Color(0xffF9F9F9),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: _messages.length,
                reverse: true,
                itemBuilder: (context, index) {
                  final message = _messages[_messages.length - 1 - index];
                  final isMe = _isMe(message.senderId);
                  return Column(
                    crossAxisAlignment:
                        isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                    children: [
                      if (!isMe && message.senderName != null)
                        Padding(
                          padding: const EdgeInsets.only(left: 8, bottom: 2),
                          child: Text(
                            message.senderName!,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.75),
                        decoration: BoxDecoration(
                          color: isMe ? const Color(0xFFDCF8C6) : Colors.grey[300],
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(18),
                            topRight: const Radius.circular(18),
                            bottomLeft: Radius.circular(isMe ? 18 : 0),
                            bottomRight: Radius.circular(isMe ? 0 : 18),
                          ),
                        ),
                        child: Text(
                          message.message,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10, left: 8, right: 8),
                        child: Text(
                          formatTimestamp(message.createdAt),
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      )
                    ],
                  );

                },
              ),
            ),
            const Divider(height: 1),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: "Type a message...",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send, color: Color(0xff1F94D4)),
                    onPressed: () async {
                      final text = _controller.text.trim();
                      Object payload = {
                        "message": text,
                        "thread_id": _threadId
                      };
                      BlocProvider.of<ChatCubit>(context)
                          .sendChatMessage(payload);
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ChatMessage {
  final String messageId;
  final String threadId;
  final String senderId;
  final String message;
  final String createdAt;
  final String? senderName; 

  ChatMessage({
    required this.messageId,
    required this.threadId,
    required this.senderId,
    required this.message,
    required this.createdAt,
    required this.senderName,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      messageId: json['message_id'],
      threadId: json['thread_id'],
      senderId: json['sender_id'],
      message: json['message'],
      createdAt: json['created_at'],
      senderName: json['senderName'],
    );
  }
}
