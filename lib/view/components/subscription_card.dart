import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:subsciption_management_app/model/subsciption_model.dart';

class SubscriptionCard extends StatelessWidget {
  final Subscription subscription;

  const SubscriptionCard({Key? key, required this.subscription})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          children: [
            // Subscription Image
            ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: Image.network(
                subscription.imageUrl,
                height: 50.h,
                width: 50.w,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Icon(Icons.image_not_supported, size: 50.w),
              ),
            ),

            SizedBox(width: 12.w),

            // Subscription Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    subscription.name,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.headlineMedium!.color,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    subscription.category,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Theme.of(context).textTheme.bodyMedium!.color,
                    ),
                  ),
                ],
              ),
            ),

            // Subscription Price
            Text(
              "₹${subscription.price}",
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
