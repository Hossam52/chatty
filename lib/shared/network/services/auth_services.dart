import 'package:chatgpt/constants/constants.dart';
import 'package:chatgpt/cubits/auth_cubit/auth_states.dart';
import 'package:chatgpt/shared/network/endpoints.dart';
import 'package:chatgpt/shared/network/remote/app_dio_helper.dart';

abstract class AuthServices {
  static Future<Map<String, dynamic>> login(
      String email, String password) async {
    final response = await AppDioHelper.postData(
        url: EndPoints.login, data: {'email': email, 'password': password});
    return response.data;
  }

  static Future<Map<String, dynamic>> register(
      {required String name,
      required String email,
      required String phone,
      required String password,
      required String passwordConfirm}) async {
    final response = await AppDioHelper.postData(
        url: EndPoints.register,
        token: Constants.token,
        data: {
          'name': name,
          'email': email,
          'phone': phone,
          'password': password,
          'password_confirmation': passwordConfirm,
        });
    return response.data;
  }

  static Future<Map<String, dynamic>> profile() async {
    final response = await AppDioHelper.getData(
        url: EndPoints.profile, token: Constants.token);
    return response.data;
  }

  static Future<Map<String, dynamic>> logout() async {
    final response = await AppDioHelper.getData(
      url: EndPoints.logout,
      token: Constants.token,
    );
    return response.data;
  }

  static Future<Map<String, dynamic>> verifyAccount(String code) async {
    final response = await AppDioHelper.postData(
        url: EndPoints.verifyOtp, token: Constants.token, data: {'code': code});
    if (response.data is Map) {
      if (response.data['status'] == 0) throw response.data['message'];
    }
    return response.data;
  }

  static Future<Map<String, dynamic>> sendVerificationCode() async {
    final response = await AppDioHelper.postData(
        url: EndPoints.sendOtp, token: Constants.token, data: {});
    return response.data;
  }

  static Future<Map<String, dynamic>> changePhone(
      String phone, String password) async {
    final response = await AppDioHelper.postData(
        url: EndPoints.changePhone,
        token: Constants.token,
        data: {'phone': phone, 'password': password});
    return response.data;
  }

  static Future<Map<String, dynamic>> changePassword(
      {required String currentPassword,
      required String newPassword,
      required String newPasswordConfirmation}) async {
    final response = await AppDioHelper.postData(
        url: EndPoints.changePassword,
        token: Constants.token,
        data: {
          'current_password': currentPassword,
          'new_password': newPassword,
          'new_password_confirmation': newPasswordConfirmation,
        });
    return response.data;
  }

  static Future<Map<String, dynamic>> updateProfile(
      {required String currentPassword,
      String? name,
      String? email,
      String? phone}) async {
    final response = await AppDioHelper.postData(
        url: EndPoints.updateProfile,
        token: Constants.token,
        data: {
          'password': currentPassword,
          'phone': phone,
          'name': name,
          'email': email
        });
    return response.data;
  }
}
