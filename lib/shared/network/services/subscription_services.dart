import 'package:chatgpt/constants/constants.dart';
import 'package:chatgpt/shared/network/endpoints.dart';
import 'package:chatgpt/shared/network/remote/app_dio_helper.dart';

abstract class SubscriptionServices {
  SubscriptionServices._();
  static Future<Map<String, dynamic>> getPlans() async {
    final response = await AppDioHelper.getData(
        url: EndPoints.allPlans, token: Constants.token);
    return response.data;
  }

  static Future<Map<String, dynamic>> purchaseSubscription(
      String planId) async {
    final response = await AppDioHelper.postData(
        url: EndPoints.purchaseSubscription,
        token: Constants.token,
        data: {
          'plan_id': planId,
        });
    return response.data;
  }
}
