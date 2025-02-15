import 'package:flutter/material.dart';
import 'package:subsciption_management_app/config/theme.dart';
import 'config/routes.dart';
import 'view/screens/get_started_screen.dart';

void main() {
  runApp(const SubscriptionApp());
}

class SubscriptionApp extends StatefulWidget {
  const SubscriptionApp({super.key});

  @override
  State<SubscriptionApp> createState() => _SubscriptionAppState();
}

class _SubscriptionAppState extends State<SubscriptionApp> {
  bool isDarkMode = true;

  void toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Subscription Manager',
      debugShowCheckedModeBanner: false,
      theme: isDarkMode ? AppThemes.darkTheme : AppThemes.lightTheme,
      home: GetStartedScreen(toggleTheme: toggleTheme, isDarkMode: isDarkMode),
    );
  }
}
