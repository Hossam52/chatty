import 'strings_manager.dart';
import 'package:flutter/material.dart';

class Routes {
  static const String splashRoute = "/";
  static const String login = "/login";
  static const String userLayout = "/user_layout";
  static const String requestDetails = '/request_details';
  static const String newRequest = '/new_request';
  static const String editProfile = '/edit_profile';
  static const String privacyPolicy = '/privacy_policy';
  static const String customerService = '/customer_service';
  static const String help = '/help';
  static const String aboutApp = '/about_app';
}

class RouteGenerator {
  // static Route<T> getRoute<T>(RouteSettings routeSettings) {
  // switch (routeSettings.name) {
  //   case Routes.login:
  //     return MaterialPageRoute(
  //         builder: (_) => const LoginScreen(), settings: routeSettings);
  //   case Routes.userLayout:
  //     return MaterialPageRoute(
  //         builder: (_) => const UserLayout(), settings: routeSettings);
  //   case Routes.requestDetails:
  //     return MaterialPageRoute(
  //         builder: (_) => const RequestDetailsScreen(),
  //         settings: routeSettings);
  //   case Routes.newRequest:
  //     return MaterialPageRoute(
  //         builder: (_) => const NewRequestScreen(), settings: routeSettings);
  //   case Routes.editProfile:
  //     return MaterialPageRoute(
  //         builder: (_) => const EditProfileScreen(), settings: routeSettings);
  //   case Routes.privacyPolicy:
  //     return MaterialPageRoute(
  //         builder: (_) => const PrivacyPolicyScreen(),
  //         settings: routeSettings);
  //   case Routes.customerService:
  //     return MaterialPageRoute(
  //         builder: (_) => const CustomerServiceScreen(),
  //         settings: routeSettings);
  //   case Routes.help:
  //     return MaterialPageRoute(
  //         builder: (_) => const HelpScreen(), settings: routeSettings);
  //   case Routes.aboutApp:
  //     return MaterialPageRoute(
  //         builder: (_) => const AboutAppScreen(), settings: routeSettings);
  //   default:
  //     return unDefinedRoute();
  // }
  // }

  static Route<T> unDefinedRoute<T>() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: const Text(AppStrings.noRouteFound),
        ),
        body: const Center(
          child: Text(AppStrings.noRouteFound),
        ),
      ),
    );
  }
}
