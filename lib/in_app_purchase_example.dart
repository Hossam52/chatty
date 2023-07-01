// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:chatgpt/cubits/subscription_cubit/subscription_cubit.dart';
import 'package:chatgpt/shared/presentation/resourses/theme_manager.dart';
import 'package:chatgpt/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/billing_client_wrappers.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Auto-consume must be true on iOS.
// To try without auto-consume on another platform, change `true` to `false` here.
final bool _kAutoConsume = Platform.isIOS || true;

const String _kConsumableId = 'consumable';
const String _kUpgradeId = 'upgrade';
const String _kSilverSubscriptionId = 'subscription_silver';
const String _kGoldSubscriptionId = 'subscription_gold';
const List<String> _kProductIds = <String>[
  _kConsumableId,
  _kUpgradeId,
  _kSilverSubscriptionId,
  _kGoldSubscriptionId,
];

class IAPTest extends StatefulWidget {
  IAPTest({super.key});

  @override
  State<IAPTest> createState() => _IAPTestState();
}

class _IAPTestState extends State<IAPTest> {
  // final _iap = InAppPurchase.instance;

  // List<ProductDetails> _products = [];

  // List<PurchaseDetails> _purchases = [];

  // StreamSubscription? _subscription;

  // bool _available = false;
  // int _credits = 0;

  // @override
  // void initState() {
  //   _initialize();
  //   super.initState();
  // }

  // void _initialize() async {
  //   _available = await _iap.isAvailable();
  //   if (_available) {
  //     await _getProducts();
  //     await _getPastPurchases();

  //     await _verifyPurchase();

  //     _subscription = _iap.purchaseStream.listen(_listenedData);
  //   }
  // }

  // void _listenedData(List<PurchaseDetails> data) {
  //   setState(() {
  //     print('---' * 5 + data[0].error.toString());
  //     print('New Purchase');
  //     _purchases.addAll(data);
  //     _verifyPurchase();
  //   });
  // }

  // Future<void> _getProducts() async {
  //   Set<String> ids = {'gptiva_week', 'gptiva_yearly'};
  //   final response = await _iap.queryProductDetails(ids);
  //   print(response.error);
  //   setState(() {
  //     _products = response.productDetails;
  //   });
  // }

  // Future<void> _getPastPurchases() async {}

  // PurchaseDetails? _hasPurchased(String productId) {
  //   if (_purchases.isEmpty) {
  //     return null;
  //   } else {
  //     final res =
  //         _purchases.where((purchase) => purchase.productID == productId);
  //     return res.isEmpty ? null : res.first;
  //   }
  // }

  // Future<void> _verifyPurchase() async {
  //   final purchase = await _hasPurchased('gptiva_week');
  //   if (purchase != null && purchase.status == PurchaseStatus.purchased) {
  //     _credits = 10;
  //   }
  // }

  // void _buyProduct(ProductDetails prod) {
  //   final purchaseParam = PurchaseParam(productDetails: prod);
  //   _iap.buyConsumable(purchaseParam: purchaseParam, autoConsume: false);
  // }

  // void _spendCredits(PurchaseDetails purchase) async {
  //   setState(() {
  //     _credits--;
  //   });
  //   if (_credits == 0) {
  //     // final res = await _iap.consume
  //   }
  // }

