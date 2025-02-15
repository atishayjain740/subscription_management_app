import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subsciption_management_app/model/subsciption_model.dart';
import 'package:subsciption_management_app/service/hive_service.dart';
import 'subscription_event.dart';
import 'subscription_state.dart';

class SubscriptionBloc extends Bloc<SubscriptionEvent, SubscriptionState> {
  final HiveService hiveService;

  SubscriptionBloc(this.hiveService) : super(SubscriptionInitial()) {
    on<LoadSubscriptions>(_onLoadSubscriptions);
    on<AddFilterEvent>(_onAddFilter);
    on<ChangeFilterEvent>(_onChangeFilter);
    on<AddSubscriptionEvent>(_onAddSubscription);
  }

  void _onLoadSubscriptions(
      LoadSubscriptions event, Emitter<SubscriptionState> emit) async {
    final subscriptions = await hiveService.getSubscriptions();
    final filters = await hiveService.getFilters();

    emit(SubscriptionLoaded(
      subscriptions: subscriptions,
      filters: filters,
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

      updatedFilters.add(filterAdded);
      List<Subscription> updatedSubscriptions =
          currentState.subscriptions.map((sub) {
        return subsSelected.contains(sub.name)
            ? sub.copyWith(category: filterAdded)
            : sub;
      }).toList();

      //await hiveService.saveFilters(updatedFilters);

      emit(SubscriptionLoaded(
        subscriptions: updatedSubscriptions,
        filters: updatedFilters,
        selectedFilter: currentState.selectedFilter,
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

      currentState.subscriptions.add(Subscription(
          name: subName, category: subCategory, price: subPrice, imageUrl: ""));

      //await hiveService.saveFilters(updatedFilters);

      emit(SubscriptionLoaded(
        subscriptions: currentState.subscriptions,
        filters: currentState.filters,
        selectedFilter: currentState.selectedFilter,
      ));
    }
  }
}
