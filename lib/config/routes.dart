import 'package:flutter/material.dart';
import '../view/screens/get_started_screen.dart';
import '../view/screens/my_subscriptions_screen.dart';

class Routes {
  // static void navigateToGetStarted(BuildContext context) {
  //   Navigator.pushReplacement(
  //     context,
  //     MaterialPageRoute(builder: (context) => const GetStartedScreen()),
  //   );
  // }

  static void navigateToMySubscriptions(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MySubscriptionsScreen()),
    );
  }

  static void goBack(BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }
}
