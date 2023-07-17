import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import 'package:chatgpt/cubits/subscription_cubit/subscription_cubit.dart';

import 'bloc_observer.dart';
import 'constants/constants.dart';
import 'cubits/ads_cubit/ads_cubit.dart';
import 'cubits/auth_cubit/auth_cubit.dart';
import 'cubits/personas_cubit/personas_cubit.dart';
import 'providers/chats_provider.dart';
import 'providers/models_provider.dart';
import 'screens/home/home_screen.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'shared/network/local/cache_helper.dart';
import 'shared/network/remote/app_dio_helper.dart';
import 'shared/network/remote/dio_helper.dart';
import 'shared/presentation/resourses/theme_manager.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

  HttpOverrides.global = MyHttpOverrides();

  await Firebase.initializeApp();
  await MobileAds.instance.initialize();

  await CacheHelper.init();
  Constants.token = await CacheHelper.getData(key: 'token');
  DioHelper.init();
  AppDioHelper.init();
  Bloc.observer = MyBlocObserver();
  runApp(const MyApp());
  // runApp(IAPTest());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // return FirebasePhoneAuthProvider(
    //     child: ScreenUtilInit(
    //   designSize: const Size(360, 690),
    //   minTextAdapt: true,
    //   splitScreenMode: true,
    //   builder: (context, child) {
    //     return MaterialApp(
    //       debugShowCheckedModeBanner: false,
    //       title: 'First Method',
    //       // You can use the library anywhere in the app even in theme
    //       theme: getApplicationTheme(),

    //       home: child,
    //     );
    //   },
    //   child: const _TestScaffold(),
    // ));
    return FirebasePhoneAuthProvider(
      child: ScreenUtilInit(
        builder: (_, child) => MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => AuthCubit(),
            ),
            BlocProvider(
              create: (context) => AdsCubit(),
            ),
            BlocProvider(
              create: (context) => PersonasCubit(),
            ),
            BlocProvider(
              create: (context) => SubscriptionCubit(),
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
              title: 'Gptiva',
              debugShowCheckedModeBanner: false,
              theme: getApplicationTheme(),
              //  ThemeData(
              //     scaffoldBackgroundColor: scaffoldBackgroundColor,
              //     appBarTheme: AppBarTheme(
              //       color: cardColor,
              //     )),

              // home: const ConfirmPhoneScreen(phoneNumber: '+201115425561'),
              // home: _TestScaffold(),
              home: Constants.token != null
                  ? const HomeScreen()
                  : const OnBoardingScreen(),
            ),
          ),
        ),
      ),
    );
  }
}
