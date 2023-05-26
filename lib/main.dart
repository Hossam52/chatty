import 'package:chatgpt/bloc_observer.dart';
import 'package:chatgpt/cubits/app_cubit/app_cubit.dart';
import 'package:chatgpt/cubits/auth_cubit/auth_cubit.dart';
import 'package:chatgpt/cubits/conversation_cubit/conversation_cubit.dart';
import 'package:chatgpt/cubits/personas_cubit/personas_cubit.dart';
import 'package:chatgpt/providers/models_provider.dart';
import 'package:chatgpt/screens/auth/login_screen.dart';
import 'package:chatgpt/screens/chat/chat_history_screen.dart';
import 'package:chatgpt/screens/onboarding/onboarding_screen.dart';
import 'package:chatgpt/shared/network/local/cache_helper.dart';
import 'package:chatgpt/shared/network/remote/app_dio_helper.dart';
import 'package:chatgpt/shared/network/remote/dio_helper.dart';
import 'package:chatgpt/shared/presentation/resourses/theme_manager.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'constants/constants.dart';
import 'providers/chats_provider.dart';
import 'screens/conversation_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper.init();
  Constants.token = await CacheHelper.getData(key: 'token');
  DioHelper.init();
  AppDioHelper.init();
  Bloc.observer = MyBlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (_, __) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AppCubit(),
          ),
          BlocProvider(
            create: (context) => AuthCubit(),
          ),
          BlocProvider(
            create: (context) => PersonasCubit(),
          ),
        ],
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (_) => ModelsProvider(),
            ),
            ChangeNotifierProvider(
              create: (_) => ChatProvider(),
            ),
          ],
          child: MaterialApp(
            title: 'Chatty',
            debugShowCheckedModeBanner: false,
            theme: getApplicationTheme(),
            //  ThemeData(
            //     scaffoldBackgroundColor: scaffoldBackgroundColor,
            //     appBarTheme: AppBarTheme(
            //       color: cardColor,
            //     )),
            home: Constants.token != null
                ? const ChatHistoryScreen()
                // : const LoginScreen(),
                : const OnBoardingScreen(),
          ),
        ),
      ),
    );
  }
}
