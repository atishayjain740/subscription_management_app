import 'package:flutter/material.dart';
import 'package:subsciption_management_app/view/components/custom_button.dart';
import '../../config/routes.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GetStartedScreen extends StatefulWidget {
  final VoidCallback toggleTheme;
  final bool isDarkMode;

  const GetStartedScreen(
      {super.key, required this.toggleTheme, required this.isDarkMode});

  @override
  State<GetStartedScreen> createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen> {
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();

    // Delay to have that animated effect
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isVisible = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Choose theme",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        actions: [
          IconButton(
            icon: Icon(widget.isDarkMode ? Icons.dark_mode : Icons.light_mode),
            onPressed: widget.toggleTheme,
          ),
        ],
      ),
      body: AnimatedOpacity(
        opacity: _isVisible ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 1500),
        child: Padding(
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
