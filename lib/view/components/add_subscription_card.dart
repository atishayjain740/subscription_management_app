import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:subsciption_management_app/model/subscription.dart';

class AddSubscriptionCard extends StatelessWidget {
  final VoidCallback onPressed;
  Color color;
  AddSubscriptionCard({Key? key, required this.onPressed, required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        height: 150.h,
        child: Card(
          color: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          elevation: 4,
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                SizedBox(width: 12.w),

                // Subscription Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Add Subscription",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color:
                              Theme.of(context).textTheme.headlineMedium!.color,
                        ),
                      ),
                    ],
                  ),
                ),

                const Icon(Icons.add),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
