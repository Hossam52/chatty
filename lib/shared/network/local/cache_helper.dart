import 'package:shared_preferences/shared_preferences.dart';

abstract class CacheHelper {
  static SharedPreferences? sharedPreferences;

  static init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  static Future<bool> saveData({
    required String key,
    required dynamic value,
  }) async {
    if (value is String) return await sharedPreferences!.setString(key, value);
    if (value is int) return await sharedPreferences!.setInt(key, value);
    if (value is bool) return await sharedPreferences!.setBool(key, value);

    return await sharedPreferences!.setDouble(key, value);
  }

  static dynamic getData({required String key}) {
    return sharedPreferences!.get(key);
  }

  static Future<bool> removeData({required String key}) async {
    return await sharedPreferences!.remove(key);
  }

  static Future<bool> clearData() async {
    return await sharedPreferences!.clear();
  }

//For token management
  static Future<String?> get getToken async => getData(key: 'token');
  static Future<bool?> setToken(String token) async =>
      await saveData(key: 'token', value: token);
  static Future<bool?> removeToken() async => await removeData(key: 'token');

  //For remembere me functionality
  static Future<bool> get getIsRemembered async =>
      await getData(key: 'isRemember') ?? false;
  static Future<String> get getEmailRemembered async =>
      await getData(key: 'email') ?? '';
  static Future<String> get getPasswordRemembered async =>
      await getData(key: 'password') ?? '';
  static Future<bool?> setIsRemembered(
      bool isRemebered, String email, String password) async {
    final v1 = await saveData(key: 'isRemember', value: isRemebered);
    final v2 = await saveData(key: 'email', value: email);
    final v3 = await saveData(key: 'password', value: password);
    return v1 && v2 && v3;
  }
}
