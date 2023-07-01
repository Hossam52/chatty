import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:chatgpt/screens/chat/widgets/add_new_chats.dart';
import 'package:chatgpt/screens/chat/widgets/chat_history_item.dart';

import '../../cubits/app_cubit/app_cubit.dart';
import '../../cubits/app_cubit/app_states.dart';
import '../../widgets/ads/banner_ad_widget.dart';
import '../conversation/conversation_screen.dart';

class ChatHistoryScreen extends StatefulWidget {
  const ChatHistoryScreen({Key? key}) : super(key: key);

  @override
  State<ChatHistoryScreen> createState() => _ChatHistoryScreenState();
}

class _ChatHistoryScreenState extends State<ChatHistoryScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      primary: true,
      appBar: AppBar(
        title: const Text('Chat history'),
        actions: [
          AddNewChats(),
        ],
      ),
      body: AppBlocConsumer(listener: (context, state) {
        if (state is AddNewChatSuccessState) {
          _navigateToChat(context, state);
        }
      }, builder: (context, state) {
        final chats = AppCubit.instance(context).getChats;
        if (state is FetchAllChatsLoadingState) {
          return const Center(
              child: SpinKitCubeGrid(color: Colors.white, size: 30));
        }

        return Column(
          children: [
            const BannerAdWidget(),
            Expanded(
              child: ListView.separated(
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
      }),
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