  // @override
  // void dispose() {
  //   _subscription?.cancel();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SubscriptionCubit(),
      child: SubscriptionBlocBuilder(
        builder: (context, state) {
          return Builder(builder: (context) {
            final cubit = SubscriptionCubit.instance(context);
            final products = cubit.products;
            return ScreenUtilInit(builder: (a, b) {
              return MaterialApp(
                theme: getApplicationTheme(),
                home: Builder(builder: (context) {
                  return Scaffold(
                    appBar: AppBar(
                      title: Text(cubit.available
                          ? 'Open for businessss'
                          : 'Not available'),
                    ),
                    body: Center(
                        child: Column(
                      children: [
                        for (var product in products)
                          if (cubit.hasPurchased(product.id) != null) ...[
                            Text('_credits Credits'),
                            // Text('$_credits Credits'),
                            TextButton(
                              child: Text('Consume'),
                              onPressed: () => {},
                              // _spendCredits(_hasPurchased(product.id)!),
                            )
                          ] else ...[
                            Text(product.title),
                            Text(product.description),
                            Text(product.price),
                            TextButton(
                              child: Text('Buy it'),
                              onPressed: () => cubit.buyProduct(product),
                            )
                          ]
                      ],
                    )),
                  );
                }),
              );
            });
          });
        },
      ),
    );
  }
}

class IAPTest2 extends StatefulWidget {
  @override
  State<IAPTest2> createState() => IAPTestState();
}

class IAPTestState extends State<IAPTest2> {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  List<String> _notFoundIds = <String>[];
  List<ProductDetails> _products = <ProductDetails>[];
  List<PurchaseDetails> _purchases = <PurchaseDetails>[];
  List<String> _consumables = <String>[];
  bool _isAvailable = false;
  bool _purchasePending = false;
  bool _loading = true;
  String? _queryProductError;

  @override
  void initState() {
    final Stream<List<PurchaseDetails>> purchaseUpdated =
        _inAppPurchase.purchaseStream;
    _subscription =
        purchaseUpdated.listen((List<PurchaseDetails> purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      _subscription.cancel();
    }, onError: (Object error) {
      // handle error here.
    });
    initStoreInfo();
    super.initState();
  }

