import 'dart:developer';

import 'package:chatgpt/constants/ad_helper.dart';
import 'package:chatgpt/cubits/app_cubit/app_cubit.dart';
import 'package:chatgpt/cubits/conversation_cubit/conversation_cubit.dart';
import 'package:chatgpt/cubits/conversation_cubit/conversation_states.dart';
import 'package:chatgpt/cubits/personas_cubit/personas_cubit.dart';
import 'package:chatgpt/models/chat_history_model.dart';
import 'package:chatgpt/services/services.dart';
import 'package:chatgpt/shared/methods.dart';
import 'package:chatgpt/shared/presentation/resourses/assets_manager.dart';
import 'package:chatgpt/shared/presentation/resourses/color_manager.dart';
import 'package:chatgpt/widgets/ads/banner_ad_widget.dart';
import 'package:chatgpt/widgets/chat_dialogs/tag_details_dialog.dart';
import 'package:chatgpt/widgets/chat_widget.dart';
import 'package:chatgpt/widgets/send_message_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../widgets/text_widget.dart';

class ConversationScreen extends StatefulWidget {
  const ConversationScreen({super.key, required this.chat});
  final ChatModel chat;

  @override
  State<ConversationScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ConversationScreen> {
  late ScrollController _listScrollController;
  InterstitialAd? _interstitialAd;

  @override
  void initState() {
    _loadInterstitialAd();
    _listScrollController = ScrollController();
    super.initState();
  }

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              log('On DismissedFullScreenContent');
            },
          );

          setState(() {
            _interstitialAd = ad;
          });
        },
        onAdFailedToLoad: (err) {
          debugPrint('Failed to load an interstitial ad: ${err.message}');
        },
      ),
    );
  }

  @override
  void dispose() {
    _listScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBlocBuilder(
      builder: (context, state) {
        final appCubit = AppCubit.instance(context);
        if (appCubit.userError) {
          return TextButton(
              onPressed: () async {
                appCubit.getUser();
              },
              child:
                  const TextWidget(label: 'Error happened in user try again'));
        }
        return BlocProvider(
          create: (_) => ConversationCubit(widget.chat)..fetchAllMessages(),
          child: Builder(builder: (context) {
            return Scaffold(
                appBar: _appBar(context),
                body: Column(
                  children: [
                    const BannerAdWidget(),
                    _roleSelection(context),
                    Expanded(
                      child:
                          ConversationBlocConsumer(listener: (context, state) {
                        if (state is SendMessageSuccessState) {
                          _successSendMessage(context);
                          AppCubit.instance(context)
                              .decreaseQuota(state.totalMessagesSent);
                        }
                        if (state is ErrorAddUserFileMessage) {
                          Methods.showSnackBar(context, state.error);
                        }
                      }, builder: (context, state) {
                        final conversationCubit =
                            ConversationCubit.instance(context);
                        if (state is FetchAllMessagesLoadingState) {
                          return const Center(
                              child: SpinKitCubeGrid(
                                  color: Colors.white, size: 30));
                        }
                        return SafeArea(
                          child: Column(
                            children: [
                              _messages(conversationCubit),
                              _loadingResponse(conversationCubit),
                              const SizedBox(
                                height: 15,
                              ),
                              if (conversationCubit.tagsStrings.isNotEmpty)
                                _keywordsAppBar(),
                              const SendMessageField(),
                            ],
                          ),
                        );
                      }),
                    ),
                  ],
                ));
          }),
        );
      },
    );
  }

  Widget _loadingResponse(ConversationCubit conversationCubit) {
    if (conversationCubit.isGeneratingAssitantMessage) {
      return const SpinKitThreeBounce(
        color: Colors.white,
        size: 18,
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Flexible _messages(ConversationCubit conversationCubit) {
    return Flexible(child: BlocBuilder<PersonasCubit, PersonasState>(
      builder: (context, state) {
        return ListView.builder(
            reverse: true,
            controller: _listScrollController,
            itemCount: conversationCubit.getMessages.length, //chatList.length,
            itemBuilder: (context, index) {
              return MessageWidget(
                message: conversationCubit.getMessages[index],
              );
            });
      },
    ));
  }

  void _successSendMessage(BuildContext context) {
    if (_interstitialAd != null &&
        AppCubit.instance(context).showInterstitialAds) {
      _interstitialAd?.show();
      _loadInterstitialAd();
    }
    AppCubit.instance(context).increaseMessagesCount();
  }

  ExpansionTileTheme _roleSelection(BuildContext context) {
    return ExpansionTileTheme(
      data: ExpansionTileThemeData(
        iconColor: ColorManager.grey,
        collapsedIconColor: ColorManager.grey,
        collapsedBackgroundColor: ColorManager.primary,
        backgroundColor: ColorManager.primary.withOpacity(0.8),
      ),
      child: ExpansionTile(
        title: Center(
          child: TextWidget(
            label: 'Select role',
            color: ColorManager.grey,
          ),
        ),
        children: [Services.roleSelection(context)],
      ),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      elevation: 2,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.asset(AssetsManager.openaiLogo),
      ),
      // bottom: _keywordsAppBar(),
      title: TextWidget(
        label: "Chatty (${widget.chat.chat_name})",
        fontSize: 15,
      ),
      // actions: [
      //   IconButton(
      //     onPressed: () async =>
      //         await Services.showModalSheet(context: context),
      //     icon: const Icon(Icons.more_vert_rounded, color: Colors.white),
      //   ),
      // ],
    );
  }

  AppBar _keywordsAppBar() {
    return AppBar(
        leadingWidth: 0,
        leading: const SizedBox.shrink(),
        title: ConversationBlocBuilder(
          builder: (context, state) {
            final conversationCubit = ConversationCubit.instance(context);
            conversationCubit.formatTags();
            return Container(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // const TextWidget(label: 'Keywords: ', fontSize: 14),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Wrap(
                        spacing: 10,
                        children: conversationCubit.tagsStrings
                            .map((e) => OutlinedButton(
                                  style: const ButtonStyle(
                                      side: MaterialStatePropertyAll(BorderSide(
                                        color: Colors.white,
                                      )),
                                      padding: MaterialStatePropertyAll(
                                        EdgeInsets.all(1),
                                      ),
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap),
                                  child: TextWidget(
                                    label: e,
                                    color: Colors.white70,
                                    fontSize: 13,
                                  ),
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (_) =>
                                            TagDetailsDialog(tagName: e));
                                  },
                                ))
                            .toList(),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ));
  }
}
