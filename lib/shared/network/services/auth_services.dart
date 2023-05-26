import 'package:chatgpt/constants/constants.dart';
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
      required String password,
      required String passwordConfirm}) async {
    final response = await AppDioHelper.postData(
        url: EndPoints.register,
        token: Constants.token,
        data: {
          'name': name,
          'email': email,
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
}
