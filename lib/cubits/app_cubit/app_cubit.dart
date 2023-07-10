import 'dart:developer';

import 'package:chatgpt/models/home_model.dart';
import 'package:chatgpt/models/prompts/prompt_model.dart';
import 'package:chatgpt/models/prompts/prompts_map.dart';

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
  HomeModel? _homeModel;
  String get contactEmail => _homeModel?.contact_email ?? '';
  String get facebookLink => _homeModel?.facebook_link ?? '';
  List<PromptItem> get prompts => _homeModel?.prompts ?? [];
  User? get user => _homeModel?.user;
  List<ChatModel> get allChats => _homeModel?.chats ?? [];
  List<ChatModel> get allChatsPrompts => _homeModel?.chats_prompts ?? [];

  final int _showAdsAfter = 5; //Show intersential ads after # messages
  int _totalMessagesSent =
      1; //For managing the intersentitial ads after $trails of messags
  bool get showInterstitialAds =>
      currentUser.isFreeSubscription && _totalMessagesSent % _showAdsAfter == 0;

  void increaseMessagesCount() {
    _totalMessagesSent++;
  }

  int _selectedBottomIndex = 1;
  int get getSelectedBottomIndex => _selectedBottomIndex;
  set selectedBottomIndex(int index) {
    _selectedBottomIndex = index;
    emit(ChangeAppBottomState());
  }

  bool get userError => user == null;
  void updateCurrentUser(User user) {
    _homeModel?.user = user;
    emit(UpdateUserState());
  }

  User get currentUser {
    if (userError) {
      // final user = await getUser();
      throw 'Undifined user';
    } else {
      return _homeModel!.user;
    }
  }

  void decreaseQuota(int totalMessagesSent) {
    if (currentUser.isFreeSubscription)
      currentUser.remaining_messages -= totalMessagesSent;
    emit(ChangeMessagesQuota());
  }

  bool get hasExcceedQuota => currentUser.remaining_messages <= 0;

  Future<void> getHomeData() async {
    try {
      emit(GetHomeDataLoadingState());
      final res = await AppServices.getHomeData();
      _homeModel = HomeModel.fromMap(res);
      emit(GetHomeDataSuccessState());
    } catch (e) {
      emit(GetHomeDataErrorState(error: e.toString()));
    }
  }

  Future<void> fetchAllChats() async {
    try {
      if (userError) await getUser();
      final user = currentUser;
      emit(FetchAllChatsLoadingState());
      final response = await AppServices.getAllChats(user.id);
      log(response.toString());
      final _chats = (response['chats'] as List)
          .map((e) => ChatModel.fromJson(e))
          .toList();
      _homeModel?.chats = _chats;
      emit(FetchAllChatsSuccessState());
    } catch (e) {
      print(e.toString());
      emit(FetchAllChatsErrorState(error: e.toString()));
      rethrow;
    }
  }

  Future<void> addNewChat(String chatName,
      {bool isChat = true, String? initialMessage}) async {
    try {
      emit(AddNewChatLoadingState());
      final response = await AppServices.createChat(chatName, isChat);
      ChatModel chatModel = ChatModel.fromJson(response);
      _homeModel?.addChat(chatModel);
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
      _homeModel?.chats.removeWhere((element) => element.id == chat.id);
      _homeModel?.chats_prompts.removeWhere((element) => element.id == chat.id);
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
      _homeModel?.user = User.fromMap(response);
      emit(ClaimAdRewardSuccessState(response['message']));
    } catch (e) {
      emit(ClaimAdRewardErrorState(error: e.toString()));
    }
  }

  Future<void> getUser() async {
    if (!userError) return;
    try {
      emit(GetUserLoadingState());
      final response = await AuthServices.profile();
      log(response.toString());
      _homeModel?.user = User.fromMap(response);
      emit(GetUserSuccessState());
    } catch (e) {
      emit(GetUserErrorState(error: e.toString()));
    }
  }

  Future<void> getPrompts() async {
    try {
      emit(GetPromptsLoadingState());
      final response = await AppServices.getPrompts();
      _homeModel!.prompts = PromptModel.fromMap(response).data;
      emit(GetPromptsSuccessState());
    } catch (e) {
      emit(GetPromptsErrorState(error: e.toString()));
    }
  }
}
