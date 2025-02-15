import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subsciption_management_app/bloc/subscription_bloc.dart';
import 'package:subsciption_management_app/bloc/subscription_event.dart';
import 'package:subsciption_management_app/bloc/subscription_state.dart';
import 'package:subsciption_management_app/model/subscription.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:subsciption_management_app/view/components/custom_button.dart';

class AddSubscriptionBottomSheet extends StatefulWidget {
  final String category;

  const AddSubscriptionBottomSheet({super.key, required this.category});
  @override
  _AddSubscriptionBottomSheetState createState() =>
      _AddSubscriptionBottomSheetState();
}

class _AddSubscriptionBottomSheetState
    extends State<AddSubscriptionBottomSheet> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      height: 600.h,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: "Subscription Name"),
          ),
          SizedBox(
            height: 20.h,
          ),
          TextField(
            keyboardType: TextInputType.number,
            controller: _priceController,
            decoration:
                const InputDecoration(labelText: "Monthly subscription price"),
          ),
          const Spacer(),
          CustomButton(
            onPressed: () {
              if (_nameController.text.isNotEmpty &&
                  _priceController.text.isNotEmpty) {
                BlocProvider.of<SubscriptionBloc>(context).add(
                  AddSubscriptionEvent(
                      subscriptionName: _nameController.text,
                      subscriptionPrice: _priceController.text,
                      subscriptionCategory:
                          widget.category == "All" ? "" : widget.category),
                );
                Navigator.pop(context);
              }
            },
            text: "Save Subscription",
          ),
        ],
      ),
    );
  }
}
