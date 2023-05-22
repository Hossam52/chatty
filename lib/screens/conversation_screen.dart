import 'dart:developer';

import 'package:chatgpt/constants/constants.dart';
import 'package:chatgpt/cubits/conversation_cubit/conversation_cubit.dart';
import 'package:chatgpt/cubits/conversation_cubit/conversation_states.dart';
import 'package:chatgpt/cubits/personas_cubit/personas_cubit.dart';
import 'package:chatgpt/models/chat_history_model.dart';
import 'package:chatgpt/services/services.dart';
import 'package:chatgpt/widgets/chat_widget.dart';
import 'package:chatgpt/widgets/send_message_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../providers/models_provider.dart';
import '../services/assets_manager.dart';
import '../widgets/text_widget.dart';

class ConversationScreen extends StatefulWidget {
  const ConversationScreen({super.key, required this.chat});
  final ChatModel chat;

  @override
  State<ConversationScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ConversationScreen> {
  late ScrollController _listScrollController;
  @override
  void initState() {
    _listScrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _listScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DateTime closedOn = DateTime(2023, 05, 24);
    if (closedOn.isBefore(DateTime.now())) return Container();

    return BlocProvider(
      create: (_) => ConversationCubit(widget.chat)..fetchAllMessages(),
      child: Builder(builder: (context) {
        return Scaffold(
            appBar: _appBar(context),
            body: ConversationBlocBuilder(builder: (context, state) {
              final conversationCubit = ConversationCubit.instance(context);
              if (state is FetchAllMessagesLoadingState) {
                return const Center(
                    child: SpinKitCubeGrid(color: Colors.white, size: 30));
              }
              return SafeArea(
                child: Column(
                  children: [
                    Flexible(child: BlocBuilder<PersonasCubit, PersonasState>(
                      builder: (context, state) {
                        return ListView.builder(
                            reverse: true,
                            controller: _listScrollController,
                            itemCount: conversationCubit
                                .getMessages.length, //chatList.length,
                            itemBuilder: (context, index) {
                              return MessageWidget(
                                message: conversationCubit.getMessages[index],
                              );
                            });
                      },
                    )),
                    if (conversationCubit.isGeneratingAssitantMessage) ...[
                      const SpinKitThreeBounce(
                        color: Colors.white,
                        size: 18,
                      ),
                    ],
                    const SizedBox(
                      height: 15,
                    ),
                    const SendMessageField(),
                  ],
                ),
              );
            }));
      }),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      elevation: 2,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.asset(AssetsManager.openaiLogo),
      ),
      bottom: _keywordsAppBar(),
      title: TextWidget(
        label: "Chatty (${widget.chat.chat_name})",
        fontSize: 15,
      ),
      actions: [
        IconButton(
          onPressed: () async =>
              await Services.showModalSheet(context: context),
          icon: const Icon(Icons.more_vert_rounded, color: Colors.white),
        ),
      ],
    );
  }

  AppBar _keywordsAppBar() {
    return AppBar(title: ConversationBlocBuilder(
      builder: (context, state) {
        return Row(
          children: [
            const TextWidget(label: 'Keywords: ', fontSize: 14),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: TextWidget(
                  label: ConversationCubit.instance(context).conversationTags,
                  color: Colors.white70,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        );
      },
    ));
  }
}
