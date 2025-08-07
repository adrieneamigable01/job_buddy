import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:job_buddy/cubit/chat_threads/chat_cubit.dart';
import 'package:job_buddy/cubit/company/company_cubit.dart';
import 'package:job_buddy/models/company_model.dart';
import 'package:job_buddy/models/student_model.dart';
import 'package:job_buddy/widgets/common/alert_dialog_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

final _studentBox = StudentBox();
final _companyDetails = CompanyBox();
final AlertDialogWidget alertDialog = AlertDialogWidget();
class NewChatPage extends StatefulWidget {
  const NewChatPage({super.key});

  @override
  State<NewChatPage> createState() => _NewChatPageState();
}

class _NewChatPageState extends State<NewChatPage> {
  final TextEditingController _titleController = TextEditingController();
  bool _isLoading = false;
  String? _userId;
  String? _studentName;

  Future<void> _createNewThread() async {
    final title = _titleController.text.trim();

    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Chat title is required')),
      );
      return;
    }

    Object payload = {
      "user2_id": _userId, 
      "title": _titleController.text,
      "company_id":CompanyBox().data.companyId
    };

    BlocProvider.of<ChatCubit>(context).createChatThreadMessage(payload);
  }

  Future<void> _initLoad() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      String? studentId = prefs.getString('studentId');
      final details = _studentBox.getByStudentId(studentId);
      final companyDetails = _companyDetails.data;
      _userId = details.userId;
      _studentName = '${details.firstname} ${details.lastname}';
      print("_studentName : ${_studentName}");
      _titleController.text =
          '${_studentName} - ${companyDetails.companyName} Application';
    });
  }

  @override
  void initState() {
    super.initState();
    _initLoad();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChatCubit, ChatState>(
      listener: (context, state) {

        if(state is LoadingChatThreadState){
            _isLoading = state.isLoading;
        }

        if(state is SuccesCreateChatThread){
          alertDialog.showConfirmDialog(
            isError: false,
            title: 'Success',
            content: state.successMessage,
            onPressCancel: () async {
              Navigator.of(context).pop(); // Close the dialog
            },
            onPressedConfirm: () async {
               Navigator.of(context).pop(); // Close the dialog
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setString('thread_id',state.threadId.toString()) ?? 'No ID found';
              context.push('/chatmessages');
            },
            context: context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("New Chat"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
          backgroundColor: const Color(0xffB5E5E6),
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Chat Title *',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _isLoading ? null : _createNewThread,
                icon: const Icon(Icons.chat_bubble_outline),
                label: const Text("Start Chat"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
