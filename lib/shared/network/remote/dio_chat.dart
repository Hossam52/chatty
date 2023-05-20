import 'dart:developer';
import 'dart:io';

import 'package:chatgpt/shared/network/endpoints.dart';
import 'package:chatgpt/shared/network/remote/dio_helper.dart';
import 'package:dio/dio.dart';

class DioChat {
  static Future<Response> postData(String url, Map<String, dynamic> map) async {
    final response = await DioHelper.postData(url: url, data: map);
    _checkResponse(response);
    return response;
  }

  static Future<Response> getData(String url) async {
    final response = await DioHelper.getData(url: url);
    _checkResponse(response);
    return response;
  }

  static void _checkResponse(Response response) {
    log(response.data.toString());
    if (response.data['error'] != null) {
      throw HttpException(response.data['error']["message"]);
    }
  }
}
