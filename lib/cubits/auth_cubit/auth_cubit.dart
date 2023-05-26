import 'dart:developer';

import 'package:chatgpt/constants/constants.dart';
import 'package:chatgpt/models/auth/user_model.dart';
import 'package:chatgpt/shared/network/local/cache_helper.dart';
import 'package:chatgpt/shared/network/services/app_services.dart';
import 'package:chatgpt/shared/network/services/auth_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import './auth_states.dart';

//Bloc builder and bloc consumer methods
typedef AuthBlocBuilder = BlocBuilder<AuthCubit, AuthStates>;
typedef AuthBlocConsumer = BlocConsumer<AuthCubit, AuthStates>;

//
class AuthCubit extends Cubit<AuthStates> {
  AuthCubit() : super(IntitalAuthState());
  static AuthCubit instance(BuildContext context) =>
      BlocProvider.of<AuthCubit>(context);

  Future<void> login(String email, String password) async {
    print(await CacheHelper.getToken);

    try {
      emit(LoginLoadingState());
      final response = await AuthServices.login(email, password);
      final user = User.fromMap(response);

      await CacheHelper.setToken(user.access_token);
      Constants.token = user.access_token;

      log(user.toString());
      emit(LoginSuccessState());
    } catch (e) {
      emit(LoginErrorState(error: e.toString()));
      rethrow;
    }
  }

  Future<void> register(
      {required String name,
      required String email,
      required String password,
      required String passwordConfirm}) async {
    try {
      emit(RegisterLoadingState());
      final response = await AuthServices.register(
          email: email,
          name: name,
          password: password,
          passwordConfirm: passwordConfirm);
      log(response.toString());
      emit(RegisterSuccessState());
    } catch (e) {
      emit(RegisterErrorState(error: e.toString()));
    }
  }

  Future<void> logout() async {
    try {
      emit(LogoutLoadingState());
      final response = await AuthServices.logout();
      await CacheHelper.removeToken();
      Constants.token = null;

      emit(LogoutSuccessState());
    } catch (e) {
      emit(LogoutErrorState(error: e.toString()));
    }
  }
}
