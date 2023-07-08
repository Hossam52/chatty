import 'dart:async';
// ignore: unused_import
import 'dart:developer';

import 'package:chatgpt/models/subscriptions/purchase_subscription_model.dart';
import 'package:chatgpt/models/subscriptions/subscription_plans_model.dart';
import 'package:chatgpt/shared/network/services/subscription_services.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import './subscription_states.dart';

//Bloc builder and bloc consumer methods
typedef SubscriptionBlocBuilder
    = BlocBuilder<SubscriptionCubit, SubscriptionStates>;
typedef SubscriptionBlocConsumer
    = BlocConsumer<SubscriptionCubit, SubscriptionStates>;

//
class SubscriptionCubit extends Cubit<SubscriptionStates> {
  SubscriptionCubit() : super(IntitalSubscriptionState()) {
    init();
  }
  static SubscriptionCubit instance(BuildContext context) =>
      BlocProvider.of<SubscriptionCubit>(context);
  SubscriptionPlans? _allPlans;

  List<Package> _packages = [];
  List<Package> get products => _packages;

  Package? _selectedPackage;

  Future<void> init() async {
    if (_packages.isEmpty) {
      await PurchaseApi.init();
      await fetchOffers();
      await getPlans();
    }
  }

  Future<void> fetchOffers() async {
    try {
      emit(FetchOffersLoadingState());
      if (_packages.isEmpty) {
        final offerings = await PurchaseApi.fetchOffers();
        if (offerings.isEmpty) {
          throw 'No plans available';
        } else {
          final packages = offerings
              .map((offer) => offer.availablePackages)
              .expand((pair) => pair)
              .toList();
          _packages = packages;
        }
      }
      emit(FetchOffersSuccessState());
    } catch (e) {
      emit(FetchOffersErrorState(error: e.toString()));
    }
  }

  Future<void> getPlans() async {
    try {
      emit(GetPlansLoadingState());
      final res = await SubscriptionServices.getPlans();
      _allPlans = SubscriptionPlans.fromMap(res);
      emit(GetPlansSuccessState());
    } catch (e) {
      emit(GetPlansErrorState(error: e.toString()));
      rethrow;
    }
  }

  int? extractPlanId(String storePlanName) {
    final res = _allPlans?.plans
        .where((element) => element.storePlanName == storePlanName)
        .toList();
    return res == null || res.isEmpty ? null : res.first.id;
  }

  Future<void> storeSubscriptions(String storePlanName) async {
    try {
      emit(StoreSubscriptionsLoadingState());
      int? planId = extractPlanId(storePlanName);
      if (planId != null) {
        final res =
            await SubscriptionServices.purchaseSubscription(planId.toString());
        print(res.toString());
        final purchaseModel = PurchaseSubscriptionModel.fromMap(res);
        emit(StoreSubscriptionsSuccessState(purchaseModel.user));
      } else {
        throw 'Unknwon plan id';
      }
    } catch (e) {
      emit(StoreSubscriptionsErrorState(error: e.toString()));
      rethrow;
    }
  }

  void changeSelected(Package? product) {
    this._selectedPackage = product;
    emit(ChangeSubscriptionSelectedState());
  }

  bool get isPackageSelected => _selectedPackage != null;
  bool isProductSelected({required Package package}) {
    if (_selectedPackage == null)
      return false;
    else
      return _selectedPackage!.identifier == package.identifier;
  }

  bool get errorInPlans => _allPlans == null;

  Future<void> purchasePackage(String userId) async {
    try {
      emit(PurchasePackageLoadingState());
      final res = await PurchaseApi.purchasePackage(_selectedPackage!, userId);
      if (res) {
        emit(PurchasePackageSuccessState());

        storeSubscriptions(_selectedPackage!.storeProduct.identifier);
      } else {
        throw 'Purchase not succeeded';
      }
    } catch (e) {
      emit(PurchasePackageErrorState(error: e.toString()));
    }
  }
}

class PurchaseApi {
  static const _apiKey = 'goog_ZmxxvmIvQWKlWDjKuvcuhDZIssK';
  static Future init() async {
    print(_apiKey);
    await Purchases.setLogLevel(LogLevel.warn);
    await Purchases.setLogLevel(LogLevel.warn);

    await Purchases.configure(PurchasesConfiguration(_apiKey));
  }

  static Future<List<Offering>> fetchOffers() async {
    try {
      final offerings = await Purchases.getOfferings();

      final current = offerings.current;

      return current == null ? [] : [current];
    } on PlatformException catch (_) {
      return [];
    }
  }

  static Future<bool> purchasePackage(Package package, String userId) async {
    try {
      Purchases.logIn(userId);
      await Purchases.purchasePackage(package);
      return true;
    } on Exception catch (_) {
      return false;
    } finally {}
  }
}
