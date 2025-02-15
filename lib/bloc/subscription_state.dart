import 'package:equatable/equatable.dart';
import 'package:subsciption_management_app/model/subsciption_model.dart';

abstract class SubscriptionState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SubscriptionInitial extends SubscriptionState {}

class SubscriptionLoaded extends SubscriptionState {
  final List<Subscription> subscriptions;
  final List<String> filters;
  final String selectedFilter;

  SubscriptionLoaded({
    required this.subscriptions,
    required this.filters,
    required this.selectedFilter,
  });

  SubscriptionLoaded copyWith({
    List<Subscription>? subscriptions,
    List<String>? filters,
    String? selectedFilter,
  }) {
    return SubscriptionLoaded(
      subscriptions: subscriptions ?? this.subscriptions,
      filters: filters ?? this.filters,
      selectedFilter: selectedFilter ?? this.selectedFilter,
    );
  }

  @override
  List<Object?> get props => [subscriptions, filters, selectedFilter];
}
