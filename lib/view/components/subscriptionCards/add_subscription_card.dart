import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:subsciption_management_app/config/constants.dart';
import 'package:subsciption_management_app/view/components/initial_circle.dart';

// Card for adding/deleting subscription
class AddSubscriptionCard extends StatelessWidget {
  final VoidCallback onAddPressed;
  final VoidCallback onDeletePressed;
  final Color color;
  const AddSubscriptionCard(
      {Key? key,
      required this.onAddPressed,
      required this.onDeletePressed,
      required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150.h,
      child: Card(
        color: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width: 12.w),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Add/Delete\nSubscription",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: onAddPressed,
                child: const InitialCircle(
                  name: "+",
                ),
              ),
              SizedBox(width: 8.w),
              InkWell(
                onTap: onDeletePressed,
                child: const InitialCircle(
                  name: "-",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
