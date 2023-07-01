import 'dart:async';
import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import './subscription_states.dart';

//Bloc builder and bloc consumer methods
typedef SubscriptionBlocBuilder
    = BlocBuilder<SubscriptionCubit, SubscriptionStates>;
typedef SubscriptionBlocConsumer
    = BlocConsumer<SubscriptionCubit, SubscriptionStates>;

//
class SubscriptionCubit extends Cubit<SubscriptionStates> {
  SubscriptionCubit() : super(IntitalSubscriptionState()) {
    _initialize();
  }
  static SubscriptionCubit instance(BuildContext context) =>
      BlocProvider.of<SubscriptionCubit>(context);
  Set<String> _planIds = {'week', 'monthly', '3months', '6months', 'yearly'};
  final _iap = InAppPurchase.instance;

  List<ProductDetails> _products = [];
  List<ProductDetails> get products => _products;

  List<PurchaseDetails> _purchases = [];

  StreamSubscription? _subscription;

  bool _available = false;
  bool get available => _available;

  void _initialize() async {
    _available = await _iap.isAvailable();
    print('-' * 20 + _available.toString());
    if (_available) {
      await _getProducts();
      await _getPastPurchases();

      await _verifyPurchase();

      _subscription = _iap.purchaseStream.listen(_listenedData);
    }
  }

  void _listenedData(List<PurchaseDetails> data) {
    print('---' * 5 + data[0].error.toString());
    print('New Purchase');
    _purchases.addAll(data);
    _verifyPurchase();
    emit(PurchasedStreamChangedState());
  }

  Future<void> _getProducts() async {
    final response = await _iap.queryProductDetails(_planIds);
    print(response.error);
    _products = response.productDetails;

    emit(PurchasedStreamChangedState());
  }

  Future<void> _getPastPurchases() async {}

  PurchaseDetails? hasPurchased(String productId) {
    if (_purchases.isEmpty) {
      return null;
    } else {
      final res =
          _purchases.where((purchase) => purchase.productID == productId);
      return res.isEmpty ? null : res.first;
    }
  }

  Future<void> _verifyPurchase() async {
    final purchase = await hasPurchased('week');
    print('Purchase ' + '-' * 20 + purchase.toString());
    if (purchase != null && purchase.status == PurchaseStatus.purchased) {}
  }

  void buyProduct(ProductDetails prod) async {
    // final response = await _iap.queryProductDetails({'week'});
    // final first = response.productDetails.first;

    // print(response.productDetails.first.);
    // return;
    final purchaseParam = PurchaseParam(productDetails: prod);
    // print('Buy ' + '-' * 20 + prod.id);
    final res = await _iap.buyConsumable(
        purchaseParam: purchaseParam, autoConsume: false);
    print('$res');
  }

  @override
  Future<void> close() async {
    _subscription?.cancel();
    super.close();
  }
}