  Future<void> initStoreInfo() async {
    final bool isAvailable = await _inAppPurchase.isAvailable();
    if (!isAvailable) {
      setState(() {
        _isAvailable = isAvailable;
        _products = <ProductDetails>[];
        _purchases = <PurchaseDetails>[];
        _notFoundIds = <String>[];
        _consumables = <String>[];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    if (Platform.isIOS) {
      final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition =
          _inAppPurchase
              .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      await iosPlatformAddition.setDelegate(ExamplePaymentQueueDelegate());
    }

    final ProductDetailsResponse productDetailResponse =
        await _inAppPurchase.queryProductDetails(_kProductIds.toSet());
    if (productDetailResponse.error != null) {
      setState(() {
        _queryProductError = productDetailResponse.error!.message;
        _isAvailable = isAvailable;
        _products = productDetailResponse.productDetails;
        _purchases = <PurchaseDetails>[];
        _notFoundIds = productDetailResponse.notFoundIDs;
        _consumables = <String>[];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    if (productDetailResponse.productDetails.isEmpty) {
      setState(() {
        _queryProductError = null;
        _isAvailable = isAvailable;
        _products = productDetailResponse.productDetails;
        _purchases = <PurchaseDetails>[];
        _notFoundIds = productDetailResponse.notFoundIDs;
        _consumables = <String>[];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    final List<String> consumables = await ConsumableStore.load();
    setState(() {
      _isAvailable = isAvailable;
      _products = productDetailResponse.productDetails;
      _notFoundIds = productDetailResponse.notFoundIDs;
      _consumables = consumables;
      _purchasePending = false;
      _loading = false;
    });
  }

  @override
  void dispose() {
    if (Platform.isIOS) {
      final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition =
          _inAppPurchase
              .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      iosPlatformAddition.setDelegate(null);
    }
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> stack = <Widget>[];
    if (_queryProductError == null) {
      stack.add(
        ListView(
          children: <Widget>[
            _buildConnectionCheckTile(),
            _buildProductList(),
            _buildConsumableBox(),
            _buildRestoreButton(),
          ],
        ),
      );
    } else {
      stack.add(Center(
        child: Text(_queryProductError!),
      ));
    }
    if (_purchasePending) {
      stack.add(
        // TODO(goderbauer): Make this const when that's available on stable.
        // ignore: prefer_const_constructors
        Stack(
          children: const <Widget>[
            Opacity(
              opacity: 0.3,
              child: ModalBarrier(dismissible: false, color: Colors.grey),
            ),
            Center(
              child: CircularProgressIndicator(),
            ),
          ],
        ),
      );
    }

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('IAP Example'),
        ),
        body: Stack(
          children: stack,
        ),
      ),
    );
  }

  Card _buildConnectionCheckTile() {
    if (_loading) {
      return const Card(child: ListTile(title: Text('Trying to connect...')));
    }
    final Widget storeHeader = ListTile(
      leading: Icon(_isAvailable ? Icons.check : Icons.block,
          color: _isAvailable
              ? Colors.green
              : ThemeData.light().colorScheme.error),
      title:
          Text('The store is ${_isAvailable ? 'available' : 'unavailable'}.'),
    );
    final List<Widget> children = <Widget>[storeHeader];

    if (!_isAvailable) {
      children.addAll(<Widget>[
        const Divider(),
        ListTile(
          title: Text('Not connected',
              style: TextStyle(color: ThemeData.light().colorScheme.error)),
          subtitle: const Text(
              'Unable to connect to the payments processor. Has this app been configured correctly? See the example README for instructions.'),
        ),
      ]);
    }
    return Card(child: Column(children: children));
  }

  Card _buildProductList() {
    if (_loading) {
      return const Card(
          child: ListTile(
              leading: CircularProgressIndicator(),
              title: Text('Fetching products...')));
    }
    if (!_isAvailable) {
      return const Card();
    }
    const ListTile productHeader = ListTile(title: Text('Products for Sale'));
    final List<ListTile> productList = <ListTile>[];
    if (_notFoundIds.isNotEmpty) {
      productList.add(ListTile(
          title: Text('[${_notFoundIds.join(", ")}] not found',
              style: TextStyle(color: ThemeData.light().colorScheme.error)),
          subtitle: const Text(
              'This app needs special configuration to run. Please see example/README.md for instructions.')));
    }

    // This loading previous purchases code is just a demo. Please do not use this as it is.
    // In your app you should always verify the purchase data using the `verificationData` inside the [PurchaseDetails] object before trusting it.
    // We recommend that you use your own server to verify the purchase data.
    final Map<String, PurchaseDetails> purchases =
        Map<String, PurchaseDetails>.fromEntries(
            _purchases.map((PurchaseDetails purchase) {
      if (purchase.pendingCompletePurchase) {
        _inAppPurchase.completePurchase(purchase);
      }
      return MapEntry<String, PurchaseDetails>(purchase.productID, purchase);
    }));
    productList.addAll(
      _products.map(
        (ProductDetails productDetails) {
          final PurchaseDetails? previousPurchase =
              purchases[productDetails.id];
          return ListTile(
            title: Text(
              productDetails.title,
            ),
            subtitle: Text(
              productDetails.description,
            ),
            trailing: previousPurchase != null && Platform.isIOS
                ? IconButton(
                    onPressed: () => confirmPriceChange(context),
                    icon: const Icon(Icons.upgrade))
                : TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.green[800],
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      late PurchaseParam purchaseParam;

                      if (Platform.isAndroid) {
                        // NOTE: If you are making a subscription purchase/upgrade/downgrade, we recommend you to
                        // verify the latest status of you your subscription by using server side receipt validation
                        // and update the UI accordingly. The subscription purchase status shown
                        // inside the app may not be accurate.
                        final GooglePlayPurchaseDetails? oldSubscription =
                            _getOldSubscription(productDetails, purchases);

                        purchaseParam = GooglePlayPurchaseParam(
                            productDetails: productDetails,
                            changeSubscriptionParam: (oldSubscription != null)
                                ? ChangeSubscriptionParam(
                                    oldPurchaseDetails: oldSubscription,
                                    prorationMode: ProrationMode
                                        .immediateWithTimeProration,
                                  )
                                : null);
                      } else {
                        purchaseParam = PurchaseParam(
                          productDetails: productDetails,
                        );
                      }

                      if (productDetails.id == _kConsumableId) {
                        _inAppPurchase.buyConsumable(
                            purchaseParam: purchaseParam,
                            autoConsume: _kAutoConsume);
                      } else {
                        _inAppPurchase.buyNonConsumable(
                            purchaseParam: purchaseParam);
                      }
                    },
                    child: Text(productDetails.price),
                  ),
          );
        },
      ),
    );

    return Card(
        child: Column(
            children: <Widget>[productHeader, const Divider()] + productList));
  }

  Card _buildConsumableBox() {
    if (_loading) {
      return const Card(
          child: ListTile(
              leading: CircularProgressIndicator(),
              title: Text('Fetching consumables...')));
    }
    if (!_isAvailable || _notFoundIds.contains(_kConsumableId)) {
      return const Card();
    }
    const ListTile consumableHeader =
        ListTile(title: Text('Purchased consumables'));
    final List<Widget> tokens = _consumables.map((String id) {
      return GridTile(
        child: IconButton(
          icon: const Icon(
            Icons.stars,
            size: 42.0,
            color: Colors.orange,
          ),
          splashColor: Colors.yellowAccent,
          onPressed: () => consume(id),
        ),
      );
    }).toList();
    return Card(
        child: Column(children: <Widget>[
      consumableHeader,
      const Divider(),
      GridView.count(
        crossAxisCount: 5,
        shrinkWrap: true,
        padding: const EdgeInsets.all(16.0),
        children: tokens,
      )
    ]));
  }

  Widget _buildRestoreButton() {
    if (_loading) {
      return Container();
    }

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
            ),
            onPressed: () => _inAppPurchase.restorePurchases(),
            child: const Text('Restore purchases'),
          ),
        ],
      ),
    );
  }

  Future<void> consume(String id) async {
    await ConsumableStore.consume(id);
    final List<String> consumables = await ConsumableStore.load();
    setState(() {
      _consumables = consumables;
    });
  }

  void showPendingUI() {
    setState(() {
      _purchasePending = true;
    });
  }

  Future<void> deliverProduct(PurchaseDetails purchaseDetails) async {
    // IMPORTANT!! Always verify purchase details before delivering the product.
    if (purchaseDetails.productID == _kConsumableId) {
      await ConsumableStore.save(purchaseDetails.purchaseID!);
      final List<String> consumables = await ConsumableStore.load();
      setState(() {
        _purchasePending = false;
        _consumables = consumables;
      });
    } else {
      setState(() {
        _purchases.add(purchaseDetails);
        _purchasePending = false;
      });
    }
  }

  void handleError(IAPError error) {
    setState(() {
      _purchasePending = false;
    });
  }

  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) {
    // IMPORTANT!! Always verify a purchase before delivering the product.
    // For the purpose of an example, we directly return true.
    return Future<bool>.value(true);
  }

  void _handleInvalidPurchase(PurchaseDetails purchaseDetails) {
    // handle invalid purchase here if  _verifyPurchase` failed.
  }

  Future<void> _listenToPurchaseUpdated(
      List<PurchaseDetails> purchaseDetailsList) async {
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        showPendingUI();
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          handleError(purchaseDetails.error!);
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          final bool valid = await _verifyPurchase(purchaseDetails);
          if (valid) {
            unawaited(deliverProduct(purchaseDetails));
          } else {
            _handleInvalidPurchase(purchaseDetails);
            return;
          }
        }
        if (Platform.isAndroid) {
          if (!_kAutoConsume && purchaseDetails.productID == _kConsumableId) {
            final InAppPurchaseAndroidPlatformAddition androidAddition =
                _inAppPurchase.getPlatformAddition<
                    InAppPurchaseAndroidPlatformAddition>();
            await androidAddition.consumePurchase(purchaseDetails);
          }
        }
        if (purchaseDetails.pendingCompletePurchase) {
          await _inAppPurchase.completePurchase(purchaseDetails);
        }
      }
    }
  }

  Future<void> confirmPriceChange(BuildContext context) async {
    // Price changes for Android are not handled by the application, but are
    // instead handled by the Play Store. See
    // https://developer.android.com/google/play/billing/price-changes for more
    // information on price changes on Android.
    if (Platform.isIOS) {
      final InAppPurchaseStoreKitPlatformAddition iapStoreKitPlatformAddition =
          _inAppPurchase
              .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      await iapStoreKitPlatformAddition.showPriceConsentIfNeeded();
    }
  }

  GooglePlayPurchaseDetails? _getOldSubscription(
      ProductDetails productDetails, Map<String, PurchaseDetails> purchases) {
    // This is just to demonstrate a subscription upgrade or downgrade.
    // This method assumes that you have only 2 subscriptions under a group, 'subscription_silver' & 'subscription_gold'.
    // The 'subscription_silver' subscription can be upgraded to 'subscription_gold' and
    // the 'subscription_gold' subscription can be downgraded to 'subscription_silver'.
    // Please remember to replace the logic of finding the old subscription Id as per your app.
    // The old subscription is only required on Android since Apple handles this internally
    // by using the subscription group feature in iTunesConnect.
    GooglePlayPurchaseDetails? oldSubscription;
    if (productDetails.id == _kSilverSubscriptionId &&
        purchases[_kGoldSubscriptionId] != null) {
      oldSubscription =
          purchases[_kGoldSubscriptionId]! as GooglePlayPurchaseDetails;
    } else if (productDetails.id == _kGoldSubscriptionId &&
        purchases[_kSilverSubscriptionId] != null) {
      oldSubscription =
          purchases[_kSilverSubscriptionId]! as GooglePlayPurchaseDetails;
    }
    return oldSubscription;
  }
}

