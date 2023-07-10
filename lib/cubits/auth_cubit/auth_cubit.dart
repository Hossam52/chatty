import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants/constants.dart';
import '../../models/auth/register_model.dart';
import '../../models/auth/user_model.dart' as userModel;
import '../../shared/network/local/cache_helper.dart';
import '../../shared/network/services/auth_services.dart';
import 'auth_states.dart';

//Bloc builder and bloc consumer methods
typedef AuthBlocBuilder = BlocBuilder<AuthCubit, AuthStates>;
typedef AuthBlocConsumer = BlocConsumer<AuthCubit, AuthStates>;

//
class AuthCubit extends Cubit<AuthStates> {
  AuthCubit() : super(IntitalAuthState());
  static AuthCubit instance(BuildContext context) =>
      BlocProvider.of<AuthCubit>(context);

  Future<void> login(String email, String password) async {
    try {
      emit(LoginLoadingState());
      final response = await AuthServices.login(email, password);
      final user = userModel.User.fromMap(response);
      Constants.token = user.access_token;

      if (user.verified != 0) {
        await CacheHelper.setToken(user.access_token);
        await _remember.saveData(email, password);
      }

      log(user.toString());
      emit(LoginSuccessState(user));
    } catch (e) {
      emit(LoginErrorState(error: e.toString()));
      rethrow;
    }
  }

  RememberMeHelper _remember = RememberMeHelper();

  bool get isRememberd => _remember.isRemembered;
  String get cachedEmail => _remember.email;
  String get cachedPassword => _remember.password;

  void onChangeCheckMe(bool? isRemembered) {
    _remember.changeIsRemembered(isRemembered);
    emit(ChangeIsRememberedState());
  }

  Future<void> loadCahcedRemember() async {
    await _remember.loadData();
    print(_remember.toString());
    emit(LoadCachedRememberState());
  }

  Future<void> register(
      {required String name,
      required String email,
      required String phone,
      required String password,
      required String passwordConfirm}) async {
    try {
      emit(RegisterLoadingState());
      final response = await AuthServices.register(
          email: email,
          name: name,
          phone: phone,
          password: password,
          passwordConfirm: passwordConfirm);
      final registerModel = RegisterModel.fromMap(response);
      Constants.token = registerModel.user.access_token;
      log(response.toString());
      emit(RegisterSuccessState());
    } catch (e) {
      emit(RegisterErrorState(error: e.toString()));
      rethrow;
    }
  }

  Future<UserCredential> _signInWithCred(PhoneAuthCredential cred) async {
    try {
      return await FirebaseAuth.instance.signInWithCredential(cred);
    } on FirebaseAuthException {
      throw 'Error on code';
    }
  }

  Future<void> verifyOtp(String code) async {
    try {
      emit(VerifyOtpLoadingState());
      if (_verificationId == null) throw 'The verification id is null';
      final phoneCred = _phoneAuthCredential ??
          PhoneAuthProvider.credential(
              verificationId: _verificationId!, smsCode: code);
      final user = await _signInWithCred(phoneCred);
      log(user.toString());
      final response = await AuthServices.verifyAccount(code);
      log(response.toString());
      emit(VerifyOtpSuccessState(message: response['message']));
    } catch (e) {
      emit(VerifyOtpErrorState(error: e.toString()));
      rethrow;
    }
  }

  PhoneAuthCredential? _phoneAuthCredential;
  String? _verificationId;

  Future<void> sendVerification(String phoneNumber) async {
    try {
      emit(SendVerificationLoadingState());
      await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted: (cred) {
            //when auth retrieved autocomplete
            _phoneAuthCredential = cred;
            verifyOtp(cred.smsCode!);
          },
          verificationFailed: (err) {},
          codeSent: (verificationId, forceResendingToken) {
            _verificationId = verificationId;
          },
          codeAutoRetrievalTimeout: (verificationId) {});

      emit(SendVerificationSuccessState());
    } catch (e) {
      emit(SendVerificationErrorState(error: e.toString()));
    }
  }

  Future<void> logout() async {
    try {
      emit(LogoutLoadingState());
      await CacheHelper.removeToken();
      Constants.token = null;

      emit(LogoutSuccessState());
    } catch (e) {
      emit(LogoutErrorState(error: e.toString()));
    }
  }

  Future<void> changePhone(String phone, String password) async {
    try {
      emit(ChangePhoneLoadingState());

      emit(ChangePhoneSuccessState(phone));
    } catch (e) {
      emit(ChangePhoneErrorState(error: e.toString()));
    }
  }

  Future<void> updateProfileData(
      {required String password,
      String? phone,
      String? email,
      String? name}) async {
    try {
      emit(UpdateProfileDataLoadingState());
      final response = await AuthServices.updateProfile(
        currentPassword: password,
        phone: phone,
        name: name,
        email: email,
      );

      log(response.toString());
      final user = userModel.User.fromMap(response);
      emit(UpdateProfileDataSuccessState(user));
    } catch (e) {
      emit(UpdateProfileDataErrorState(error: e.toString()));
    }
  }
}

class RememberMeHelper {
  bool isRemembered = false;
  String email = '';
  String password = '';

  void changeIsRemembered(bool? isRemembered) {
    this.isRemembered = isRemembered ?? false;
  }

  Future<void> loadData() async {
    final isRemembered = await CacheHelper.getIsRemembered;
    final emailRemembered = await CacheHelper.getEmailRemembered;
    final passwordRemembered = await CacheHelper.getPasswordRemembered;
    if (isRemembered) {
      email = emailRemembered;
      password = passwordRemembered;
    } else {
      email = password = '';
    }
  }

  Future<void> saveData(String email, String password) async {
    if (isRemembered)
      await CacheHelper.setIsRemembered(isRemembered, email, password);
  }

  @override
  String toString() =>
      'RememberMeHelper(isRemembered: $isRemembered, email: $email, password: $password)';
}
