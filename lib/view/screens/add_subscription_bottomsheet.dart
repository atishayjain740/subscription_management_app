import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subsciption_management_app/bloc/subscription_bloc.dart';
import 'package:subsciption_management_app/bloc/subscription_event.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:subsciption_management_app/view/components/custom_button.dart';
import 'package:subsciption_management_app/view/components/show_dialog.dart';

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
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Container(
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
              decoration: const InputDecoration(
                  labelText: "Monthly subscription price"),
            ),
            const Spacer(),
            CustomButton(
              onPressed: () {
                if (validateInput()) {
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
      ),
    );
  }

  bool validateInput() {
    if (_nameController.text.isEmpty) {
      showMessageDialog(context, "Please enter a subscription name");
      return false;
    }
    if (_priceController.text.isEmpty) {
      showMessageDialog(context, "Please enter the monthly price");
      return false;
    }

    return true;
  }
}
