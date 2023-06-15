//

abstract class ConversationStates {}

class IntitalChatState extends ConversationStates {}
//

class AddUserMessage extends ConversationStates {}

class ErrorAddUserFileMessage extends ConversationStates {
  final String error;

  ErrorAddUserFileMessage(this.error);
}

class ChangeChatPersona extends ConversationStates {}

class ChangeStatusToOld extends ConversationStates {
  final int index;
  ChangeStatusToOld({required this.index});
}

//SendMessage online fetch data
class SendMessageLoadingState extends ConversationStates {}

class SendMessageSuccessState extends ConversationStates {
  final int totalMessagesSent;

  SendMessageSuccessState(this.totalMessagesSent);
}

class SendMessageErrorState extends ConversationStates {
  final String error;
  SendMessageErrorState({required this.error});
}

//FetchAllMessages online fetch data
class FetchAllMessagesLoadingState extends ConversationStates {}

class FetchAllMessagesSuccessState extends ConversationStates {}

class FetchAllMessagesErrorState extends ConversationStates {
  final String error;
  FetchAllMessagesErrorState({required this.error});
}

//SummerizeFile online fetch data
class SummerizeFileLoadingState extends ConversationStates {}

class SummerizeFileSuccessState extends ConversationStates {}

class SummerizeFileErrorState extends ConversationStates {
  final String error;
  SummerizeFileErrorState({required this.error});
}
