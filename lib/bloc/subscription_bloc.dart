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

  // Get all the filter and subs. Default selected filter will be All.
  void _onLoadSubscriptions(
      LoadSubscriptions event, Emitter<SubscriptionState> emit) async {
    final subscriptions = hiveService.getSubscriptions();
    final filters = hiveService.getFilters();

    emit(SubscriptionLoaded(
      subscriptions: subscriptions,
      filters: filters,
      selectedFilter: "All",
    ));
  }

  // Add a new filter
  void _onAddFilter(
      AddFilterEvent event, Emitter<SubscriptionState> emit) async {
    if (state is SubscriptionLoaded) {
      final currentState = state as SubscriptionLoaded;

      final subsSelected = event
          .selectedSubscriptions; // subs to be added to the new filter added
      final filterAdded = event.filterName; // filter name

      // Update the filters.
      final updatedFilters = List<String>.from(currentState.filters);
      if (currentState.filters.contains(filterAdded)) {
        updatedFilters.removeWhere((element) => element == filterAdded);
      }
      updatedFilters.add(filterAdded);

      // Update the subscriptions with the new category.
      List<Subscription> updatedSubscriptions =
          currentState.subscriptions.map((sub) {
        return subsSelected.contains(sub.name)
            ? sub.copyWith(category: filterAdded)
            : sub;
      }).toList();

      // Save the information
      await hiveService.saveFilters(updatedFilters);
      await hiveService.saveSubscriptions(updatedSubscriptions);

      // emit the new state
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

      // Update the filters
      final filtersSelected = event.selectedFilters;
      final updatedFilters = List<String>.from(currentState.filters);
      updatedFilters
          .removeWhere((element) => filtersSelected.contains(element));

      // Update the subs. Remove their category.
      List<Subscription> updatedSubscriptions =
          currentState.subscriptions.map((sub) {
        return filtersSelected.contains(sub.category)
            ? sub.copyWith(category: "")
            : sub;
      }).toList();

      // Save the information
      await hiveService.saveFilters(updatedFilters);
      await hiveService.saveSubscriptions(updatedSubscriptions);

      // Emit new state
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
      // emit new state with the new filter selected
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

      // Add the subs at the first place and if a filter is selected then add that to its category.
      List<Subscription> updatedSubs = List.from(currentState.subscriptions)
        ..insert(
            0,
            Subscription(
                name: subName,
                category: subCategory,
                price: subPrice,
                imageUrl: ""));

      // Save the information
      await hiveService.saveSubscriptions(updatedSubs);

      // Emit new state
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

      // Delete the subs from the list. No matter what filter is selected.
      final updatedSubscriptions =
          List<Subscription>.from(currentState.subscriptions);
      updatedSubscriptions.removeWhere(
          (element) => subscriptionsSelected.contains(element.name));

      // Save the information
      await hiveService.saveSubscriptions(updatedSubscriptions);

      // Emit new state
      emit(
        currentState.copyWith(subscriptions: updatedSubscriptions),
      );
    }
  }
}
