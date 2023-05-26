import 'dart:developer';

import 'package:chatgpt/models/auth/user_model.dart';
import 'package:chatgpt/models/chat_history_model.dart';
import 'package:chatgpt/shared/network/services/app_services.dart';
import 'package:chatgpt/shared/network/services/auth_services.dart';
import 'package:chatgpt/shared/network/services/chat_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import './app_states.dart';

//Bloc builder and bloc consumer methods
typedef AppBlocBuilder = BlocBuilder<AppCubit, AppStates>;
typedef AppBlocConsumer = BlocConsumer<AppCubit, AppStates>;

//
class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(IntitalAppState());
  static AppCubit instance(BuildContext context) =>
      BlocProvider.of<AppCubit>(context);
  List<ChatModel> _chats = [];

  List<ChatModel> get getChats => _chats;

  User? _user;
  Future<User> get currentUser async {
    if (_user == null) {
      final user = await getUser();
      if (user == null) throw 'Undifined user';
    }

    return _user!;
  }

  Future<void> fetchAllChats() async {
    try {
      final user = await currentUser;
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

  Future<void> addNewChat(String chatName) async {
    try {
      emit(AddNewChatLoadingState());
      final response = await AppServices.createChat(chatName);
      ChatModel chatModel = ChatModel.fromJson(response);
      _chats.add(chatModel);
      emit(AddNewChatSuccessState(chatModel));
    } catch (e) {
      emit(AddNewChatErrorState(error: e.toString()));
      rethrow;
    }
  }

  Future<User?> getUser() async {
    try {
      emit(GetUserLoadingState());
      final response = await AuthServices.profile();
      log(response.toString());
      _user = User.fromMap(response);
      emit(GetUserSuccessState());
      return _user;
    } catch (e) {
      emit(GetUserErrorState(error: e.toString()));
    }
    return null;
  }
}
