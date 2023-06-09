//
import 'package:chatgpt/models/chat_history_model.dart';

abstract class AppStates {}

class IntitalAppState extends AppStates {}

//
class ChangeAppBottomState extends AppStates {}

class UpdateUserState extends AppStates {}

//FetchAllChats online fetch data
class FetchAllChatsLoadingState extends AppStates {}

class FetchAllChatsSuccessState extends AppStates {}

class FetchAllChatsErrorState extends AppStates {
  final String error;
  FetchAllChatsErrorState({required this.error});
}

//AddNewChat online fetch data
class AddNewChatLoadingState extends AppStates {}

class AddNewChatSuccessState extends AppStates {
  final ChatModel chat;

  AddNewChatSuccessState(this.chat);
}

class AddNewChatErrorState extends AppStates {
  final String error;
  AddNewChatErrorState({required this.error});
}

//GetUser online fetch data
class GetUserLoadingState extends AppStates {}

class GetUserSuccessState extends AppStates {}

class GetUserErrorState extends AppStates {
  final String error;
  GetUserErrorState({required this.error});
}
