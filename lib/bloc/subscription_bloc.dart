import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subsciption_management_app/model/subscription.dart';
import 'package:subsciption_management_app/service/hive_service.dart';
import 'subscription_event.dart';
import 'subscription_state.dart';

class SubscriptionBloc extends Bloc<SubscriptionEvent, SubscriptionState> {
  final HiveService hiveService;

  SubscriptionBloc(this.hiveService) : super(SubscriptionInitial()) {
    on<LoadSubscriptions>(_onLoadSubscriptions);
    on<AddFilterEvent>(_onAddFilter);
    on<DeleteFilterEvent>(_onDeleteFilter);
    on<ChangeFilterEvent>(_onChangeFilter);
    on<AddSubscriptionEvent>(_onAddSubscription);
    on<DeleteSubscriptionEvent>(_onDeleteSubscription);
  }

  void _onLoadSubscriptions(
      LoadSubscriptions event, Emitter<SubscriptionState> emit) async {
    final subscriptions = hiveService.getSubscriptions();
    final filters = hiveService.getFilters();

    emit(SubscriptionLoaded(
      subscriptions: subscriptions!,
      filters: filters!,
      selectedFilter: "All",
    ));
  }

  void _onAddFilter(
      AddFilterEvent event, Emitter<SubscriptionState> emit) async {
    if (state is SubscriptionLoaded) {
      final currentState = state as SubscriptionLoaded;

      final subsSelected = event.selectedSubscriptions;
      final filterAdded = event.filterName;

      final updatedFilters = List<String>.from(currentState.filters);

      if (currentState.filters.contains(filterAdded)) {
        updatedFilters.removeWhere((element) => element == filterAdded);
      }

      updatedFilters.add(filterAdded);
      List<Subscription> updatedSubscriptions =
          currentState.subscriptions.map((sub) {
        return subsSelected.contains(sub.name)
            ? sub.copyWith(category: filterAdded)
            : sub;
      }).toList();

      await hiveService.saveFilters(updatedFilters);
      await hiveService.saveSubscriptions(updatedSubscriptions);

      emit(SubscriptionLoaded(
        subscriptions: updatedSubscriptions,
        filters: updatedFilters,
        selectedFilter: filterAdded,
      ));
    }
  }

  void _onDeleteFilter(
      DeleteFilterEvent event, Emitter<SubscriptionState> emit) async {
    if (state is SubscriptionLoaded) {
      final currentState = state as SubscriptionLoaded;

      final filtersSelected = event.selectedFilters;

      final updatedFilters = List<String>.from(currentState.filters);
      updatedFilters
          .removeWhere((element) => filtersSelected.contains(element));

      List<Subscription> updatedSubscriptions =
          currentState.subscriptions.map((sub) {
        return filtersSelected.contains(sub.category)
            ? sub.copyWith(category: "")
            : sub;
      }).toList();

      await hiveService.saveFilters(updatedFilters);
      await hiveService.saveSubscriptions(updatedSubscriptions);

      emit(SubscriptionLoaded(
        subscriptions: updatedSubscriptions,
        filters: updatedFilters,
        selectedFilter: "All",
      ));
    }
  }

  void _onChangeFilter(
      ChangeFilterEvent event, Emitter<SubscriptionState> emit) {
    if (state is SubscriptionLoaded) {
      final currentState = state as SubscriptionLoaded;
      emit(currentState.copyWith(selectedFilter: event.filterName));
    }
  }

  void _onAddSubscription(
      AddSubscriptionEvent event, Emitter<SubscriptionState> emit) async {
    if (state is SubscriptionLoaded) {
      final currentState = state as SubscriptionLoaded;

      final subName = event.subscriptionName;
      final subPrice = event.subscriptionPrice;
      final subCategory = event.subscriptionCategory;

      List<Subscription> updatedSubs = List.from(currentState.subscriptions)
        ..add(Subscription(
            name: subName,
            category: subCategory,
            price: subPrice,
            imageUrl: ""));

      await hiveService.saveSubscriptions(updatedSubs);

      emit(
        currentState.copyWith(subscriptions: updatedSubs),
      );
    }
  }

  void _onDeleteSubscription(
      DeleteSubscriptionEvent event, Emitter<SubscriptionState> emit) async {
    if (state is SubscriptionLoaded) {
      final currentState = state as SubscriptionLoaded;

      final subscriptionsSelected = event.selectedSubscriptions;

      final updatedSubscriptions =
          List<Subscription>.from(currentState.subscriptions);
      updatedSubscriptions.removeWhere(
          (element) => subscriptionsSelected.contains(element.name));

      await hiveService.saveSubscriptions(updatedSubscriptions);

      emit(
        currentState.copyWith(subscriptions: updatedSubscriptions),
      );
    }
  }
}
