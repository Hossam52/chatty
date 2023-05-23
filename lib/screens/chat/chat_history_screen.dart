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
      resizeToAvoidBottomInset: true,
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              backgroundColor: Colors.blueGrey,
              context: context,
              builder: (_) => _CreateChatBottomSheetWidget(
                appCubit: AppCubit.instance(context),
              ),
            );
          },
          child: const Icon(Icons.add)),
      appBar: AppBar(
        title: const Text('Welcome back ... ^_^'),
      ),
      body: SafeArea(
          child: AppBlocConsumer(listener: (context, state) {
        if (state is AddNewChatSuccessState) {
          Navigator.pop(context);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => ConversationScreen(chat: state.chat)));
        }
      }, builder: (context, state) {
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

class _CreateChatBottomSheetWidget extends StatefulWidget {
  const _CreateChatBottomSheetWidget({super.key, required this.appCubit});

  final AppCubit appCubit;
  @override
  State<_CreateChatBottomSheetWidget> createState() =>
      _CreateChatBottomSheetWidgetState();
}

class _CreateChatBottomSheetWidgetState
    extends State<_CreateChatBottomSheetWidget> {
  final controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Flexible(child: TextWidget(label: 'Chat Name: ')),
              Expanded(
                  flex: 2,
                  child: TextField(
                    decoration: const InputDecoration(
                        filled: true, fillColor: Colors.white30),
                    controller: controller,
                  ))
            ],
          ),
          SizedBox(height: 15),
          OutlinedButton.icon(
              onPressed: () {
                widget.appCubit.addNewChat(controller.text);
              },
              icon: const Icon(
                Icons.save,
                color: Colors.white,
              ),
              label: const TextWidget(
                label: 'Save and create',
              ))
        ],
      ),
    );
  }
}
