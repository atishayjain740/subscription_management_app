import 'package:flutter/material.dart';
import '../view/screens/my_subscriptions_screen.dart';

class Routes {
  static void navigateToMySubscriptions(BuildContext context) {
    // Giving animation while navigating to the subscription screen.
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 1000), // Adjust speed
        pageBuilder: (context, animation, secondaryAnimation) =>
            const MySubscriptionsScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var curve = Curves.fastLinearToSlowEaseIn;
          var tween = Tween<double>(begin: 0.5, end: 1.0)
              .chain(CurveTween(curve: curve));
          var scaleAnimation = animation.drive(tween);

          return ScaleTransition(
            scale: scaleAnimation,
            child: child,
          );
        },
      ),
    );
  }

  static void goBack(BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }
}
