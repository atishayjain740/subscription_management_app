import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:subsciption_management_app/config/constants.dart';
import 'package:subsciption_management_app/model/subscription.dart';
import 'package:subsciption_management_app/view/components/initial_circle.dart';

class SubscriptionCard extends StatelessWidget {
  final Color color;
  final Subscription subscription;
  final Animation<double> animation;
  final int index;

  const SubscriptionCard(
      {Key? key,
      required this.subscription,
      required this.color,
      required this.animation,
      required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double offset = -50.h * index;
    return Transform.translate(
      offset: Offset(0, offset),
      child: SlideTransition(
          key: ValueKey(subscription.name),
          position: Tween<Offset>(
            begin: const Offset(-1.0, 0.0),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          )),
          child: SizedBox(
            height: 200.h,
            child: Card(
              color: color,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              margin: EdgeInsets.symmetric(horizontal: 16.w),
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            subscription.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.white,
                            ),
                          ),
                          Text(
                            "₹${subscription.price}",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.white,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            subscription.category,
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 12.w),
                    InitialCircle(name: subscription.name)
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
