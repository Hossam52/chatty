import '../../../constants/constants.dart';
import 'package:dio/dio.dart';

class DioHelper {
  static late Dio dio;
  static init() {
    dio = Dio(
      BaseOptions(
        baseUrl: Constants.CHAT_GPT_URL,
        receiveDataWhenStatusError: true,
        followRedirects: false,
        validateStatus: (status) => true,
        headers: {
          'Content-Type': 'application/json',
          'Accept-Language': Constants.lang,
          'Authroization': 'Bearer ${Constants.CHAT_KEY}'
        },
      ),
    );
    dio.options.headers = {'Authorization': 'Bearer ${Constants.CHAT_KEY}'};
  }

  static Future<Response> getData({
    required String url,
    Map<String, dynamic>? query,
    String? token,
    Options? options,
  }) async {
    final response = await dio.get(
      url,
      queryParameters: query,
      // options: options,
    );

    return response;
  }

  static Future<Response> postData({
    required String url,
    required Map<String, dynamic> data,
    Map<String, dynamic>? query,
    String? token,
    Options? options,
  }) async {
    final response = await dio.post(
      url,
      queryParameters: query,
      data: data,
      options: options,
    );

    return response;
  }

  static Future<Response> postFormData({
    required String url,
    required FormData formData,
    Map<String, dynamic>? query,
    String? token,
    Options? options,
  }) async {
    final response = await dio.post(
      url,
      queryParameters: query,
      data: formData,
      options: options,
    );

    return response;
  }

  /// Put Data Function
  static Future<Response> putData({
    required String url,
    Map<String, dynamic>? data,
    Map<String, dynamic>? query,
    String? token,
  }) async {
    final response = await dio.put(
      url,
      data: (data)!,
      queryParameters: query,
    );

    return response;
  }

  /// Delete data function
  static Future<Response> deleteData({
    required String url,
    Map<String, dynamic>? data,
    Map<String, dynamic>? query,
    String? token,
  }) async {
    final response = await dio.delete(
      url,
      data: data,
      queryParameters: query,
    );

    return response;
  }
}
