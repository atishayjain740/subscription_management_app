import 'package:equatable/equatable.dart';
import 'package:subsciption_management_app/model/subsciption_model.dart';

abstract class SubscriptionEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadSubscriptions extends SubscriptionEvent {}

class AddFilterEvent extends SubscriptionEvent {
  final String filterName;
  final List<String> selectedSubscriptions;

  AddFilterEvent(
      {required this.filterName, required this.selectedSubscriptions});

  @override
  List<Object?> get props => [filterName, selectedSubscriptions];
}

class ChangeFilterEvent extends SubscriptionEvent {
  final String filterName;

  ChangeFilterEvent(this.filterName);

  @override
  List<Object?> get props => [filterName];
}

class AddSubscriptionEvent extends SubscriptionEvent {
  final String subscriptionName;
  final String subscriptionPrice;
  final String subscriptionCategory;

  AddSubscriptionEvent(
      {required this.subscriptionName,
      required this.subscriptionPrice,
      required this.subscriptionCategory});

  @override
  List<Object?> get props => [subscriptionName, subscriptionPrice];
}
