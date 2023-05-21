//
import 'package:bloc/bloc.dart';

abstract class ChatStates {}

class IntitalChatState extends ChatStates {}
//

class AddUserMessage extends ChatStates {}

class ChangeChatPersona extends ChatStates {}

class ChangeStatusToOld extends ChatStates {
  final int index;
  ChangeStatusToOld({required this.index});
}

//SendMessage online fetch data
class SendMessageLoadingState extends ChatStates {}

class SendMessageSuccessState extends ChatStates {}

class SendMessageErrorState extends ChatStates {
  final String error;
  SendMessageErrorState({required this.error});
}

//FetchAllMessages online fetch data
class FetchAllMessagesLoadingState extends ChatStates {}

class FetchAllMessagesSuccessState extends ChatStates {}

class FetchAllMessagesErrorState extends ChatStates {
  final String error;
  FetchAllMessagesErrorState({required this.error});
}

//FetchAllChats online fetch data
class FetchAllChatsLoadingState extends ChatStates {}

class FetchAllChatsSuccessState extends ChatStates {}

class FetchAllChatsErrorState extends ChatStates {
  final String error;
  FetchAllChatsErrorState({required this.error});
}
