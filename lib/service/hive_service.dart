import 'package:hive/hive.dart';
import '../model/subscription.dart';

class HiveService {
  static const String filterBoxName = 'filters';
  static const String subscriptionsBoxName = 'subscriptions';

  static Box<Subscription>? _subscriptionBox;
  static Box<List<String>>? _filterBox;

  /// Open Hive Boxes Only Once
  Future<void> init() async {
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(
          SubscriptionAdapter()); // Ensure adapter is registered
    }

    if (!Hive.isBoxOpen(subscriptionsBoxName)) {
      _subscriptionBox = await Hive.openBox<Subscription>(subscriptionsBoxName);
    } else {
      _subscriptionBox = Hive.box<Subscription>(subscriptionsBoxName);
    }

    if (!Hive.isBoxOpen(filterBoxName)) {
      _filterBox = await Hive.openBox<List<String>>(filterBoxName);
    } else {
      _filterBox = Hive.box<List<String>>(filterBoxName);
    }
  }

  /// Save a list of Subscriptions
  Future<void> saveSubscriptions(List<Subscription> subscriptions) async {
    await _subscriptionBox!.clear(); // Remove old data
    for (var i = 0; i < subscriptions.length; i++) {
      await _subscriptionBox!.put(i, subscriptions[i]);
    }
  }

  /// Get all Subscriptions
  List<Subscription> getSubscriptions() {
    try {
      return _subscriptionBox!.values.toList();
    } catch (e) {
      print("Error retrieving subscriptions: $e");
      return [];
    }
  }

  /// Save Filters (List of Strings)
  Future<void> saveFilters(List<String> filters) async {
    await _filterBox!.put("filter_list", filters);
  }

  /// Get Filters
  List<String> getFilters() {
    return _filterBox!.get("filter_list", defaultValue: <String>["All"])!;
  }
}
