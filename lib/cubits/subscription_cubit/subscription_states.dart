//
import 'package:chatgpt/models/auth/user_model.dart';

abstract class SubscriptionStates {}

class IntitalSubscriptionState extends SubscriptionStates {}
//

class PurchasedStreamChangedState extends SubscriptionStates {}

class ChangeSubscriptionSelectedState extends SubscriptionStates {}

//PurchasePackage online fetch data
class PurchasePackageLoadingState extends SubscriptionStates {}

class PurchasePackageSuccessState extends SubscriptionStates {}

class PurchasePackageErrorState extends SubscriptionStates {
  final String error;
  PurchasePackageErrorState({required this.error});
}

//FetchOffers online fetch data
class FetchOffersLoadingState extends SubscriptionStates {}

class FetchOffersSuccessState extends SubscriptionStates {}

class FetchOffersErrorState extends SubscriptionStates {
  final String error;
  FetchOffersErrorState({required this.error});
}

//GetPlans online fetch data
class GetPlansLoadingState extends SubscriptionStates {}

class GetPlansSuccessState extends SubscriptionStates {}

class GetPlansErrorState extends SubscriptionStates {
  final String error;
  GetPlansErrorState({required this.error});
}

//StoreSubscriptions online fetch data
class StoreSubscriptionsLoadingState extends SubscriptionStates {}

class StoreSubscriptionsSuccessState extends SubscriptionStates {
  final User user;

  StoreSubscriptionsSuccessState(this.user);
}

class StoreSubscriptionsErrorState extends SubscriptionStates {
  final String error;
  StoreSubscriptionsErrorState({required this.error});
}
