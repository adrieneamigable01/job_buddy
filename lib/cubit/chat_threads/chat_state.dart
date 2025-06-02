part of 'chat_cubit.dart';


@immutable
abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object> get props => [];
}

class ChatThreadInitial extends ChatState {}

class LoadingChatThreadState extends ChatState {
  bool isLoading;

  LoadingChatThreadState(this.isLoading);

  @override
  List<Object> get props => [isLoading];
}


class FailureChatThreadState extends ChatState {
  String errorMessage;
  bool isError;

  FailureChatThreadState(this.errorMessage, this.isError);

  @override
  List<Object> get props => [errorMessage, isError];

  @override
  String toString() {
    print("**** entication Failure State Message .... : ${errorMessage}");
    return errorMessage;
  }
}
class ChatLoadedState extends ChatState {
  List<ChatThreadModel> updatedThreads;

  ChatLoadedState(this.updatedThreads);

  @override
  List<Object> get props => [updatedThreads];


}

class SuccessChatThreadState extends ChatState {
  String successMessage;
  bool isError;

  SuccessChatThreadState(this.successMessage, this.isError);

  @override
  List<Object> get props => [successMessage, isError];

  @override
  String toString() {
    print("**** entication Success State Message .... : ${successMessage}");
    return successMessage;
  }
}


class SuccessChatState extends ChatState {
  String successMessage;
  bool isError;

  SuccessChatState(this.successMessage, this.isError);

  @override
  List<Object> get props => [successMessage, isError];

  @override
  String toString() {
    print("**** entication Success State Message .... : ${successMessage}");
    return successMessage;
  }
}

class FailureChatState extends ChatState {
  String errorMessage;
  bool isError;

  FailureChatState(this.errorMessage, this.isError);

  @override
  List<Object> get props => [errorMessage, isError];

  @override
  String toString() {
    print("**** entication Failure State Message .... : ${errorMessage}");
    return errorMessage;
  }
}
class SuccesCreateChatThread extends ChatState {
  String threadId;
  String successMessage;
  bool isError;

  SuccesCreateChatThread(this.threadId,this.successMessage, this.isError);

  @override
  List<Object> get props => [threadId,successMessage, isError];

  @override
  String toString() {
    print("**** entication Failure State Message .... : ${successMessage}");
    return successMessage;
  }
}
class FailureCreateChatThreadState extends ChatState {
  String errorMessage;
  bool isError;

  FailureCreateChatThreadState(this.errorMessage, this.isError);

  @override
  List<Object> get props => [errorMessage, isError];

  @override
  String toString() {
    print("**** entication Failure State Message .... : ${errorMessage}");
    return errorMessage;
  }
}

class HasChatThreadData extends ChatState {
  bool hasData;

  HasChatThreadData(this.hasData);

  @override
  List<Object> get props => [hasData];
}
