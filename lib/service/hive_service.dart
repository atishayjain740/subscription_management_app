import 'package:hive/hive.dart';
import 'package:subsciption_management_app/model/subsciption_model.dart';

class HiveService {
  // late Box subscriptionBox;
  // late Box filterBox;

  // Future<void> init() async {
  //   //Hive.registerAdapter(SubscriptionModelAdapter());
  //   subscriptionBox = await Hive.openBox('subscriptions');
  //   filterBox = await Hive.openBox('filters');
  // }

  Future<List<Subscription>> getSubscriptions() async {
    List<Subscription> subs = [
      Subscription(
          name: "Figma", category: "", price: "12/month", imageUrl: ""),
      Subscription(
          name: "HBO Max",
          category: "",
          price: "12/month",
          imageUrl: ""),
      Subscription(
          name: "Spotify",
          category: "",
          price: "12/month",
          imageUrl: ""),
      Subscription(
          name: "Figma2", category: "", price: "12/month", imageUrl: ""),
      Subscription(
          name: "HBO Max3",
          category: "",
          price: "12/month",
          imageUrl: ""),
      Subscription(
          name: "Spotify2",
          category: "",
          price: "12/month",
          imageUrl: "")
    ];
    return subs;
    //return subscriptionBox.values.cast<Subscription>().toList();
  }

  Future<List<String>> getFilters() async {
    final filters = <String>[];
    // filterBox.keys.forEach((key) {
    //   filters[key] = (filterBox.get(key) as List).cast<Subscription>();
    // });
    filters.add("All");
    filters.add("Entertainment");
    filters.add("Productivity");
    return filters;
  }

  // Future<void> saveFilters(Map<String, List<Subscription>> filters) async {
  //   filters.forEach((key, value) {
  //     filterBox.put(key, value);
  //   });
  // }
}
