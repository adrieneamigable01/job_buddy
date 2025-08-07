import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:job_buddy/constants/api_constants.dart';
import 'package:job_buddy/cubit/profile/profile_cubit.dart';
import 'package:job_buddy/models/chat_thread_model.dart';
import 'package:job_buddy/models/response_model.dart';

import 'package:meta/meta.dart';
import 'package:job_buddy/services/api_service.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatThreadInitial());

  final APIServiceRepo _apiServiceRepo = APIServiceRepo();

  final ChatThreadBox _chatThreadBox = ChatThreadBox();

  clearBoxes() async {
    await _chatThreadBox.clear(); 
  }

  getChatUpdatedTreads() async {
    final updatedThreads = _chatThreadBox.items;

    print("updatedThreads length : ${updatedThreads.length}");
    emit(ChatLoadedState(updatedThreads)); // ⬅️ FINAL emit
  }

  
  getChatTreads() async {

    var response = await _apiServiceRepo.get(kGetChatThread);
    ResponseModel responseModel = ResponseModel(json: response);

    if (!responseModel.isError) {
      await clearBoxes();
      await _chatThreadBox.insertAll(responseModel);
      final updatedThreads = _chatThreadBox.items;

      print("updatedThreads length : ${updatedThreads.length}");
      emit(ChatLoadedState(updatedThreads)); // ⬅️ FINAL emit
    } else {
      emit(FailureChatThreadState(responseModel.message, responseModel.isError));
    }

  }
  sendChatMessage(Object payload) async {
    emit(LoadingChatThreadState(true)); // ⬅️ FINAL emit
    var response = await _apiServiceRepo.post(kChatSendMessage,payload);
    ResponseModel responseModel = ResponseModel(json: response);

    if (!responseModel.isError) {
      emit(SuccessChatState(responseModel.message,responseModel.isError)); 
      emit(LoadingChatThreadState(false)); // ⬅️ FINAL emit
    } else {
      emit(FailureChatState(responseModel.message, responseModel.isError));
      emit(LoadingChatThreadState(false)); // ⬅️ FINAL emit
    }

  }
  createChatThreadMessage(Object payload) async {
    emit(LoadingChatThreadState(true)); // ⬅️ FINAL emit
    var response = await _apiServiceRepo.post(kChatCreateThreadMessage,payload);
    ResponseModel responseModel = ResponseModel(json: response);

    if (!responseModel.isError) {
      await getChatTreads();
      emit(SuccesCreateChatThread(responseModel.data['thread_id'].toString(),responseModel.message,responseModel.isError)); 
      emit(LoadingChatThreadState(false)); // ⬅️ FINAL emit
    } else {
      emit(FailureCreateChatThreadState(responseModel.message, responseModel.isError));
      emit(LoadingChatThreadState(false)); // ⬅️ FINAL emit
    }

  }
  
  chatMarkAsRead(Object payload) async {
    emit(LoadingChatThreadState(true)); // ⬅️ FINAL emit
    var response = await _apiServiceRepo.post(kChatMarkAsRead,payload);
    ResponseModel responseModel = ResponseModel(json: response);

    if (!responseModel.isError) {
      getChatUpdatedTreads();
      emit(LoadingChatThreadState(false)); // ⬅️ FINAL emit
    } else {
      emit(FailureCreateChatThreadState(responseModel.message, responseModel.isError));
      emit(LoadingChatThreadState(false)); // ⬅️ FINAL emit
    }

  }

  checkifHasChatThreadItem(String threadId) async {
    var threadData = _chatThreadBox.getByThreadId(threadId);
    emit(HasChatThreadData(threadData != null ? true : false));
  }
  
}
