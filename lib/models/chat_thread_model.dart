import 'package:hive/hive.dart';
import 'package:job_buddy/helpers/hive_db_helper.dart';
import 'package:job_buddy/models/response_model.dart';

part 'chat_thread_model.g.dart';

@HiveType(typeId: 11) // Make sure this is unique and not same as others
class ChatThreadModel {
  @HiveField(0)
  String? threadId;

  @HiveField(1)
  String? user1Id;

  @HiveField(2)
  String? user2Id;

  @HiveField(3)
  String? title;

  @HiveField(4)
  String? threadCreatedAt;

  @HiveField(5)
  String? createdBy;

  @HiveField(6)
  String? createdByUsername;

  @HiveField(7)
  String? lastMessage;

  @HiveField(8)
  String? lastMessageTime;

  @HiveField(9)
  String? lastMessageRead;

  @HiveField(10)
  String? lastMessageSender;

  @HiveField(11)
  String? createdByName;
  
  @HiveField(12)
  dynamic participants;

  @HiveField(13)
  dynamic companyId;

  @HiveField(14)
  dynamic readByUsers;

  ChatThreadModel({
    this.threadId,
    this.user1Id,
    this.user2Id,
    this.title,
    this.threadCreatedAt,
    this.createdBy,
    this.createdByUsername,
    this.lastMessage,
    this.lastMessageTime,
    this.lastMessageRead,
    this.lastMessageSender,
    this.createdByName,
    this.participants,
    this.companyId,
    this.readByUsers,
  });

  factory ChatThreadModel.fromJson(Map<String, dynamic> json) {
    return ChatThreadModel(
      threadId: json['thread_id'],
      user1Id: json['user1_id'],
      user2Id: json['user2_id'],
      title: json['title'],
      threadCreatedAt: json['thread_created_at'],
      createdBy: json['created_by'],
      createdByUsername: json['created_by_username'],
      lastMessage: json['last_message'],
      lastMessageTime: json['last_message_time'],
      lastMessageRead: json['last_message_read'],
      lastMessageSender: json['last_message_sender'],
      createdByName: json['created_by_name'],
      participants: json['participants'],
      companyId: json['company_id'],
      readByUsers: json['read_by_users'],
    );
  }

  Map<String, dynamic> toJson() => {
        'thread_id': threadId,
        'user1_id': user1Id,
        'user2_id': user2Id,
        'title': title,
        'thread_created_at': threadCreatedAt,
        'created_by': createdBy,
        'created_by_username': createdByUsername,
        'last_message': lastMessage,
        'last_message_time': lastMessageTime,
        'last_message_read': lastMessageRead,
        'last_message_sender': lastMessageSender,
        'created_by_name': createdByName,
        'participants': participants,
        'companyId': companyId,
        'read_by_users': readByUsers,
      };
}

class ChatThreadBox {
  Box get _chatThreadBox {
    return Hive.box(Boxes.chatThreadBox); // Box name should be declared in your helper
  }


  ChatThreadModel get data {
    return _chatThreadBox.getAt(0);
  }

  List<ChatThreadModel> get items {
    return _chatThreadBox.values.cast<ChatThreadModel>().toList();
  }

  Future<void> insert(Map<String, dynamic> json) async {
    final data = ChatThreadModel.fromJson(json);
    await _chatThreadBox.put(data.threadId, data);
  }

  Future<void> insertAll(ResponseModel response) async {
    for (var element in response.data) {
      final data = ChatThreadModel.fromJson(element);
      await _chatThreadBox.put(data.threadId, data);
    }
  }

  int count() => _chatThreadBox.length;

  ChatThreadModel? getById(String id) => _chatThreadBox.get(id);

  ChatThreadModel? getByThreadId(String id) {
    return _chatThreadBox.values.firstWhere(
      (element) => element.threadId.toString() == id.toString(),
      orElse: () => null,  // Return null if no item is found
    );
  }

  Future<void> update(ChatThreadModel thread) async {
    await _chatThreadBox.put(thread.threadId, thread);
  }

  Future<void> clear() async => await _chatThreadBox.clear();

  bool get isEmpty => _chatThreadBox.isEmpty;
}
