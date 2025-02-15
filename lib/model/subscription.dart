import 'package:hive/hive.dart';

part 'subscription.g.dart'; // Run: flutter packages pub run build_runner build

@HiveType(typeId: 0)
class Subscription {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String category; // Entertainment, Productivity, etc.

  @HiveField(2)
  final String price;

  @HiveField(3)
  final String imageUrl;

  Subscription({
    required this.name,
    required this.category,
    required this.price,
    required this.imageUrl,
  });

  // Create a copy with an updated category
  Subscription copyWith({String? category}) {
    return Subscription(
        name: name,
        category: category ?? this.category,
        price: price,
        imageUrl: imageUrl);
  }
}
