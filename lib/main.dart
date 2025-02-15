import 'package:flutter/material.dart';
import 'package:subsciption_management_app/config/theme.dart';
import 'view/screens/get_started_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  runApp(const ScreenUtilInit(
      designSize: Size(375, 812), // Base design (iPhone X)
      minTextAdapt: true, // to prevent text overflow
      child: ResponsiveScreen(child: SubscriptionApp())));
}

/// Wrap all screens with this to ensure a max width
class ResponsiveScreen extends StatelessWidget {
  final Widget child;
  const ResponsiveScreen({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double maxWidth = 700; // Limit the width to a max size

        return Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: maxWidth,
            ),
            child: child,
          ),
        );
      },
    );
  }
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
