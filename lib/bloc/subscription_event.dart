import 'package:equatable/equatable.dart';

abstract class SubscriptionEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

// Event for loading the subscriptions
class LoadSubscriptions extends SubscriptionEvent {}

// Event for adding a new filter
class AddFilterEvent extends SubscriptionEvent {
  final String filterName;
  final List<String> selectedSubscriptions;

  AddFilterEvent(
      {required this.filterName, required this.selectedSubscriptions});

  @override
  List<Object?> get props => [filterName, selectedSubscriptions];
}

// Event for deleting existing filters
class DeleteFilterEvent extends SubscriptionEvent {
  final List<String> selectedFilters;

  DeleteFilterEvent({required this.selectedFilters});

  @override
  List<Object?> get props => [selectedFilters];
}

// Event for change filter
class ChangeFilterEvent extends SubscriptionEvent {
  final String filterName;

  ChangeFilterEvent(this.filterName);

  @override
  List<Object?> get props => [filterName];
}

// Event for adding a new subscription
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

// Event for deleting subscriptions
class DeleteSubscriptionEvent extends SubscriptionEvent {
  final List<String> selectedSubscriptions;

  DeleteSubscriptionEvent({
    required this.selectedSubscriptions,
  });

  @override
  List<Object?> get props => [selectedSubscriptions];
}
