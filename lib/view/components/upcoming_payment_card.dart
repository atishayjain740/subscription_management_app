import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:subsciption_management_app/config/constants.dart';
import 'package:subsciption_management_app/model/subscription.dart';
import 'package:subsciption_management_app/view/components/initial_circle.dart';

class UpcomingPaymentCard extends StatelessWidget {
  final Color color;
  final Subscription subscription;

  const UpcomingPaymentCard({
    Key? key,
    required this.subscription,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200.h,
      child: Card(
        color: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        elevation: 4,
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Upcoming payment: ₹${subscription.price}",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      subscription.name,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                      ),
                    ),
                    Text(
                      subscription.category,
                      style: TextStyle(
                        fontSize: 14.sp,
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
    );
  }
}
