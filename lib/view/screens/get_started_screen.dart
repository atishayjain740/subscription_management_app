import 'package:flutter/material.dart';
import 'package:subsciption_management_app/view/components/custom_button.dart';
//import 'package:flutter_bloc/flutter_bloc.dart';
import '../../config/routes.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GetStartedScreen extends StatelessWidget {
  final VoidCallback toggleTheme;
  final bool isDarkMode;

  const GetStartedScreen(
      {super.key, required this.toggleTheme, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Choose theme mode"),
        actions: [
          IconButton(
            icon: Icon(isDarkMode ? Icons.dark_mode : Icons.light_mode),
            onPressed: toggleTheme,
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(20.w), // Padding around the content
        child: Column(
          children: [
            const Spacer(),
            ShaderMask(
              shaderCallback: (Rect bounds) {
                return const RadialGradient(
                  center: Alignment.center,
                  radius: 0.5, // Controls the fade intensity
                  colors: [Colors.white, Colors.transparent],
                  stops: [0.4, 1.0], // 40% visible, then fades out
                ).createShader(bounds);
              },
              blendMode: BlendMode.dstIn,
              child: Image.asset(
                'assets/images/logo.JPG',
                height: 200.h,
                width: 300.h,
                fit: BoxFit.contain,
              ),
            ),

            SizedBox(height: 32.h),
            Text(
              "Manage all your subscriptions",
              style: Theme.of(context).textTheme.displayLarge,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.h),
            Text(
              "Keep regular expenses on hand and receive timely notifications of upcoming fees",
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            CustomButton(
              text: "Get Started",
              onPressed: () => Routes.navigateToMySubscriptions(context),
            ), // Extra space at the bottom
          ],
        ),
      ),
    );
  }
}
