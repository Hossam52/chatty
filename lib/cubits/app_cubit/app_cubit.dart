import 'package:chatgpt/models/chat_history_model.dart';
import 'package:chatgpt/shared/network/services/app_services.dart';
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

  Future<void> fetchAllChats() async {
    try {
      emit(FetchAllChatsLoadingState());
      final response = await AppServices.getAllChats();
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
}
