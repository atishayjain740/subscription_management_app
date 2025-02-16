import 'package:flutter/material.dart';
import 'package:subsciption_management_app/bloc/subscription_bloc.dart';
import 'package:subsciption_management_app/bloc/subscription_event.dart';
import 'package:subsciption_management_app/config/theme.dart';
import 'package:subsciption_management_app/service/hive_service.dart';
import 'view/screens/get_started_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'model/subscription.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  // Register the Adapter
  Hive.registerAdapter(SubscriptionAdapter());

  // Initialize Hive Service
  await HiveService().init();

  runApp(const ScreenUtilInit(
      designSize: Size(375, 812),
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

  // To toggle theme
  void toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          SubscriptionBloc(HiveService())..add(LoadSubscriptions()),
      child: MaterialApp(
        title: 'Subscription Manager',
        debugShowCheckedModeBanner: false,
        theme: isDarkMode ? AppThemes.darkTheme : AppThemes.lightTheme,
        home:
            GetStartedScreen(toggleTheme: toggleTheme, isDarkMode: isDarkMode),
      ),
    );
  }
}
