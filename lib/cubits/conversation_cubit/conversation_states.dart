//
import 'package:bloc/bloc.dart';

abstract class ConversationStates {}

class IntitalChatState extends ConversationStates {}
//

class AddUserMessage extends ConversationStates {}

class ChangeChatPersona extends ConversationStates {}

class ChangeStatusToOld extends ConversationStates {
  final int index;
  ChangeStatusToOld({required this.index});
}

//SendMessage online fetch data
class SendMessageLoadingState extends ConversationStates {}

class SendMessageSuccessState extends ConversationStates {}

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
