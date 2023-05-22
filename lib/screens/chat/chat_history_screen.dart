import 'package:chatgpt/cubits/app_cubit/app_cubit.dart';
import 'package:chatgpt/cubits/app_cubit/app_states.dart';
import 'package:chatgpt/cubits/conversation_cubit/conversation_cubit.dart';
import 'package:chatgpt/screens/conversation_screen.dart';
import 'package:chatgpt/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ChatHistoryScreen extends StatefulWidget {
  const ChatHistoryScreen({Key? key}) : super(key: key);

  @override
  State<ChatHistoryScreen> createState() => _ChatHistoryScreenState();
}

class _ChatHistoryScreenState extends State<ChatHistoryScreen> {
  @override
  void initState() {
    AppCubit.instance(context).fetchAllChats();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome back ... ^_^'),
      ),
      body: SafeArea(child: AppBlocBuilder(builder: (context, state) {
        final chats = AppCubit.instance(context).getChats;
        if (state is FetchAllChatsLoadingState) {
          return const Center(
              child: SpinKitCubeGrid(color: Colors.white, size: 30));
        }

        return ListView.separated(
          padding: const EdgeInsets.all(10),
          separatorBuilder: (context, index) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            return ListTile(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                  side: const BorderSide(
                    color: Colors.grey,
                  )),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ConversationScreen(
                    chat: chats[index],
                  ),
                ));
              },
              tileColor: Colors.white24,
              title: TextWidget(
                label: chats[index].chat_name,
                fontSize: 14,
              ),
            );
          },
          itemCount: chats.length,
        );
      })),
    );
  }
}
