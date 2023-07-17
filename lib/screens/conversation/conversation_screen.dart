import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:chatgpt/screens/conversation/widgets/conversation_keywords_widget.dart';
import 'package:chatgpt/screens/conversation/widgets/conversation_messages_list.dart';
import 'package:chatgpt/screens/conversation/widgets/loading_message_response.dart';
import 'package:chatgpt/screens/conversation/widgets/role_selection_widget.dart';

import '../../constants/ad_helper.dart';
import '../../cubits/app_cubit/app_cubit.dart';
import '../../cubits/conversation_cubit/conversation_cubit.dart';
import '../../cubits/conversation_cubit/conversation_states.dart';
import '../../models/chat_history_model.dart';
import '../../services/services.dart';
import '../../shared/methods.dart';
import '../../shared/presentation/resourses/assets_manager.dart';
import '../../widgets/ads/banner_ad_widget.dart';
import '../../widgets/send_message_field.dart';
import '../../widgets/text_widget.dart';

class ConversationScreen extends StatefulWidget {
  const ConversationScreen(
      {super.key,
      required this.chat,
      this.initialMessage,
      required this.appCubit});
  final ChatModel chat;
  final String? initialMessage;
  final AppCubit appCubit;
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
    if (AppCubit.instance(context).currentUser.isFreeSubscription)
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

  bool hasLoadedInitial = false;
  @override
  Widget build(BuildContext context) {
    return AppBlocBuilder(
      builder: (context, state) {
        final appCubit = widget.appCubit;
        if (appCubit.userError) {
          return _ErrorUser(appCubit: appCubit);
        }
        return BlocProvider(
            create: (_) => ConversationCubit(widget.chat)..fetchAllMessages(),
            child: Scaffold(
                appBar: _appBar(),
                body: Column(
                  children: [
                    const BannerAdWidget(),
                    RoleSelectionWidget(),
                    Expanded(
                      child:
                          ConversationBlocConsumer(listener: (context, state) {
                        if (state is FetchAllMessagesSuccessState &&
                            !hasLoadedInitial &&
                            widget.initialMessage != null) {
                          Services.sendMessage(
                            context: context,
                            text: widget.initialMessage!,
                          );
                          hasLoadedInitial = true;
                        }

                        if (state is SendMessageSuccessState) {
                          _successSendMessage(context);
                          widget.appCubit
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
                              Flexible(
                                  child: ConversationMessagesList(
                                      conversationCubit: conversationCubit)),
                              LoadingMessageResponse(
                                  conversationCubit: conversationCubit),
                              const SizedBox(height: 15),
                              if (conversationCubit.allTags.isNotEmpty)
                                ConversationKeywordsWidget(),
                              const SendMessageField(),
                            ],
                          ),
                        );
                      }),
                    ),
                  ],
                )));
      },
    );
  }

  void _successSendMessage(BuildContext context) {
    if (_interstitialAd != null && widget.appCubit.showInterstitialAds) {
      _interstitialAd?.show();
      _loadInterstitialAd();
    }
    widget.appCubit.increaseMessagesCount();
  }

  AppBar _appBar() {
    return AppBar(
      elevation: 2,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.asset(AssetsManager.logoBackgrounded),
      ),
      // bottom: _keywordsAppBar(),
      title: TextWidget(
        label: "Gptiva (${widget.chat.chat_name})",
        fontSize: 15,
      ),
    );
  }
}

class _ErrorUser extends StatelessWidget {
  const _ErrorUser({
    required this.appCubit,
  });

  final AppCubit appCubit;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () async {
          appCubit.getUser();
        },
        child: const TextWidget(label: 'Error happened in user try again'));
  }
}
