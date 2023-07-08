import 'package:chatgpt/cubits/app_cubit/app_cubit.dart';
import 'package:chatgpt/cubits/app_cubit/app_states.dart';
import 'package:chatgpt/models/chat_history_model.dart';
import 'package:chatgpt/screens/conversation/conversation_screen.dart';
import 'package:chatgpt/widgets/ads/banner_ad_widget.dart';
import 'package:chatgpt/widgets/empty_content_widget.dart';
import 'package:chatgpt/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:chatgpt/screens/chat/widgets/add_new_chats.dart';
import 'package:chatgpt/screens/chat/widgets/chat_history_item.dart';

class BaseChatHistory extends StatelessWidget {
  const BaseChatHistory({Key? key, required this.chats, required this.title})
      : super(key: key);
  final List<ChatModel> chats;
  final String title;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AppBlocConsumer(
        listener: (context, state) {
          if (state is AddNewChatSuccessState) {
            _navigateToChat(context, state);
          }
        },
        builder: (context, state) {
          if (state is FetchAllChatsLoadingState ||
              state is GetHomeDataLoadingState) {
            return const Center(
                child: SpinKitCubeGrid(color: Colors.white, size: 30));
          }

          return Column(
            children: [
              AppBar(
                title: TextWidget(label: title),
                actions: [
                  AddNewChats(),
                ],
              ),
              const BannerAdWidget(),
              Expanded(
                child: chats.isEmpty
                    ? EmptyContentWidget()
                    : ListView.separated(
                        padding: const EdgeInsets.all(10),
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          return ChatHistoryItem(chat: chats[index]);
                        },
                        itemCount: chats.length,
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _navigateToChat(BuildContext context, AddNewChatSuccessState state) {
    Navigator.pop(context);
    Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => BlocProvider.value(
              value: AppCubit.instance(context),
              child: ConversationScreen(
                  appCubit: AppCubit.instance(context),
                  chat: state.chat,
                  initialMessage: state.initialMessage),
            )));
  }
}
