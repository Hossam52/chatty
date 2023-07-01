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
  final String? initialMessage;
  AddNewChatSuccessState(this.chat, {this.initialMessage});
}

class AddNewChatErrorState extends AppStates {
  final String error;
  AddNewChatErrorState({required this.error});
}

//DeleteChat online fetch data
class DeleteChatLoadingState extends AppStates {}

class DeleteChatSuccessState extends AppStates {}

class DeleteChatErrorState extends AppStates {
  final String error;
  DeleteChatErrorState({required this.error});
}

//GetUser online fetch data
class GetUserLoadingState extends AppStates {}

class GetUserSuccessState extends AppStates {}

class GetUserErrorState extends AppStates {
  final String error;
  GetUserErrorState({required this.error});
}

//ClaimAdReward online fetch data
class ClaimAdRewardLoadingState extends AppStates {}

class ClaimAdRewardSuccessState extends AppStates {
  final String message;

  ClaimAdRewardSuccessState(this.message);
}

class ClaimAdRewardErrorState extends AppStates {
  final String error;
  ClaimAdRewardErrorState({required this.error});
}

class ChangeMessagesQuota extends AppStates {}

//GetPrompts online fetch data
class GetPromptsLoadingState extends AppStates {}

class GetPromptsSuccessState extends AppStates {}

class GetPromptsErrorState extends AppStates {
  final String error;
  GetPromptsErrorState({required this.error});
}
