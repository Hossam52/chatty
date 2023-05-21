import 'package:chatgpt/cubits/chat_cubit/chat_cubit.dart';
import 'package:chatgpt/screens/chat_screen.dart';
import 'package:chatgpt/widgets/text_widget.dart';
import 'package:flutter/material.dart';

class ChatHistoryScreen extends StatefulWidget {
  const ChatHistoryScreen({Key? key}) : super(key: key);

  @override
  State<ChatHistoryScreen> createState() => _ChatHistoryScreenState();
}

class _ChatHistoryScreenState extends State<ChatHistoryScreen> {
  @override
  void initState() {
    ChatCubit.instance(context).fetchAllChats();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome back ... ^_^'),
      ),
      body: SafeArea(child: ChatBlocBuilder(builder: (context, state) {
        final chatCubit = ChatCubit.instance(context);
        return ListView.separated(
          padding: const EdgeInsets.all(10),
          separatorBuilder: (context, index) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            return ListTile(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                  side: BorderSide(
                    color: Colors.grey,
                  )),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ChatScreen(
                    chat: chatCubit.chatsHistory[index],
                  ),
                ));
              },
              tileColor: Colors.white24,
              title: TextWidget(
                label: chatCubit.chatsHistory[index].chat_name,
                fontSize: 14,
              ),
            );
          },
          itemCount: chatCubit.chatsHistory.length,
        );
      })),
    );
  }
}