/// Example implementation of the
/// [`SKPaymentQueueDelegate`](https://developer.apple.com/documentation/storekit/skpaymentqueuedelegate?language=objc).
///
/// The payment queue delegate can be implementated to provide information
/// needed to complete transactions.
class ExamplePaymentQueueDelegate implements SKPaymentQueueDelegateWrapper {
  @override
  bool shouldContinueTransaction(
      SKPaymentTransactionWrapper transaction, SKStorefrontWrapper storefront) {
    return true;
  }

  @override
  bool shouldShowPriceConsent() {
    return false;
  }
}

// ignore: avoid_classes_with_only_static_members
/// A store of consumable items.
///
/// This is a development prototype tha stores consumables in the shared
/// preferences. Do not use this in real world apps.
class ConsumableStore {
  static const String _kPrefKey = 'consumables';
  static Future<void> _writes = Future<void>.value();

  /// Adds a consumable with ID `id` to the store.
  ///
  /// The consumable is only added after the returned Future is complete.
  static Future<void> save(String id) {
    _writes = _writes.then((void _) => _doSave(id));
    return _writes;
  }

  /// Consumes a consumable with ID `id` from the store.
  ///
  /// The consumable was only consumed after the returned Future is complete.
  static Future<void> consume(String id) {
    _writes = _writes.then((void _) => _doConsume(id));
    return _writes;
  }

  /// Returns the list of consumables from the store.
  static Future<List<String>> load() async {
    return (await SharedPreferences.getInstance()).getStringList(_kPrefKey) ??
        <String>[];
  }

  static Future<void> _doSave(String id) async {
    final List<String> cached = await load();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    cached.add(id);
    await prefs.setStringList(_kPrefKey, cached);
  }

  static Future<void> _doConsume(String id) async {
    final List<String> cached = await load();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    cached.remove(id);
    await prefs.setStringList(_kPrefKey, cached);
  }
}
