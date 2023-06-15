import '../../../constants/constants.dart';
import 'package:dio/dio.dart';

class AppDioHelper {
  static late Dio dio;
  static init() {
    dio = Dio(
      BaseOptions(
        baseUrl: Constants.APP_BASE_URL,
        receiveDataWhenStatusError: true,
        followRedirects: false,
        validateStatus: (status) => true,
        headers: {
          'Content-Type': 'application/json',
          'Accept-Language': Constants.lang,
        },
      ),
    );
    dio.options.headers = {
      'Accept': 'application/json',
    };
  }

  static Future<Response> getData({
    required String url,
    Map<String, dynamic>? query,
    String? token,
    Options? options,
  }) async {
    _setTokenAuthorization(token);
    final response = await dio.get(
      url,
      queryParameters: query,
      // options: options,
    );
    _validateResponse(response);

    return response;
  }

  static Future<Response> postData({
    required String url,
    required Map<String, dynamic> data,
    Map<String, dynamic>? query,
    String? token,
    Options? options,
  }) async {
    _setTokenAuthorization(token);

    final response = await dio.post(
      url,
      queryParameters: query,
      data: data,
      options: options,
    );
    _validateResponse(response);

    return response;
  }

  static Future<Response> postFormData({
    required String url,
    required FormData formData,
    Map<String, dynamic>? query,
    String? token,
    Options? options,
  }) async {
    _setTokenAuthorization(token);

    final response = await dio.post(
      url,
      queryParameters: query,
      data: formData,
      options: options,
    );
    _validateResponse(response);

    return response;
  }

  /// Put Data Function
  static Future<Response> putData({
    required String url,
    Map<String, dynamic>? data,
    Map<String, dynamic>? query,
    String? token,
  }) async {
    _setTokenAuthorization(token);

    final response = await dio.put(
      url,
      data: (data)!,
      queryParameters: query,
    );
    _validateResponse(response);

    return response;
  }

  /// Delete data function
  static Future<Response> deleteData({
    required String url,
    Map<String, dynamic>? data,
    Map<String, dynamic>? query,
    String? token,
  }) async {
    _setTokenAuthorization(token);

    final response = await dio.delete(
      url,
      data: data,
      queryParameters: query,
    );
    _validateResponse(response);
    return response;
  }

  static void _setTokenAuthorization(String? token) {
    dio.options.headers.addAll({'Authorization': 'Bearer $token'});
  }

  static void _validateResponse(Response response) {
    final data = response.data;
    if (data is Map) {
      if (data['errors'] != null) {
        throw data['message'] ?? (throw 'Undefined exception');
      }
      if (data['status'] != null && data['status'] == 0) {
        if (data['message'] != null) {
          throw data['message'];
        } else {
          throw 'Undefined exception in status 0';
        }
      }
    } else {
      throw 'Un expected error happened';
    }
  }
}
