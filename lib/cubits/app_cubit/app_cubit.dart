import 'dart:developer';

import 'package:chatgpt/models/prompts/prompt_model.dart';

import '../../models/auth/user_model.dart';
import '../../models/chat_history_model.dart';
import '../../shared/network/services/app_services.dart';
import '../../shared/network/services/auth_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'app_states.dart';

//Bloc builder and bloc consumer methods
typedef AppBlocBuilder = BlocBuilder<AppCubit, AppStates>;
typedef AppBlocConsumer = BlocConsumer<AppCubit, AppStates>;

//
class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(IntitalAppState());
  static AppCubit instance(BuildContext context) =>
      BlocProvider.of<AppCubit>(context);
  PromptModel? promptModel;
  final int _showAdsAfter = 5; //Show intersential ads after # messages
  int _totalMessagesSent =
      1; //For managing the intersentitial ads after $trails of messags
  bool get showInterstitialAds => _totalMessagesSent % _showAdsAfter == 0;

  void increaseMessagesCount() {
    _totalMessagesSent++;
  }

  int _selectedBottomIndex = 1;
  int get getSelectedBottomIndex => _selectedBottomIndex;
  set selectedBottomIndex(int index) {
    _selectedBottomIndex = index;
    emit(ChangeAppBottomState());
  }

  List<ChatModel> _chats = [];

  List<ChatModel> get getChats => _chats;

  User? _user;
  bool get userError => _user == null;
  void updateCurrentUser(User user) {
    _user = user;
    emit(UpdateUserState());
  }

  User get currentUser {
    if (userError) {
      // final user = await getUser();
      throw 'Undifined user';
    }

    return _user!;
  }

  void decreaseQuota(int totalMessagesSent) {
    currentUser.remaining_messages -= totalMessagesSent;
    emit(ChangeMessagesQuota());
  }

  bool get hasExcceedQuota => currentUser.remaining_messages <= 0;

  Future<void> fetchAllChats() async {
    try {
      if (userError) await getUser();
      final user = currentUser;
      emit(FetchAllChatsLoadingState());
      final response = await AppServices.getAllChats(user.id);
      log(response.toString());
      _chats = (response['chats'] as List)
          .map((e) => ChatModel.fromJson(e))
          .toList();
      emit(FetchAllChatsSuccessState());
    } catch (e) {
      print(e.toString());
      emit(FetchAllChatsErrorState(error: e.toString()));
      rethrow;
    }
  }

  Future<void> addNewChat(String chatName, {String? initialMessage}) async {
    try {
      emit(AddNewChatLoadingState());
      final response = await AppServices.createChat(chatName);
      ChatModel chatModel = ChatModel.fromJson(response);
      _chats.add(chatModel);
      emit(AddNewChatSuccessState(chatModel, initialMessage: initialMessage));
    } catch (e) {
      emit(AddNewChatErrorState(error: e.toString()));
      rethrow;
    }
  }

  Future<void> deleteChat(ChatModel chat) async {
    try {
      emit(DeleteChatLoadingState());
      await AppServices.deleteChat(chat.id);

      _chats.removeWhere((element) => element.id == chat.id);
      emit(DeleteChatSuccessState());
    } catch (e) {
      print(e.toString());
      emit(DeleteChatErrorState(error: e.toString()));
    }
  }

  Future<void> claimAdReward() async {
    try {
      emit(ClaimAdRewardLoadingState());
      final response = await AppServices.claimAdReward();
      _user = User.fromMap(response);
      emit(ClaimAdRewardSuccessState(response['message']));
    } catch (e) {
      emit(ClaimAdRewardErrorState(error: e.toString()));
    }
  }

  Future<void> getUser() async {
    if (_user != null) return;
    try {
      emit(GetUserLoadingState());
      final response = await AuthServices.profile();
      log(response.toString());
      _user = User.fromMap(response);
      emit(GetUserSuccessState());
    } catch (e) {
      emit(GetUserErrorState(error: e.toString()));
    }
  }

  Future<void> getPrompts() async {
    try {
      emit(GetPromptsLoadingState());
      final response = await AppServices.getPrompts();
      promptModel = PromptModel.fromMap(response);
      emit(GetPromptsSuccessState());
    } catch (e) {
      emit(GetPromptsErrorState(error: e.toString()));
    }
  }
}
